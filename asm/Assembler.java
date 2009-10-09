package asm;

import static java.util.Arrays.*;
import static util.Utils.*;
import cpu.*;
import java.io.*;
import java.util.*;

public class Assembler {
	
	String[][] lex(String encoding) {
		Scanner sc = null;
		try {
			sc = new Scanner(System.in, encoding);
		} catch (IllegalArgumentException e) {
			System.err.printf("エラー: %s: このエンコーディングはサポートされていません%n", encoding);
			System.exit(1);
		}
		List<String[]> list = new ArrayList<String[]>();
		while (sc.hasNext()) {
			String line = sc.nextLine().toLowerCase() + "#";
			line = line.substring(0, line.indexOf('#'));
			list.add(line.trim().split("\\s+"));
		}
		return list.toArray(new String[0][]);
	}
	
	int[] parse(String[][] ts) throws ParseException {
		int n = ts.length;
		Map<String, Integer> labels = new HashMap<String, Integer>();
		List<Integer> lines = new ArrayList<Integer>();
		List<String[]> list = new ArrayList<String[]>();
		boolean ok = true;
		for (int i = 0; i < n; i++) {
			String[] ss = ts[i];
			int m = ss.length, j;
			for (j = 0; j < m && ss[j].endsWith(":"); j++) {
				String label = ss[j].substring(0, ss[j].length() - 1);
				if (labels.containsKey(label)) {
					throw new ParseException(String.format("%d行目: ラベル \"%s\" が複数回出現", i + 1, label));
				}
				labels.put(label, lines.size());
				ok = false;
			}
			if (j < m && ss[0].length() > 0) {
				lines.add(i + 1);
				list.add(copyOfRange(ss, j, m));
				ok = true;
			}
		}
		if (!ok) {
			throw new ParseException(String.format("%d行目: 無効なラベル", n));
		}
		CPU cpu = new CPU();
		return cpu.assemble(labels, toints(lines.toArray(new Integer[0])), list.toArray(new String[0][]));
	}
	
	void run(String encode, boolean vhdl) {
		try {
			int[] binary = parse(lex(encode));
			if (vhdl) {
				for (int i : binary) {
					System.out.printf("\"%s\",%n", toBinary(i));
				}
			} else {
				writeBinary(new DataOutputStream(System.out), binary);
			}
		} catch (ParseException e) {
			System.err.println("エラー: " + e.getMessage());
		}
	}
	
	public static void main(String[] args) {
		String encode = "UTF-8";
		boolean vhdl = false;
		boolean ok = true;
		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-encoding")) {
				encode = args[++i];
			} else if (args[i].equals("-vhdl")) {
				vhdl = true;
			}
		}
		if (!ok) {
			System.err.println("使い方: java asm.Assembler [-encoding s] [-vhdl] [< src] [> dst]");
			return;
		}
		new Assembler().run(encode, vhdl);
	}
	
}
