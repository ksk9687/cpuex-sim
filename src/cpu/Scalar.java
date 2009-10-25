package cpu;

import static util.Utils.*;
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
	
	public Scalar() {
		super(50e6, 1 << 20, 1 << 5);
	}
	
	protected int getBinary(String op, Parser p) {
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
		clock++;
		step(ope, opecode, rs, rt, rd, imm, addr);
	}
	
	protected void step(int ope, int opecode, int rs, int rt, int rd, int imm, int addr) {
		if (opecode == 0) { //add
			regs[rd] = regs[rs] + regs[rt];
			pc++;
		} else if (opecode == 1) { //addi
			regs[rt] = regs[rs] + signExt(imm, 16);
			pc++;
		} else if (opecode == 2) { //sub
			regs[rd] = regs[rs] - regs[rt];
			pc++;
		} else if (opecode == 3) { //srl
			regs[rt] = regs[rs] >>> imm;
			pc++;
		} else if (opecode == 4) { //sll
			regs[rt] = regs[rs] << imm;
			pc++;
		} else if (opecode == 5) { //fadd
			regs[rd] = ftoi(itof(regs[rs]) + itof(regs[rt]));
			pc++;
		} else if (opecode == 6) { //fsub
			regs[rd] = ftoi(itof(regs[rs]) - itof(regs[rt]));
			pc++;
		} else if (opecode == 7) { //fmul
			regs[rd] = ftoi(itof(regs[rs]) * itof(regs[rt]));
			pc++;
		} else if (opecode == 8) { //finv
			regs[rd] = ftoi(1.0f / itof(regs[rs]));
			pc++;
		} else if (opecode == 9) { //load
			regs[rt] = load(regs[rs] + signExt(imm, 16));
			pc++;
		} else if (opecode == 10) { //li
			regs[rt] = signExt(imm, 16);
			pc++;
		} else if (opecode == 11) { //store
			store(regs[rs] + signExt(imm, 16), regs[rt]);
			pc++;
		} else if (opecode == 12) { //cmp
			regs[rd] = cmp(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 13) { //jmp
			if ((regs[rs] & rt) == 0) {
				pc += signExt(imm, 16);
			} else {
				pc++;
			}
		} else if (opecode == 14) { //jal
			regs[31] = pc + 1;
			pc = addr;
		} else if (opecode == 15) { //jr
			pc = regs[rs];
		} else if (opecode == 16) { //read
			regs[rt] = read();
			pc++;
		} else if (opecode == 17) { //write
			regs[rt] = write(regs[rs]);
			pc++;
		} else if (opecode == 18) { //nop
			pc++;
		} else if (opecode == 19) { //halt
			halted = true;
		} else if (opecode == 20) { //fcmp
			regs[rd] = fcmp(regs[rs], regs[rt]);
			pc++;
		} else if (opecode == 21) { //ledout
			System.err.printf("LED: %s%n", toBinary(regs[rs]).substring(24));
			pc++;
		} else {
			super.step(ope);
		}
	}
	
	static class Debug extends Scalar {
		
		protected int getBinary(String op, Parser p) {
			if (op.equals("debug_int")) {
				return typeI(63, reg(p), 0, 0);
			} else if (op.equals("debug_float")) {
				return typeI(62, reg(p), 0, 0);
			} else if (op.equals("break")) {
				return typeJ(61,0);
			}
			return super.getBinary(op, p);
		}
		
		protected void step(int ope, int opecode, int rs, int rt, int rd, int imm, int addr) {
			if (opecode == 63) { //debug_int
				System.err.printf("%s(%d)%n", toHex(regs[rs]), regs[rs]);
				pc++;
			} else if (opecode == 62) { //debug_float
				System.err.printf("%.6E%n", itof(regs[rs]));
				pc++;
			} else if (opecode == 61) { //break
				pc++;
				throw new ExecuteException("Break!");
			} else {
				super.step(ope, opecode, rs, rt, rd, imm, addr);
			}
		}
	}
	
	static class Count extends Debug {
		String[] NAME = {"add", "addi", "sub", "srl", "sll", "fadd", "fsub", "fmul", "finv", "load", "li", "store", "cmp", "jmp", "jal", "jr", "read", "write", "nop", "halt", "fcmp", "ledout"};
		
		long[] countOpe = new long[64];
		long[] countCall = new long[MEMORYSIZE];
		
		protected void step(int ope, int opecode, int rs, int rt, int rd, int imm, int addr) {
			countOpe[opecode]++;
			if (opecode == 19) {
				System.err.println("* 命令実行数");
				System.err.printf("| Total | %,d |%n", instruction + 1);
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
				countCall[addr]++;
			}
			super.step(ope, opecode, rs, rt, rd, imm, addr);
		}
	}
	
}
