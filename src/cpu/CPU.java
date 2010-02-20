package cpu;

import static java.lang.Math.*;
import static util.Utils.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.*;
import javax.swing.*;
import javax.swing.table.*;
import sim.*;
import asm.*;

public abstract class CPU {
	
	private static final String DEFAULT = "SuperScalar";
	
	public static CPU loadCPU(String name) {
		String s = name;
		if (s.equals("")) s = DEFAULT;
		s = s.replace('.', '$');
		try {
			return (CPU) Class.forName("cpu." + s).newInstance();
		} catch (Exception e) {
		}
		try {
			return (CPU) Class.forName("cpu." + DEFAULT + "$" + s).newInstance();
		} catch (Exception e) {
			failWith(String.format("%s: CPUが見つかりませんでした", name));
			throw new RuntimeException(e);
		}
	}
	
	public CPU(double hz, int memorySize, int registerSize) {
		Hz = hz;
		MEMORYSIZE = memorySize;
		REGISTERSIZE = registerSize;
	}
	
	//Asm
	protected final int imm(Parser p, int len, boolean signExt) {
		int i = p.nextImm();
		if (i < 0) {
			if (!signExt || i <= (-1 ^ 1 << (len - 1))) {
				throw new AssembleException("オペランドの値が不正です");
			}
		} else {
			if (i >= 1 << len) {
				throw new AssembleException("オペランドの値が不正です");
			}
			if (signExt && i >= 1 << (len - 1)) {
				throw new AssembleException("符号拡張により負の数となります");
			}
		}
		return getBits(i, len - 1, 0);
	}
	
	protected final int reg(Parser p) {
		int i = p.nextReg();
		if (i < 0 || i >= REGISTERSIZE) {
			throw new AssembleException("レジスタが不正です");
		}
		return i;
	}
	
	public final int getBinary(Parser p) {
		try {
			String op = p.next();
			int bin = getBinary(op, p);
			p.end();
			return bin;
		} catch (ParseException e) {
			throw new AssembleException("オペランドが不正です");
		}
	}
	
	protected int getBinary(String op, Parser p) {
		throw new AssembleException("オペコードが不正です");
	}
	
	//Sim
	protected final double Hz;
	protected int pc;
	protected long clock;
	protected long instruction;
	protected boolean halted;
	
	public final void init(Program prog, InputStream in, OutputStream out) {
		this.prog = prog;
		this.in = in;
		this.out = out;
		progSize = prog.ss.length;
		pc = 0;
		regs = new int[REGISTERSIZE];
		mems = new int[MEMORYSIZE];
		for (int i = 0; i < progSize; i++) {
			mems[i] = prog.ss[i].binary;
		}
		data = getData();
		for (Data d : data) {
			if (d instanceof InstructionData) count = d;
		}
		init();
	}
	
	protected void init() {
	}
	
	public final void step() {
		if (halted) {
			throw new ExecuteException("Finished!");
		}
		int p = pc;
		for (int i = 0; i < data.length; i++) data[i].begin();
		step(mems[pc]);
		if (!halted) {
			instruction++;
			for (int i = 0; i < data.length; i++) data[i].end(p);
		}
	}
	
	protected void step(int ope) {
		throw new ExecuteException(String.format("IllegalOperation: %08x", ope));
	}
	
	protected void changePC(int newPC) {
		if (newPC < 0 || newPC >= progSize) {
			throw new ExecuteException(String.format("IllegalPC: %d", pc));
		}
		pc = newPC;
	}
	
	//Data
	protected Data count;
	protected Data[] data;
	
	protected Data[] getData() {
		return new Data[] {new InstructionData(), new ClockData()};
	}
	
	protected abstract class Data {
		
		protected String name;
		protected long[] data;
		protected long[] sum;
		
		protected Data(String name) {
			this.name = name;
			data = new long[progSize];
			sum = new long[prog.names.length];
		}
		
		protected void calcSum() {
			Arrays.fill(sum, 0);
			long[] total = new long[progSize + 1];
			for (int i = 0; i < progSize; i++) total[i + 1] = total[i] + data[i];
			for (int i = 0; i < prog.ids.length; i++) {
				sum[prog.ids[i]] += total[prog.end[i]] - total[prog.begin[i]];
			}
		}
		
		protected abstract void begin();
		
		protected abstract void end(int pc);
		
	}
	
	protected class InstructionData extends Data {
		
		protected InstructionData() {
			super("Instructions");
		}
		
		protected void begin() {
		}
		
		protected void end(int pc) {
			data[pc]++;
		}
		
	}
	
	protected class ClockData extends Data {
		
		private long c;
		
		protected ClockData() {
			super("Clocks");
		}
		
		protected void begin() {
			c = clock;
		}
		
		protected void end(int pc) {
			data[pc] += clock - c;
		}
		
	}
	
