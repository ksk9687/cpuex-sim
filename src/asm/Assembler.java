package asm;

import static java.util.Arrays.*;
import static java.util.Collections.*;
import static util.Utils.*;
import cpu.*;
import java.util.*;
import util.*;

public class Assembler {
	
	public static Statement s;
	
	//linesからコメントの除去・ラベルの抽出・文字列のトークン化を行う
	public static Statement[] lex(String[] lines) {
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
	public static String[] contents(Parser p) {
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
	public static void replace(String[] ss, Map<String, Integer> labels) {
		for (int i = 0; i < ss.length; i++) {
			if (labels.containsKey(ss[i])) {
				ss[i] = "" + labels.get(ss[i]);
			}
		}
	}
	
	//文字列の置換
	public static void replace(String[] ss, String s, String t) {
		for (int i = 0; i < ss.length; i++) {
			if (ss[i].equals(s)) {
				ss[i] = t;
			}
		}
	}
	
	//マクロを処理する
	public static Pair<Define[], Statement[]> macro(Statement[] ss) {
		Map<String, Integer> labels = new HashMap<String, Integer>();
		Map<String, String[]> map = new HashMap<String, String[]>();
		List<Statement> list = new ArrayList<Statement>();
		List<Define> defs = new ArrayList<Define>();
		for (Statement s : ss) {
			for (String label : s.labels) {
				if (labels.containsKey(label)) {
					throw new AssembleException(s.createMessage(String.format("%s: ラベルが複数回出現", label)));
				}
				labels.put(label, list.size());
			}
			s.replace(map);
			try {
				Parser p = new Parser(s.tokens);
				String t = p.next();
				if (t.equals(".define")) {
					if (s.labels.length > 0) {
						throw new AssembleException(s.createMessage("ラベル位置が不正です"));
					}
					if (!p.crt().equals("{")) {
						map.put(p.next(), p.rest());
					} else {
						defs.add(new Define(list.size(), contents(p), contents(p)));
						p.end();
					}
				} else if (t.equals(".skip")) {
					int d = p.nextImm();
					p.end();
					if (d <= 0 || d >= 1 << 20) {
						throw new ParseException();
					}
					list.addAll(nCopies(d, s));
				} else {
					s.isOp = true;
					list.add(s);
				}
			} catch (ParseException e) {
				throw new AssembleException(s.createMessage("マクロ引数が不正です"));
			}
		}
		int pc = 0;
		for (Statement s : list) {
			replace(s.tokens, labels);
			replace(s.tokens, "%pc", "" + pc);
			try {
				Parser p = new Parser(s.tokens);
				String t = p.next();
				if (t.equals(".int")) {
					s.isOp = false;
					s.binary = p.nextImm();
					p.end();
				} else if (t.equals(".float")) {
					s.isOp = false;
					try {
						s.binary = ftoi(Float.parseFloat(s.str.substring(6).trim()));
					} catch (NumberFormatException e) {
						throw new ParseException();
					}
				}
			} catch (ParseException e) {
				throw new AssembleException(s.createMessage("マクロ引数が不正です"));
			}
			pc++;
		}
		for (Define def : defs) {
			replace(def.ss, labels);
			replace(def.st, labels);
		}
		return Pair.make(defs.toArray(new Define[0]), list.toArray(new Statement[0]));
	}
	
	private static int rec(CPU cpu, Parser p, int pc, Define[] defs, int i) {
		AssembleException ex = null;
		while (i >= 0) {
			if (defs[i].from <= pc) {
				try {
					p.init();
					String[] ss = p.match(defs[i].ss, defs[i].st);
					replace(ss, "%pc", "" + pc);
					return rec(cpu, new Parser(ss), pc, defs, i - 1);
				} catch (ParseException e) {
				} catch (AssembleException e) {
					if (ex == null) ex = e;
				}
			}
			i--;
		}
		try {
			p.init();
			return cpu.getBinary(p);
		} catch (ParseException e) {
		} catch (AssembleException e) {
			if (ex == null) ex = e;
		}
		if (ex != null) throw ex;
		throw new ParseException();
	}
	
	//linesをcpu向けにアセンブルし、命令列を返す
	public static Statement[] assemble(CPU cpu, String[] lines) {
		try {
			Statement[] ss = lex(lines);
			Pair<Define[], Statement[]> pair = macro(ss);
			Define[] ds = pair.first;
			ss = pair.second;
			int pc = 0;
			for (Statement s : ss) {
				if (s.isOp) {
					try {
						Assembler.s = s;
						s.binary = rec(cpu, new Parser(s.tokens), pc, ds, ds.length - 1);
					} catch (ParseException e) {
						throw new AssembleException(s.createMessage("命令を解釈できません"));
					} catch (AssembleException e) {
						throw new AssembleException(s.createMessage(e.getMessage()));
					}
				}
				pc++;
			}
			return ss;
		} catch (AssembleException e) {
			System.err.printf("エラー: %s%n", e.getMessage());
			System.exit(1);
			throw e;
		}
	}
	
	//linesをcpu向けにアセンブルし、バイナリを返す
	public static int[] assembleToBinary(CPU cpu, String[] lines) {
		Statement[] ss = Assembler.assemble(cpu, lines);
		int[] bin = new int[ss.length];
		for (int i = 0; i < ss.length; i++) {
			bin[i] = ss[i].binary;
		}
//		for (int i = 0; i < ss.length; i++) {
//			debug(ss[i]);
//		}
		return bin;
	}
	
}
