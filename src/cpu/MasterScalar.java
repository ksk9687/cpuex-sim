package cpu;

import static java.lang.Math.*;
import static util.Utils.*;
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
		return unitop << 33 | op << 30 | rs << 22 | (imm2 >> 10 & 0xf) << 18 | rt << 10 | (imm2 & ((1 << 10) - 1));
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
			return typeM(2, 2, ireg(p), imm(p, 14, true), ireg(p)) | 1L << 29;
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
			return typeI(3, 0, 0, 0, ireg(p));
		} else if (op.equals("write")) {
			return typeI(3, 2, ireg(p), 0, ireg(p));
		} else if (op.equals("ledout")) {
			return typeI(3, 4, ireg(p), 0, 0);
		} else if (op.equals("ledouti")) {
			return typeI(3, 6, 0, imm(p, 8, false), 0);
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
	}
	
	@Override
	protected void step(long ope) {
		clock++;
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
			int op = getBits(ope, 32, 31);
			int mask = getBits(ope, 30, 28);
			int rs = getBits(ope, 27, 22);
			int rt = getBits(ope, 15, 10);
			int imm2 = getBits(ope, 21, 18) << 10 | getBits(ope, 9, 0);
			int imm3 = getBits(ope, 17, 10);
			if (op == 0) { //cmpjmp
				int cond = cmp(regs[rs], regs[rt]);
				if ((cond & mask) == 0) {
					if (imm2 == pc) { //halt
						halted = true;
						System.err.println();
					} else {
						changePC(imm2);
					}
				} else {
					changePC(pc + 1);
				}
			} else if (op == 1) { //cmpijmp
				int cond = cmp(regs[rs], signExt(imm3, 8));
				if ((cond & mask) == 0) {
					changePC(imm2);
				} else {
					changePC(pc + 1);
				}
			} else if (op == 2) { //fcmpjmp
				rs += 64;
				rt += 64;
				int cond = fcmp(regs[rs], regs[rt]);
				if ((cond & mask) == 0) {
					changePC(imm2);
				} else {
					changePC(pc + 1);
				}
			} else if (op == 3) { //jr
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
			} else if (op == 2) { //store
				store(regs[rs] + signExt(imm2, 14), regs[rt]);
				changePC(pc + 1);
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
	
}
