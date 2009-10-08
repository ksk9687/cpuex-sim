package util;

import static java.util.Arrays.*;
import java.io.*;
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
	
	public static int[] readBinary(DataInputStream in) {
		List<Integer> list = new ArrayList<Integer>();
		try {
			for (;;) {
				list.add(in.readInt());
			}
		} catch (EOFException e) {
			return toints(list.toArray(new Integer[0]));
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
	public static void writeBinary(DataOutputStream out, int[] binary) {
		try {
			for (int i : binary) {
				out.writeInt(i);
			}
			out.flush();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
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
	
	public static int[] toints(Integer[] Is) {
		int n = Is.length;
		int[] is = new int[n];
		for (int i = 0; i < n; i++) is[i] = Is[i];
		return is;
	}
	
	public static void debug(Object...os) {
		System.err.println(deepToString(os));
	}
	
}
