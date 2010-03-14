package cpu;

import static java.lang.Math.*;
import static java.util.Arrays.*;
import static util.Utils.*;
import java.awt.*;
import java.util.*;
import javax.swing.*;
import javax.swing.table.*;
import sim.*;
import asm.*;

public class SuperScalar extends CPU32 {
	
	public SuperScalar() {
		super(150e6, 1 << 20, 1 << 6);
	}
	
	//Asm
	protected static int typeR(int op, int rs, int rt, int rd) {
		return op << 26 | rs << 20 | rt << 14 | rd << 8;
	}
	
	protected static int typeI(int op, int rs, int rt, int imm) {
		return op << 26 | rs << 20 | rt << 14 | imm;
	}
	
	@Override
	protected long getBinary(String op, Parser p) {
		if (op.equals("li")) {
			return typeI(000, 0, reg(p), imm(p, 14, false));
		} else if (op.equals("add")) {
			return typeR(010, reg(p), reg(p), reg(p));
		} else if (op.equals("addi")) {
			return typeI(001, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("sub")) {
			return typeR(011, reg(p), reg(p), reg(p));
		} else if (op.equals("sll")) {
			return typeI(002, reg(p), reg(p), imm(p, 5, false));
		} else if (op.equals("cmp")) {
			return typeI(012, reg(p), reg(p), 0);
		} else if (op.equals("cmpi")) {
			return typeI(003, reg(p), 0, imm(p, 14, true));
		} else if (op.equals("fadd")) {
			return typeR(020, reg(p), reg(p), reg(p));
		} else if (op.equals("fsub")) {
			return typeR(021, reg(p), reg(p), reg(p));
		} else if (op.equals("fmul")) {
			return typeR(022, reg(p), reg(p), reg(p));
		} else if (op.equals("finv")) {
			return typeR(023, reg(p), 0, reg(p));
		} else if (op.equals("fsqrt")) {
			return typeR(024, reg(p), 0, reg(p));
		} else if (op.equals("fcmp")) {
			return typeI(025, reg(p), reg(p), 0);
		} else if (op.equals("fabs")) {
			return typeR(006, reg(p), 0, reg(p));
		} else if (op.equals("fneg")) {
			return typeR(007, reg(p), 0, reg(p));
		} else if (op.equals("load")) {
			return typeI(030, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("loadr")) {
			return typeR(031, reg(p), reg(p), reg(p));
		} else if (op.equals("store")) {
			return typeI(032, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("read")) {
			return typeI(050, 0, reg(p), 1);
		} else if (op.equals("write")) {
			return typeI(051, reg(p), reg(p), 1);
		} else if (op.equals("ledout")) {
			return typeI(052, reg(p), 0, 0);
		} else if (op.equals("nop")) {
			return typeI(060, 0, 0, 0);
		} else if (op.equals("halt")) {
			return typeI(061, 0, 0, 0);
		} else if (op.equals("mov")) {
			return typeI(005, reg(p), reg(p), 0);
		} else if (op.equals("jmp")) {
			return typeI(070, imm(p, 3, false), 0, imm(p, 14, false));
		} else if (op.equals("call")) {
			return typeI(071, 0, 0, imm(p, 14, false));
		} else if (op.equals("ret")) {
			return typeI(072, 0, 0, 0);
		}
		return super.getBinary(op, p);
	}
	
	//Sim
	protected static final int MAXDEPTH = 16;
	protected int cond;
	protected int callDepth;
	protected int maxDepth;
	protected int[] callStack;
	protected long[] canUse;
	protected static final int[] delay = new int[64];
/*
	static {
		delay[020] = 2; //fadd
		delay[021] = 2; //fsub
		delay[022] = 2; //fmul
		delay[023] = 2; //finv
		delay[024] = 2; //fsqrt
		delay[030] = 1; //load
		delay[031] = 1; //loadr
		delay[050] = 1; //read
		delay[051] = 1; //write
	}
*/
	static {
		delay[000] = 1; //li
		delay[010] = 1; //add
		delay[001] = 1; //addi
		delay[011] = 1; //sub
		delay[002] = 1; //sll
		delay[012] = 1; //cmp
		delay[003] = 1; //cmpi
		delay[020] = 4; //fadd
		delay[021] = 4; //fsub
		delay[022] = 4; //fmul
		delay[023] = 4; //finv
		delay[024] = 4; //fsqrt
		delay[025] = 1; //fcmp
		delay[006] = 1; //fabs
		delay[007] = 1; //fneg
		delay[030] = 2; //load
		delay[031] = 2; //loadr
		delay[050] = 1; //read
		delay[051] = 1; //write
	}
	
	@Override
	protected void init() {
		super.init();
		cond = 0;
		callDepth = 0;
		maxDepth = 0;
		callStack = new int[MAXDEPTH];
		canUse = new long[REGISTERSIZE + 1];
		countOpe = new long[64];
		clockOpe = new long[64];
		icache = new int[ICACHESIZE];
		dcache = new int[DCACHESIZE];
		fill(icache, -1);
		fill(dcache, -1);
		bpTable = new int[BP_TABLE_SIZE];
		stalled = 0;
		stackSize = heapSize = 0;
		dataLoad = stackLoad = heapLoad = 0;
		dataStore = stackStore = heapStore = 0;
		iHit = iMiss = dHit = dMiss = 0;
		bpHit = bpMiss = 0;
	}
	
	//ALU
	protected int cmp(int a, int b) {
		return a > b ? 4 : a == b ? 2 : 1;
	}
	
	//FPU
	protected int fadd(int a, int b) {
		return ftoi(itof(a) + itof(b));
	}
	
	protected int fsub(int a, int b) {
		return ftoi(itof(a) - itof(b));
	}
	
	protected int fmul(int a, int b) {
		return ftoi(itof(a) * itof(b));
	}
	
	protected int finv(int a) {
		return ftoi(1.0f / itof(a));
	}
	
	protected int fsqrt(int a) {
		return ftoi((float)sqrt(itof(a)));
	}
	
	protected int fcmp(int a, int b) {
		float fa = itof(a), fb = itof(b);
		return fa > fb ? 4 : fa == fb ? 2 : 1;
	}
	
	protected int fabs(int a) {
		return ftoi(abs(itof(a)));
	}
	
	protected int fneg(int a) {
		return ftoi(-(itof(a)));
	}
	
	@Override
	protected final void step(long _ope) {
		int ope = (int)_ope;
		int opecode = ope >>> 26;
		int rs = ope >>> 20 & (REGISTERSIZE - 1);
		int rt = ope >>> 14 & (REGISTERSIZE - 1);
		int rd = ope >>> 8 & (REGISTERSIZE - 1);
		int imm = ope & ((1 << 14) - 1);
		countOpe[opecode]++;
		long c = clock;
		icache(pc);
		step(ope, opecode, rs, rt, rd, imm);
		clockOpe[opecode] += clock - c;
	}
	
	protected void step(int ope, int opecode, int rs, int rt, int rd, int imm) {
		if (opecode == 000) { //li
			stall(opecode, rt);
			regs[rt] = imm;
			changePC(pc + 1);
		} else if (opecode == 010) { //add
			stall(opecode, rd, rs, rt);
			regs[rd] = regs[rs] + regs[rt];
			changePC(pc + 1);
		} else if (opecode == 001) { //addi
			stall(opecode, rt, rs);
			regs[rt] = regs[rs] + signExt(imm, 14);
			changePC(pc + 1);
		} else if (opecode == 011) { //sub
			stall(opecode, rd, rs, rt);
			regs[rd] = regs[rs] - regs[rt];
			changePC(pc + 1);
		} else if (opecode == 002) { //sll
			stall(opecode, rt, rs);
			regs[rt] = regs[rs] << imm;
			changePC(pc + 1);
		} else if (opecode == 012) { //cmp
			stall(opecode, REGISTERSIZE, rs, rt);
			cond = cmp(regs[rs], regs[rt]);
			changePC(pc + 1);
		} else if (opecode == 003) { //cmpi
			stall(opecode, REGISTERSIZE, rs);
			cond = cmp(regs[rs], signExt(imm, 14));
			changePC(pc + 1);
		} else if (opecode == 020) { //fadd
			stall(opecode, rd, rs, rt);
			regs[rd] = fadd(regs[rs], regs[rt]);
			changePC(pc + 1);
		} else if (opecode == 021) { //fsub
			stall(opecode, rd, rs, rt);
			regs[rd] = fsub(regs[rs], regs[rt]);
			changePC(pc + 1);
		} else if (opecode == 022) { //fmul
			stall(opecode, rd, rs, rt);
			regs[rd] = fmul(regs[rs], regs[rt]);
			changePC(pc + 1);
		} else if (opecode == 023) { //finv
			stall(opecode, rd, rs);
			regs[rd] = finv(regs[rs]);
			changePC(pc + 1);
		} else if (opecode == 024) { //fsqrt
			stall(opecode, rd, rs);
			regs[rd] = fsqrt(regs[rs]);
			changePC(pc + 1);
		} else if (opecode == 025) { //fcmp
			stall(opecode, REGISTERSIZE, rs, rt);
			cond = fcmp(regs[rs], regs[rt]);
			changePC(pc + 1);
		} else if (opecode == 006) { //fabs
			stall(opecode, rd, rs);
			regs[rd] = fabs(regs[rs]);
			changePC(pc + 1);
		} else if (opecode == 007) { //fneg
			stall(opecode, rd, rs);
			regs[rd] = fneg(regs[rs]);
			changePC(pc + 1);
		} else if (opecode == 030) { //load
			stall(opecode, rt, rs);
			regs[rt] = load(regs[rs] + signExt(imm, 14));
			changePC(pc + 1);
		} else if (opecode == 031) { //loadr
			stall(opecode, rd, rs, rt);
			regs[rd] = load(regs[rs] + regs[rt]);
			changePC(pc + 1);
		} else if (opecode == 032) { //store
			stall(opecode, -1, rs, rt);
			store(regs[rs] + signExt(imm, 14), regs[rt]);
			changePC(pc + 1);
		} else if (opecode == 050) { //read
			stall(opecode, rt);
			regs[rt] = read();
			changePC(pc + 1);
		} else if (opecode == 051) { //write
			stall(opecode, rt, rs);
			regs[rt] = write(regs[rs]);
			changePC(pc + 1);
		} else if (opecode == 052) { //ledout
			stall(opecode, -1);
			System.err.printf("LED: %s%n", toBinary(regs[rs]).substring(24));
			changePC(pc + 1);
		} else if (opecode == 060) { //nop
			stall(opecode, -1);
			changePC(pc + 1);
		} else if (opecode == 061) { //halt
			stall(opecode, -1);
			printStat();
			halted = true;
		} else if (opecode == 005) { //mov
			stall(opecode, rt, rs);
			regs[rt] = regs[rs];
			changePC(pc + 1);
		} else if (opecode == 070) { //jmp
			stall(opecode, -1, REGISTERSIZE);
			branchPredict((cond & rs) == 0 ? 1 : 0);
			if ((cond & rs) == 0) {
				changePC(imm);
			} else {
				changePC(pc + 1);
			}
		} else if (opecode == 071) { //call
			stall(opecode, -1);
			if (callDepth >= MAXDEPTH) throw new ExecuteException("Illegal Depth");
			callStack[callDepth++] = pc + 1;
			maxDepth = max(maxDepth, callDepth);
			changePC(imm);
		} else if (opecode == 072) { //ret
			stall(opecode, -1);
			if (callDepth <= 0) throw new ExecuteException("Illegal Depth");
			changePC(callStack[--callDepth]);
		} else {
			super.step(ope);
		}
	}
	
	@Override
	protected int load(int addr) {
		if (addr < 0x10000) dataLoad++;
		else if (addr < 0x70000) {
			heapLoad++;
			heapSize = max(heapSize, addr - 0x10000 + 1);
		} else {
			stackLoad++;
			stackSize = max(stackSize, 0x80000 - addr + 1);
		}
		dcache(addr);
		return super.load(addr);
	}
	
	@Override
	protected void store(int addr, int i) {
		if (addr < 0x10000) dataStore++;
		else if (addr < 0x70000) {
			heapStore++;
			heapSize = max(heapSize, addr - 0x10000 + 1);
		} else {
			stackStore++;
			stackSize = max(stackSize, 0x80000 - addr + 1);
		}
		super.store(addr, i);
	}
	
	protected void stall(int opecode, int write, int...reads) {
		long max = clock;
		for (int r : reads) if (max < canUse[r]) max = canUse[r];
//		if (write >= 0 && max < canUse[write]) throw new ExecuteException("WW Hazard!!");
		stalled += max - clock;
		clock = max + 1;
		if (write >= 0) canUse[write] = clock + delay[opecode];
	}
	
	//Cache
	protected static final int ICACHESIZE = 1 << 8;
	protected static final int DCACHESIZE = 1 << 11;
	protected int[] icache;
	protected int[] dcache;
	
	protected void icache(int a) {
		a >>>= 3;
		if (icache[a & (ICACHESIZE - 1)] != a) {
			icache[a & (ICACHESIZE - 1)] = a;
			clock += 6;
			iMiss++;
		} else {
			iHit++;
		}
	}
	
	protected void dcache(int a) {
		if (dcache[a & (DCACHESIZE - 1)] != a) {
			dcache[a & (DCACHESIZE - 1)] = a;
			clock += 6;
			for (int i = 0; i < 4; i++) dcache[(a + i) & (DCACHESIZE - 1)] = a + i;
			dMiss++;
		} else {
			dHit++;
		}
	}
	
	//BranchPrediction
	protected static final int BP_TABLE_SIZE = 1 << 13;
	protected int[] bpTable;
	protected int bpHistory;
	
	protected void branchPredict(int taken) {
		int p = (pc & (BP_TABLE_SIZE - 1)) ^ (bpHistory << 4);
		if (taken == (bpTable[p] & 1)) {
			bpHit++;
		} else {
			bpMiss++;
			clock += 2;
		}
		bpTable[p] = taken << 1 | bpTable[p] >>> 1;
		bpHistory = (bpHistory << 1 | taken) & ((1 << 9) - 1);
	}
	
	@Override
	public String[] getViews() {
		ArrayList<String> list = new ArrayList<String>(asList(super.getViews()));
		list.add("CallStack");
		return list.toArray(new String[0]);
	}
	
	//CallStack
	@Override
	public SimView createView(String name) {
		if (name.equals("CallStack")) {
			return new CallStackView();
		}
		return super.createView(name);
	}
	
	protected class CallStackView extends SimView {
		
		protected DefaultTableModel tableModel;
		protected JTable table;
		
		protected CallStackView() {
			super("CallStack");
			tableModel = new DefaultTableModel();
			table = new JTable(tableModel);
			table.setFont(FONT);
			table.setDefaultRenderer(Object.class, new DefaultTableCellRenderer() {
				public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
					super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
					if (callDepth - 1 == row) {
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
			setPreferredSize(new Dimension(200, 300));
			pack();
		}
		
		@Override
		public void refresh() {
			String[] label = {"Depth", "PC"};
			String[][] data = new String[MAXDEPTH][2];
			for (int i = 0; i < MAXDEPTH; i++) {
				data[i][0] = "" + i;
				data[i][1] = "" + callStack[i];
			}
			tableModel.setDataVector(data, label);
			table.getColumnModel().getColumn(0).setMinWidth(50);
			table.getColumnModel().getColumn(0).setMaxWidth(50);
		}
		
	}
	
	//Data
	@Override
	protected Data[] getData() {
		ArrayList<Data> list = new ArrayList<Data>(asList(super.getData()));
		list.add(new StallData());
		list.add(new ICacheData());
		list.add(new DCacheData());
		list.add(new BranchData());
		return list.toArray(new Data[0]);
	}
	
	protected class StallData extends Data {
		
		private long m;
		
		protected StallData() {
			super("Stall");
		}
		
		@Override
		protected void begin() {
			m = stalled;
		}
		
		@Override
		protected void end(int pc) {
			data[pc] += stalled - m;
		}
		
	}
	
	protected class ICacheData extends Data {
		
		private long m;
		
		protected ICacheData() {
			super("ICacheMiss");
		}
		
		@Override
		protected void begin() {
			m = iMiss;
		}
		
		@Override
		protected void end(int pc) {
			data[pc] += iMiss - m;
		}
		
	}
	
	protected class DCacheData extends Data {
		
		private long m;
		
		protected DCacheData() {
			super("DCacheMiss");
		}
		
		@Override
		protected void begin() {
			m = dMiss;
		}
		
		@Override
		protected void end(int pc) {
			data[pc] += dMiss - m;
		}
		
	}
	
	protected class BranchData extends Data {
		
		private long m;
		
		protected BranchData() {
			super("BranchMiss");
		}
		
		@Override
		protected void begin() {
			m = bpMiss;
		}
		
		@Override
		protected void end(int pc) {
			data[pc] += bpMiss - m;
		}
		
	}
	
	//Stat
	protected static final String[] NAME = new String[64];
	static {
		NAME[000] = "li";
		NAME[010] = "add";
		NAME[001] = "addi";
		NAME[011] = "sub";
		NAME[002] = "sll";
		NAME[012] = "cmp";
		NAME[003] = "cmpi";
		NAME[020] = "fadd";
		NAME[021] = "fsub";
		NAME[022] = "fmul";
		NAME[023] = "finv";
		NAME[024] = "fsqrt";
		NAME[025] = "fcmp";
		NAME[006] = "fabs";
		NAME[007] = "fneg";
		NAME[030] = "load";
		NAME[031] = "loadr";
		NAME[032] = "store";
		NAME[050] = "read";
		NAME[051] = "write";
		NAME[052] = "ledout";
		NAME[060] = "nop";
		NAME[061] = "halt";
		NAME[005] = "mov";
		NAME[070] = "jmp";
		NAME[071] = "call";
		NAME[072] = "ret";
	}
	protected long[] countOpe;
	protected long[] clockOpe;
	protected long stalled;
	protected int dataSize, stackSize, heapSize;
	protected long dataLoad, stackLoad, heapLoad;
	protected long dataStore, stackStore, heapStore;
	protected long iHit, iMiss, dHit, dMiss;
	protected long bpHit, bpMiss;
	
	protected void printStat() {
		System.err.println();
		System.err.printf("コード長:%d%n", prog.ss.length);
		System.err.println();
		System.err.println("* Time");
		System.err.printf("| Total | %.3f |%n", clock / Hz);
		System.err.printf("| Instruction | %.3f |%n", instruction / Hz);
		System.err.printf("| Stall | %.3f |%n", stalled / Hz);
		System.err.printf("| ICacheMiss | %.3f |%n", iMiss * 6 / Hz);
		System.err.printf("| DCacheMiss | %.3f |%n", dMiss * 6 / Hz);
		System.err.printf("| BranchMiss | %.3f |%n", bpMiss * 2 / Hz);
		System.err.println();
		System.err.println("* InstructionCount");
		System.err.println("| Name | Count | Clocks | CPI |");
		System.err.printf("| Total | %,d | %,d | %.3f |%n", instruction, clock, (double)clock / instruction);
		for (int i = 0; i < NAME.length; i++) if (NAME[i] != null) {
			System.err.printf("| %s | %,d (%.3f) | %,d (%.3f) | %.3f |%n", NAME[i], countOpe[i], 100.0 * countOpe[i] / instruction, clockOpe[i], 100.0 * clockOpe[i] / clock, countOpe[i] == 0 ? 0 : (double)clockOpe[i] / countOpe[i]);
		}
		System.err.println();
		System.err.println("* CallStack");
		System.err.printf("| MaxDepth | %d |%n", maxDepth);
		System.err.println();
		System.err.println("* Memory");
		System.err.printf("| Type | Size | Load | Store |%n");
		System.err.printf("| Data | %,d | %,d | %,d |%n", dataSize, dataLoad, dataStore);
		System.err.printf("| Stack | %,d | %,d | %,d |%n", stackSize, stackLoad, stackStore);
		System.err.printf("| Heap | %,d | %,d | %,d |%n", heapSize, heapLoad, heapStore);
		System.err.println();
		System.err.println("* ICache");
		System.err.printf("| Total | %,d |%n", iHit + iMiss);
		System.err.printf("| Hit | %,d (%.3f) |%n", iHit, 100.0 * iHit / (iHit + iMiss));
		System.err.printf("| Miss | %,d (%.3f) |%n", iMiss, 100.0 * iMiss / (iHit + iMiss));
		System.err.println();
		System.err.println("* DCache");
		System.err.printf("| Total | %,d |%n", dHit + dMiss);
		System.err.printf("| Hit | %,d (%.3f) |%n", dHit, 100.0 * dHit / (dHit + dMiss));
		System.err.printf("| Miss | %,d (%.3f) |%n", dMiss, 100.0 * dMiss / (dHit + dMiss));
		System.err.println();
		System.err.println("* BranchPrediction");
		System.err.printf("| Total | %,d |%n", bpHit + bpMiss);
		System.err.printf("| Hit | %,d (%.3f) |%n", bpHit, 100.0 * bpHit / (bpHit + bpMiss));
		System.err.printf("| Miss | %,d (%.3f) |%n", bpMiss, 100.0 * bpMiss / (bpHit + bpMiss));
		System.err.println();
	}
	
	//Debug
	protected static class Debug extends SuperScalar {
		
		@Override
		protected long getBinary(String op, Parser p) {
			if (op.equals("debug_int")) {
				return typeI(060, 1, reg(p), 0);
			} else if (op.equals("debug_float")) {
				return typeI(060, 2, reg(p), 0);
			} else if (op.equals("break")) {
				return typeI(060, 3, 0, 0);
			}
			return super.getBinary(op, p);
		}
		
		@Override
		protected void step(int ope, int opecode, int rs, int rt, int rd, int imm) {
			if (opecode == 060 && rs == 1) { //debug_int
				System.err.printf("%s(%d)%n", toHex(regs[rt]), regs[rt]);
				changePC(pc + 1);
			} else if (opecode == 060 && rs == 2) { //debug_float
				System.err.printf("%.6E%n", itof(regs[rt]));
				changePC(pc + 1);
			} else if (opecode == 060 && rs == 3) { //break
				changePC(pc + 1);
				throw new ExecuteException("Break!");
			} else {
				super.step(ope, opecode, rs, rt, rd, imm);
			}
		}
	}
	
	//NoStat
	protected static class NoStat extends SuperScalar {
		
		@Override
		protected Data[] getData() {
			return new Data[0];
		}
		
	}
	
	//FPU
	protected static class FPU extends MasterScalar {
		@Override
		protected int fadd(int a, int b) {
			return cpu.fpu.FPU.fadd(a, b);
		}

		@Override
		protected int fsub(int a, int b) {
			return cpu.fpu.FPU.fadd(a, fneg(b));
		}

		@Override
		protected int fmul(int a, int b) {
			return cpu.fpu.FPU.fmul(a, b);
		}

		@Override
		protected int finv(int a) {
			return cpu.fpu.FPU.finv(a);
		}

		@Override
		protected int fsqrt(int a) {
			return cpu.fpu.FPU.fsqrt(a);
		}

		@Override
		protected int fneg(int a) {
			return cpu.fpu.FPU.fneg(a);
		}
	}
	
}
