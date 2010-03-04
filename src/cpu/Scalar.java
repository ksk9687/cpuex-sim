package cpu;

import static java.util.Arrays.*;
import static util.Utils.*;
import sim.*;
import asm.*;

public class Scalar extends CPU32 {
	
	public Scalar() {
		super(50e6, 1 << 20, 1 << 5);
	}
	
	//Asm
	protected static int typeR(int op, int rs, int rt, int rd) {
		return op << 26 | rs << 21 | rt << 16 | rd << 11;
	}
	
	protected static int typeI(int op, int rs, int rt, int imm) {
		return op << 26 | rs << 21 | rt << 16 | imm;
	}
	
	protected static int typeJ(int op, int imm) {
		return op << 26 | imm;
	}
	
	@Override
	protected long getBinary(String op, Parser p) {
		if (op.equals("add")) {
			return typeR(0, reg(p), reg(p), reg(p));
		} else if (op.equals("addi")) {
			return typeI(1, reg(p), reg(p), imm(p, 16, true));
		} else if (op.equals("sub")) {
			return typeR(2, reg(p), reg(p), reg(p));
		} else if (op.equals("srl")) {
			return typeI(3, reg(p), reg(p), imm(p, 5, false));
		} else if (op.equals("sll")) {
			return typeI(4, reg(p), reg(p), imm(p, 5, false));
		} else if (op.equals("fadd")) {
			return typeR(5, reg(p), reg(p), reg(p));
		} else if (op.equals("fsub")) {
			return typeR(6, reg(p), reg(p), reg(p));
		} else if (op.equals("fmul")) {
			return typeR(7, reg(p), reg(p), reg(p));
		} else if (op.equals("finv")) {
			return typeR(8, reg(p), 0, reg(p));
		} else if (op.equals("load")) {
			return typeI(9, reg(p), reg(p), imm(p, 16, true));
		} else if (op.equals("li")) {
			return typeI(10, 0, reg(p), imm(p, 16, true));
		} else if (op.equals("store")) {
			return typeI(11, reg(p), reg(p), imm(p, 16, true));
		} else if (op.equals("cmp")) {
			return typeR(12, reg(p), reg(p), reg(p));
		} else if (op.equals("_jmp")) {
			return typeI(13, reg(p), imm(p, 3, false), imm(p, 16, true));
		} else if (op.equals("jal")) {
			return typeJ(14, imm(p, 26, false));
		} else if (op.equals("jr")) {
			return typeI(15, reg(p), 0, 0);
		} else if (op.equals("read")) {
			return typeI(16, 0, reg(p), 0);
		} else if (op.equals("write")) {
			return typeI(17, reg(p), reg(p), 0);
		} else if (op.equals("nop")) {
			return typeJ(18, 0);
		} else if (op.equals("halt")) {
			return typeJ(19, 0);
		} else if (op.equals("fcmp")) {
			return typeR(20, reg(p), reg(p), reg(p));
		} else if (op.equals("ledout")) {
			return typeR(21, reg(p), 0, 0);
		}
		return super.getBinary(op, p);
	}
	
	//Sim
	protected static int cmp(int a, int b) {
		return a > b ? 4 : a == b ? 2 : 1;
	}
	
	protected static int fcmp(int a, int b) {
		float fa = itof(a), fb = itof(b);
		return fa > fb ? 4 : fa == fb ? 2 : 1;
	}
	
	@Override
	protected void init() {
		super.init();
		countOpe = new long[64];
		countCall = new long[MEMORYSIZE];
		icache = new int[ICACHESIZE];
		dcache = new int[DCACHESIZE];
		fill(icache, -1);
		fill(dcache, -1);
		ihit = 0;
		imiss = 0;
		dhit = 0;
		dmiss = 0;
	}
	
	@Override
	protected final void step(long _ope) {
		int ope = (int)_ope;
		int opecode = ope >>> 26;
		int rs = ope >>> 21 & (REGISTERSIZE - 1);
		int rt = ope >>> 16 & (REGISTERSIZE - 1);
		int rd = ope >>> 11 & (REGISTERSIZE - 1);
		int imm = ope & ((1 << 16) - 1);
		int addr = ope & ((1 << (26)) - 1);
		clock += 1;
		icache(pc);
		step(ope, opecode, rs, rt, rd, imm, addr);
	}
	
