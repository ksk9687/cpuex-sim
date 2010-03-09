package cpu;

import static util.Utils.*;
import java.io.*;
import asm.*;

public abstract class CPU32 extends CPU {
	
	public CPU32(double hz, int memorySize, int registerSize) {
		super(hz, memorySize, registerSize, 0, false);
	}
	
	//Asm
	@Override
	public void asmOut(Program prog, DataOutputStream out, boolean fillNop) throws IOException {
		out.writeInt(prog.ss.length);
		for (Statement s : prog.ss) {
			out.writeInt((int)s.binary);
		}
		out.close();
	}
	
	@Override
	public void vhdlOut(Program prog, PrintWriter out) {
		for (Statement s : prog.ss) {
			out.printf("\"%s\",%n", toBinary((int)s.binary));
		}
		out.close();
	}
	
}
