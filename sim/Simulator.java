package sim;

import static util.Utils.*;
import java.io.*;
import cpu.*;

public class Simulator {
	
	private DataInputStream in;
	private DataOutputStream out;
	
	public int read() {
		try {
			return in.readInt();
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	public void write(int i) {
		try {
			out.writeInt(i);
			out.flush();
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	public void run(CPU cpu, int[] bin) {
		in = new DataInputStream(System.in);
		out = new DataOutputStream(System.out);
		cpu.init(this, bin);
		try {
			for (;;) {
				cpu.clock();
			}
		} catch (ExecuteException e) {
			System.err.println(e.getMessage());
		}
	}
	
	public static void main(String[] args) {
		String cpu = CPU.DEFAULT;
		String file = null;
		boolean ok = true;
		try {
			for (int i = 0; i < args.length; i++) {
				if (args[i].equals("-cpu")) {
					cpu = args[++i];
				} else if (args[i].charAt(0) != '-') {
					file = args[i];
				}
			}
		} catch (ArrayIndexOutOfBoundsException e) {
			ok = false;
		}
		if (file == null) {
			ok = false;
		}
		if (!ok) {
			System.err.println("使い方: java sim.Simulator [-cpu s] bin [< input] [> output]");
			return;
		}
		int[] bin;
		try {
			DataInputStream in = new DataInputStream(new FileInputStream(args[0]));
			bin = readBinary(in);
		} catch (IOException e) {
			failWith("指定されたファイルが見つかりません");
			throw new RuntimeException(e);
		}
		new Simulator().run(CPU.loadCPU(cpu), bin);
	}
	
}
