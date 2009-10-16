#再帰版フィボナッチ
#変数の対応
#$zero=0
#$one=1
#$n=引数&戻り値
#$t=一時変数
#$sp=スタックポインタ
#$ra=リンクレジスタ
#レジスタの退避はcallerが行う

#jmp
.define { jmp %Reg %Imm %Imm } { _jmp %1 %2 %{ %3 - %pc } }

#疑似命令
.define { mov %Reg %Reg } { addi %1 %2 0 }
.define { neg %Reg %Reg } { sub $zero %1 %2 }
.define { fneg %Reg %Reg } { fsub $fzero %1 %2 }
.define { b %Imm } { jmp $i0 0 %1 }
.define { be %Reg %Imm } { jmp %1 5 %2 }
.define { bne %Reg %Imm } { jmp %1 2 %2 }
.define { bl %Reg %Imm } { jmp %1 6 %2 }
.define { ble %Reg %Imm } { jmp %1 4 %2 }
.define { bg %Reg %Imm } { jmp %1 3 %2 }
.define { bge %Reg %Imm } { jmp %1 1 %2 }
.define { ret } { jr $ra }

.define	$zero $i0
.define	$one $i1
.define	$n $i2
.define	$t $i3
.define	$sp $i14
.define	$ra $i15
main:
	li $sp STACK		# $sp = STACK
	li $one 1			# $one = 1
	load $zero $n N		# $n = [N]
	jal FIB				## $n = fib $n
	write $n $n
	halt
FIB:
	cmp $n $one $t		# $t = cmp $n 1
	ble $t RET
	addi $sp $sp 3		# $sp = $sp + 3
	store $sp $n -3		# [$sp - 3] = $n
	store $sp $ra -1	# [$sp - 1] = $ra
	addi $n $n -1		# $n = $n - 1
	jal FIB				## $n = fib $n
	store $sp $n -2		# [$sp - 2] = $n
	load $sp $n -3		# $n = [$sp - 3]
	addi $n $n -2		# $n = $n - 2
	jal FIB				## $n = fib $n
	load $sp $t -2		# $t = [$sp - 2]
	add $n $t $n		# $n = $n + $t
	load $sp $ra -1		# $ra = [$sp - 2]
	addi $sp $sp -3		# $sp = $sp + 3
RET:
	jr $ra
N:	.int 35
STACK:
	.int 0				#スタックの位置
