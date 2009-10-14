######################################################################
# test_lib.s - lib.s のテスト用
######################################################################

	load $zero $f1 F
	jal min_caml_fsqr
	jal min_caml_float_to_int
	write $i1
	halt
N:
	.int -2
F:
	.float 16.0
F2:
	.float 4.0
F3:
	.float -50.0
F4:
	.float 1.9