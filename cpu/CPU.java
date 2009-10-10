package cpu;

import static util.Utils.*;
import asm.*;
import java.util.*;

public class CPU {
	
	public int parse(Map<String, Integer> labels, String s) {
		if (labels != null && labels.containsKey(s)) return labels.get(s);
		if (s.startsWith("0x")) return parseHex(s.substring(2));
		if (s.startsWith("0b")) return parseBinary(s.substring(2));
		if (s.indexOf('.') >= 0) return ftoi(Float.parseFloat(s));
		return Integer.parseInt(s);
	}
	
	public int parse(Map<String, Integer> labels, String s, int len, int offset, boolean signExt, int line) {
		int i;
		if (labels != null && labels.containsKey(s)) i = labels.get(s) - offset;
		else if (s.startsWith("0x")) i = parseHex(s.substring(2));
		else if (s.startsWith("0b")) i = parseBinary(s.substring(2));
		else i = Integer.parseInt(s);
		if (i < 0) {
			if (!signExt || i <= (-1 ^ 1 << (len - 1))) throw new NumberFormatException();
		} else {
			if (i >= 1 << len) throw new NumberFormatException();
			if (signExt && i >= 1 << (len - 1)) {
				System.err.printf("警告: %d行目: %s: 符号拡張により負の数となります%n", line, s);
			}
		}
		return getBits(i, len - 1, 0);
	}
	
	public int parseRegister(String s) {
		if (!s.startsWith("$")) {
			throw new NumberFormatException();
		}
		return parse(null, s.substring(1), 5, 0, false, 0);
	}
	
	public int[] assemble(Map<String, Integer> labels, int[] lines, String[][] ts) throws ParseException {
		int n = lines.length;
		int[] binary = new int[n];
		for (int i = 0; i < n; i++) {
			String[] ss = ts[i];
			int line = lines[i];
			int j = 1;
			try {
				if (ss[0].equals("add")) {
					binary[i] = 0 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parseRegister(ss[j++]) << 11;
				} else if (ss[0].equals("addi")) {
					binary[i] = 1 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parse(labels, ss[j++], 16, 0, true, line);
				} else if (ss[0].equals("sub")) {
					binary[i] = 2 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parseRegister(ss[j++]) << 11;
				} else if (ss[0].equals("srl")) {
					binary[i] = 3 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parse(null, ss[j++], 5, 0, false, line);
				} else if (ss[0].equals("sll")) {
					binary[i] = 4 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parse(null, ss[j++], 5, 0, false, line);
				} else if (ss[0].equals("fadd")) {
					binary[i] = 5 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parseRegister(ss[j++]) << 11;
				} else if (ss[0].equals("fsub")) {
					binary[i] = 6 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parseRegister(ss[j++]) << 11;
				} else if (ss[0].equals("fmul")) {
					binary[i] = 7 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parseRegister(ss[j++]) << 11;
				} else if (ss[0].equals("finv")) {
					binary[i] = 8 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 11;
				} else if (ss[0].equals("load")) {
					binary[i] = 9 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parse(labels, ss[j++], 16, 0, true, line);
				} else if (ss[0].equals("li")) {
					binary[i] = 10 << 26 | parseRegister(ss[j++]) << 16 | parse(labels, ss[j++], 16, 0, true, line);
				} else if (ss[0].equals("store")) {
					binary[i] = 11 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parse(labels, ss[j++], 16, 0, true, line);
				} else if (ss[0].equals("cmp")) {
					binary[i] = 12 << 26 | parseRegister(ss[j++]) << 21 | parseRegister(ss[j++]) << 16 | parseRegister(ss[j++]) << 11;
				} else if (ss[0].equals("jmp")) {
					binary[i] = 13 << 26 | parseRegister(ss[j++]) << 21 | parse(null, ss[j++], 3, 0, false, line) << 16 | parse(labels, ss[j++], 16, i, true, line);
				} else if (ss[0].equals("jal")) {
					binary[i] = 14 << 26 | parse(labels, ss[j++], 26, 0, false, line);
				} else if (ss[0].equals("jr")) {
					binary[i] = 15 << 26 | parseRegister(ss[j++]) << 21;
				} else if (ss[0].equals("read")) {
					binary[i] = 16 << 26 | parseRegister(ss[j++]) << 21;
				} else if (ss[0].equals("write")) {
					binary[i] = 17 << 26 | parseRegister(ss[j++]) << 21;
				} else if (ss[0].equals("nop")) {
					binary[i] = 18 << 26;
				} else if (ss[0].equals("halt")) {
					binary[i] = 19 << 26;
				} else if (ss[0].equals("set")) {
					//これじゃだめぽ
					binary[i] = 10 << 26 | parseRegister(ss[j++]) << 16 | parse(labels, ss[j++], 16, 0, true, line);
				} else if (ss[0].equals("raw")) {
					binary[i] = parse(labels, ss[j++]);
				} else {
					throw new ParseException(String.format("%d行目: %s: 不正な命令", line, ss[0]));
				}
				if (j != ss.length) throw new ArrayIndexOutOfBoundsException();
			} catch (ArrayIndexOutOfBoundsException e) {
				throw new ParseException(String.format("%d行目: 不正なオペランド数", line));
			} catch (NumberFormatException e) {
				throw new ParseException(String.format("%d行目: %s: 不正なオペランド", line, ss[j - 1]));
			}
		}
		return binary;
	}
	
}
