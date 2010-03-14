package cpu.fpu;

/*
 * 色々チェックする際に使うために、CPU のクラスと分離した。
 *
 * 本当は JVM の浮動小数点演算を使う FPU のクラスと VHDL での実装をシミュレートする FPU のクラスを作って、
 * CPU クラスがジェネリクスでそれらのどちらかを受け取るようにすれば良い感じだと思うんだけどな
 */

public class FPU {
	private static int downto(int a, int h, int l) {
		int n = h - l + 1;
		a = (a >>> l);
		return a & ((1 << n) - 1);
	}



	public static int fneg(int a) {
		int s = (1 & (a >>> 31)) == 1 ? 0 : 1;
		return (s << 31) | (0x7fffffff & a);
	}



	public static int fadd(int a, int b) {
		int as, ae, am;
		int bs, be, bm;
		as = (a >>> 31) & 1; ae = (a >>> 23) & 0xff; am = a & 0x7fffff;
		bs = (b >>> 31) & 1; be = (b >>> 23) & 0xff; bm = b & 0x7fffff;

		int be_minus_ae = be - ae;
		int ae_minus_be = ae - be;

		boolean agtb = (a & ((1 << 31) - 1)) > (b & ((1 << 31) - 1));

		int am1 = ae != 0 ? ((1 << 23) | am) : 0;
		int bm1 = be != 0 ? ((1 << 23) | bm) : 0;

		int we_minus_le, we, wm, lm, os;
		if (agtb) {
			we_minus_le = ae_minus_be;
			we = ae;
			wm = am1;
			lm = bm1;
			os = as;
		}
		else {
			we_minus_le = be_minus_ae;
			we = be;
			wm = bm1;
			lm = am1;
			os = bs;
		}


		int lm2;

		if (we_minus_le >= 30) lm2 = 0;
		else lm2 = lm >> we_minus_le;

		int oe1 = we;
		int pm = wm;
		int os1 = os;
		int qm = lm2;
		int op = as ^ bs;


		int om1;
		if (op != 0) om1 = pm - qm;
		else om1 = pm + qm;

		int oe2 = oe1;
		int os2 = os1;


		int rs, re, rm;
		rs = os2;
		for (int i = 24; i >= 0; i--) {
			if ((om1 & (1 << i)) != 0) {
				int t = oe2 + i - 23;
				// assert(t >= 0);
				re = t;

				if (i == 24) rm = (om1 >> 1) & ((1 << 23) - 1);
				else rm = (om1 << (23 - i)) & ((1 << 23) - 1);

				return (int)((rs << 31) | (re << 23) | (rm));
			}
		}

		return 0;
	}



	public static int fsub(int a, int b) {
		return fadd(a, fneg(b));
	}



	public static int fmul(int a, int b) {
		if (downto(a, 30, 23) == 0 || downto(b, 30, 23) == 0) return 0;

		long am = (1 << 23) | (a & 0x7fffff);
		long bm = (1 << 23) | (b & 0x7fffff);
		long ah = am >> 12, al = am & ((1 << 12) - 1);
		long bh = bm >> 12, bl = bm & ((1 << 12) - 1);

		long oh = ah * bh;
		long om1 = (ah * bl) >> 11;
		long om2 = (al * bh) >> 11;

		long rm = (oh << 1) + om1 + om2 + 2;
		long re = ((a >>> 23) & 0xff) + ((b >>> 23) & 0xff) - 127;

		if ((rm >>> 24) != 0) {
			rm >>>= 1;
			re++;
		}
		if (re < 0 || re >= 256) return 0;

		int rs = ((a >>> 31) & 1) ^ ((b >>> 31) & 1);
		rm = rm & ((1 << 23) - 1);

		return (int)((rs << 31) | (re << 23) | (rm));
	}



	public static int finv(int a) {
		int as, ae, am;
		int rs, re, rm;

		as = (a >>> 31) & 1; ae = (a >>> 23) & 0xff; am = a & 0x7fffff;

		am = (1 << 23) | am;
		long x1 = am >>> 12;
		long x2 = am & 0xfff;

		long c = FInvTable.table[(int)x1 - (1 << 11)];
		long x = (x1 << 12) | (x2 ^ 0xfff);

		long ch = c >>> 12, cl = c & 0xfff;
		long xh = x >>> 12, xl = x & 0xfff;

		long oh = ch * xh;
		long omm1 = (ch * xl) >>> 11;
		long omm2 = (cl * xh) >>> 11;

		long om1 = (oh << 1) + omm1 + omm2 + 2;
		long om2 = (om1 & (1L << 24)) != 0 ? (om1 >>> 1) : om1;
		long oe = 254 - ae - ((om1 & (1L << 24)) != 0 ? 0 : 1);

		rs = as;
		re = (int)oe;
		rm = (int)(om2 & 0x7fffff);
		return ((rs & 1) << 31) | ((re & 0xff) << 23) | (rm & 0x7fffff);
	}



	public static int fsqrt(int a) {
		int as, ae, am;
		int rs, re, rm;

		if (a < 0) return Float.floatToIntBits(Float.NaN);

		as = (a >>> 31) & 1; ae = (a >>> 23) & 0xff; am = a & 0x7fffff;

		am = (1 << 23) | am;
		long oe = 63 + (ae >>> 1);

		int idx = (((ae & 1) ^ 1) << 10) | ((am >>> 13) ^ (1 << 10));
		long c = FSqrtTable.table[idx];

		long x1 = am >>> 13;
		long x2 = am & ((1 << 13) - 1);

		long x = 0;
		x |= x1 << 13;
		x |= (1 + ((x2 >>> 12) & 1)) << 11;
		x |= (x2 & ((1 << 12) - 1)) >>> 11;

		if (a == 0) {
			x = c = 0;
			oe = 0;
		}

		long ch = c >>> 12, cl = c & 0xfff;
		long xh = x >>> 12, xl = x & 0xfff;

		long oh = ch * xh;
		long omm1 = (ch * xl) >>> 11;
		long omm2 = (cl * xh) >>> 11;

		long om1 = (oh << 1) + omm1 + omm2 + 2;
		long om2 = (om1 & (1L << 24)) != 0 ? (om1 >>> 1) : om1;
		long oe2 = oe + ((om1 & (1L << 24)) != 0 ? 1 : 0);

		rs = as;
		re = (int)oe2;
		rm = (int)(om2 & 0x7fffff);
		return ((rs & 1) << 31) | ((re & 0xff) << 23) | (rm & 0x7fffff);
	}
}
