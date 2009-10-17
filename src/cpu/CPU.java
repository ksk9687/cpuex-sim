package cpu;

import static util.Utils.*;
import java.awt.*;
import java.util.*;
import javax.swing.*;
import javax.swing.table.*;
import sim.*;
import asm.*;

public abstract class CPU {
	
	public static final String DEFAULT = "Scalar";
	
	public static CPU loadCPU(String name) {
		try {
			Object o = Class.forName("cpu." + name).newInstance();
			return (CPU)o;
		} catch (Exception e) {
			failWith(String.format("%s: CPUが見つかりませんでした", name));
			throw new RuntimeException(e);
		}
	}
	
	protected static int imm(int i, int len, boolean signExt) {
		if (i < 0) {
			if (!signExt || i <= (-1 ^ 1 << (len - 1))) {
				throw new AssembleException("オペランドの値が不正です");
			}
		} else {
			if (i >= 1 << len) {
				throw new AssembleException("オペランドの値が不正です");
			}
			if (signExt && i >= 1 << (len - 1)) {
				//行数も表示
				System.err.printf("警告: %s%n", Assembler.s.createMessage("符号拡張により負の数となります"));
			}
		}
		return getBits(i, len - 1, 0);
	}
	
	protected static int reg(Map<String, Integer> regs, String reg) {
		if (!regs.containsKey(reg)) {
			throw new AssembleException("レジスタが不正です");
		}
		return regs.get(reg);
	}
	
	public abstract int getBinary(Parser p);
	
	private Simulator sim;
	protected String[] lines;
	protected Statement[] ss;
	protected int pc;
	private int readByteNum;
	private int writeByteNum;
	
	public void init(Simulator sim, String[] lines, Statement[] ss) {
		this.sim = sim;
		this.lines = lines;
		this.ss = ss;
		pc = 0;
	}
	
	protected int read() {
		readByteNum++;
		return sim.read();
	}
	
	protected int write(int i) {
		writeByteNum++;
		return sim.write(i);
	}
	
	public abstract void clock();
	
	public String[] getViews() {
		return new String[] {"Source", "Status"};
	}
	
	public SimView createView(String name) {
		if (name.equals("Source")) {
			return new SourceView();
		}
		if (name.equals("Status")) {
			return new StatusView();
		}
		failWith(String.format("%s: 存在しないView名", name));
		return null;
	}
	
	protected class SourceView extends SimView {
		
		protected boolean trackingPC = true;
		protected JTable table;
		
		protected SourceView() {
			super("Source");
			String[][] data = new String[lines.length][3];
			for (int i = 0; i < lines.length; i++) {
				data[i][0] = "" + (i + 1);
				data[i][1] = "";
				data[i][2] = lines[i];//.replaceAll("\t", "    ");
			}
			for (int i = ss.length - 1; i >= 0; i--) {
				data[ss[i].lineID][1] = "" + i;
			}
			table = new JTable(data, new String[] {"Line", "PC", ""});
			table.setFont(FONT);
			table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer() {
				public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
					super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
					if (ss[pc].lineID == row) {
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
			table.getColumnModel().getColumn(0).setMinWidth(50);
			table.getColumnModel().getColumn(0).setMaxWidth(50);
			table.getColumnModel().getColumn(1).setMinWidth(50);
			table.getColumnModel().getColumn(1).setMaxWidth(50);
			add(new JScrollPane(table), BorderLayout.CENTER);
			pack();
		}
		
		public void refresh() {
			if (trackingPC) {
				table.scrollRectToVisible(table.getCellRect(ss[pc].lineID, 0, true));
			}
			repaint();
		}
		
	}
	
	protected class StatusView extends SimView {
		
		protected JLabel pcLabel;
		protected JLabel readLabel;
		protected JLabel writeLabel;
		
		protected StatusView() {
			super("Status");
			setLayout(new GridLayout(3, 1));
			pcLabel = new JLabel("PC");
			pcLabel.setHorizontalAlignment(JLabel.CENTER);
			readLabel = new JLabel("Read");
			readLabel.setHorizontalAlignment(JLabel.CENTER);
			writeLabel = new JLabel("Write");
			writeLabel.setHorizontalAlignment(JLabel.CENTER);
			add(pcLabel);
			add(readLabel);
			add(writeLabel);
			pack();
		}
		
		public void refresh() {
			pcLabel.setText(String.format("PC = %d", pc));
			readLabel.setText(String.format("Read %d bytes", readByteNum));
			writeLabel.setText(String.format("Write %d bytes", writeByteNum));
		}
		
	}
	
}
