package asm;

import static java.util.Arrays.*;
import static java.util.Collections.*;
import static util.Utils.*;
import cpu.*;
import java.util.*;

public class Assembler {
	
	//linesからコメントの除去・ラベルの抽出・文字列のトークン化を行う
	private static Statement[] lex(String[] lines) {
		List<Statement> list = new ArrayList<Statement>();
		List<String> labels = new ArrayList<String>();
		for (int lineID = 0; lineID < lines.length; lineID++) {
			Statement s = new Statement(lineID, lines[lineID]);
			labels.addAll(asList(s.labels));
			if (s.tokens.length > 0) {
				s.labels = labels.toArray(new String[0]);
				list.add(s);
				labels.clear();
			}
		}
		if (labels.size() > 0) {
			throw new AssembleException("ラベル位置が不正です");
		}
		return list.toArray(new Statement[0]);
	}
	
	//{}の中身を返す
	private static String[] contents(Parser p) {
		List<String> list = new ArrayList<String>();
		p.eat("{");
		int depth = 1;
		while (depth > 0) {
			String s = p.next();
			list.add(s);
			if (s.equals("{")) {
				depth++;
			} else if (s.equals("}")) {
				depth--;
			}
		}
		list.remove(list.size() - 1);
		return list.toArray(new String[0]);
	}
	
	//ラベルの置換
	private static void replace(String[] ss, Map<String, Integer> labels) {
		for (int i = 0; i < ss.length; i++) {
			if (labels.containsKey(ss[i])) {
				ss[i] = "" + labels.get(ss[i]);
			}
		}
	}
	
	//文字列の置換
	private static void replace(String[] ss, String s, String t) {
		for (int i = 0; i < ss.length; i++) {
			if (ss[i].equals(s)) {
				ss[i] = t;
			}
		}
	}
	
	//Define
	private static class Define {
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
	
