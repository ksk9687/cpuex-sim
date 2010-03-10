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
		String encoding = "UTF-8";
		String cpuName = "";
		boolean fillNop = false;
		boolean noOutput = false;
		boolean noOffset = false;
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
				} else if (args[i].equals("-fillNop")) {
					fillNop = true;
				} else if (args[i].equals("-vhdl")) {
					if (vhdlOut != null) ok = false;
					vhdlOut = args[++i];
				} else if (args[i].equals("-gui")) {
					if (simType != 0) ok = false;
					simType = 1;
				} else if (args[i].equals("-cui")) {
					if (simType != 0) ok = false;
					simType = 2;
				} else if (args[i].equals("-noOutput")) {
					noOutput = true;
				} else if (args[i].equals("-noOffset")) {
					noOffset = true;
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
		if (fileName == null || simType == 0 && noOutput) ok = false;
		if (!ok) {
			System.err.println("使い方: sim file [-cpu s] [-encoding s] [-asm s] [-fillNop] [-vhdl s] [-gui] [-cui] [-noOutput]");
			System.exit(1);
		}
		CPU cpu = CPU.loadCPU(cpuName);
		if (noOffset) cpu.OFFSET = 0;
		String[] lines = readLines(openInputFile(fileName), encoding);
		System.err.println("Assembling...");
		Program prog = null;
		try {
			prog = Assembler.assemble(cpu, lines);
		} catch (AssembleException e) {
			System.err.printf("エラー: %s%n", e.getMessage());
			System.exit(1);
		}
		System.err.println("Finished!");
		if (asmOut != null) {
			try {
				cpu.asmOut(prog, new DataOutputStream(openOutputFile(asmOut)), fillNop);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		if (vhdlOut != null) {
			cpu.vhdlOut(prog, new PrintWriter(openOutputFile(vhdlOut)));
		}
		if (simType != 0) {
			Simulator sim = new Simulator(cpu, prog, !noOutput);
			if (simType == 1) {
				sim.runGUI();
			} else {
				sim.runCUI();
			}
		}
	}
	
}
