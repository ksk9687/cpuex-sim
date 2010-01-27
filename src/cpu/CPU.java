package cpu;

import static java.lang.Math.*;
import static util.Utils.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
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
		pc = 0;
		regs = new int[REGISTERSIZE];
		mems = new int[MEMORYSIZE];
		for (int i = 0; i < prog.ss.length; i++) {
			mems[i] = prog.ss[i].binary;
		}
		counts = new long[prog.ss.length + 1];
		init();
	}
	
	protected void init() {
	}
	
	public final void step() {
		if (halted) {
			throw new ExecuteException("Finished!");
		}
		if (pc < 0 || pc >= prog.ss.length) {
			throw new ExecuteException(String.format("IllegalPC: %08x", pc));
		}
		counts[pc]++;
		step(mems[pc]);
		instruction++;
	}
	
	protected void step(int ope) {
		throw new ExecuteException(String.format("IllegalOperation: %08x", ope));
	}
	
	//View
	public String[] getViews() {
		return new String[] {"Source", "Status", "Register", "Memory", "Stat"};
	}
	
	public SimView createView(String name) {
		if (name.equals("Source")) {
			return new SourceView();
		} else if (name.equals("Status")) {
			return new StatusView();
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
	
	protected class StatusView extends SimView {
		
		protected JLabel pcLabel;
		protected JLabel timeLabel;
		protected JLabel instructionLabel;
		protected JLabel clockLabel;
		protected JLabel readLabel;
		protected JLabel writeLabel;
		
		protected StatusView() {
			super("Status");
			setLayout(new GridLayout(6, 1));
			add(pcLabel = new JLabel("pc", JLabel.CENTER));
			add(timeLabel = new JLabel("time", JLabel.CENTER));
			add(instructionLabel = new JLabel("instruction", JLabel.CENTER));
			add(clockLabel = new JLabel("clock", JLabel.CENTER));
			add(readLabel = new JLabel("read", JLabel.CENTER));
			add(writeLabel = new JLabel("write", JLabel.CENTER));
			pack();
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
			addressField = new JTextField("0");
			addressField.setFont(FONT);
			addressField.setHorizontalAlignment(JTextField.CENTER);
			addressField.addActionListener(new AbstractAction() {
				public void actionPerformed(ActionEvent ae) {
					try {
						int p = parseInt(addressField.getText());
						if (0 <= p && p < MEMORYSIZE) {
							address = p;
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
			from = max(address - SIZE, 0);
			to = min(address + SIZE, MEMORYSIZE);
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
			String[][] data = new String[REGISTERSIZE][2];
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
	protected long[] counts;
	
	protected class SourceView extends SimView {
		
		protected boolean trackingPC = true;
		protected DefaultTableModel tableModel;
		protected JTable table;
		
		protected SourceView() {
			super("Source");
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
			add(new JScrollPane(table), BorderLayout.CENTER);
			pack();
		}
		
		public void refresh() {
			String[] label = {"Line", "PC", "", "Count"};
			String[][] data = new String[prog.lines.length][4];
			for (int i = 0; i < prog.lines.length; i++) {
				data[i][0] = "" + (i + 1);
				data[i][1] = "";
				data[i][2] = prog.lines[i];
				data[i][3] = "";
			}
			for (int i = prog.ss.length - 1; i >= 0; i--) {
				data[prog.ss[i].lineID][1] = "" + i;
				data[prog.ss[i].lineID][3] = String.format("%,10d", counts[i]);
			}
			tableModel.setDataVector(data, label);
			table.getColumnModel().getColumn(0).setMinWidth(50);
			table.getColumnModel().getColumn(0).setMaxWidth(50);
			table.getColumnModel().getColumn(1).setMinWidth(50);
			table.getColumnModel().getColumn(1).setMaxWidth(50);
			table.getColumnModel().getColumn(3).setMinWidth(100);
			table.getColumnModel().getColumn(3).setMaxWidth(100);
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
		protected String[] label = {"Name", "Count", "Total"};
		protected String[][] data = new String[prog.names.length][3];
		
		protected StatView() {
			super("Stat");
			tableModel = new DefaultTableModel();
			table = new JTable(tableModel);
			table.setFont(FONT);
			table.setDefaultEditor(Object.class, null);
			table.getTableHeader().setReorderingAllowed(false);
			add(new JButton(new AbstractAction("Output") {
				public void actionPerformed(ActionEvent e) {
					System.err.println("* ブロック実行数");
					System.err.printf("| %s | %s | %s |%n", label[0], label[1], label[2]);
					for (int i = 0; i < prog.names.length; i++) {
						System.err.printf("| %s | %s | %s |%n", data[i][0].trim(), data[i][1].trim(), data[i][2].trim());
					}
				}
			}), BorderLayout.SOUTH);
			add(new JScrollPane(table), BorderLayout.CENTER);
			setPreferredSize(new Dimension(500, 400));
			pack();
		}
		
		public void refresh() {
			long[] sum = new long[prog.ss.length + 1];
			long[] count = new long[prog.names.length];
			long[] total = new long[prog.names.length];
			for (int i = 0; i < prog.ss.length; i++) {
				sum[i + 1] = sum[i] + counts[i];
			}
			for (int i = 0; i < prog.ids.length; i++) {
				count[prog.ids[i]] += counts[prog.begin[i]];
				total[prog.ids[i]] += sum[prog.end[i]] - sum[prog.begin[i]];
			}
			for (int i = 0; i < prog.names.length; i++) {
				data[i][0] = prog.names[i];
				data[i][1] = String.format("%,14d", count[i]);
				data[i][2] = String.format("%,14d", total[i]);
			}
			tableModel.setDataVector(data, label);
			table.getColumnModel().getColumn(0).setMinWidth(200);
			table.getColumnModel().getColumn(1).setMinWidth(120);
			table.getColumnModel().getColumn(2).setMinWidth(120);
		}
		
	}
	
}
