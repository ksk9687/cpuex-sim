package asm;

import static java.util.Arrays.*;
import static util.Utils.*;
import java.util.*;
import java.util.regex.*;

public class Statement {
	
	public static final int TABSIZE = 4;
	public static final String SIGN = "[](){}<>+-*/=,";
	
	public int lineID;
	public String original;
	public String[] labels;
	public String str;
	public String[] tokens;
	public long binary;
	
	public Statement(int lineID, String original) {
		this.lineID = lineID;
		this.original = original;
		String[] ss = (" " + removeComment(original).toLowerCase() + " ").split(":");
		if (ss.length == 0) ss = new String[] {""};
		labels = copyOfRange(ss, 0, ss.length - 1);
		str = ss[ss.length - 1].trim();
		tokens = tokenize(str);
		for (int i = 0; i < labels.length; i++) {
			labels[i] = labels[i].trim();
			if (labels[i].length() == 0) {
				throw new AssembleException(createMessage("ラベル名が不正です"));
			}
			for (char c : labels[i].toCharArray()) {
				if (Character.isWhitespace(c) || SIGN.indexOf(c) >= 0) {
					throw new AssembleException(createMessage("ラベル名が不正です"));
				}
			}
		}
	}
	
	public void replace(Map<String, String[]> map) {
		List<String> list = new ArrayList<String>();
		for (String s : tokens) {
			if (map.containsKey(s)) {
				list.addAll(asList(map.get(s)));
			} else {
				list.add(s);
			}
		}
		tokens = list.toArray(new String[0]);
	}
	
	public String createMessage(String detail) {
		return String.format("%d行目: %s%n%s%n%s", lineID + 1, detail, original, concat(tokens, " "));
	}
	
	public String toString() {
		return String.format("{%d, %s, %s, %d}", lineID, Arrays.toString(labels), str, binary);
	}
	
	public static String removeComment(String str) {
		int i = str.indexOf('#');
		if (i >= 0) return str.substring(0, i);
		return str;
	}
	
	public static String[] tokenize(String str) {
		str = str.trim();
		if (str.length() == 0) return new String[0];
		for (char c : SIGN.toCharArray()) {
			str = str.replaceAll(Pattern.quote("" + c), " " + c + " ");
		}
		return str.trim().split("\\s+");
	}
	
}
