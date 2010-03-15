package cpu;

import static java.lang.Math.*;
import static java.util.Arrays.*;
import static util.Utils.*;
import java.util.*;
import sim.*;
import asm.*;

public class MasterScalar extends CPU36 {

	public MasterScalar() {
		super(150e6, 1 << 17, 1 << 6);
	}

	//Asm
	protected static long typeI(long unitop, long op, long rs, long imm, long rd) {
		return unitop << 33 | op << 30 | rs << 22 | rd << 16 | imm;
	}

	protected static long typeR(long unitop, long op, long rs, long rt, long rd) {
		return unitop << 33 | op << 30 | rs << 22 | rd << 16 | rt << 10;
	}

	protected static long typeF(long unitop, long op, long subop, long rs, long rt, long rd) {
		return unitop << 33 | op << 30 | subop << 28 | rs << 22 | rd << 16 | rt << 10;
	}

	protected static long typeM(long unitop, long op, long rs, long imm2, long rt) {
		return unitop << 33 | op << 30 | rs << 22 | (imm2 >> 10 & 0xf) << 18 | rt << 10 | (imm2 & ((1 << 10) - 1)) | 1L << 28;
	}

	protected static long typeJ(long unitop, long op, long mask, long rs, long rt, long imm2) {
		return unitop << 33 | op << 31 | mask << 28 | rs << 22 | (imm2 >> 10 & 0xf) << 18 | rt << 10 | (imm2 & ((1 << 10) - 1));
	}

	@Override
	protected long getBinary(String op, Parser p) {
		if (op.equals("li")) {
			return typeI(0, 0, 0, imm(p, 14, false), ireg(p));
		} else if (op.equals("addi")) {
			return typeI(0, 1, ireg(p), imm(p, 14, false), ireg(p));
		} else if (op.equals("subi")) {
			return typeI(0, 2, ireg(p), imm(p, 14, false), ireg(p));
		} else if (op.equals("mov")) {
			return typeI(0, 4, ireg(p), 0, ireg(p));
		} else if (op.equals("add")) {
			return typeR(0, 5, ireg(p), ireg(p), ireg(p));
		} else if (op.equals("sub")) {
			return typeR(0, 6, ireg(p), ireg(p), ireg(p));
		} else if (op.equals("cmpjmp")) {
			return typeJ(6, 0, imm(p, 3, false), ireg(p), ireg(p), imm(p, 14, false));
		} else if (op.equals("cmpijmp")) {
			return typeJ(6, 1, imm(p, 3, false), ireg(p), imm(p, 8, true), imm(p, 14, false));
		} else if (op.equals("fcmpjmp")) {
			return typeJ(6, 2, imm(p, 3, false), freg(p), freg(p), imm(p, 14, false));
		} else if (op.equals("jal")) {
			return typeI(0, 3, 0, imm(p, 14, false), ireg(p));
		} else if (op.equals("jr")) {
			return typeI(6, 6, ireg(p), 0, 0);
		} else if (op.equals("fadd")) {
			return typeF(4, 0, imm(p, 2, false), freg(p), freg(p), freg(p));
		} else if (op.equals("fsub")) {
			return typeF(4, 1, imm(p, 2, false), freg(p), freg(p), freg(p));
		} else if (op.equals("fmul")) {
			return typeF(4, 2, imm(p, 2, false), freg(p), freg(p), freg(p));
		} else if (op.equals("finv")) {
			return typeF(4, 3, imm(p, 2, false), freg(p), 0, freg(p));
		} else if (op.equals("fsqrt")) {
			return typeF(4, 4, imm(p, 2, false), freg(p), 0, freg(p));
		} else if (op.equals("fmov")) {
			return typeF(4, 5, imm(p, 2, false), freg(p), 0, freg(p));
		} else if (op.equals("load")) {
			return typeI(2, 0, ireg(p), imm(p, 14, true), ireg(p));
		} else if (op.equals("loadr")) {
			return typeR(2, 1, ireg(p), ireg(p), ireg(p));
		} else if (op.equals("store")) {
			return typeM(2, 2, ireg(p), imm(p, 14, true), ireg(p));
		} else if (op.equals("store_inst")) {
			return typeM(2, 2, ireg(p), 0, ireg(p)) | 1L << 29;
		} else if (op.equals("fload")) {
			return typeI(2, 4, ireg(p), imm(p, 14, true), freg(p));
		} else if (op.equals("floadr")) {
			return typeR(2, 5, ireg(p), ireg(p), freg(p));
		} else if (op.equals("fstore")) {
			return typeM(2, 6, ireg(p), imm(p, 14, true), freg(p));
		} else if (op.equals("imovf")) {
			return typeR(2, 3, 0, ireg(p), freg(p));
		} else if (op.equals("fmovi")) {
			return typeR(2, 7, 0, freg(p), ireg(p));
		} else if (op.equals("read")) {
			return typeI(3, 0, 0, 0, ireg(p)) | 1L << 28;
		} else if (op.equals("write")) {
			return typeI(3, 2, ireg(p), 0, ireg(p)) | 1L << 28;
		} else if (op.equals("ledout")) {
			return typeI(3, 4, ireg(p), 0, ireg(p)) | 1L << 28;
		} else if (op.equals("ledouti")) {
			return typeI(3, 6, 0, imm(p, 8, false), ireg(p)) | 1L << 28;
		} else if (op.equals("nop")) {
			return typeI(5, 7, 0, 0, 0);
		} else if (op.equals("break")) {
			return typeI(7, 0, 0, 0, 0);
		}
		return super.getBinary(op, p);
	}

