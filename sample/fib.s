######################################################################
#
# 		↓　ここから macro.s
#
######################################################################

#レジスタ名置き換え
.define $zero $0
.define $sp $63
.define $hp $62
.define $tmp $61
.define $0 orz
.define $63 orz
.define $62 orz
.define $61 orz

#疑似命令
.define { neg %Reg %Reg } { sub $zero %1 %2 }
.define { b %Imm } { jmp 0 %1 }
.define { be %Imm } { jmp 5 %1 }
.define { bne %Imm } { jmp 2 %1 }
.define { bl %Imm } { jmp 6 %1 }
.define { ble %Imm } { jmp 4 %1 }
.define { bg %Imm } { jmp 3 %1 }
.define { bge %Imm } { jmp 1 %1 }

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
	call     min_caml_main
	halt

######################################################################
#
# 		↑　ここまで macro.s
#
######################################################################
.define $n $1
.define $a $2
.define $b $3
.define $t $4
min_caml_main:
	load [N], $n		# $n = [N]
	li 1, $b			# $b = 1
LOOP:
	cmp $n, $zero		# $t = cmp $n 0
	ble END
	add $a, $b, $t		# $t = $a + $b
	mov $b, $a			# $a = $b
	mov $t, $b			# $b = $t
	add $n, -1, $n		# $n = $n - 1
	b LOOP
END:
	write $a, $tmp
	halt
N:	.int 10
