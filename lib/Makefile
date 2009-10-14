CP = -classpath "../"

test : macro.s test_lib.s lib.s
	cat macro.s test_lib.s lib.s > code.s
	java $(CP) asm.Assembler < code.s > a.out
	java $(CP) sim.Simulator a.out > dat
	hd dat

clean:
	rm -f code.s a.out dat
