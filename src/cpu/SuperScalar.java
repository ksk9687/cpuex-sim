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
			return typeI(031, reg(p), reg(p), reg(p));
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
	}
	
	protected static int cmp(int a, int b) {
		return a > b ? 4 : a == b ? 2 : 1;
	}
	
	protected static int fcmp(int a, int b) {
		float fa = itof(a), fb = itof(b);
		return fa > fb ? 4 : fa == fb ? 2 : 1;
	}
	
	protected final void step(int ope) {
		int opecode = ope >>> 26;
		int rs = ope >>> 20 & (REGISTERSIZE - 1);
		int rt = ope >>> 14 & (REGISTERSIZE - 1);
		int rd = ope >>> 8 & (REGISTERSIZE - 1);
		int imm = ope & ((1 << 14) - 1);
		clock += 1;
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
			cond = cmp(regs[rs], imm);
			pc++;
		} else if (opecode == 020) { //fadd
			regs[rd] = ftoi(itof(regs[rs]) + itof(regs[rt]));
			pc++;
		} else if (opecode == 021) { //fsub
			regs[rd] = ftoi(itof(regs[rs]) - itof(regs[rt]));
			pc++;
		} else if (opecode == 022) { //fmul
			regs[rd] = ftoi(itof(regs[rs]) * itof(regs[rt]));
			pc++;
		} else if (opecode == 023) { //finv
			regs[rd] = ftoi(1.0f / itof(regs[rs]));
			pc++;
		} else if (opecode == 024) { //fsqrt
			regs[rd] = ftoi((float)sqrt(itof(regs[rs])));
			pc++;
		} else if (opecode == 025) { //fcmp
			cond = fcmp(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 026) { //fabs
			regs[rd] = ftoi(abs(itof(regs[rs])));
			pc++;
		} else if (opecode == 027) { //fneg
			regs[rd] = ftoi(-(itof(regs[rs])));
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
			regs[63] = pc + 1;
			pc = imm;
		} else if (opecode == 072) { //jr
			pc = regs[rs];
		} else {
			super.step(ope);
		}
	}
	
}