	protected void step(int ope, int opecode, int rs, int rt, int rd, int imm, int addr) {
		countOpe[opecode]++;
		if (opecode == 0) { //add
			regs[rd] = regs[rs] + regs[rt];
			pc++;
			clock += 2;
		} else if (opecode == 1) { //addi
			regs[rt] = regs[rs] + signExt(imm, 16);
			pc++;
			clock += 1;
		} else if (opecode == 2) { //sub
			regs[rd] = regs[rs] - regs[rt];
			pc++;
			clock += 2;
		} else if (opecode == 3) { //srl
			regs[rt] = regs[rs] >>> imm;
			pc++;
			clock += 1;
		} else if (opecode == 4) { //sll
			regs[rt] = regs[rs] << imm;
			pc++;
			clock += 1;
		} else if (opecode == 5) { //fadd
			regs[rd] = ftoi(itof(regs[rs]) + itof(regs[rt]));
			pc++;
			clock += 4;
		} else if (opecode == 6) { //fsub
			regs[rd] = ftoi(itof(regs[rs]) - itof(regs[rt]));
			pc++;
			clock += 4;
		} else if (opecode == 7) { //fmul
			regs[rd] = ftoi(itof(regs[rs]) * itof(regs[rt]));
			pc++;
			clock += 3;
		} else if (opecode == 8) { //finv
			regs[rd] = ftoi(1.0f / itof(regs[rs]));
			pc++;
			clock += 3;
		} else if (opecode == 9) { //load
			int a = regs[rs] + signExt(imm, 16);
			regs[rt] = load(a);
			pc++;
			clock += 1;
			dcache(a);
		} else if (opecode == 10) { //li
			regs[rt] = signExt(imm, 16);
			pc++;
			clock += 1;
		} else if (opecode == 11) { //store
			store(regs[rs] + signExt(imm, 16), regs[rt]);
			pc++;
			clock += 1;
		} else if (opecode == 12) { //cmp
			regs[rd] = cmp(regs[rs], regs[rt]);
			pc++;
			clock += 2;
		} else if (opecode == 13) { //jmp
			if ((regs[rs] & rt) == 0) {
				pc += signExt(imm, 16);
			} else {
				pc++;
			}
			clock += 1;
		} else if (opecode == 14) { //jal
			countCall[addr]++;
			regs[31] = pc + 1;
			pc = addr;
			clock += 1;
		} else if (opecode == 15) { //jr
			pc = regs[rs];
			clock += 1;
		} else if (opecode == 16) { //read
			regs[rt] = read();
			pc++;
			clock += 8;
		} else if (opecode == 17) { //write
			regs[rt] = write(regs[rs]);
			pc++;
			clock += 8;
		} else if (opecode == 18) { //nop
			pc++;
		} else if (opecode == 19) { //halt
			printStat();
			halted = true;
		} else if (opecode == 20) { //fcmp
			regs[rd] = fcmp(regs[rs], regs[rt]);
			pc++;
			clock += 3;
		} else if (opecode == 21) { //ledout
			System.out.printf("LED: %s%n", toBinary(regs[rs]).substring(24));
			pc++;
		} else {
			super.step(ope);
		}
	}
	
	//Cache
	protected final int ICACHESIZE = 1 << 12;
	protected final int DCACHESIZE = 1 << 11;
	protected int[] icache;
	protected int[] dcache;
	
	protected void icache(int a) {
		if (icache[a & (ICACHESIZE - 1)] != a) {
			icache[a & (ICACHESIZE - 1)] = a;
			clock += 3;
			imiss++;
		} else {
			ihit++;
		}
	}
	
	protected void dcache(int a) {
		if (dcache[a & (DCACHESIZE - 1)] != a) {
			dcache[a & (DCACHESIZE - 1)] = a;
			clock += 2;
			dmiss++;
		} else {
			dhit++;
		}
	}
	
	//Stat
	protected final String[] NAME = {"add", "addi", "sub", "srl", "sll", "fadd", "fsub", "fmul", "finv", "load", "li", "store", "cmp", "jmp", "jal", "jr", "read", "write", "nop", "halt", "fcmp", "ledout"};
	protected long[] countOpe;
	protected long[] countCall;
	protected long ihit, imiss;
	protected long dhit, dmiss;
	
	protected void printStat() {
		System.out.println("* 命令実行数");
		System.out.printf("| Total | %,d |%n", instruction);
		for (int i = 0; i < NAME.length; i++) {
			System.out.printf("| %s | %,d (%.3f) |%n", NAME[i], countOpe[i], 100.0 * countOpe[i] / (instruction));
		}
		System.out.println();
		System.out.println("* ICache");
		System.out.printf("| Total | %,d |%n", ihit + imiss);
		System.out.printf("| Hit | %,d (%.3f) |%n", ihit, 100.0 * ihit / (ihit + imiss));
		System.out.printf("| Miss | %,d (%.3f) |%n", imiss, 100.0 * imiss / (ihit + imiss));
		System.out.println();
		System.out.println("* DCache");
		System.out.printf("| Total | %,d |%n", dhit + dmiss);
		System.out.printf("| Hit | %,d (%.3f) |%n", dhit, 100.0 * dhit / (dhit + dmiss));
		System.out.printf("| Miss | %,d (%.3f) |%n", dmiss, 100.0 * dmiss / (dhit + dmiss));
	}
	
	//Debug
	protected static class Debug extends Scalar {
		
		@Override
		protected long getBinary(String op, Parser p) {
			if (op.equals("debug_int")) {
				return typeI(63, reg(p), 0, 0);
			} else if (op.equals("debug_float")) {
				return typeI(62, reg(p), 0, 0);
			} else if (op.equals("break")) {
				return typeJ(61,0);
			}
			return super.getBinary(op, p);
		}
		
		@Override
		protected void step(int ope, int opecode, int rs, int rt, int rd, int imm, int addr) {
			if (opecode == 63) { //debug_int
				System.out.printf("%s(%d)%n", toHex(regs[rs]), regs[rs]);
				pc++;
			} else if (opecode == 62) { //debug_float
				System.out.printf("%.6E%n", itof(regs[rs]));
				pc++;
			} else if (opecode == 61) { //break
				pc++;
				throw new ExecuteException("Break!");
			} else {
				super.step(ope, opecode, rs, rt, rd, imm, addr);
			}
		}
	}
	
}
