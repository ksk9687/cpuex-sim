package sim;

import static util.Utils.*;
import java.io.*;
import java.util.*;
import asm.*;
import cpu.*;

public class Main {
	
	public static final int TABSIZE = 4;
	
	public static FileInputStream openInputFile(String fileName) {
		try {
			return new FileInputStream(fileName);
		} catch (FileNotFoundException e) {
			failWith(String.format("%s: 指定されたファイルが見つかりません", fileName));
			return null;
		}
	}
	
	public static FileOutputStream openOutputFile(String fileName) {
		try {
			return new FileOutputStream(fileName);
		} catch (FileNotFoundException e) {
			failWith(String.format("%s: 指定されたファイルが見つかりません", fileName));
			return null;
		}
	}
	
	public static String tabChange(String str) {
		StringBuilder sb = new StringBuilder();
		for (char c : str.toCharArray()) {
			if (c == '\t') {
				do {
					sb.append(' ');
				} while (sb.length() % TABSIZE != 0);
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}
	
	public static String[] readLines(FileInputStream in, String encoding) {
		List<String> list = new ArrayList<String>();
		try {
			Scanner sc = new Scanner(in, encoding);
			while (sc.hasNext()) {
				list.add(tabChange(sc.nextLine()));
			}
		} catch (IllegalArgumentException e) {
			failWith(String.format("%s: このエンコーディングはサポートされていません", encoding));
		}
		return list.toArray(new String[0]);
	}
	
	public static void main(String[] args) {
		int simType = 0;
		String fileName = null;
		String asmOut = null;
		String vhdlOut = null;
		String simIn = null;
		String simOut = null;
		String encoding = "UTF-8";
		String cpuName = "";
		boolean xyx = false;
		boolean ok = true;
		try {
			for (int i = 0; i < args.length; i++) {
				if (args[i].equals("-cpu")) {
					cpuName = args[++i];
				} else if (args[i].equals("-encoding")) {
					encoding = args[++i];
				} else if (args[i].equals("-asm")) {
					if (asmOut != null) ok = false;
					asmOut = args[++i];
				} else if (args[i].equals("-vhdl")) {
					if (vhdlOut != null) ok = false;
					vhdlOut = args[++i];
				} else if (args[i].equals("-gui")) {
					if (simType != 0) ok = false;
					simType = 1;
				} else if (args[i].equals("-cui")) {
					if (simType != 0) ok = false;
					simType = 2;
				} else if (args[i].equals("-in")) {
					if (simIn != null) ok = false;
					simIn = args[++i];
				} else if (args[i].equals("-out")) {
					if (simOut != null) ok = false;
					simOut = args[++i];
				} else if (args[i].equals("-xyx")) {
					xyx = true;
				} else if (args[i].charAt(0) != '-') {
					if (fileName != null) ok = false;
					fileName = args[i];
				} else {
					ok = false;
					break;
				}
			}
		} catch (ArrayIndexOutOfBoundsException e) {
			ok = false;
		}
		if (fileName == null) ok = false;
		if (simType == 0 && (simIn != null || simOut != null)) ok = false;
		if (!ok) {
			System.err.println("使い方: sim file [-cpu s] [-encoding s] [-asm s] [-vhdl s] [-gui] [-cui] [-in s] [-out s]");
			System.exit(1);
		}
		CPU cpu = CPU.loadCPU(cpuName);
		String[] lines = readLines(openInputFile(fileName), encoding);
		System.err.println("Assembling...");
		Statement[] ss = Assembler.assemble(cpu, lines);
		System.err.println("Finished!");
		if (asmOut != null) {
			try {
				DataOutputStream out = new DataOutputStream(openOutputFile(asmOut));
				out.writeInt(ss.length);
				for (Statement s : ss) {
					out.writeInt(s.binary);
				}
				out.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		if (vhdlOut != null) {
			PrintWriter out = new PrintWriter(openOutputFile(vhdlOut));
			for (Statement s : ss) {
				out.printf("\"%s\",%n", toBinary(s.binary));
			}
			out.close();
		}
		if (xyx) {
			Random r = new Random();
			int num = ss.length * 36;
			for (Statement s : ss) {
				String str = toBinary(s.binary);
				for (int j = 0; j < 4; j++) {
					System.out.print("\"0\"&\"");
					System.out.print(str.substring(j * 8, (j + 1) * 8));
					int m = 1 + r.nextInt(10);
					num += m;
					System.out.print("\"&\"");
					for (int k = 0; k < m; k++) System.out.print(1);
					System.out.println("\"&");
				}
			}
			System.out.println(num);
		}
		if (simType != 0) {
			InputStream in = null;
			OutputStream out = null;
			if (simIn != null) in = openInputFile(simIn);
			if (simOut != null) out = openOutputFile(simOut);
			Simulator sim = new Simulator(cpu, lines, ss, in, out);
			if (simType == 1) {
				sim.runGUI();
			} else {
				sim.runCUI();
			}
		}
	}
	
}
