package cpu;

import static java.lang.Math.*;
import static java.util.Arrays.*;
import static util.Utils.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.table.*;
import sim.*;
import asm.*;

public class Scalar extends CPU {
	
	protected static int typeR(int op, int rs, int rt, int rd) {
		return op << 26 | rs << 21 | rt << 16 | rd << 11;
	}
	
	protected static int typeI(int op, int rs, int rt, int imm) {
		return op << 26 | rs << 21 | rt << 16 | imm;
	}
	
	protected static int typeJ(int op, int imm) {
		return op << 26 | imm;
	}
	
	protected static int reg(int r) {
		return imm(r, 5, false);
	}
	
	public int getBinary(Parser p) {
		String s = p.next();
		if (s.equals("add")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(0, reg(rs), reg(rt), reg(rd));
		} else if (s.equals("addi")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(1, reg(rs), reg(rt), imm(i, 16, true));
		} else if (s.equals("sub")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(2, reg(rs), reg(rt), reg(rd));
		} else if (s.equals("srl")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(3, reg(rs), reg(rt), imm(i, 5, false));
		} else if (s.equals("sll")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(4, reg(rs), reg(rt), imm(i, 5, false));
		} else if (s.equals("fadd")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(5, reg(rs), reg(rt), reg(rd));
		} else if (s.equals("fsub")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(6, reg(rs), reg(rt), reg(rd));
		} else if (s.equals("fmul")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(7, reg(rs), reg(rt), reg(rd));
		} else if (s.equals("finv")) {
			int rs = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(8, reg(rs), 0, reg(rd));
		} else if (s.equals("load")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(9, reg(rs), reg(rt), imm(i, 16, true));
		} else if (s.equals("li")) {
			int rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(10, 0, reg(rt), imm(i, 16, true));
		} else if (s.equals("store")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(11, reg(rs), reg(rt), imm(i, 16, true));
		} else if (s.equals("cmp")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(12, reg(rs), reg(rt), reg(rd));
		} else if (s.equals("_jmp")) {
			int rs = p.nextReg();
			int t = p.nextImm();
			int i = p.nextImm();
			p.end();
			return typeI(13, reg(rs), imm(t, 3, false), imm(i, 16, true));
		} else if (s.equals("jal")) {
			int i = p.nextImm();
			p.end();
			return typeJ(14, imm(i, 26, false));
		} else if (s.equals("jr")) {
			int rs = p.nextReg();
			p.end();
			return typeI(15, reg(rs), 0, 0);
		} else if (s.equals("read")) {
			int rt = p.nextReg();
			p.end();
			return typeI(16, 0, reg(rt), 0);
		} else if (s.equals("write")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			p.end();
			return typeI(17, reg(rs), reg(rt), 0);
		} else if (s.equals("nop")) {
			p.end();
			return typeJ(18, 0);
		} else if (s.equals("halt")) {
			p.end();
			return typeJ(19, 0);
		} else if (s.equals("fcmp")) {
			int rs = p.nextReg();
			int rt = p.nextReg();
			int rd = p.nextReg();
			p.end();
			return typeR(20, reg(rs), reg(rt), reg(rd));
		} else if (s.equals("ledout")) {
			int rs = p.nextReg();
			p.end();
			return typeR(21, reg(rs), 0, 0);
		} else {
			throw new ParseException();
		}
	}
	
	protected static int cmp(int a, int b) {
		return a > b ? 4 : a == b ? 2 : 1;
	}
	
	protected static int fcmp(int a, int b) {
		float fa = itof(a), fb = itof(b);
		return fa > fb ? 4 : fa == fb ? 2 : 1;
	}
	
	protected static final int REGISTERSIZE = 32;
	protected static final int MEMORYSIZE = 1 << 20;
	protected int[] register;
	protected int[] memory;
	
	public void init(Simulator sim, String[] lines, Statement[] ss) {
		super.init(sim, lines, ss);
		register = new int[REGISTERSIZE];
		memory = new int[MEMORYSIZE];
		for (int i = 0; i < ss.length; i++) {
			memory[i] = ss[i].binary;
		}
	}
	