	//Status
	public Status getStatus() {
		return new Status();
	}
	
	public class Status extends JComponent {
		
		protected JLabel pcLabel;
		protected JLabel timeLabel;
		protected JLabel instructionLabel;
		protected JLabel clockLabel;
		protected JLabel readLabel;
		protected JLabel writeLabel;
		
		protected Status() {
			setLayout(new GridLayout(6, 1));
			add(pcLabel = new JLabel("pc", JLabel.CENTER));
			add(timeLabel = new JLabel("time", JLabel.CENTER));
			add(instructionLabel = new JLabel("instruction", JLabel.CENTER));
			add(clockLabel = new JLabel("clock", JLabel.CENTER));
			add(readLabel = new JLabel("read", JLabel.CENTER));
			add(writeLabel = new JLabel("write", JLabel.CENTER));
			setPreferredSize(new Dimension(130, 120));
		}
		
		public void refresh() {
			pcLabel.setText(String.format("PC = %d", pc));
			timeLabel.setText(String.format("%.3fs", clock / Hz));
			instructionLabel.setText(String.format("%,d instr.", instruction));
			clockLabel.setText(String.format("%,d clocks", clock));
			readLabel.setText(String.format("Read %,d bytes", readByteNum));
			writeLabel.setText(String.format("Write %,d bytes", writeByteNum));
		}
		
	}
	
	//View
	public String[] getViews() {
		if (data.length == 0) return new String[] {"Register", "Memory"};
		return new String[] {"Source", "Register", "Memory", "Stat"};
	}
	
	public SimView createView(String name) {
		if (name.equals("Source")) {
			return new SourceView();
		} else if (name.equals("Register")) {
			return new RegisterView();
		} else if (name.equals("Memory")) {
			return new MemoryView();
		} else if (name.equals("Stat")) {
			return new StatView();
		}
		failWith(String.format("%s: 存在しないView名", name));
		return null;
	}
	
	//IO
	protected InputStream in;
	protected OutputStream out;
	protected int readByteNum;
	protected int writeByteNum;
	
