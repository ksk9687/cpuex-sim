package cpu;

import static util.Utils.*;
import java.io.*;
import java.util.*;
import asm.*;

public abstract class CPU36 extends CPU {
	
	public CPU36(double hz, int memorySize, int registerSize) {
		super(hz, memorySize, registerSize * 2, 256);
		for (int i = 0; i < registerSize; i++) {
			REGISTERNAME[i] = "$i" + i;
			REGISTERNAME[registerSize + i] = "$f" + i;
		}
	}
	
	//Asm
	protected int ireg(Parser p) {
		int i = p.nextReg("i");
		if (i < 0 || i >= REGISTERSIZE / 2) {
			throw new AssembleException("レジスタが不正です");
		}
		return i;
	}
	
	protected int freg(Parser p) {
		int i = p.nextReg("f");
		if (i < 0 || i >= REGISTERSIZE / 2) {
			throw new AssembleException("レジスタが不正です");
		}
		return i;
	}
	
	@Override
	public void asmOut(Program prog, DataOutputStream out, boolean fillNop) throws IOException {
		long nop = getBinary(new Parser(new String[] {"nop"}));
		int size = prog.ss.length - OFFSET;
		if (size % 2 == 1) size++;
		if (fillNop) size = 1 << 14;
		out.writeInt(size / 2 * 3);
		for (int i = 0; i < size; i += 2) {
			long data1 = nop, data2 = nop;
			if (OFFSET + i < prog.ss.length) data1 = prog.ss[OFFSET + i].binary;
			if (OFFSET + i + 1 < prog.ss.length) data2 = prog.ss[OFFSET + i + 1].binary;
			out.writeInt(getBits(data1, 35, 28));
			out.writeInt(getBits(data1, 27, 0) << 8 | getBits(data2, 35, 32));
			out.writeInt(getBits(data2, 31, 0));
		}
		out.writeInt(prog.ss.length);
		for (Statement s : prog.ss) {
			out.writeInt((int)s.binary);
		}
		out.close();
	}
	
	@Override
	public void vhdlOut(Program prog, PrintWriter out) {
		char[] cs = new char[36];
		Arrays.fill(cs, '0');
		String s0 = new String(cs);
		for (int i = OFFSET; i < prog.ss.length; i++) {
			String s = Long.toBinaryString(prog.ss[i].binary);
			out.printf("%s,%n", s0.substring(s.length()) + s);
		}
		out.close();
	}
	
}
