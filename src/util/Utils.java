package util;

import static java.util.Arrays.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;
import java.util.*;

public class Utils {
	
	//high downto low
	public static int getBits(int i, int high, int low) {
		if (high == 31 && low == 0) return i;
		return i >>> low & ((1 << (high - low + 1)) - 1);
	}
	
	public static int getBit(int i, int j) {
		return getBits(i, j, j);
	}
	
	public static String toHex(int i) {
		return String.format("%08x", i);
	}
	
	public static String toBinary(int i) {
		String s = Integer.toBinaryString(i);
		char[] cs = new char[32 - s.length()];
		fill(cs, '0');
		return String.valueOf(cs) + s;
	}
	
	public static int parseHex(String s) {
		if (s.length() > 8) throw new NumberFormatException(s);
		return (int)Long.parseLong(s, 16);
	}
	
	public static int parseBinary(String s) {
		if (s.length() > 32) throw new NumberFormatException(s);
		return (int)Long.parseLong(s, 2);
	}
	
	public static int parseUInt(String s) {
		if (s.indexOf('-') >= 0) throw new NumberFormatException();
		if (s.startsWith("0x")) return parseHex(s.substring(2));
		if (s.startsWith("0b")) return parseBinary(s.substring(2));
		return (int)Long.parseLong(s);
	}
	
	public static int parseInt(String s) {
		if (s.startsWith("-")) return -parseUInt(s.substring(1));
		if (s.startsWith("+")) return parseUInt(s.substring(1));
		return parseUInt(s);
	}
	
	public static float itof(int i) {
		return Float.intBitsToFloat(i);
	}
	
	public static int ftoi(float f) {
		return Float.floatToIntBits(f);
	}
	
	public static int signExt(int i, int len) {
		if (getBit(i, len - 1) != 0) {
			i |= ((1 << (32 - len)) - 1) << len;
		}
		return i;
	}
	
	public static int[] toints(List<Integer> list) {
		Integer[] Is = list.toArray(new Integer[0]);
		int n = Is.length;
		int[] is = new int[n];
		for (int i = 0; i < n; i++) is[i] = Is[i];
		return is;
	}
	
	public static void failWith(String s) {
		System.err.printf("エラー: %s%n", s);
		System.exit(1);
	}
	
	public static String concat(String[] ss, String sep) {
		if (ss.length == 0) return "";
		StringBuilder sb = new StringBuilder(ss[0]);
		for (int i = 1; i < ss.length; i++) {
			sb.append(sep).append(ss[i]);
		}
		return sb.toString();
	}
	
	// 文字列をクリップボードにコピー
	public static void copyToClipboard(String s) {
		Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
		StringSelection select = new StringSelection(s);
		clipboard.setContents(select, select);
	}
	
	public static void debug(Object...os) {
		System.err.println(deepToString(os));
	}
	
}
