package test;

/*
 * テスト用のコードは、atan を実行して止まる、みたいなのを作っておく
 */



import java.util.Random;

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





interface MathFunction {
	public double f(double x);
}

class AtanFunction implements MathFunction {
	public double f(double x) { return Math.atan(x); }
}

class SinFunction implements MathFunction {
	public double f(double x) {
		float t = (float)x;
		float y = t - (float)Math.PI * (float)Math.floor(t / (float)Math.PI);
		return Math.sin(x / ((float)Math.PI) * Math.PI);
		// return Math.sin(x / ((float)Math.PI) * Math.PI);
		// return Math.sin(x / Math.PI * ((float)Math.PI));
	}
}

class CosFunction implements MathFunction {
	public double f(double x) { return Math.cos(x); }
}





public class MathLibraryTester implements Runnable {
	static class MaxErrorManager {
		private double maxError = -1.0;

		synchronized double update(double newError) {
			if (newError > maxError) maxError = newError;
			return maxError;
		}
	}



	TesterCPU cpu;
	MathFunction mf;
	MaxErrorManager em;		// 全スレッドでの最大エラー
	double maxError;		// 各スレッドでの最大エラー

	boolean randomMode = false;
	int fromE = 1, toE = 253;


	public MathLibraryTester(TesterCPU cpu, MathFunction mf, MaxErrorManager em) {
		this.cpu = cpu;
		this.mf = mf;
		this.em = em;
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
		double ans = mf.f(Utils.itof(b));
		double err = relativeError(ans, res);

		if (Double.isNaN(err)) {
			System.out.printf("%08x %e %e %e\n", b, Utils.itof(b), ans, res);
		}
		else if (err > maxError) {
			double t = em.update(err);
			if (t == err) {
				System.out.printf("%08x %e %e %e %e\n", b, Utils.itof(b), ans, res, err);
				// System.out.printf("%08x %.10e %.10e %e %e %e\n", b, Utils.itof(b), Math.abs(Utils.itof(b)) - Math.PI, ans, res, err);
				maxError = err;
			}
			maxError = t;
		}
	}



	protected void test(float f) {
		int b = Utils.ftoi(f);

		cpu.revive();
		cpu.setReg(66, b);
		try {
			for (;;) cpu.step();
		} catch (ExecuteException ee) {
			// System.err.println(ee.getMessage());
		}

		double res = (double)Utils.itof(cpu.getReg(65));
		double ans = mf.f(Utils.itof(b));
		double err = relativeError(ans, res);

		if (Double.isNaN(err)) {
			System.out.printf("%08x %e %e %e\n", b, Utils.itof(b), ans, res);
		}
		else if (err > maxError) {
			double t = em.update(err);
			if (t == err) {
				System.out.printf("%08x %e %e %e %e\n", b, Utils.itof(b), ans, res, err);
				maxError = err;
			}
			maxError = t;
		}
	}



	protected void testAll() {
		// ゼロ
		test(0, 0, 0);
		test(1, 0, 0);

		// 正規化数
		long start = System.currentTimeMillis();

		for (int e = fromE; e <= toE; e++) {
			for (int s = 0; s <= 1; s++) {
				//for (int m = 0; m < (1 << 18); m++) {
				for (int m = 0; m < (1 << 23); m++) {
					test(s, e, m);
				}
			}

			int done = e - fromE + 1;
			int rest = toE - e;
			if (rest > 0) {
				long sec = (System.currentTimeMillis() - start) / done * rest / 1000;
				System.err.printf("e = %d / %02d:%02d remaining\n", e, sec / 60, sec % 60);
			}
		}
	}



	protected void testRandom() {
		Random rnd = new Random();
		while (true) {
			/*
			float f = (float)(rnd.nextDouble() * Math.PI);
			test(f);
			if (true) continue;
			*/

			int s = rnd.nextInt(2);
			int e = fromE + rnd.nextInt(toE - fromE + 1);
			int m = rnd.nextInt(1 << 23);
			test(s, e, m);
		}
	}



	public void setRandomMode(boolean b) {
		randomMode = b;
	}

	public void setERange(int from, int to) {
		fromE = from;
		toE = to;
	}

	@Override
	public void run() {
		if (randomMode) {
			testRandom();
		}
		else {
			testAll();
		}
	}



	protected int myRand(int l, int u) {	// [l, u]
		return l + (int)(Math.random() * (u - l + 1));
	}

	protected static int makeFloat(int s, int e, int m) {
		return s << 31 | e << 23 | m;
	}

	protected static double relativeError(double x, double y) {
		if (x == 0.0 || y == 0.0) return 0.0; // TODO
		else return Math.abs(x - y) / Math.max(Math.abs(x), Math.abs(y));
	}


	/* ********************************************************************************************
	 *  実行時用の static な関数たち
	 *********************************************************************************************/


	public static void usageExit() {
		System.err.println("Usage");
		System.err.println("  testing atan: -a [options] file");
		System.err.println("  testing sin : -s [options] file");
		System.err.println("  testing cos : -c [options] file");
		System.err.println("Options");
		System.err.println("  -t num_of_threads");
		System.err.println("  -r (random mode)");
		System.err.println("  -e from_e to_e (range of e, inclusive)");
		System.exit(1);
	}

	public static void main(String[] args) throws Exception {
		if (args.length < 2) usageExit();

		MathFunction mf = null;
		int threadN = 1;
		boolean random = false;
		int fromE = 1, toE = 253;
		try {
			for (int i = 0; i < args.length - 1; i++) {
				if (args[i].equals("-a")) mf = new AtanFunction();
				else if (args[i].equals("-s")) mf = new SinFunction();
				else if (args[i].equals("-c")) mf = new CosFunction();
				else if (args[i].equals("-t")) threadN = Integer.parseInt(args[++i]);
				else if (args[i].equals("-r")) random = true;
				else if (args[i].equals("-e")) {
					fromE = Integer.parseInt(args[++i]);
					toE = Integer.parseInt(args[++i]);
				}
				else {
					usageExit();
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			usageExit();
		}
		if (mf == null) usageExit();

		String fileName = args[args.length - 1];
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

		MaxErrorManager em = new MaxErrorManager();

		/*
		cpu.init(prog, false);
		MathLibraryTester tester = new MathLibraryTester(cpu, mf, em);
		tester.testRandom();
		*/

		Thread[] ths = new Thread[threadN];
		for (int i = 0; i < threadN; i++) {
			TesterCPU tc = new TesterCPU();
			tc.init(prog, false);

			MathLibraryTester tt = new MathLibraryTester(tc, mf, em);
			tt.setRandomMode(random);
			int k = toE - fromE + 1;
			int t = k / (threadN - i) + (k % (threadN - i) != 0 ? 1 : 0);
			tt.setERange(fromE, fromE + t - 1);
			System.out.printf("[%d, %d]\n", fromE, fromE + t - 1);
			fromE += t;

			ths[i] = new Thread(tt);
			ths[i].start();
		}
		for (int i = 0; i < threadN; i++) {
			ths[i].join();
		}
	}
}