package asm;

import static java.util.Arrays.*;

public class Program {
	
	public String[] lines;
	public Statement[] ss;
	public String[] names;
	public int[] ids;
	public int[] begin;
	public int[] end;
	public int[] data;
	
	public Program(String[] lines, Statement[] ss, String[] names, int[] ids, int[] begin, int[] end, int[] data) {
		this.lines = lines;
		this.ss = ss;
		this.names = names;
		this.ids = ids;
		this.begin = begin;
		this.end = end;
		this.data = data;
		String[] names2 = names.clone();
		sort(names);
		for (int i = 0; i < ids.length; i++) {
			ids[i] = binarySearch(names, names2[ids[i]]);
		}
	}
	
}
