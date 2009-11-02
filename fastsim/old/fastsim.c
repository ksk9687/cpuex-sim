#include <stdio.h>
#include <stdlib.h>

#define WRITE

typedef union {
	float f;
	int i;
} FI;

inline int ftoi(float f) { FI fi; fi.f = f; return fi.i; }
inline float itof(int i) { FI fi; fi.i = i; return fi.f; }

#define opecode (op >> 26)
#define rs (op >> 21 & 31)
#define rt (op >> 16 & 31)
#define rd (op >> 11 & 31)
#define imm (op & ((1 << 16) - 1))
#define addr (op & ((1 << 26) - 1))
#define sImm ((op & (1 << 15)) ? (((1 << 16) - 1) << 16 | op) : imm)

int regs[32];
int mems[1 << 20];

int readInt(FILE *f) {
	int i, res = 0;
	for (i = 0; i < 4; i++) {
		res = res << 8 | fgetc(f);
	}
	return res;
}

void load(char *name) {
	int i, size;
	FILE *f = fopen(name, "r");
	size = readInt(f);
	for (i = 0; i < size; i++) {
		mems[i] = readInt(f);
	}
	fclose(f);
}

int main(int argc, char **argv) {
	int pc = 0;
	long long count;
	int writeBytes = 0;
	if (argc != 2) {
		fprintf(stderr, "Usage: ./sim.exe bin < in > out\n");
		exit(1);
	}
	load(argv[1]);
	for (count = 1; ; count++) {
		unsigned int op = mems[pc];
		if (opecode == 9) { //load
			regs[rt] = mems[regs[rs] + sImm];
			pc++;
		} else if (opecode == 13) { //jmp
			if (regs[rs] & rt) {
				pc++;
			} else {
				pc += sImm;
			}
		} else if (opecode == 10) { //li
			regs[rt] = sImm;
			pc++;
		} else if (opecode == 12) { //cmp
			regs[rd] = regs[rs] > regs[rt] ? 4 : regs[rs] == regs[rt] ? 2 : 1;
			pc++;
		} else if (opecode == 11) { //store
			mems[regs[rs] + sImm] = regs[rt];
			pc++;
		} else if (opecode == 7) { //fmul
			regs[rd] = ftoi(itof(regs[rs]) * itof(regs[rt]));
			pc++;
		} else if (opecode == 1) { //addi
			regs[rt] = regs[rs] + sImm;
			pc++;
		} else if (opecode == 0) { //add
			regs[rd] = regs[rs] + regs[rt];
			pc++;
		} else if (opecode == 20) { //fcmp
			regs[rd] = itof(regs[rs]) > itof(regs[rt]) ? 4 : itof(regs[rs]) == itof(regs[rt]) ? 2 : 1;
			pc++;
		} else if (opecode == 5) { //fadd
			regs[rd] = ftoi(itof(regs[rs]) + itof(regs[rt]));
			pc++;
		} else if (opecode == 6) { //fsub
			regs[rd] = ftoi(itof(regs[rs]) - itof(regs[rt]));
			pc++;
		} else if (opecode == 14) { //jal
			regs[31] = pc + 1;
			pc = addr;
		} else if (opecode == 15) { //jr
			pc = regs[rs];
		} else if (opecode == 8) { //finv
			regs[rd] = ftoi(1.0f / itof(regs[rs]));
			pc++;
		} else if (opecode == 2) { //sub
			regs[rd] = regs[rs] - regs[rt];
			pc++;
		} else if (opecode == 17) { //write
			putchar(regs[rs]);
			regs[rt] = 0;
#ifdef WRITE
			fprintf(stderr, "\rwrite %d bytes", ++writeBytes);
#endif
			pc++;
		} else if (opecode == 4) { //sll
			regs[rt] = regs[rs] << imm;
			pc++;
		} else if (opecode == 16) { //read
			regs[rt] = getchar();
			pc++;
		} else if (opecode == 3) { //srl
			regs[rt] = regs[rs] >> imm;
			pc++;
		} else if (opecode == 19) { //halt
			fprintf(stderr, "\n%lld instr.\n", count);
			return 0;
		} else if (opecode == 18) { //nop
			pc++;
		} else if (opecode == 21) { //ledout
			pc++;
		} else {
			fprintf(stderr, "Error!!!\n");
			return 1;
		}
	}
}