	protected final int read() {
		if (in == null) {
			throw new ExecuteException("Cannot read!");
		}
		try {
			readByteNum++;
			int i = in.read();
			if (i < 0) throw new ExecuteException("Cannot read!");
			return i;
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	protected final int write(int i) {
		if (out == null) return 0;
		try {
			writeByteNum++;
			out.write(i & 0xff);
			out.flush();
			return 0;
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	//Memory
	protected final int MEMORYSIZE;
	protected int[] mems;
	
	protected int load(int addr) {
		if (addr < 0 || addr >= MEMORYSIZE) {
			throw new ExecuteException(String.format("IllegalAddress: %08x", addr));
		}
		return mems[addr];
	}
	
	protected void store(int addr, int i) {
		if (addr < 0 || addr >= MEMORYSIZE) {
			throw new ExecuteException(String.format("IllegalAddress: %08x", addr));
		}
		mems[addr] = i;
	}
	
	protected class MemoryView extends SimView {
		
		protected static final int SIZE = 100;
		protected final String[] TYPE = {"Hex", "Decimal", "Binary", "Float"};
		protected JTextField addressField;
		protected DefaultTableModel tableModel;
		protected JTable table;
		protected int address, from, to;
		protected int type;
		
		protected MemoryView() {
			super("Memory");
			address = 0;
			from = 0;
			to = SIZE;
			addressField = new JTextField("0");
			addressField.setFont(FONT);
			addressField.setHorizontalAlignment(JTextField.CENTER);
			addressField.addActionListener(new AbstractAction() {
				public void actionPerformed(ActionEvent ae) {
					try {
						int p = parseInt(addressField.getText());
						if (0 <= p && p < MEMORYSIZE) {
							address = p;
							from = max(address - SIZE, 0);
							to = min(address + SIZE, MEMORYSIZE);
							refresh();
							table.scrollRectToVisible(table.getCellRect(address - from, 0, true));
						}
					} catch (NumberFormatException e) {
					}
				}
			});
			add(addressField, BorderLayout.NORTH);
			tableModel = new DefaultTableModel();
			table = new JTable(tableModel);
			table.setFont(FONT);
			table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer() {
				public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
					super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
					if (from + row == address) {
						setBackground(table.getSelectionBackground());
					} else if (isSelected) {
						setBackground(table.getSelectionBackground());
					} else {
						setBackground(table.getBackground());
					}
					return this;
				}
			});
			table.setDefaultEditor(Object.class, null);
			table.getTableHeader().setReorderingAllowed(false);
			table.getTableHeader().addMouseListener(new MouseAdapter() {
				public void mousePressed(MouseEvent e) {
					if (table.getTableHeader().columnAtPoint(e.getPoint()) == 1) {
						type = (type + 1) % TYPE.length;
						refresh();
					}
				}
			});
			add(new JScrollPane(table), BorderLayout.CENTER);
			setPreferredSize(new Dimension(200, 300));
			pack();
		}
		
		public void refresh() {
			String[] label = {"Address", TYPE[type]};
			String[][] data = new String[to - from][2];
			for (int i = from; i < to; i++) {
				data[i - from][0] = toHex(i);
				if (type == 0) data[i - from][1] = toHex(mems[i]);
				if (type == 1) data[i - from][1] = "" + mems[i];
				if (type == 2) data[i - from][1] = toBinary(mems[i]);
				if (type == 3) data[i - from][1] = String.format("%.6E", itof(mems[i]));
			}
			tableModel.setDataVector(data, label);
			table.getColumnModel().getColumn(0).setMinWidth(80);
			table.getColumnModel().getColumn(0).setMaxWidth(80);
		}
		
	}
	
	//Register
	protected final int REGISTERSIZE;
	protected int[] regs;
	
	protected class RegisterView extends SimView {
		
		protected String[] TYPE = {"Hex", "Decimal", "Binary", "Float"};
		protected DefaultTableModel tableModel;
		protected JTable table;
		protected int type;
		String[][] data = new String[REGISTERSIZE][2];
		
		protected RegisterView() {
			super("Register");
			tableModel = new DefaultTableModel();
			table = new JTable(tableModel);
			table.setFont(FONT);
			table.setDefaultEditor(Object.class, null);
			table.getTableHeader().setReorderingAllowed(false);
			table.getTableHeader().addMouseListener(new MouseAdapter() {
				public void mousePressed(MouseEvent e) {
					if (table.getTableHeader().columnAtPoint(e.getPoint()) == 1) {
						type = (type + 1) % TYPE.length;
						refresh();
					}
				}
			});
			add(new JScrollPane(table), BorderLayout.CENTER);
			setPreferredSize(new Dimension(200, 300));
			pack();
		}
		
		public void refresh() {
			String[] label = {"Name", TYPE[type]};
			for (int i = 0; i < REGISTERSIZE; i++) {
				data[i][0] = "$" + i;
				if (type == 0) data[i][1] = toHex(regs[i]);
				if (type == 1) data[i][1] = "" + regs[i];
				if (type == 2) data[i][1] = toBinary(regs[i]);
				if (type == 3) data[i][1] = String.format("%.6E", itof(regs[i]));
			}
			tableModel.setDataVector(data, label);
			table.getColumnModel().getColumn(0).setMinWidth(50);
			table.getColumnModel().getColumn(0).setMaxWidth(50);
		}
		
	}
	
	//Source
	protected Program prog;
	protected int progSize;
	
	protected class SourceView extends SimView {
		
		protected boolean trackingPC = true;
		protected DefaultTableModel tableModel;
		protected JTable table;
		protected String[] label = {"Line", "PC", "", "", ""};
		protected String[][] field = new String[prog.lines.length][5];
		protected int data1 = 0, data2 = 1 % data.length;
		
		protected SourceView() {
			super("Source");
			for (int i = 0; i < prog.lines.length; i++) {
				field[i][0] = "" + (i + 1);
				field[i][1] = "";
				field[i][2] = prog.lines[i];
				field[i][3] = "";
				field[i][4] = "";
			}
			for (int i = 0; i < progSize; i++) {
				field[prog.ss[i].lineID][1] = "" + i;
			}
			tableModel = new DefaultTableModel();
			table = new JTable(tableModel);
			table.setFont(FONT);
			table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer() {
				public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
					super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
					if (prog.ss[pc].lineID == row) {
						setBackground(table.getSelectionBackground());
					} else if (isSelected) {
						setBackground(table.getSelectionBackground());
					} else {
						setBackground(table.getBackground());
					}
					return this;
				}
			});
			table.setDefaultEditor(Object.class, null);
			table.getTableHeader().setReorderingAllowed(false);
			table.getTableHeader().addMouseListener(new MouseAdapter() {
				public void mousePressed(MouseEvent e) {
					if (table.getTableHeader().columnAtPoint(e.getPoint()) == 3) {
						data1 = (data1 + 1) % data.length;
						refresh();
					} else if (table.getTableHeader().columnAtPoint(e.getPoint()) == 4) {
						data2 = (data2 + 1) % data.length;
						refresh();
					}
				}
			});
			add(new JButton(new AbstractAction("Output") {
				public void actionPerformed(ActionEvent e) {
					String[] ss = prog.lines.clone();
					for (int i = 0; i < progSize; i++) if (count.data[i] > 0) {
						StringBuilder s = new StringBuilder(String.format("%-40s# ", ss[prog.ss[i].lineID]));
						for (Data d : data) s.append(String.format("| %,10d ", d.data[i]));
						s.append('|');
						ss[prog.ss[i].lineID] = s.toString();
					}
					for (String s : ss) System.out.println(s);
					StringBuilder sb = new StringBuilder(String.format("%-40s# ", ""));
					for (Data d : data) sb.append(String.format("| %-10s ", d.name));
					sb.append('|');
					System.out.println(sb);
					System.out.println();
				}
			}), BorderLayout.SOUTH);
			add(new JScrollPane(table), BorderLayout.CENTER);
			setPreferredSize(new Dimension(600, 400));
			pack();
		}
		
		public void refresh() {
			label[3] = data[data1].name;
			label[4] = data[data2].name;
			for (int i = 0; i < progSize; i++) {
				field[prog.ss[i].lineID][3] = String.format("%,10d", data[data1].data[i]);
				field[prog.ss[i].lineID][4] = String.format("%,10d", data[data2].data[i]);
			}
			tableModel.setDataVector(field, label);
			table.getColumnModel().getColumn(0).setMinWidth(50);
			table.getColumnModel().getColumn(0).setMaxWidth(50);
			table.getColumnModel().getColumn(1).setMinWidth(50);
			table.getColumnModel().getColumn(1).setMaxWidth(50);
			table.getColumnModel().getColumn(3).setMinWidth(100);
			table.getColumnModel().getColumn(3).setMaxWidth(100);
			table.getColumnModel().getColumn(4).setMinWidth(100);
			table.getColumnModel().getColumn(4).setMaxWidth(100);
			if (trackingPC) {
				table.scrollRectToVisible(table.getCellRect(prog.ss[pc].lineID, 0, true));
			}
			repaint();
		}
		
	}
	
