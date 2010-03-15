package test;

/*
 * テスト用のコードは、atan を実行して止まる、みたいなのを作っておく
 */



import sim.ExecuteException;

import util.Utils;
import asm.AssembleException;
import asm.Assembler;
import asm.Program;
import cpu.MasterScalar;



class TesterCPU extends MasterScalar.FPU {
	public void setReg(int i, int x) {
		regs[i] = x;
	}

	public int getReg(int i) {
		return regs[i];
	}

	public void revive() {
		halted = false;
		pc = 0;
	}

	@Override
	public void printStat() {
	}
}





class AtanTester extends MathLibraryTester {
	@Override
	protected double answer(double x) {
		return Math.atan(x);
	}
}



class SinTester extends MathLibraryTester {
	@Override
	protected double answer(double x) {
		return Math.sin(x);
	}
}



class CosTester extends MathLibraryTester {
	@Override
	protected double answer(double x) {
		return Math.cos(x);
	}
}






public class MathLibraryTester {
	TesterCPU cpu;
	double maxError;



	public void init(TesterCPU cpu) {
		this.cpu = cpu;
		this.maxError = -1.0;
	}



	protected void test(int s, int e, int m) {
		int b = makeFloat(s, e, m);

		cpu.revive();
		cpu.setReg(66, b);
		try {
			for (;;) cpu.step();
		} catch (ExecuteException ee) {
			// System.err.println(ee.getMessage());
		}

		double res = (double)Utils.itof(cpu.getReg(65));
		double ans = answer(Utils.itof(b));
		double err = relativeError(ans, res);

		if (Double.isNaN(err)) {
			System.out.printf("%08x %e NaN (%e %e)\n", b, Utils.itof(b), ans, res, err);
		}
		else if (err > maxError) {
			System.out.printf("%08x %e %e %e %e\n", b, Utils.itof(b), ans, res, err);
			maxError = err;
		}
	}



	protected void testAll() {
		// ゼロ
		test(0, 0, 0);
		test(1, 0, 0);

		// 正規化数
		for (int s = 0; s <= 1; s++) {
		// {
			long start = System.currentTimeMillis();

			for (int e = 1; e < 254; e++) {
				//for (int m = 0; m < (1 << 23); m++) {
				// {
				for (int m = 0; m < (1 << 18); m++) {
					test(s, e, m);
				}

				int done = e - 0;
				int rest = 253 - e;
				if (rest > 0) {
					long sec = (System.currentTimeMillis() - start) / done * rest / 1000;
					System.out.printf("(s, e) = (%d, %3d) / %02d:%02d remaining\n", s, e, sec / 60, sec % 60);
				}

			}
		}
	}



	// Override me !!
	protected double answer(double x) {
		return 0.0;
	}



	protected static double relativeError(double x, double y) {
		if (x == 0.0 && y == 0.0) return 0.0;
		else return Math.abs(x - y) / Math.max(Math.abs(x), Math.abs(y));
	}



	protected static int makeFloat(int s, int e, int m) {
		return s << 31 | e << 23 | m;
	}



	public static void usageExit() {
		System.err.println("Usage");
		System.err.println("  testing atan: -a file");
		System.err.println("  testing sin : -s file");
		System.err.println("  testing cos : -c file");
		System.exit(1);
	}



	public static void main(String[] args) {
		if (args.length != 2) usageExit();

		MathLibraryTester tester = null;
		if (args[0].equals("-a")) tester = new AtanTester();
		if (tester == null) usageExit();

		String fileName = args[1];
		String encoding = "UTF-8";
		String[] lines = sim.Main.readLines(sim.Main.openInputFile(fileName), encoding);

		TesterCPU cpu = new TesterCPU();
		Program prog = null;
		try {
			prog = Assembler.assemble(cpu, lines);
		} catch (AssembleException e) {
			System.err.printf("エラー: %s%n", e.getMessage());
			System.exit(1);
		}

		cpu.init(prog, false);
		tester.init(cpu);
		tester.testAll();
	}
}