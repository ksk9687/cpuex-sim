######################################################################
# lib - 浮動小数点ライブラリ-20091014-2版
#
# * fless
# * fispos
# * fisneg
# * fhalf
# * fsqr
# * fabs
# * fneg
# * sqrt
# * floor (要改造)
# * int_to_float
# * float_to_int
# * read_int
# * read_float
# * write_int
# * write_float
#
######################################################################

.define fcmp cmp
.define $mi $i2
.define $mfhx $i3
.define $mf $f2
.define $cond $i4

.define $q $i5
.define $r $i6
.define $temp $i7

.define $rf $f6
.define $tempf $f7


######################################################################
# * fless
# fless($f1, $f2) := ($f1 < $f2) ? 1 : 0
######################################################################
min_caml_fless:
	fcmp $f1 $f2 $cond
	bge $cond FLESS_RET
	li $i1 1
	ret
FLESS_RET:
	li $i1 0
	ret


######################################################################
# * fispos
# fispos($f1) := ($f1 > 0) ? 1 : 0
######################################################################
min_caml_fispos:
	fcmp $f1 $fzero $cond
	bg $cond FISPOS_RET
	li $i1 0
	ret
FISPOS_RET:
	li $i1 1
	ret


######################################################################
# * fisneg
# fisneg($f1) := ($f1 < 0) ? 1 : 0
######################################################################
min_caml_fisneg:
	fcmp $f1 $fzero $cond
	bl $cond FISNEG_RET
	li $i1 0
	ret
FISNEG_RET:
	li $i1 1
	ret


######################################################################
# * fiszero
# fiszero($f1) := ($f1 == 0) ? 1 : 0
######################################################################
min_caml_fiszero:
	fcmp $f1 $fzero $cond
	be $cond FISZERO_RET
	li $i1 0
	ret
FISZERO_RET:
	li $i1 1
	ret


######################################################################
# * fhalf
# fhalf($f1) := $f1 / 2.0
######################################################################
min_caml_fhalf:
	load $zero $f2 FHALF_DAT
	fmul $f1 $f2 $f1
	ret
FHALF_DAT:
	.float 0.5


######################################################################
# * fsqr
# fsqr($f1) := $f1 * $f1
######################################################################
min_caml_fsqr:
	fmul $f1 $f1 $f1
	ret


######################################################################
# * fabs
######################################################################
min_caml_fabs:
	fcmp $f1 $fzero $cond
	ble $cond FABS_NEG
	ret
FABS_NEG:
	fsub $fzero $f1 $f1
	ret


######################################################################
# * fneg
######################################################################
min_caml_fneg:
	fsub $fzero $f1 $f1
	ret


######################################################################
# * floor
######################################################################
# floor(f) = itof(ftoi(f)) という適当仕様
# これじゃおそらく明らかに誤差るので、まだ要実装
min_caml_floor:
	store $sp $ra 0
	addi $sp $sp 1
	jal min_caml_float_to_int
	jal min_caml_int_to_float
	addi $sp $sp -1
	load $sp $ra 0
	jr $ra


######################################################################
# * int_to_float
######################################################################
min_caml_int_to_float:
	cmp $i1 $zero $cond
	bge $cond ITOF_MAIN		# if ($i1 >= 0) goto ITOF_MAIN
	sub $zero $i1 $i1		# 正の値にしてitofした後に、マイナスにしてかえす
	store $sp $ra 0
	addi $sp $sp 1
	jal min_caml_int_to_float	# $f1 = int_to_float(-$i1)
	addi $sp $sp -1
	load $sp $ra 0
	store $sp $f1 0
	load $sp $i1 0			# $i1 = floatToIntBits($f1)
	li $temp 1
	sll $temp $temp 31
	add $i1 $temp $i1		# ビット演算が無いので、これで $i1 = -$i1
	store $sp $i1 0
	load $sp $f1 0			# $f1 = intBitsToFloat($i1)
	jr $ra
ITOF_MAIN:
	load $zero $mi FLOAT_MAGICI	# $mi = 8388608
	load $zero $mf FLOAT_MAGICF	# $mf = 8388608.0
	load $zero $mfhx FLOAT_MAGICFHX	# $mfhx = 0x4b000000
	cmp $i1 $mi $cond		# $cond = cmp($i1, 8388608)
	bge $cond ITOF_BIG		# if ($i1 >= 8388608) goto ITOF_BIG
	add $i1 $mfhx $i1		# $i1 = $i1 + $mfhx (i.e. $i1 + 0x4b000000)
	store $sp $i1 0			# [$sp + 1] = $i1
	load $sp $f1 0			# $f1 = [$sp + 1]
	fsub $f1 $mf $f1		# $f1 = $f1 - $mf (i.e. $f1 - 8388608.0)
	jr $ra				# return
