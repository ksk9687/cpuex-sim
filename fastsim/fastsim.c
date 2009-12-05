#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define WRITE

typedef union {
	float f;
	int i;
} FI;

inline int ftoi(float f) { FI fi; fi.f = f; return fi.i; }
inline float itof(int i) { FI fi; fi.i = i; return fi.f; }

#define opecode (op >> 26)
#define rs (op >> 20 & 63)
#define rt (op >> 14 & 63)
#define rd (op >> 8 & 63)
#define imm (op & ((1 << 14) - 1))
#define sImm ((int)((op & (1 << 13)) ? (((1 << 18) - 1) << 14 | op) : imm))

int regs[64];
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
    int cond = 0;
	long long count;
	int writeBytes = 0;
	if (argc != 2) {
		fprintf(stderr, "Usage: ./sim.exe bin < in > out\n");
		exit(1);
	}
	load(argv[1]);
	for (count = 1; ; count++) {
		unsigned int op = mems[pc];
		if (opecode == 030) { //load
			regs[rt] = mems[regs[rs] + sImm];
			pc++;
		} else if (opecode == 070) { //jmp
			if (cond & rs) {
				pc++;
			} else {
				pc = imm;
			}
		} else if (opecode == 003) { //cmpi
			cond = regs[rs] > sImm ? 4 : regs[rs] == sImm ? 2 : 1;
			pc++;
		} else if (opecode == 022) { //fmul
			regs[rd] = ftoi(itof(regs[rs]) * itof(regs[rt]));
			pc++;
		} else if (opecode == 000) { //li
			regs[rt] = imm;
			pc++;
		} else if (opecode == 025) { //fcmp
			cond = itof(regs[rs]) > itof(regs[rt]) ? 4 : itof(regs[rs]) == itof(regs[rt]) ? 2 : 1;
			pc++;
		} else if (opecode == 020) { //fadd
			regs[rd] = ftoi(itof(regs[rs]) + itof(regs[rt]));
			pc++;
		} else if (opecode == 021) { //fsub
			regs[rd] = ftoi(itof(regs[rs]) - itof(regs[rt]));
			pc++;
		} else if (opecode == 031) { //store
			mems[regs[rs] + sImm] = regs[rt];
			pc++;
		} else if (opecode == 032) { //loadr
			regs[rd] = mems[regs[rs] + regs[rt]];
			pc++;
		} else if (opecode == 001) { //addi
			regs[rt] = regs[rs] + sImm;
			pc++;
		} else if (opecode == 005) { //mov
			regs[rt] = regs[rs];
			pc++;
		} else if (opecode == 006) { //fabs
			regs[rd] = ftoi(fabsf(itof(regs[rs])));
			pc++;
		} else if (opecode == 071) { //jal
			regs[63] = pc + 1;
			pc = imm;
		} else if (opecode == 072) { //jr
			pc = regs[rs];
		} else if (opecode == 010) { //add
			regs[rd] = regs[rs] + regs[rt];
			pc++;
		} else if (opecode == 011) { //sub
			regs[rd] = regs[rs] - regs[rt];
			pc++;
		} else if (opecode == 002) { //sll
			regs[rt] = regs[rs] << imm;
			pc++;
		} else if (opecode == 012) { //cmp
			cond = regs[rs] > regs[rt] ? 4 : regs[rs] == regs[rt] ? 2 : 1;
			pc++;
		} else if (opecode == 023) { //finv
			regs[rd] = ftoi(1.0f / itof(regs[rs]));
			pc++;
		} else if (opecode == 024) { //fsqrt
			regs[rd] = ftoi(sqrtf(itof(regs[rs])));
			pc++;
		} else if (opecode == 007) { //fneg
			regs[rd] = ftoi(-(itof(regs[rs])));
			pc++;
		} else if (opecode == 040) { //hsread
			//Not implemented
            pc++;
		} else if (opecode == 041) { //hswrite
        	//Not implemented
            pc++;
		} else if (opecode == 050) { //read
			regs[rt] = getchar();
			pc++;
		} else if (opecode == 051) { //write
			putchar(regs[rs]);
			regs[rt] = 0;
#ifdef WRITE
			fprintf(stderr, "\rwrite %d bytes", ++writeBytes);
#endif
			pc++;
		} else if (opecode == 052) { //ledout
			pc++;
		} else if (opecode == 060) { //nop
			pc++;
		} else if (opecode == 061) { //halt
			fprintf(stderr, "\n%lld instr.\n", count);
			return 0;
		} else {
			fprintf(stderr, "Error!!!\n");
			return 1;
		}
	}
}
