package asm;

public class Program {
	
	public String[] lines;
	public Statement[] ss;
	public String[] names;
	public int[] ids;
	public int[] begin;
	public int[] end;
	
	public Program(String[] lines, Statement[] ss, String[] names, int[] ids, int[] begin, int[] end) {
		this.lines = lines;
		this.ss = ss;
		this.names = names;
		this.ids = ids;
		this.begin = begin;
		this.end = end;
	}
	
}