ITOF_BIG:
	li $q 0				# $i1 = $q * 8388608 + $r なる$q, $rを求める
	li $r 0				# divが無いから自前で頑張る
	add $r $i1 $r			# $r = $i1
ITOF_LOOP:
	addi $q $q 1			# $q += 1
	sub $r $mi $r			# $r -= 8388608
	cmp $r $mi $cond
	bge $cond ITOF_LOOP		# if ($r >= 8388608) continue
	li $f1 0
ITOF_LOOP2:
	fadd $f1 $mf $f1		# $f1 = $q * $mf
	addi $q $q -1
	cmp $q $zero $cond
	bg $cond ITOF_LOOP2
	add $r $mfhx $r			# $r < 8388608 だからそのままitof
	store $sp $r 2
	load $sp $tempf 2
	fsub $tempf $mf $tempf		# $tempf = itof($r)
	fadd $f1 $tempf $f1		# $f1 = $f1 + $tempf (i.e. $f1 = itof($q * $mf) + itof($r) )
	jr $ra


######################################################################
# * float_to_int
######################################################################
min_caml_float_to_int:
	fcmp $f1 $fzero $cond
	bge $cond FTOI_MAIN		# if ($f1 >= 0) goto FTOI_MAIN
	fsub $fzero $f1 $f1		# 正の値にしてftoiした後に、マイナスにしてかえす
	store $sp $ra 0
	addi $sp $sp 1
	jal min_caml_float_to_int	# $i1 = int_to_float(-$f1)
	addi $sp $sp -1
	load $sp $ra 0
	sub $zero $i1 $i1
	jr $ra				# return
FTOI_MAIN:
	load $zero $mi FLOAT_MAGICI	# $mi = 8388608
	load $zero $mf FLOAT_MAGICF	# $mf = 8388608.0
	load $zero $mfhx FLOAT_MAGICFHX	# $mfhx = 0x4b000000
	fcmp $f1 $mf $cond
	bge $cond FTOI_BIG		# if ($f1 >= 8688608.0) goto FTOI_BIG
	fadd $f1 $mf $f1
	store $sp $f1 1
	load $sp $i1 1
	sub $i1 $mfhx $i1
	jr $ra
FTOI_BIG:
	li $q 0				# $f1 = $q * 8388608 + $rf なる$q, $rfを求める
	li $rf 0
	fadd $rf $f1 $rf		# $rf = $i1
FTOI_LOOP:
	addi $q $q 1			# $q += 1
	fsub $rf $mf $rf		# $rf -= 8388608.0
	fcmp $rf $mf $cond
	bge $cond FTOI_LOOP		# if ($rf >= 8388608.0) continue
	li $i1 0
FTOI_LOOP2:
	add $i1 $mi $i1			# $i1 = $q * $mi
	addi $q $q -1
	cmp $q $zero $cond
	bg $cond FTOI_LOOP2
	fadd $rf $mf $rf		# $rf < 8388608.0 だからそのままftoi
	store $sp $rf 1
	load $sp $temp 1
	sub $temp $mfhx $temp		# $temp = ftoi($rf)
	add $i1 $temp $i1		# $i1 = $i1 + $temp (i.e. $i1 = ftoi($q * $mi) + ftoi($rf) )
	jr $ra

FLOAT_MAGICI:
	.int 8388608
FLOAT_MAGICF:
	.float 8388608.0
FLOAT_MAGICFHX:
	.int 1258291200			# 0x4b000000

######################################################################
# * sqrt
######################################################################


######################################################################
# * sin
######################################################################


######################################################################
# * cos
######################################################################


######################################################################
# * atan
######################################################################


######################################################################
# * read_int
######################################################################
min_caml_read_int:
	read $i1
	ret


######################################################################
# * read_float
######################################################################
min_caml_read_float:
	read $f1
	ret


######################################################################
# * write_int
######################################################################
min_caml_write_int:
	write $i1
	ret


######################################################################
# * write_float
######################################################################
min_caml_write_float:
	write $f1
	ret
