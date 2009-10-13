#ループ版フィボナッチ
#変数の対応
#$zero=0
#$n=n(ループカウンタ)
#$a=fib n
#$b=fib (n+1)
#$t=一時変数
.define	$zero $i0
.define	$n $i1
.define	$a $i2
.define	$b $i3
.define	$t $i4

	load $zero $n N		# $n = [N]
	li $b 1				# $b = 1
LOOP:
	cmp $n $zero $t		# $t = cmp $n 0
	ble $t END
	$t = $a + $b
	$a = $b
	$b = $t
	$n = $n - 1
	b LOOP
END:
	write $a
	halt
N:	.int 10