	protected int load(int address) {
		if (address < 0 || address >= MEMORYSIZE) {
			throw new ExecuteException(String.format("IllegalAddress: %08x", address));
		}
		return memory[address];
	}
	
	protected void store(int address, int i) {
		if (address < 0 || address >= MEMORYSIZE) {
			throw new ExecuteException(String.format("IllegalAddress: %08x", address));
		}
		memory[address] = i;
	}
	
	public void clock() {
		if (pc < 0 || pc >= MEMORYSIZE) {
			throw new ExecuteException(String.format("IllegalPC: %08x", pc));
		}
		int ope = memory[pc];
		int opecode = ope >>> 26;
		int rs = ope >>> 21 & (REGISTERSIZE - 1);
		int rt = ope >>> 16 & (REGISTERSIZE - 1);
		int rd = ope >>> 11 & (REGISTERSIZE - 1);
		int immediate = ope & ((1 << 16) - 1);
		int address = ope & ((1 << (26)) - 1);
		if (opecode == 0) { //add
			register[rd] = register[rs] + register[rt];
			pc++;
		} else if (opecode == 1) { //addi
			register[rt] = register[rs] + signExt(immediate, 16);
			pc++;
		} else if (opecode == 2) { //sub
			register[rd] = register[rs] - register[rt];
			pc++;
		} else if (opecode == 3) { //srl
			register[rt] = register[rs] >>> immediate;
			pc++;
		} else if (opecode == 4) { //sll
			register[rt] = register[rs] << immediate;
			pc++;
		} else if (opecode == 5) { //fadd
			register[rd] = ftoi(itof(register[rs]) + itof(register[rt]));
			pc++;
		} else if (opecode == 6) { //fsub
			register[rd] = ftoi(itof(register[rs]) - itof(register[rt]));
			pc++;
		} else if (opecode == 7) { //fmul
			register[rd] = ftoi(itof(register[rs]) * itof(register[rt]));
			pc++;
		} else if (opecode == 8) { //finv
			register[rd] = ftoi(1.0f / itof(register[rs]));
			pc++;
		} else if (opecode == 9) { //load
			register[rt] = load(register[rs] + signExt(immediate, 16));
			pc++;
		} else if (opecode == 10) { //li
			register[rt] = signExt(immediate, 16);
			pc++;
		} else if (opecode == 11) { //store
			store(register[rs] + signExt(immediate, 16), register[rt]);
			pc++;
		} else if (opecode == 12) { //cmp
			register[rd] = cmp(register[rs], register[rt]);
			pc++;
		} else if (opecode == 13) { //jmp
			if ((register[rs] & rt) == 0) {
				pc += signExt(immediate, 16);
			} else {
				pc++;
			}
		} else if (opecode == 14) { //jal
			register[31] = pc + 1;
			pc = address;
		} else if (opecode == 15) { //jr
			pc = register[rs];
		} else if (opecode == 16) { //read
			register[rt] = read();
			pc++;
		} else if (opecode == 17) { //write
			register[rt] = write(register[rs]);
			pc++;
		} else if (opecode == 18) { //nop
			pc++;
		} else if (opecode == 19) { //halt
			throw new ExecuteException("Finished!");
		} else if (opecode == 20) { //fcmp
			register[rd] = fcmp(register[rs], register[rt]);
			pc++;
		} else if (opecode == 21) { //ledout
			System.err.printf("LED: %s%n", toBinary(register[rs]).substring(24));
			pc++;
		} else {
			throw new ExecuteException(String.format("IllegalOperation: %08x", ope));
		}
	}
	
	public String[] views = {"Register", "Memory"};
	
	public String[] getViews() {
		ArrayList<String> list = new ArrayList<String>();
		list.addAll(asList(super.getViews()));
		for (String view : views) {
			if (list.contains(view)) {
				list.remove(view);
			}
			list.add(view);
		}
		return list.toArray(new String[0]);
	}
	
