#ループ版フィボナッチ
#変数の対応
#$0=0
#$1=n(ループカウンタ)
#$2=fib n
#$3=fib (n+1)
#$4=一時変数
	load $0 $1 N		# $1 = N
	li $3 1				# $3 = 1
LOOP:
	cmp $1 $0 $4		# $4 = cmp($1, 0)
	jmp $4 0b100 END	# if $1 <= 0 then goto END
	add $2 $3 $4		# $4 = $2 + $3
	addi $3 $2 0		# $2 = $3
	addi $4 $3 0		# $3 = $4
	addi $1 $1 -1		# $1 = $1 - 1
	jmp $0 0 LOOP		# goto LOOP
END:
	write $2			# $2を出力
	halt				# 終了
N:	raw 10				# 定数N
