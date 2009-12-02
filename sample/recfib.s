######################################################################
#
# 		↓　ここから macro.s
#
######################################################################

#レジスタ名置き換え
.define $zero $0
.define $ra $63
.define $sp $62
.define $hp $61
.define $tmp $60
.define $0 orz
.define $63 orz
.define $62 orz
.define $61 orz
.define $60 orz

#疑似命令
.define { neg %Reg %Reg } { sub $zero %1 %2 }
.define { b %Imm } { jmp 0 %1 }
.define { be %Imm } { jmp 5 %1 }
.define { bne %Imm } { jmp 2 %1 }
.define { bl %Imm } { jmp 6 %1 }
.define { ble %Imm } { jmp 4 %1 }
.define { bg %Imm } { jmp 3 %1 }
.define { bge %Imm } { jmp 1 %1 }
.define { ret } { jr $ra }

# 入力,出力の順にコンマで区切る形式
.define { li %Imm, %Reg } { li %2 %1 }
.define { add %Reg, %Reg, %Reg } { add %1 %2 %3 }
.define { add %Reg, %Imm, %Reg } { addi %1 %3 %2 }
.define { sub %Reg, %Reg, %Reg } { sub %1 %2 %3 }
.define { sub %Reg, %Imm, %Reg } { addi %1 %3 -%2 }
.define { sll %Reg, %Imm, %Reg } { sll %1 %3 %2 }
.define { cmp %Reg, %Reg } { cmp %1 %2 }
.define { cmp %Reg, %Imm } { cmpi %1 %2 }
.define { fadd %Reg, %Reg, %Reg } { fadd %1 %2 %3 }
.define { fsub %Reg, %Reg, %Reg } { fsub %1 %2 %3 }
.define { fmul %Reg, %Reg, %Reg } { fmul %1 %2 %3 }
.define { finv %Reg, %Reg } { finv %1 %2 }
.define { fsqrt %Reg, %Reg } { fsqrt %1 %2 }
.define { fcmp %Reg, %Reg } { fcmp %1 %2 }
.define { fabs %Reg, %Reg } { fabs %1 %2 }
.define { fneg %Reg, %Reg } { fneg %1 %2 }
.define { load [%Reg + %Imm], %Reg } { load %1 %3 %2 }
.define { load [%Reg - %Imm], %Reg } { load [%1 + -%2], %3}
.define { load [%Reg], %Reg } { load [%1 + 0], %2 }
.define { load [%Imm], %Reg } { load [$zero + %1], %2 }
.define { load [%Imm + %Reg], %Reg } { load [%2 + %1], %3 }
.define { load [%Imm + %Imm], %Reg } { load [%{ %1 + %2 }], %3 }
.define { load [%Imm - %Imm], %Reg } { load [%{ %1 - %2 }], %3 }
.define { load [%Reg + %Reg], %Reg } { loadr %1 %2 %3 }
.define { store %Reg, [%Reg + %Imm] } { store %2 %1 %3 }
.define { store %Reg, [%Reg - %Imm] } { store %1, [%2 + -%3] }
.define { store %Reg, [%Reg] } { store %1, [%2 + 0] }
.define { store %Reg, [%Imm] } { store %1, [$zero + %2] }
.define { store %Reg, [%Imm + %Reg] } { store %1, [%3 + %2] }
.define { store %Reg, [%Imm + %Imm] } { store %1, [%{ %2 + %3 }] }
.define { store %Reg, [%Imm - %Imm] } { store %1, [%{ %2 - %3 }] }
.define { mov %Reg, %Reg } { mov %1 %2 }
.define { neg %Reg, %Reg } { neg %1 %2 }
.define { write %Reg, %Reg } { write %1 %2 }

#スタックとヒープの初期化
	li      0, $zero
	li      0x1000, $hp
	sll		$hp, 4, $hp
	sll     $hp, 3, $sp
	b       min_caml_start

######################################################################
#
# 		↑　ここまで macro.s
#
######################################################################
.define	$one $1
.define	$n $2
.define	$t $3

min_caml_start:
	li STACK, $sp		# $sp = STACK
	li 1, $one			# $one = 1
	load [N], $n		# $n = [N]
	jal FIB				## $n = fib $n
	write $n, $tmp
	halt
.begin fib
FIB:
	cmp $n, $one		# $t = cmp $n 1
	ble RET
	add $sp, 3, $sp		# $sp = $sp + 3
	store $n, [$sp - 3]	# [$sp - 3] = $n
	store $ra, [$sp - 1]# [$sp - 1] = $ra
	add $n, -1, $n		# $n = $n - 1
	jal FIB				## $n = fib $n
	store $n, [$sp - 2]	# [$sp - 2] = $n
	load [$sp - 3], $n	# $n = [$sp - 3]
	add $n, -2, $n		# $n = $n - 2
	jal FIB				## $n = fib $n
	load [$sp - 2], $t	# $t = [$sp - 2]
	add $n, $t, $n		# $n = $n + $t
	load [$sp - 1], $ra	# $ra = [$sp - 2]
	add $sp, -3, $sp	# $sp = $sp + 3
RET:
	jr $ra
.end fib
N:	.int 35
STACK:
	.int 0				#スタックの位置
