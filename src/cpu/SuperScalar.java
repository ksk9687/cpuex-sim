package cpu;

import asm.*;

public class SuperScalar extends CPU {
	
	protected static int typeR(int op, int rs, int rt, int rd) {
		return op << 26 | rs << 20 | rt << 14 | rd << 8;
	}
	
	protected static int typeI(int op, int rs, int rt, int imm) {
		return op << 26 | rs << 20 | rt << 14 | imm;
	}
	
	public SuperScalar() {
		super(100e6, 1 << 20, 1 << 6);
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
			return typeI(17, reg(p), reg(p), imm(p, 16, true));
		} else if (op.equals("hsread")) {
			throw new AssembleException("Not implemented");
		} else if (op.equals("hswrite")) {
			throw new AssembleException("Not implemented");
		} else if (op.equals("read")) {
			return typeI(20, 0, 0, 0);
		} else if (op.equals("write")) {
			return typeI(21, 0, 0, 0);
		} else if (op.equals("ledout")) {
			return typeI(22, 0, 0, 0);
		} else if (op.equals("nop")) {
			return typeI(23, 0, 0, 0);
		} else if (op.equals("halt")) {
			return typeI(24, 0, 0, 0);
		} else if (op.equals("mov")) {
			return typeI(25, 0, 0, 0);
		} else if (op.equals("jmp")) {
			return typeI(26, 0, 0, 0);
		} else if (op.equals("jal")) {
			return typeI(27, 0, 0, 0);
		} else if (op.equals("jr")) {
			return typeI(28, 0, 0, 0);
		}
		return super.getBinary(op, p);
	}
	
}
