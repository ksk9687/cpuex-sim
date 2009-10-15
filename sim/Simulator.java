package sim;

import static util.Utils.*;
import java.io.*;
import javax.swing.*;
import cpu.*;

public class Simulator {
	
	private DataInputStream in;
	private DataOutputStream out;
	private JFrame frame;
	private CPU cpu;
	
	public int read() {
		try {
			return in.read();
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	public void write(int i) {
		try {
			out.write(i & 0xff);
			out.flush();
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	public void runGUI(CPU cpu, int[] bin) {
		in = new DataInputStream(System.in);
		out = new DataOutputStream(System.out);
		cpu.init(this, bin);
		new GUI(this);
	}
	
	public void runCUI(CPU cpu, int[] bin) {
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
		String cpuName = CPU.DEFAULT;
		String file = null;
		boolean gui = false;
		boolean ok = true;
		try {
			for (int i = 0; i < args.length; i++) {
				if (args[i].equals("-cpu")) {
					cpuName = args[++i];
				} else if (args[i].equals("-gui")) {
					gui = true;
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
			System.err.println("使い方: java sim.Simulator bin [-cpu s] [-gui] [< input] [> output]");
			return;
		}
		int[] bin;
		try {
			DataInputStream in = new DataInputStream(new FileInputStream(file));
			bin = readBinary(in);
		} catch (IOException e) {
			failWith("指定されたファイルが見つかりません");
			throw new RuntimeException(e);
		}
		CPU cpu = CPU.loadCPU(cpuName);
		if (gui) {
			new Simulator().runGUI(cpu, bin);
		} else {
			new Simulator().runCUI(cpu, bin);
		}
	}
	
}
