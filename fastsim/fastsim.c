#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define WRITE

typedef long long ll;

typedef union {
	float f;
	int i;
} FI;

inline int ftoi(float f) { FI fi; fi.f = f; return fi.i; }
inline float itof(int i) { FI fi; fi.i = i; return fi.f; }

#define unitop (ope >> 33)
#define op (ope >> 30 & 7)
#define jop (ope >> 31 & 3)
#define subop (ope >> 28 & 3)
#define mask (ope >> 28 & 7)
#define rs (ope >> 22 & 63)
#define rt (ope >> 10 & 63)
#define rd (ope >> 16 & 63)
#define imm (ope & 16383)
#define sImm ((ope >> 13 & 1) ? -8192 | imm : imm)
#define imm2 ((ope >> 18 & 15) << 10 | (ope & 1023))
#define sImm2 ((ope >> 21 & 1) ? -8192 | imm2 : imm2)
#define imm3 (ope >> 10 & 255)
#define sImm3 ((ope >> 17 & 1) ? -128 | imm3 : imm3)
#define cmp(a, b) (a > b ? 4 : a == b ? 2 : 1)
#define fabsneg(a, b) (b == 0 ? a : b == 2 ? (a & ~(1 << 31)) : (a ^ (1 << 31)))
#define ledout(a) fprintf(stderr, "LED: 0x%X, %d, %.6E\n", a, a, itof(a))
#define ERROR fprintf(stderr, "Error!!!\npc = %d\n", pc); return 1;

int iregs[64];
int fregs[64];
int mem[1 << 17];
ll bin[1 << 14];

unsigned int readInt(FILE *f) {
	unsigned int i, res = 0;
	for (i = 0; i < 4; i++) {
		res = res << 8 | fgetc(f);
	}
	return res;
}

unsigned int readInt2(FILE *f) {
	unsigned int i, res = 0;
	for (i = 0; i < 3; i++) {
		res = res << 8 | fgetc(f);
	}
	return res;
}

void load(char *name) {
	int i, size;
	FILE *f = fopen(name, "r");
	size = readInt2(f) / 3 * 2;
	for (i = 0; i < size; i += 2) {
		ll a = readInt(f);
		ll b = readInt(f);
		ll c = readInt(f);
		bin[256 + i] = a << 28 | b >> 4;
		bin[256 + i + 1] = (b & 15) << 32 | c;
	}
	size = readInt(f);
	for (i = 0; i < size; i++) {
		mem[i] = readInt(f);
	}
	fclose(f);
}

int main(int argc, char **argv) {
	int pc = 256;
	long long count;
	int writeBytes = 0;
	if (argc != 2) {
		fprintf(stderr, "Usage: ./sim.exe bin < in > out\n");
		exit(1);
	}
	load(argv[1]);
	for (count = 1; ; count++) {
		ll ope = bin[pc];
		if (unitop == 2) {
			//LOADSTORE
			if (op == 4) { //fload
				fregs[rd] = mem[iregs[rs] + sImm];
				pc++;
			} else if (op == 0) { //load
				iregs[rd] = mem[iregs[rs] + sImm];
				pc++;
			} else if (op == 1) { //loadr
				iregs[rd] = mem[iregs[rs] + iregs[rt]];
				pc++;
			} else if (op == 2) { //store
				mem[iregs[rs] + sImm2] = iregs[rt];
				pc++;
			} else if (op == 6) { //fstore
				mem[iregs[rs] + sImm2] = fregs[rt];
				pc++;
			} else if (op == 5) { //floadr
				fregs[rd] = mem[iregs[rs] + iregs[rt]];
				pc++;
			} else if (op == 3) { //imovf
				fregs[rd] = iregs[rt];
				pc++;
			} else if (op == 7) { //fmovi
				iregs[rd] = fregs[rt];
				pc++;
			} else {
				ERROR
			}
		} else if (unitop == 4) {
			//FPU
			if (op == 2) { //fmul
				fregs[rd] = fabsneg(ftoi(itof(fregs[rs]) * itof(fregs[rt])), subop);
				pc++;
			} else if (op == 0) { //fadd
				fregs[rd] = fabsneg(ftoi(itof(fregs[rs]) + itof(fregs[rt])), subop);
				pc++;
			} else if (op == 1) { //fsub
				fregs[rd] = fabsneg(ftoi(itof(fregs[rs]) - itof(fregs[rt])), subop);
				pc++;
			} else if (op == 5) { //fmov
				fregs[rd] = fabsneg(fregs[rs], subop);
				pc++;
			} else if (op == 4) { //fsqrt
				fregs[rd] = fabsneg(ftoi(sqrtf(itof(fregs[rs]))), subop);
				pc++;
			} else if (op == 3) { //finv
				fregs[rd] = fabsneg(ftoi(1.0f / itof(fregs[rs])), subop);
				pc++;
			} else {
				ERROR
			}
		} else if (unitop == 6) {
			//JMP
			if (jop == 1) { //cmpijmp
				if ((cmp(iregs[rs], sImm3) & mask) == 0) {
					if (imm2 == pc) { //halt
						fprintf(stderr, "\n%lld instr.\n", count - 1);
						return 0;
					} else {
						pc = imm2;
					}
				} else {
					pc++;
				}
			} else if (jop == 2) { //fcmpjmp
				if ((cmp(itof(fregs[rs]), itof(fregs[rt])) & mask) == 0) {
					pc = imm2;
				} else {
					pc++;
				}
			} else if (jop == 3) { //jr
				pc = iregs[rs];
			} else if (jop == 0) { //cmpjmp
				if ((cmp(iregs[rs], iregs[rt]) & mask) == 0) {
					pc = imm2;
				} else {
					pc++;
				}
			} else {
				ERROR
			}
		} else if (unitop == 0) {
			//ALU
			if (op == 0) { //li
				iregs[rd] = imm;
				pc++;
			} else if (op == 4) { //mov
				iregs[rd] = iregs[rs];
				pc++;
			} else if (op == 1) { //addi
				iregs[rd] = iregs[rs] + imm;
				pc++;
			} else if (op == 3) { //jal
				iregs[rd] = pc + 1;
				pc = imm;
			} else if (op == 2) { //subi
				iregs[rd] = iregs[rs] - imm;
				pc++;
			} else if (op == 5) { //add
				iregs[rd] = iregs[rs] + iregs[rt];
				pc++;
			} else if (op == 6) { //sub
				iregs[rd] = iregs[rs] - iregs[rt];
				pc++;
			} else {
				ERROR
			}
		} else if (unitop == 3) {
			//IO
			if (op == 0) { //read
				iregs[rd] = getchar();
				pc++;
			} else if (op == 2) { //write
				putchar(iregs[rs]);
				iregs[rd] = 0;
#ifdef WRITE
				fprintf(stderr, "\rwrite %d bytes", ++writeBytes);
#endif
				pc++;
			} else if (op == 4) { //ledout
				ledout(iregs[rs]);
				pc++;
			} else if (op == 6) { //ledouti
				ledout((int)imm);
				pc++;
			} else {
				ERROR
			}
		} else if (unitop == 5) {
			//NOP
			if (op == 7) { // nop
				pc++;
			} else {
				ERROR
			}
		} else {
			ERROR
		}
	}
}
