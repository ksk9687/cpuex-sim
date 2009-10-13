package asm;

import static java.util.Arrays.*;
import static util.Utils.*;
import java.util.*;

public class Parser {
	
	private String[] tokens;
	private int p;
	
	public Parser(String[] tokens) {
		this.tokens = copyOf(tokens, tokens.length + 1);
		this.tokens[tokens.length] = "#";
	}
	
	public void init() {
		p = 0;
	}
	
	public String[] match(String[] ss, String[] st) {
		List<String> list = new ArrayList<String>();
		for (String s : ss) {
			if (s.equals("%reg")) {
				list.add(nextReg());
			} else if (s.equals("%imm")) {
				list.add("" + nextImm());
			} else {
				eat(s);
			}
		}
		end();
		List<String> res = new ArrayList<String>();
		for (String s : st) {
			if (s.charAt(0) == '%' && !s.equals("%pc") && !s.equals("%")) {
				try {
					res.addAll(asList(Statement.tokenize(list.get(Integer.parseInt(s.substring(1)) - 1))));
				} catch (Exception e) {
					throw new ParseException();
				}
			} else {
				res.add(s);
			}
		}
		return res.toArray(new String[0]);
	}
	
	public String next() {
		if (p >= tokens.length) {
			throw new ParseException();
		}
		return tokens[p++];
	}
	
	public String crt() {
		if (p >= tokens.length) {
			throw new ParseException();
		}
		return tokens[p];
	}
	
	public String[] rest() {
		if (p >= tokens.length) {
			throw new ParseException();
		}
		return copyOfRange(tokens, p, tokens.length - 1);
	}
	
	public String nextReg() {
		String s = next();
		if (!s.startsWith("$")) {
			throw new ParseException();
		}
		return s;
	}
	
	public int nextImm() {
		String s = next();
		if (s.equals("+")) {
			return nextImm();
		} else if (s.equals("-")) {
			return -nextImm();
		} else if (s.equals("%")) {
			return calc();
		}
		try {
			return parseUInt(s);
		} catch (NumberFormatException e) {
			throw new ParseException();
		}
	}
	
	public void eat(String s) {
		if (!next().equals(s)) {
			throw new ParseException();
		}
	}
	
	public void end() {
		eat("#");
	}
	
	private int calc() {
		eat("{");
		int res = equation();
		eat("}");
		return res;
	}
	
	private int eval(String op, int a, int b) {
		if (op.equals("+")) return a + b;
		if (op.equals("-")) return a - b;
		if (op.equals("*")) return a * b;
		if (b != 0) return a / b;
		throw new AssembleException("零割り算が発生");
	}
	
	private int equation() {
		int t = factor();
		while (crt().equals("+") || crt().equals("-")) {
			t = eval(next(), t, factor());
		}
		return t;
	}
	
	private int factor() {
		int t = term();
		while (crt().equals("*") || crt().equals("/")) {
			t = eval(next(), t, term());
		}
		return t;
	}
	
	private int term() {
		if (crt().equals("(")) {
			eat("(");
			int res = equation();
			eat(")");
			return res;
		} else {
			return nextImm();
		}
	}
	
}