	//Stat
	protected class StatView extends SimView {
		
		protected DefaultTableModel tableModel;
		protected JTable table;
		protected String[] label = {"Name", "Count", "", ""};
		protected String[][] field = new String[prog.names.length][4];
		protected int data1 = 0, data2 = 1 % data.length;
		
		protected StatView() {
			super("Stat");
			for (int i = 0; i < prog.names.length; i++) {
				field[i][0] = prog.names[i];
			}
			tableModel = new DefaultTableModel();
			table = new JTable(tableModel);
			table.setFont(FONT);
			table.setDefaultEditor(Object.class, null);
			table.getTableHeader().setReorderingAllowed(false);
			table.getTableHeader().addMouseListener(new MouseAdapter() {
				public void mousePressed(MouseEvent e) {
					if (table.getTableHeader().columnAtPoint(e.getPoint()) == 2) {
						data1 = (data1 + 1) % data.length;
						refresh();
					} else if (table.getTableHeader().columnAtPoint(e.getPoint()) == 3) {
						data2 = (data2 + 1) % data.length;
						refresh();
					}
				}
			});
			add(new JButton(new AbstractAction("Output") {
				public void actionPerformed(ActionEvent e) {
					for (Data d : data) d.calcSum();
					String[][] ss = new String[prog.names.length + 1][2 + data.length];
					ss[0][0] = label[0];
					ss[0][1] = label[1];
					for (int i = 0; i < data.length; i++) ss[0][2 + i] = data[i].name;
					for (int i = 0; i < prog.names.length; i++) {
						ss[i + 1][0] = field[i][0].trim();
						ss[i + 1][1] = field[i][1].trim();
						for (int j = 0; j < data.length; j++) ss[i + 1][2 + j] = String.format("%,d", data[j].sum[i]);
					}
					System.out.println("* BlockCount");
					for (String[] s : ss) {
						for (int i = 0; i < s.length; i++) {
							System.out.print("| " + s[i] + " ");
						}
						System.out.println("|");
					}
					System.out.println();
				}
			}), BorderLayout.SOUTH);
			add(new JScrollPane(table), BorderLayout.CENTER);
			setPreferredSize(new Dimension(600, 400));
			pack();
		}
		
		public void refresh() {
			label[2] = data[data1].name;
			label[3] = data[data2].name;
			data[data1].calcSum();
			data[data2].calcSum();
			long[] cs = new long[prog.names.length];
			for (int i = 0; i < prog.ids.length; i++) {
				cs[prog.ids[i]] += count.data[prog.begin[i]];
			}
			for (int i = 0; i < prog.names.length; i++) {
				field[i][1] = String.format("%,14d", cs[i]);
				field[i][2] = String.format("%,14d", data[data1].sum[i]);
				field[i][3] = String.format("%,14d", data[data2].sum[i]);
			}
			tableModel.setDataVector(field, label);
			table.getColumnModel().getColumn(0).setMinWidth(200);
			table.getColumnModel().getColumn(1).setMinWidth(120);
			table.getColumnModel().getColumn(2).setMinWidth(120);
			table.getColumnModel().getColumn(3).setMinWidth(120);
		}
		
	}
	
}
