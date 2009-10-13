package sim;

import static util.Utils.*;
import java.io.*;

public class Simulator {
	
	int cmp(int a, int b) {
		return a > b ? 4 : a == b ? 2 : 1;
	}
	
	int REGISTERSIZE = 32;
	int MEMORYSIZE = 1 << 20;
	
	void run(int[] bin) {
		DataInputStream in = new DataInputStream(System.in);
		int[] register = new int[REGISTERSIZE];
		int[] memory = new int[MEMORYSIZE];
		for (int i = 0; i < bin.length; i++) memory[i] = bin[i];
		DataOutputStream out = new DataOutputStream(System.out);
		try {
			for (int pc = 0;;) {
				if (pc < 0 || pc >= MEMORYSIZE) {
					throw new RuntimeException(String.format("IllegalPC: %08x", pc));
				}
				int ope = memory[pc];
				int opecode = ope >>> 26;
				int rs = ope >>> 21 & (REGISTERSIZE - 1);
				int rt = ope >>> 16 & (REGISTERSIZE - 1);
				int rd = ope >>> 11 & (REGISTERSIZE - 1);
				int immediate = ope & ((1 << 16) - 1);
				int address = ope & ((1 << (26)) - 1);
				switch (opecode) {
				case 0:
					//add
					register[rd] = register[rs] + register[rt];
					pc++;
					break;
				case 1:
					//addi
					register[rt] = register[rs] + signExt(immediate, 16);
					pc++;
					break;
				case 2:
					//sub
					register[rd] = register[rs] - register[rt];
					pc++;
					break;
				case 3:
					//srl
					register[rt] = register[rs] >>> immediate;
					pc++;
					break;
				case 4:
					//sll
					register[rt] = register[rs] << immediate;
					pc++;
					break;
				case 5:
					//fadd
					register[rd] = ftoi(itof(register[rs]) + itof(register[rt]));
					pc++;
					break;
				case 6:
					//fsub
					register[rd] = ftoi(itof(register[rs]) - itof(register[rt]));
					pc++;
					break;
				case 7:
					//fmul
					register[rd] = ftoi(itof(register[rs]) * itof(register[rt]));
					pc++;
					break;
				case 8:
					//finv
					register[rd] = ftoi(1.0f / itof(register[rs]));
					pc++;
					break;
				case 9:
					//load
					int p = register[rs] + signExt(immediate, 16);
					if (p < 0 || p >= MEMORYSIZE) {
						throw new RuntimeException(String.format("IllegalMemory: %08x", p));
					}
					register[rt] = memory[p];
					pc++;
					break;
				case 10:
					//li
					register[rt] = signExt(immediate, 16);
					pc++;
					break;
				case 11:
					//store
					p = register[rs] + signExt(immediate, 16);
					memory[p] = register[rt];
					pc++;
					break;
				case 12:
					//cmp
					register[rd] = cmp(register[rs], register[rt]);
					pc++;
					break;
				case 13:
					//jmp
					if ((register[rs] & rt) == 0) {
						pc += signExt(immediate, 16);
					} else {
						pc++;
					}
					break;
				case 14:
					//jal
					register[31] = pc + 1;
					pc = address;
					break;
				case 15:
					//jr
					pc = register[rs];
					break;
				case 16:
					//read
					register[rs] = in.readInt();
					pc++;
					break;
				case 17:
					//write
					out.writeInt(register[rs]);
					pc++;
					break;
				case 18:
					//nop
					pc++;
					break;
				case 19:
					//halt
					out.flush();
					return;
				default:
					throw new RuntimeException(String.format("IllegalOperation: %08x", ope));
				}
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
	public static void main(String[] args) {
		DataInputStream in;
		try {
			in = new DataInputStream(new FileInputStream(args[0]));
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		new Simulator().run(readBinary(in));
	}
	
}
