#再帰版フィボナッチ
#変数の対応
#$zero=0
#$one=1
#$n=引数&戻り値
#$t=一時変数
#$sp=スタックポインタ
#$ra=リンクレジスタ
#レジスタの退避はcallerが行う
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
	write $n
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
N:	.int 10
STACK:
	.int 0				#スタックの位置
