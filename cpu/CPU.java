package cpu;

import static util.Utils.*;
import java.util.*;
import asm.*;

public class CPU {
	
	public HashMap<String, Integer> iregs = new HashMap<String, Integer>();
	public HashMap<String, Integer> fregs = new HashMap<String, Integer>();
	public HashMap<String, Integer> allregs = new HashMap<String, Integer>();
	
	public CPU() {
		for (int i = 0; i < 16; i++) iregs.put("$i" + i, i + 16);
		for (int i = 0; i < 16; i++) fregs.put("$f" + i, i);
		allregs.putAll(iregs);
		allregs.putAll(fregs);
	}
	
	public int typeR(int op, int rs, int rt, int rd) {
		return op << 26 | rs << 21 | rt << 16 | rd << 11;
	}
	
	public int typeI(int op, int rs, int rt, int imm) {
		return op << 26 | rs << 21 | rt << 16 | imm;
	}
	
	public int typeJ(int op, int imm) {
		return op << 26 | imm;
	}
	
	public static int imm(int i, int len, boolean signExt) {
		if (i < 0) {
			if (!signExt || i <= (-1 ^ 1 << (len - 1))) {
				throw new AssembleException("オペランドの値が不正です");
			}
		} else {
			if (i >= 1 << len) throw new NumberFormatException();
			if (signExt && i >= 1 << (len - 1)) {
				//行数も表示
				System.err.printf("警告: %s%n", "符号拡張により負の数となります");
			}
		}
		return getBits(i, len - 1, 0);
	}
	
	public static int reg(Map<String, Integer> regs, String reg) {
		if (!regs.containsKey(reg)) {
			throw new AssembleException("レジスタが不正です");
		}
		return regs.get(reg);
	}
	
	public int getBinary(Parser p) {
		String s = p.next();
		if (s.equals("_add")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(0, reg(allregs, rs), reg(allregs, rt), reg(allregs, rd));
		} else if (s.equals("_sub")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(2, reg(allregs, rs), reg(allregs, rt), reg(allregs, rd));
		} else if (s.equals("add")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(0, reg(iregs, rs), reg(iregs, rt), reg(iregs, rd));
		} else if (s.equals("addi")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(1, reg(allregs, rs), reg(allregs, rt), imm(i, 16, true));
		} else if (s.equals("sub")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(2, reg(iregs, rs), reg(iregs, rt), reg(iregs, rd));
		} else if (s.equals("rl")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(3, reg(allregs, rs), reg(allregs, rt), imm(i, 5, false));
		} else if (s.equals("sll")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(4, reg(allregs, rs), reg(allregs, rt), imm(i, 5, false));
		} else if (s.equals("fadd")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(5, reg(fregs, rs), reg(fregs, rt), reg(fregs, rd));
		} else if (s.equals("fsub")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(6, reg(fregs, rs), reg(fregs, rt), reg(fregs, rd));
		} else if (s.equals("fmul")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(7, reg(fregs, rs), reg(fregs, rt), reg(fregs, rd));
		} else if (s.equals("finv")) {
			String rs = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(8, reg(fregs, rs), 0, reg(fregs, rd));
		} else if (s.equals("load")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(9, reg(allregs, rs), reg(allregs, rt), imm(i, 16, true));
		} else if (s.equals("li")) {
			String rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(10, 0, reg(allregs, rt), imm(i, 16, true));
		} else if (s.equals("store")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			int i = p.nextImm();
			p.end();
			return typeI(11, reg(allregs, rs), reg(allregs, rt), imm(i, 16, true));
		} else if (s.equals("cmp")) {
			String rs = p.nextReg();
			String rt = p.nextReg();
			String rd = p.nextReg();
			p.end();
			return typeR(12, reg(allregs, rs), reg(allregs, rt), reg(allregs, rd));
		} else if (s.equals("_jmp")) {
			String rs = p.nextReg();
			int t = p.nextImm();
			int i = p.nextImm();
			p.end();
			return typeI(13, reg(allregs, rs), imm(t, 3, false), imm(i, 16, true));
		} else if (s.equals("jal")) {
			int i = p.nextImm();
			p.end();
			return typeJ(14, imm(i, 26, false));
		} else if (s.equals("jr")) {
			String rs = p.nextReg();
			p.end();
			return typeI(15, reg(allregs, rs), 0, 0);
		} else if (s.equals("read")) {
			String rs = p.nextReg();
			p.end();
			return typeI(16, reg(allregs, rs), 0, 0);
		} else if (s.equals("write")) {
			String rs = p.nextReg();
			p.end();
			return typeI(17, reg(allregs, rs), 0, 0);
		} else if (s.equals("nop")) {
			p.end();
			return typeJ(18, 0);
		} else if (s.equals("halt")) {
			p.end();
			return typeJ(19, 0);
		} else {
			throw new ParseException();
		}
	}
	
}
