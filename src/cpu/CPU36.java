package cpu;

import static util.Utils.*;
import java.io.*;
import asm.*;

public abstract class CPU36 extends CPU {
	
	public CPU36(double hz, int memorySize, int registerSize) {
		super(hz, memorySize, registerSize * 2, 1 << 13, 256, true);
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
		int s = size / 2 * 3;
		out.writeByte(s >> 16 & 255);
		out.writeByte(s >> 8 & 255);
		out.writeByte(s & 255);
		for (int i = 0; i < size; i += 2) {
			long data1 = nop, data2 = nop;
			if (OFFSET + i < prog.ss.length) data1 = prog.ss[OFFSET + i].binary;
			if (OFFSET + i + 1 < prog.ss.length) data2 = prog.ss[OFFSET + i + 1].binary;
			out.writeInt(getBits(data1, 35, 28));
			out.writeInt(getBits(data1, 27, 0) << 4 | getBits(data2, 35, 32));
			out.writeInt(getBits(data2, 31, 0));
		}
		out.writeInt(prog.data.length);
		for (int i : prog.data) {
			out.writeInt(i);
		}
		out.close();
	}
	
	@Override
	public void vhdlOut(Program prog, PrintWriter out) {
		out.println("memory_initialization_radix=2;");
		out.println("memory_initialization_vector=");
		char[] cs = new char[72];
		for (int i = OFFSET; i < prog.ss.length; i += 2) {
			long a = prog.ss[i].binary, b = i + 1 < prog.ss.length ? prog.ss[i + 1].binary : 0;
			for (int j = 0; j < 36; j++) cs[j] = (char)('0' + (a >> (35 - j) & 1));
			for (int j = 0; j < 36; j++) cs[36 + j] = (char)('0' + (b >> (35 - j) & 1));
			out.printf("%s%c%n", String.valueOf(cs), i + 2 >= prog.ss.length ? ';' : ',');
		}
		out.close();
	}
	
	@Override
	protected void init() {
		store_inst_p = 0;
		super.init();
	}
	
	private int store_inst_p;
	
	protected void store_inst(int addr, int i) {
		long b = i & ((1L << 32) - 1);
		if (store_inst_p == 0) {
			bin[addr << 1] = bin[addr << 1 | 1] = 0;
			bin[addr << 1] |= b << 28;
		} else if (store_inst_p == 1) {
			bin[addr << 1] |= b >> 4;
			bin[addr << 1 | 1] |= (b & 15) << 32;
		} else {
			bin[addr << 1 | 1] |= b;
		}
		store_inst_p = (store_inst_p + 1) % 3;
	}
	
}