	//Sim
	@Override
	protected void init() {
		super.init();
		countOpe = new long[256];
		dcache = new int[DCACHESIZE];
		fill(dcache, -1);
		bpTable = new int[BP_TABLE_SIZE];
		dataSize = prog.data.length;
		stackSize = heapSize = 0;
		dataLoad = stackLoad = heapLoad = 0;
		dataStore = stackStore = heapStore = 0;
		dHit = dMiss = 0;
		bpHit = bpMiss = 0;
	}

	@Override
	protected void step(long ope) {
		clock++;
		countOpe[getBits(ope, 35, 28)]++;
		int unitop = getBits(ope, 35, 33);
		if (unitop == 0) {
			//ALU
			int op = getBits(ope, 32, 30);
			int rs = getBits(ope, 27, 22);
			int rt = getBits(ope, 15, 10);
			int rd = getBits(ope, 21, 16);
			int imm = getBits(ope, 13, 0);
			if (op == 0) { //li
				regs[rd] = imm;
				changePC(pc + 1);
			} else if (op == 1) { //addi
				regs[rd] = regs[rs] + imm;
				changePC(pc + 1);
			} else if (op == 2) { //subi
				regs[rd] = regs[rs] - imm;
				changePC(pc + 1);
			} else if (op == 4) { //mov
				regs[rd] = regs[rs];
				changePC(pc + 1);
			} else if (op == 5) { //add
				regs[rd] = regs[rs] + regs[rt];
				changePC(pc + 1);
			} else if (op == 6) { //sub
				regs[rd] = regs[rs] - regs[rt];
				changePC(pc + 1);
			} else if (op == 3) { //jal
				regs[rd] = pc + 1;
				changePC(imm);
			} else {
				super.step(ope);
			}
		} else if (unitop == 6) {
			//JMP
			int jop = getBits(ope, 32, 31);
			int mask = getBits(ope, 30, 28);
			int rs = getBits(ope, 27, 22);
			int rt = getBits(ope, 15, 10);
			int imm2 = getBits(ope, 21, 18) << 10 | getBits(ope, 9, 0);
			int imm3 = getBits(ope, 17, 10);
			if (jop == 0) { //cmpjmp
				int cond = cmp(regs[rs], regs[rt]);
				branchPredict((cond & mask) == 0 ? 1 : 0);
				if ((cond & mask) == 0) {
					changePC(imm2);
				} else {
					changePC(pc + 1);
				}
			} else if (jop == 1) { //cmpijmp
				int cond = cmp(regs[rs], signExt(imm3, 8));
				branchPredict((cond & mask) == 0 ? 1 : 0);
				if ((cond & mask) == 0) {
					if (imm2 == pc) { //halt
						halted = true;
						printStat();
					} else {
						changePC(imm2);
					}
				} else {
					changePC(pc + 1);
				}
			} else if (jop == 2) { //fcmpjmp
				rs += 64;
				rt += 64;
				int cond = fcmp(regs[rs], regs[rt]);
				branchPredict((cond & mask) == 0 ? 1 : 0);
				if ((cond & mask) == 0) {
					changePC(imm2);
				} else {
					changePC(pc + 1);
				}
			} else if (jop == 3) { //jr
				changePC(regs[rs]);
			} else {
				super.step(ope);
			}
		} else if (unitop == 4) {
			//FPU
			int op = getBits(ope, 32, 30);
			int subop = getBits(ope, 29, 28);
			int rs = 64 + getBits(ope, 27, 22);
			int rt = 64 + getBits(ope, 15, 10);
			int rd = 64 + getBits(ope, 21, 16);
			if (op == 0) { //fadd
				regs[rd] = fabsneg(fadd(regs[rs], regs[rt]), subop);
				changePC(pc + 1);
			} else if (op == 1) { //fsub
				regs[rd] = fabsneg(fsub(regs[rs], regs[rt]), subop);
				changePC(pc + 1);
			} else if (op == 2) { //fmul
				regs[rd] = fabsneg(fmul(regs[rs], regs[rt]), subop);
				changePC(pc + 1);
			} else if (op == 3) { //finv
				regs[rd] = fabsneg(finv(regs[rs]), subop);
				changePC(pc + 1);
			} else if (op == 4) { //fsqrt
				regs[rd] = fabsneg(fsqrt(regs[rs]), subop);
				changePC(pc + 1);
			} else if (op == 5) { //fmov
				regs[rd] = fabsneg(regs[rs], subop);
				changePC(pc + 1);
			} else {
				super.step(ope);
			}
		} else if (unitop == 2) {
			//LOADSTORE
			int op = getBits(ope, 32, 30);
			int rs = getBits(ope, 27, 22);
			int rt = getBits(ope, 15, 10);
			int rd = getBits(ope, 21, 16);
			int imm = getBits(ope, 13, 0);
			int imm2 = getBits(ope, 21, 18) << 10 | getBits(ope, 9, 0);
			if (op == 0) { //load
				regs[rd] = load(regs[rs] + signExt(imm, 14));
				changePC(pc + 1);
			} else if (op == 1) { //loadr
				regs[rd] = load(regs[rs] + regs[rt]);
				changePC(pc + 1);
			} else if (op == 2) {
				if ((ope >> 29 & 1) != 0) { //store_inst
					store_inst(regs[rs], regs[rt]);
					changePC(pc + 1);
				} else { //store
					store(regs[rs] + signExt(imm2, 14), regs[rt]);
					changePC(pc + 1);
				}
			} else if (op == 4) { //fload
				rd += 64;
				regs[rd] = load(regs[rs] + signExt(imm, 14));
				changePC(pc + 1);
			} else if (op == 5) { //floadr
				rd += 64;
				regs[rd] = load(regs[rs] + regs[rt]);
				changePC(pc + 1);
			} else if (op == 6) { //fstore
				rt += 64;
				store(regs[rs] + signExt(imm2, 14), regs[rt]);
				changePC(pc + 1);
			} else if (op == 3) { //imovf
				rd += 64;
				regs[rd] = regs[rt];
				changePC(pc + 1);
			} else if (op == 7) { //fmovi
				rt += 64;
				regs[rd] = regs[rt];
				changePC(pc + 1);
			} else {
				super.step(ope);
			}
		} else if (unitop == 3) {
			//IO
			int op = getBits(ope, 32, 30);
			int rs = getBits(ope, 27, 22);
			int rd = getBits(ope, 21, 16);
			int imm = getBits(ope, 13, 0);
			if (op == 0) { //read
				regs[rd] = read();
				changePC(pc + 1);
			} else if (op == 2) { //write
				regs[rd] = write(regs[rs]);
				changePC(pc + 1);
			} else if (op == 4) { //ledout
				ledout(regs[rs]);
				changePC(pc + 1);
			} else if (op == 6) { //ledouti
				ledout(imm);
				changePC(pc + 1);
			} else {
				super.step(ope);
			}
		} else if (unitop == 5) {
			//NOP
			int op = getBits(ope, 32, 30);
			if (op == 7) { // nop
				changePC(pc + 1);
			} else {
				super.step(ope);
			}
		} else if (unitop == 7) {
			changePC(pc + 1);
			throw new ExecuteException("Break!");
		} else {
			super.step(ope);
		}
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

	protected int fabsneg(int a, int subop) {
		if (subop == 0) return a;
		if (subop == 1) return fneg(a);
		if (subop == 2) return fabs(a);
		throw new ExecuteException(String.format("IllegalFlag"));
	}

	protected int fabs(int a) {
		return ftoi(abs(itof(a)));
	}

	protected int fneg(int a) {
		return ftoi(-(itof(a)));
	}

	@Override
	protected int load(int addr) {
		if (addr < 0x2000) dataLoad++;
		else if (addr < 0x20000 - 1000) {
			heapLoad++;
			heapSize = max(heapSize, addr - 0x2000 + 1);
		} else {
			stackLoad++;
			stackSize = max(stackSize, 0x20000 - addr);
		}
		dcache(addr);
		return super.load(addr);
	}

	@Override
	protected void store(int addr, int i) {
		if (addr < 0x4000) dataStore++;
		else if (addr < 0x20000 - 1000) {
			heapStore++;
			heapSize = max(heapSize, addr - 0x4000 + 1);
		} else {
			stackStore++;
			stackSize = max(stackSize, 0x20000 - addr);
		}
		super.store(addr, i);
	}

	//Cache
	protected static final int DCACHESIZE = 1 << 13;
	protected int[] dcache;

	protected void dcache(int a) {
		if (dcache[a & (DCACHESIZE - 1)] != a) {
			for (int i = 0; i < 4; i++) {
				dcache[(a & ~3 | (a + i) & 3) & (DCACHESIZE - 1)] = (a & ~3 | (a + i) & 3);
			}
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
			//clock += 2;
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

	//Data
	@Override
	protected Data[] getData() {
		ArrayList<Data> list = new ArrayList<Data>(asList(super.getData()));
		list.add(new DCacheData());
		list.add(new BranchData());
		return list.toArray(new Data[0]);
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
	protected enum Ope {

		li			(0, "000000"),
		addi		(0, "000001"),
		subi		(0, "000010"),
		mov			(0, "000100"),
		add			(0, "000101"),
		sub			(0, "000110"),
		bl			(0, "11000110"),
		be			(0, "11000101"),
		ble			(0, "11000100"),
		bge			(0, "11000001"),
		bne			(0, "11000010"),
		bg			(0, "11000011"),
		bli			(0, "11001110"),
		bei			(0, "11001101"),
		blei		(0, "11001100"),
		bgei		(0, "11001001"),
		bnei		(0, "11001010"),
		bgi			(0, "11001011"),
		b			(0, "11001000"),
		blf			(0, "11010110"),
		bef			(0, "11010101"),
		blef		(0, "11010100"),
		bgef		(0, "11010001"),
		bnef		(0, "11010010"),
		bgf			(0, "11010011"),
		jal			(0, "000011"),
		jr			(0, "110110"),
		fadd		(0, "10000000"),
		fsub		(0, "10000100"),
		fmul		(0, "10001000"),
		finv		(0, "10001100"),
		fsqrt		(0, "10010000"),
		fmov		(0, "10010100"),
		fadd_a		(0, "10000010"),
		fsub_a		(0, "10000110"),
		fmul_a		(0, "10001010"),
		finv_a		(0, "10001110"),
		fsqrt_a		(0, "10010010"),
		fabs		(0, "10010110"),
		fadd_n		(0, "10000001"),
		fsub_n		(0, "10000101"),
		fmul_n		(0, "10001001"),
		finv_n		(0, "10001101"),
		fsqrt_n		(0, "10010001"),
		fneg		(0, "10010101"),
		load		(0, "010000"),
		loadr		(0, "010001"),
		store		(0, "010010"),
		fload		(0, "010100"),
		floadr		(0, "010101"),
		fstore		(0, "010110"),
		imovf		(0, "010011"),
		fmovi		(0, "010111"),
		read		(0, "011000"),
		write		(0, "011010"),
		nop			(0, "101111"),

		_li			(1, "000000"),
		_addi		(1, "000001"),
		_subi		(1, "000010"),
		_mov		(1, "000100", "100101", "010011", "010111"),
		_add		(1, "000101"),
		_sub		(1, "000110"),
		_cmpjmp		(1, "11000"),
		_cmpijmp	(1, "11001001", "1100101", "110011"),
		_cmpfjmp	(1, "11010"),
		_jmp		(1, "11001000"),
		_jal		(1, "000011"),
		_jr			(1, "110110"),
		_fadd		(1, "100000"),
		_fsub		(1, "100001"),
		_fmul		(1, "100010"),
		_finv		(1, "100011"),
		_fsqrt		(1, "100100"),
		_load		(1, "010000", "010100"),
		_loadr		(1, "010001", "010101"),
		_store		(1, "010010", "010110"),
		_read		(1, "011000"),
		_write		(1, "011010"),
		_nop		(1, "101111"),

		ALU			(2, "000"),
		FPU			(2, "100"),
		LOADSTORE	(2, "010"),
		IO			(2, "011"),
		JMP			(2, "110");

		Ope(int level, String...bin) {
			this.level = level;
			from = new int[bin.length];
			to = new int[bin.length];
			for (int j = 0; j < bin.length; j++) {
				int i = parseBinary(bin[j]);
				int size = 8 - bin[j].length();
				from[j] = i << size;
				to[j] = (i + 1) << size;
			}
		}

		protected final int level;
		protected final int[] from, to;

	}

	protected long[] countOpe;
	protected int dataSize, stackSize, heapSize;
	protected long dataLoad, stackLoad, heapLoad;
	protected long dataStore, stackStore, heapStore;
	protected long dHit, dMiss;
	protected long bpHit, bpMiss;

	protected void printStat() {
		System.err.println();
		System.err.printf("コード長:%d%n", prog.ss.length);
		System.err.println();
		for (int level = 0; level < 3; level++) {
			System.err.println("* InstructionCount" + "SML".charAt(level));
			System.err.println("| Name | Count |");
			System.err.printf("| Total | %,d |%n", instruction);
			for (Ope ope : Ope.values()) if (ope.level == level) {
				long count = 0;
				for (int j = 0; j < ope.from.length; j++) {
					for (int i = ope.from[j]; i < ope.to[j]; i++) {
						count += countOpe[i];
					}
				}
				String name = ope.name();
				if (level == 1) name = name.substring(1);
				System.err.printf("| %s | %,d (%.3f) |%n", name, count, 100.0 * count / instruction);
			}
			System.err.println();
		}
		System.err.println("* Memory");
		System.err.printf("| Type | Size | Load | Store |%n");
		System.err.printf("| Data | %,d | %,d | %,d |%n", dataSize, dataLoad, dataStore);
		System.err.printf("| Stack | %,d | %,d | %,d |%n", stackSize, stackLoad, stackStore);
		System.err.printf("| Heap | %,d | %,d | %,d |%n", heapSize, heapLoad, heapStore);
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

	//NoStat
	protected static class NoStat extends MasterScalar {

		@Override
		protected Data[] getData() {
			return new Data[] {new InstructionData()};
		}

	}

	//FPU
	public static class FPU extends MasterScalar {
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

		@Override
		protected Data[] getData() {
			return new Data[] {new InstructionData()};
		}

		@Override
		protected void dcache(int a) {
		}

		@Override
		protected void branchPredict(int taken) {
		}
	}


}
