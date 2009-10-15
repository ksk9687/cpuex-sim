package sim;

import static util.Utils.*;
import java.io.*;
import java.util.*;
import asm.*;
import cpu.*;

public class Main {
	
	public static void main(String[] args) {
		int type = 0;
		String fileName = null;
		String encoding = "UTF-8";
		String cpuName = CPU.DEFAULT;
		boolean ok = true;
		try {
			for (int i = 0; i < args.length; i++) {
				if (args[i].equals("-cpu")) {
					cpuName = args[++i];
				} else if (args[i].equals("-encoding")) {
					encoding = args[++i];
				} else if (args[i].equals("-asm")) {
					if (type != 0) ok = false;
					type = 1;
				} else if (args[i].equals("-vhdl")) {
					if (type != 0) ok = false;
					type = 2;
				} else if (args[i].equals("-nw")) {
					if (type != 0) ok = false;
					type = 3;
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
		if (fileName == null) {
			ok = false;
		}
		if (!ok) {
			System.err.println("使い方: sim file [-cpu s] [-encoding s] [-asm] [-vhdl] [-nw] [< in] [> out]");
			return;
		}
		CPU cpu = CPU.loadCPU(cpuName);
		List<String> list = new ArrayList<String>();
		try {
			Scanner sc = new Scanner(new FileInputStream(fileName), encoding);
			while (sc.hasNext()) {
				list.add(sc.nextLine());
			}
		} catch (FileNotFoundException e) {
			failWith(String.format("%s: 指定されたファイルが見つかりません", fileName));
		} catch (IllegalArgumentException e) {
			failWith(String.format("%s: このエンコーディングはサポートされていません", encoding));
		}
		String[] lines = list.toArray(new String[0]);
		if (type == 0) {
			new Simulator(cpu, lines).runGUI();
		} else if (type == 1) {
			int[] bin = Assembler.assembleToBinary(cpu, lines);
			DataOutputStream out = new DataOutputStream(System.out);
			try {
				out.writeInt(bin.length);
				for (int i : bin) {
					out.writeInt(i);
				}
				out.flush();
			} catch (IOException e) {
				throw new RuntimeException(e);
			}
		} else if (type == 2) {
			int[] bin = Assembler.assembleToBinary(cpu, lines);
			for (int i : bin) {
				System.out.printf("\"%s\",%n", toBinary(i));
			}
		} else {
			new Simulator(cpu, lines).runCUI();
		}
	}
	
	
}
