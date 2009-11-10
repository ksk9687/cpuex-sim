package cpu;

import static java.lang.Math.*;
import static util.Utils.*;
import sim.*;
import asm.*;

public class SuperScalar extends CPU {
	
	public SuperScalar() {
		super(100e6, 1 << 20, 1 << 6);
	}
	
	//Asm
	protected static int typeR(int op, int rs, int rt, int rd) {
		return op << 26 | rs << 20 | rt << 14 | rd << 8;
	}
	
	protected static int typeI(int op, int rs, int rt, int imm) {
		return op << 26 | rs << 20 | rt << 14 | imm;
	}
	
	protected int getBinary(String op, Parser p) {
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
			return typeR(026, reg(p), 0, reg(p));
		} else if (op.equals("fneg")) {
			return typeR(027, reg(p), 0, reg(p));
		} else if (op.equals("load")) {
			return typeI(030, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("loadr")) {
			return typeR(031, reg(p), reg(p), reg(p));
		} else if (op.equals("store")) {
			return typeI(032, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("hsread")) {
			throw new AssembleException("Not implemented");
		} else if (op.equals("hswrite")) {
			throw new AssembleException("Not implemented");
		} else if (op.equals("read")) {
			return typeI(050, 0, reg(p), 0);
		} else if (op.equals("write")) {
			return typeI(051, reg(p), 0, 0);
		} else if (op.equals("ledout")) {
			return typeI(052, reg(p), 0, 0);
		} else if (op.equals("nop")) {
			return typeI(060, 0, 0, 0);
		} else if (op.equals("halt")) {
			return typeI(061, 0, 0, 0);
		} else if (op.equals("mov")) {
			return typeI(047, reg(p), reg(p), 0);
		} else if (op.equals("jmp")) {
			return typeI(070, imm(p, 3, false), 0, imm(p, 14, false));
		} else if (op.equals("jal")) {
			return typeI(071, 0, 0, imm(p, 14, false));
		} else if (op.equals("jr")) {
			return typeI(072, reg(p), 0, 0);
		}
		return super.getBinary(op, p);
	}
	
	//Sim
	protected int cond;
	
	protected void init() {
		super.init();
		cond = 0;
		countOpe = new long[64];
		countCall = new long[MEMORYSIZE];
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
	
	protected final void step(int ope) {
		int opecode = ope >>> 26;
		int rs = ope >>> 20 & (REGISTERSIZE - 1);
		int rt = ope >>> 14 & (REGISTERSIZE - 1);
		int rd = ope >>> 8 & (REGISTERSIZE - 1);
		int imm = ope & ((1 << 14) - 1);
		clock += 1;
		countOpe[opecode]++;
		step(ope, opecode, rs, rt, rd, imm);
	}
	
	protected void step(int ope, int opecode, int rs, int rt, int rd, int imm) {
		if (opecode == 000) { //li
			regs[rt] = imm;
			pc++;
		} else if (opecode == 010) { //add
			regs[rd] = regs[rs] + regs[rt];
			pc++;
		} else if (opecode == 001) { //addi
			regs[rt] = regs[rs] + signExt(imm, 14);
			pc++;
		} else if (opecode == 011) { //sub
			regs[rd] = regs[rs] - regs[rt];
			pc++;
		} else if (opecode == 002) { //sll
			regs[rt] = regs[rs] << imm;
			pc++;
		} else if (opecode == 012) { //cmp
			cond = cmp(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 003) { //cmpi
			cond = cmp(regs[rs], signExt(imm, 14));
			pc++;
		} else if (opecode == 020) { //fadd
			regs[rd] = fadd(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 021) { //fsub
			regs[rd] = fsub(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 022) { //fmul
			regs[rd] = fmul(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 023) { //finv
			regs[rd] = finv(regs[rs]);
			pc++;
		} else if (opecode == 024) { //fsqrt
			regs[rd] = fsqrt(regs[rs]);
			pc++;
		} else if (opecode == 025) { //fcmp
			cond = fcmp(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 026) { //fabs
			regs[rd] = fabs(regs[rs]);
			pc++;
		} else if (opecode == 027) { //fneg
			regs[rd] = fneg(regs[rs]);
			pc++;
		} else if (opecode == 030) { //load
			regs[rt] = load(regs[rs] + signExt(imm, 14));
			pc++;
		} else if (opecode == 031) { //loadr
			regs[rd] = load(regs[rs] + regs[rt]);
			pc++;
		} else if (opecode == 032) { //store
			store(regs[rs] + signExt(imm, 14), regs[rt]);
			pc++;
		} else if (opecode == 040) { //hsread
			throw new ExecuteException("Not implemented");
		} else if (opecode == 041) { //hswrite
			throw new ExecuteException("Not implemented");
		} else if (opecode == 050) { //read
			regs[rt] = read();
			pc++;
		} else if (opecode == 051) { //write
			cond = write(regs[rs]);
			pc++;
		} else if (opecode == 052) { //ledout
			System.err.printf("LED: %s%n", toBinary(regs[rs]).substring(24));
			pc++;
		} else if (opecode == 060) { //nop
			pc++;
		} else if (opecode == 061) { //halt
			printStat();
			halted = true;
		} else if (opecode == 047) { //mov
			regs[rt] = regs[rs];
			pc++;
		} else if (opecode == 070) { //jmp
			if ((cond & rs) == 0) {
				pc = imm;
			} else {
				pc++;
			}
		} else if (opecode == 071) { //jal
			countCall[imm]++;
			regs[63] = pc + 1;
			pc = imm;
		} else if (opecode == 072) { //jr
			pc = regs[rs];
		} else {
			super.step(ope);
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
		NAME[026] = "fabs";
		NAME[027] = "fneg";
		NAME[030] = "load";
		NAME[031] = "loadr";
		NAME[032] = "store";
		NAME[040] = "hsread";
		NAME[041] = "hswrite";
		NAME[050] = "read";
		NAME[051] = "write";
		NAME[052] = "ledout";
		NAME[060] = "nop";
		NAME[061] = "halt";
		NAME[047] = "mov";
		NAME[070] = "jmp";
		NAME[071] = "jal";
		NAME[072] = "jr";
	}
	protected long[] countOpe;
	protected long[] countCall;
	
	protected void printStat() {
		System.err.println("* 命令実行数");
		System.err.printf("| Total | %,d |%n", instruction);
		for (int i = 0; i < NAME.length; i++) if (NAME[i] != null) {
			System.err.printf("| %s | %,d (%.3f) |%n", NAME[i], countOpe[i], 100.0 * countOpe[i] / (instruction));
		}
		System.err.println();
		System.err.println("* 関数呼び出し数(jalのみ)");
		for (int i = 0; i < MEMORYSIZE; i++) if (countCall[i] > 0 && ss[i].labels.length > 0) {
			String name = ss[i].labels[0];
			if (name.startsWith("min_caml_")) name = name.substring("min_caml_".length());
			if (name.indexOf('.') >= 0) name = name.substring(0, name.indexOf('.'));
			System.err.printf("| %s | %,d |%n", name, countCall[i]);
		}
	}
	
	//Debug
	protected static class Debug extends SuperScalar {
		
		protected int getBinary(String op, Parser p) {
			if (op.equals("debug_int")) {
				return typeI(060, 1, reg(p), 0);
			} else if (op.equals("debug_float")) {
				return typeI(060, 2, reg(p), 0);
			} else if (op.equals("break")) {
				return typeI(060, 3, 0, 0);
			}
			return super.getBinary(op, p);
		}
		
		protected void step(int ope, int opecode, int rs, int rt, int rd, int imm) {
			if (opecode == 060 && rs == 1) { //debug_int
				System.err.printf("%s(%d)%n", toHex(regs[rt]), regs[rt]);
				pc++;
			} else if (opecode == 060 && rs == 2) { //debug_float
				System.err.printf("%.6E%n", itof(regs[rt]));
				pc++;
			} else if (opecode == 060 && rs == 3) { //break
				pc++;
				throw new ExecuteException("Break!");
			} else {
				super.step(ope, opecode, rs, rt, rd, imm);
			}
		}
	}
	
	//FPU
	protected static class FPU extends SuperScalar {
		
		//TODO:ここにfaddとかをOverrideする
		
	}
	
}
