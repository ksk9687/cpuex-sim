package asm;

import java.util.*;

public class Define {
	
	public int from;
	public String[] ss, st;
	
	public Define(int from, String[] ss, String[] st) {
		this.from = from;
		this.ss = ss;
		this.st = st;
	}
	
	public String toString() {
		return String.format("{%d, %s, %s}", from, Arrays.toString(ss), Arrays.toString(st));
	}
	
}