	//linesをcpu向けにアセンブルする
	public static Program assemble(CPU cpu, String[] lines) {
		Map<String, Integer> labels = new HashMap<String, Integer>();
		Map<String, String[]> map = new HashMap<String, String[]>();
		List<Statement> list = new ArrayList<Statement>();
		List<Statement> list2 = new ArrayList<Statement>();
		LinkedList<Define> defs = new LinkedList<Define>();
		Map<String, Integer> namemap = new HashMap<String, Integer>();
		List<String> names = new ArrayList<String>();
		List<Integer> last = new ArrayList<Integer>();
		List<Integer> ids = new ArrayList<Integer>();
		List<Integer> begin = new ArrayList<Integer>();
		List<Integer> end = new ArrayList<Integer>();
		Statement[] ss = lex(lines);
		for (int i = 0; i < cpu.OFFSET; i++) list.add(new Statement(-1, ""));
		for (Statement s : ss) {
			int pos = list.size();
			s.replace(map);
			try {
				Parser p = new Parser(s.tokens);
				String t = p.next();
				if (t.equals(".define")) {
					if (!p.crt().equals("{")) {
						map.put(p.next(), p.rest());
					} else {
						defs.addFirst(new Define(list.size(), contents(p), contents(p)));
						p.end();
					}
				} else if (t.equals(".skip")) {
					int d = p.nextImm();
					p.end();
					if (d <= 0 || d >= 1 << 20) {
						throw new ParseException();
					}
					if (cpu.HAS_DATA) {
						pos = list2.size();
						list2.addAll(nCopies(d, s));
					} else {
						list.addAll(nCopies(d, s));
					}
				} else if (t.equals(".begin")) {
					String id = p.next();
					p.end();
					if (!namemap.containsKey(id)) {
						namemap.put(id, names.size());
						names.add(id);
						last.add(-1);
					}
					int i = namemap.get(id);
					if (last.get(i) >= 0) {
						throw new AssembleException(s.createMessage("beginとendの対応が取れていません"));
					}
					last.set(i, list.size());
				} else if (t.equals(".end")) {
					String id = p.next();
					p.end();
					if (!namemap.containsKey(id)) {
						namemap.put(id, names.size());
						names.add(id);
						last.add(-1);
					}
					int i = namemap.get(id);
					if (last.get(i) < 0) {
						throw new AssembleException(s.createMessage("beginとendの対応が取れていません"));
					}
					ids.add(i);
					begin.add(last.get(i));
					end.add(list.size());
					last.set(i, -1);
				} else if (t.equals(".count")) {
					String id = p.next();
					p.end();
					if (!namemap.containsKey(id)) {
						namemap.put(id, names.size());
						names.add(id);
						last.add(-1);
					}
					int i = namemap.get(id);
					ids.add(i);
					begin.add(list.size());
					end.add(list.size() + 1);
				} else if (t.equals(".int") || t.equals(".float")) {
					if (cpu.HAS_DATA) {
						pos = list2.size();
						list2.add(s);
					} else {
						list.add(s);
					}
				} else if (t.equals(".align")) {
					int d = p.nextImm();
					p.end();
					if (d <= 0) throw new ParseException();
					while (list.size() % d != 0) {
						list.add(new Statement(-1, ""));
					}
				} else {
					list.add(s);
				}
			} catch (ParseException e) {
				throw new AssembleException(s.createMessage("マクロ引数が不正です"));
			}
			for (String label : s.labels) {
				if (labels.containsKey(label)) {
					throw new AssembleException(s.createMessage(String.format("%s: ラベルが複数回出現", label)));
				}
				labels.put(label, pos);
			}
		}
		for (int i : last) if (i >= 0) throw new AssembleException("beginとendの対応が取れていません");
		ss = list.toArray(new Statement[0]);
		for (int i : begin) if (i >= ss.length) throw new AssembleException("マクロの位置が不正です");
		for (Define def : defs) {
			replace(def.ss, labels);
			replace(def.st, labels);
		}
		int pc = 0;
		for (Statement s : ss) {
			if (s.lineID >= 0) {
				replace(s.tokens, labels);
				replace(s.tokens, "%pc", "" + pc);
				try {
					Parser p = new Parser(s.tokens);
					String t = p.next();
					if (t.equals(".int")) {
						s.binary = p.nextImm();
						p.end();
					} else if (t.equals(".float")) {
						try {
							s.binary = ftoi(Float.parseFloat(s.str.substring(".float".length()).trim()));
						} catch (NumberFormatException e) {
							throw new ParseException();
						}
					} else if (!t.equals(".skip")) {
						p = new Parser(s.tokens);
						for (Define def : defs) if (def.from <= pc) {
							try {
								s.tokens = p.match(def.ss, def.st);
								replace(s.tokens, "%pc", "" + pc);
								p = new Parser(s.tokens);
							} catch (ParseException e) {
								p.init();
							}
						}
						try {
							s.binary = cpu.getBinary(new Parser(s.tokens));
						} catch (AssembleException e) {
							throw new AssembleException(s.createMessage(e.getMessage()));
						}
					}
				} catch (ParseException e) {
					throw new AssembleException(s.createMessage("マクロ引数が不正です"));
				}
			}
			pc++;
		}
		int[] data = new int[list2.size()];
		for (int i = 0; i < data.length; i++) {
			Statement s = list2.get(i);
			replace(s.tokens, labels);
			try {
				Parser p = new Parser(s.tokens);
				String t = p.next();
				if (t.equals(".int")) {
					data[i] = p.nextImm();
					p.end();
				} else if (t.equals(".float")) {
					try {
						data[i] = ftoi(Float.parseFloat(s.str.substring(".float".length()).trim()));
					} catch (NumberFormatException e) {
						throw new ParseException();
					}
				}
			} catch (ParseException e) {
				throw new AssembleException(s.createMessage("マクロ引数が不正です"));
			}
		}
		return new Program(lines, ss, names.toArray(new String[0]), toints(ids), toints(begin), toints(end), data);
	}
	
}
