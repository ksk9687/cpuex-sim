#ループ版フィボナッチ
#変数の対応
#$zero=0
#$n=n(ループカウンタ)
#$a=fib n
#$b=fib (n+1)
#$t=一時変数

#jmp
.define { jmp %Reg %Imm %Imm } { _jmp %1 %2 %{ %3 - %pc } }

#疑似命令
.define { mov %Reg %Reg } { addi %1 %2 0 }
.define { neg %Reg %Reg } { sub $zero %1 %2 }
.define { fneg %Reg %Reg } { fsub $fzero %1 %2 }
.define { b %Imm } { jmp $0 0 %1 }
.define { be %Reg %Imm } { jmp %1 5 %2 }
.define { bne %Reg %Imm } { jmp %1 2 %2 }
.define { bl %Reg %Imm } { jmp %1 6 %2 }
.define { ble %Reg %Imm } { jmp %1 4 %2 }
.define { bg %Reg %Imm } { jmp %1 3 %2 }
.define { bge %Reg %Imm } { jmp %1 1 %2 }
.define { ret } { jr $ra }

.define	$zero $0
.define	$n $1
.define	$a $2
.define	$b $3
.define	$t $4

	load $zero $n N		# $n = [N]
	li $b 1				# $b = 1
LOOP:
	cmp $n $zero $t		# $t = cmp $n 0
	ble $t END
	add $a $b $t		# $t = $a + $b
	mov $b $a			# $a = $b
	mov $t $b			# $b = $t
	addi $n $n -1		# $n = $n - 1
	b LOOP
END:
	write $a $a
	halt
N:	.int 10