	public SimView createView(String name) {
		if (name.equals("Register")) {
			return new RegisterView();
		}
		if (name.equals("Memory")) {
			return new MemoryView();
		}
		return super.createView(name);
	}
	
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
			String[] label = new String[] {"Name", TYPE[type]};
			String[][] data = new String[REGISTERSIZE][2];
			for (int i = 0; i < REGISTERSIZE; i++) {
				data[i][0] = "$" + i;
				if (type == 0) data[i][1] = toHex(register[i]);
				if (type == 1) data[i][1] = "" + register[i];
				if (type == 2) data[i][1] = toBinary(register[i]);
				if (type == 3) data[i][1] = String.format("%.6E", itof(register[i]));
			}
			tableModel.setDataVector(data, label);
			table.getColumnModel().getColumn(0).setMinWidth(50);
			table.getColumnModel().getColumn(0).setMaxWidth(50);
		}
		
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
			String[] label = new String[] {"Address", TYPE[type]};
			String[][] data = new String[to - from][2];
			for (int i = from; i < to; i++) {
				data[i - from][0] = toHex(i);
				if (type == 0) data[i - from][1] = toHex(memory[i]);
				if (type == 1) data[i - from][1] = "" + memory[i];
				if (type == 2) data[i - from][1] = toBinary(memory[i]);
				if (type == 3) data[i - from][1] = String.format("%.6E", itof(memory[i]));
			}
			tableModel.setDataVector(data, label);
			table.getColumnModel().getColumn(0).setMinWidth(80);
			table.getColumnModel().getColumn(0).setMaxWidth(80);
		}
		
	}
	
	static class Debug extends Scalar {
		
		public int getBinary(Parser p) {
			try {
				return super.getBinary(p);
			} catch (ParseException e) {
				p.init();
				String s = p.next();
				if (s.equals("debug_int")) {
					int rs = p.nextReg();
					p.end();
					return typeI(63, reg(rs), 0, 0);
				} else if (s.equals("debug_float")) {
					int rs = p.nextReg();
					p.end();
					return typeI(62, reg(rs), 0, 0);
				} else if (s.equals("break")) {
					p.end();
					return typeJ(61,0);
				} else {
					throw e;
				}
			}
		}
		
		public void clock() {
			try {
				super.clock();
			} catch (ExecuteException e) {
				int ope = memory[pc];
				int opecode = ope >>> 26;
				int rs = ope >>> 21 & (REGISTERSIZE - 1);
				if (opecode == 63) { //debug_int
					System.err.printf("%s(%d)%n", toHex(register[rs]), register[rs]);
					pc++;
				} else if (opecode == 62) { //debug_float
					System.err.printf("%.6E%n", itof(register[rs]));
					pc++;
				} else if (opecode == 61) { //break
					pc++;
					throw new ExecuteException("Break!");
				} else {
					throw e;
				}
			}
		}
	}
	
	static class Count extends Scalar {
		String[] NAME = {"add", "addi", "sub", "srl", "sll", "fadd", "fsub", "fmul", "finv", "load", "li", "store", "cmp", "jmp", "jal", "jr", "read", "write", "nop", "halt", "fcmp", "ledout"};
		
		long[] countOpe = new long[64];
		long[] countCall = new long[MEMORYSIZE];
		long total = 0;
		public void clock() {
			total++;
			int ope = memory[pc];
			int opecode = ope >>> 26;
			int address = ope & ((1 << (26)) - 1);
			countOpe[opecode]++;
			if (opecode == 19) {
				System.err.println("* 命令実行数");
				System.err.printf("| Total | %,d |%n", total);
				for (int i = 0; i < NAME.length; i++) {
					System.err.printf("| %s | %,d |%n", NAME[i], countOpe[i]);
				}
				System.err.println();
				System.err.println("* 関数呼び出し数(jalのみ)");
				for (int i = 0; i < MEMORYSIZE; i++) if (countCall[i] > 0 && ss[i].labels.length > 0) {
					String name = ss[i].labels[0];
					if (name.startsWith("min_caml_")) name = name.substring("min_caml_".length());
					if (name.indexOf('.') >= 0) name = name.substring(0, name.indexOf('.'));
					System.err.printf("| %s | %,d |%n", name, countCall[i]);
				}
			} else if (opecode == 14) {
				countCall[address]++;
			}
			super.clock();
		}
	}
	
}
