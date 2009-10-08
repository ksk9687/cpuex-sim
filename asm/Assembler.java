package asm;

import static java.util.Arrays.*;
import static util.Utils.*;
import cpu.*;
import java.io.*;
import java.util.*;

public class Assembler {
	
	String[][] lex() {
		Scanner sc = new Scanner(System.in);
		List<String[]> list = new ArrayList<String[]>();
		while (sc.hasNext()) {
			String line = sc.nextLine().toLowerCase() + "#";
			line = line.substring(0, line.indexOf('#'));
			list.add(line.split(" +"));
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
					throw new ParseException(String.format("%d: ラベル \"%s\" が複数回出現", i + 1, label));
				}
				labels.put(label, lines.size());
				ok = false;
			}
			if (j < m) {
				lines.add(i + 1);
				list.add(copyOfRange(ss, j, m));
				ok = true;
			}
		}
		if (!ok) {
			throw new ParseException(String.format("%d: 無効なラベル", n));
		}
		CPU cpu = new CPU();
		return cpu.assemble(labels, toints(lines.toArray(new Integer[0])), list.toArray(new String[0][]));
	}
	
	void run() {
		try {
			writeBinary(new DataOutputStream(System.out), parse(lex()));
		} catch (ParseException e) {
			System.err.println(e.getMessage());
		}
	}
	
	public static void main(String[] args) {
		new Assembler().run();
	}
	
}
