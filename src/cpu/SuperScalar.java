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
			return typeI(0, 0, reg(p), imm(p, 14, false));
		} else if (op.equals("add")) {
			return typeR(1, reg(p), reg(p), reg(p));
		} else if (op.equals("addi")) {
			return typeI(2, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("sub")) {
			return typeR(3, reg(p), reg(p), reg(p));
		} else if (op.equals("sll")) {
			return typeI(4, reg(p), reg(p), imm(p, 5, false));
		} else if (op.equals("cmp")) {
			return typeI(5, reg(p), reg(p), 0);
		} else if (op.equals("cmpi")) {
			return typeI(6, reg(p), 0, imm(p, 14, true));
		} else if (op.equals("fadd")) {
			return typeR(7, reg(p), reg(p), reg(p));
		} else if (op.equals("fsub")) {
			return typeR(8, reg(p), reg(p), reg(p));
		} else if (op.equals("fmul")) {
			return typeR(9, reg(p), reg(p), reg(p));
		} else if (op.equals("finv")) {
			return typeR(10, reg(p), 0, reg(p));
		} else if (op.equals("fsqrt")) {
			return typeR(11, reg(p), 0, reg(p));
		} else if (op.equals("fcmp")) {
			return typeI(12, reg(p), reg(p), 0);
		} else if (op.equals("fabs")) {
			return typeR(13, reg(p), 0, reg(p));
		} else if (op.equals("fneg")) {
			return typeR(14, reg(p), 0, reg(p));
		} else if (op.equals("load")) {
			return typeI(15, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("loadr")) {
			return typeI(16, reg(p), reg(p), reg(p));
		} else if (op.equals("store")) {
			return typeI(17, reg(p), reg(p), imm(p, 14, true));
		} else if (op.equals("hsread")) {
			throw new AssembleException("Not implemented");
		} else if (op.equals("hswrite")) {
			throw new AssembleException("Not implemented");
		} else if (op.equals("read")) {
			return typeI(20, 0, reg(p), 0);
		} else if (op.equals("write")) {
			return typeI(21, reg(p), 0, 0);
		} else if (op.equals("ledout")) {
			return typeI(22, reg(p), 0, 0);
		} else if (op.equals("nop")) {
			return typeI(23, 0, 0, 0);
		} else if (op.equals("halt")) {
			return typeI(24, 0, 0, 0);
		} else if (op.equals("mov")) {
			return typeI(25, reg(p), reg(p), 0);
		} else if (op.equals("jmp")) {
			return typeI(26, imm(p, 3, false), 0, imm(p, 14, false));
		} else if (op.equals("jal")) {
			return typeI(27, reg(p), 0, 0);
		} else if (op.equals("jr")) {
			return typeI(28, 0, 0, 0);
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
		int rs = ope >>> 21 & (REGISTERSIZE - 1);
		int rt = ope >>> 16 & (REGISTERSIZE - 1);
		int rd = ope >>> 11 & (REGISTERSIZE - 1);
		int imm = ope & ((1 << 16) - 1);
		int addr = ope & ((1 << (26)) - 1);
		clock += 1;
		step(ope, opecode, rs, rt, rd, imm, addr);
	}
	
	protected void step(int ope, int opecode, int rs, int rt, int rd, int imm, int addr) {
		if (opecode == 0) { //li
			regs[rd] = imm;
			pc++;
		} else if (opecode == 1) { //add
			regs[rd] = regs[rs] + regs[rt];
			pc++;
		} else if (opecode == 2) { //addi
			regs[rt] = regs[rs] + signExt(imm, 14);
			pc++;
		} else if (opecode == 3) { //sub
			regs[rd] = regs[rs] - regs[rt];
			pc++;
		} else if (opecode == 4) { //sll
			regs[rt] = regs[rs] << imm;
			pc++;
		} else if (opecode == 5) { //cmp
			cond = cmp(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 6) { //cmpi
			cond = cmp(regs[rs], imm);
			pc++;
		} else if (opecode == 7) { //fadd
			regs[rd] = ftoi(itof(regs[rs]) + itof(regs[rt]));
			pc++;
		} else if (opecode == 8) { //fsub
			regs[rd] = ftoi(itof(regs[rs]) - itof(regs[rt]));
			pc++;
		} else if (opecode == 9) { //fmul
			regs[rd] = ftoi(itof(regs[rs]) * itof(regs[rt]));
			pc++;
		} else if (opecode == 10) { //finv
			regs[rd] = ftoi(1.0f / itof(regs[rs]));
			pc++;
		} else if (opecode == 11) { //fsqrt
			regs[rd] = ftoi((float)sqrt(itof(regs[rs])));
			pc++;
		} else if (opecode == 12) { //fcmp
			cond = fcmp(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 13) { //fabs
			regs[rd] = ftoi(abs(itof(regs[rs])));
			pc++;
		} else if (opecode == 14) { //fneg
			regs[rd] = ftoi(-(itof(regs[rs])));
			pc++;
		} else if (opecode == 15) { //load
			regs[rt] = load(regs[rs] + signExt(imm, 14));
			pc++;
		} else if (opecode == 16) { //loadr
			regs[rd] = load(regs[rs] + regs[rt]);
			pc++;
		} else if (opecode == 17) { //store
			store(regs[rs] + signExt(imm, 14), regs[rt]);
			pc++;
		} else if (opecode == 18) { //hsread
			throw new ExecuteException("Not implemented");
		} else if (opecode == 19) { //hswrite
			throw new ExecuteException("Not implemented");
		} else if (opecode == 20) { //read
			regs[rt] = read();
			pc++;
		} else if (opecode == 21) { //write
			cond = write(regs[rs]);
			pc++;
		} else if (opecode == 22) { //ledout
			System.err.printf("LED: %s%n", toBinary(regs[rs]).substring(24));
			pc++;
		} else if (opecode == 23) { //nop
			pc++;
		} else if (opecode == 24) { //halt
			halted = true;
		} else if (opecode == 25) { //mov
			regs[rt] = regs[rs];
			pc++;
		} else if (opecode == 26) { //jmp
			if ((cond & rs) == 0) {
				pc = imm;
			} else {
				pc++;
			}
		} else if (opecode == 27) { //jal
			regs[63] = pc + 1;
			pc = imm;
		} else if (opecode == 28) { //jr
			pc = regs[rs];
		} else {
			super.step(ope);
		}
	}
	
}
