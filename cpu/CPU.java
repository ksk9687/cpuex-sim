package cpu;

import static util.Utils.*;
import java.util.*;
import sim.*;
import asm.*;

public abstract class CPU {
	
	public static final String DEFAULT = "cpu.Scalar";
	
	public static CPU loadCPU(String name) {
		try {
			Class<CPU> cpu = (Class<CPU>)Class.forName(name);
			return cpu.newInstance();
		} catch (Exception e) {
			failWith(String.format("%s: CPUが見つかりませんでした", name));
			throw new RuntimeException(e);
		}
	}
	
	protected static int imm(int i, int len, boolean signExt) {
		if (i < 0) {
			if (!signExt || i <= (-1 ^ 1 << (len - 1))) {
				throw new AssembleException("オペランドの値が不正です");
			}
		} else {
			if (i >= 1 << len) throw new NumberFormatException();
			if (signExt && i >= 1 << (len - 1)) {
				//行数も表示
				System.err.printf("警告: %s%n", Assembler.s.createMessage("符号拡張により負の数となります"));
			}
		}
		return getBits(i, len - 1, 0);
	}
	
	protected static int reg(Map<String, Integer> regs, String reg) {
		if (!regs.containsKey(reg)) {
			throw new AssembleException("レジスタが不正です");
		}
		return regs.get(reg);
	}
	
	public abstract int getBinary(Parser p);
	
	protected Simulator sim;
	
	public void init(Simulator sim, int[] bin) {
		this.sim = sim;
	}
	
	protected int read() {
		return sim.read();
	}
	
	protected void write(int i) {
		sim.write(i);
	}
	
	public abstract void clock();
	
}
