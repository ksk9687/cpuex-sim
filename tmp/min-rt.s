######################################################################
#
# 		↓　ここから macro.s
#
######################################################################

#レジスタ名置き換え
.define $zero $i0
.define $ra $i15
.define $sp $i14
.define $hp $i13
.define $fzero $f0
.define $i0 orz
.define $i15 orz
.define $i14 orz
.define $i13 orz
.define $f0 orz

#jmp
.define { jmp %Reg %Imm %Imm } { _jmp %1 %2 %{ %3 - %pc } }

#疑似命令
.define { mov %Reg %Reg } { addi %1 %2 0 }
.define { neg %Reg %Reg } { sub $zero %1 %2 }
.define { fneg %Reg %Reg } { fsub $fzero %1 %2 }
.define { b %Imm } { jmp $zero 0 %1 }
.define { be %Reg %Imm } { jmp %1 5 %2 }
.define { bne %Reg %Imm } { jmp %1 2 %2 }
.define { bl %Reg %Imm } { jmp %1 6 %2 }
.define { ble %Reg %Imm } { jmp %1 4 %2 }
.define { bg %Reg %Imm } { jmp %1 3 %2 }
.define { bge %Reg %Imm } { jmp %1 1 %2 }
.define { ret } { jr $ra }

# 入力,出力の順にコンマで区切る形式
.define { add %Reg, %Reg, %Reg } { add %1 %2 %3 }
.define { add %Reg, %Imm, %Reg } { addi %1 %3 %2 }
.define { sub %Reg, %Reg, %Reg } { sub %1 %2 %3 }
.define { sub %Reg, %Imm, %Reg } { addi %1 %3 -%2 }
.define { srl %Reg, %Imm, %Reg } { srl %1 %3 %2 }
.define { sll %Reg, %Imm, %Reg } { sll %1 %3 %2 }
.define { fadd %Reg, %Reg, %Reg } { fadd %1 %2 %3 }
.define { fsub %Reg, %Reg, %Reg } { fsub %1 %2 %3 }
.define { fmul %Reg, %Reg, %Reg } { fmul %1 %2 %3 }
.define { finv %Reg, %Reg } { finv %1 %2 }
.define { load %Imm(%Reg), %Reg } { load %2 %3 %1 }
.define { load %Reg, %Reg } { load 0(%1), %2 }
.define { load %Imm, %Reg } { load %1($zero), %2 }
.define { li %Imm, %Reg } { li %2 %1 }
.define { store %Reg, %Imm(%Reg) } { store %3 %1 %2 }
.define { store %Reg, %Reg } { store %1, 0(%2) }
.define { store %Reg, %Imm } { store %1, %2($zero) }
.define { cmp %Reg, %Reg, %Reg } { cmp %1 %2 %3 }
.define { fcmp %Reg, %Reg, %Reg } { fcmp %1 %2 %3 }
.define { write %Reg, %Reg } { write %1 %2 }
.define { jmp %Reg, %Imm, %Imm } { jmp %1 %2 %3 }
.define { mov %Reg, %Reg } { mov %1 %2 }
.define { neg %Reg, %Reg } { neg %1 %2 }
.define { fneg %Reg, %Reg } { fneg %1 %2 }
.define { be %Reg, %Imm } { be %1 %2 }
.define { bne %Reg, %Imm } { bne %1 %2 }
.define { bl %Reg, %Imm } { bl %1 %2 }
.define { ble %Reg, %Imm } { ble %1 %2 }
.define { bg %Reg, %Imm } { bg %1 %2 }
.define { bge %Reg, %Imm } { bge %1 %2 }

#メモリ参照に[]を使う形式
.define { load [%Reg + %Imm], %Reg } { load %2(%1), %3 }
.define { load [%Reg - %Imm], %Reg } { load -%2(%2), %3 }
.define { load [%Reg], %Reg } { load %1, %2 }
.define { load [%Imm], %Reg } { load %1, %2 }
.define { store %Reg, [%Reg + %Imm] } { store %1, %3(%2) }
.define { store %Reg, [%Reg - %Imm] } { store %1, -%3(%2) }
.define { store %Reg, [%Reg] } { store %1, %2 }
.define { store %Reg, [%Imm] } { store %1, %2 }

#代入に=使う形式
.define { %Reg = %Reg + %Reg } { add %2, %3, %1 }
.define { %Reg = %Reg + %Imm } { add %2, %3, %1 }
.define { %Reg = %Reg - %Reg } { sub %2, %3, %1 }
.define { %Reg = %Reg - %Imm } { sub %2, %3, %1 }
.define { %Reg = %Reg >> %Imm } { srl %2, %3, %1 }
.define { %Reg = %Reg << %Imm } { sll %2, %3, %1 }
.define { %Reg = %Reg + %Reg } { fadd %2, %3, %1 }
.define { %Reg = %Reg - %Reg } { fsub %2, %3, %1 }
.define { %Reg = %Reg * %Reg } { fmul %2, %3, %1 }
.define { %Reg = finv %Reg } { finv %2, %1 }
.define { %Reg = [%Reg + %Imm] } { load [%2 + %3], %1 }
.define { %Reg = [%Reg - %Imm] } { load [%2 - %3], %1 }
.define { %Reg = [%Reg] } { load [%2], %1 }
.define { %Reg = [%Imm] } { load [%2], %1 }
.define { %Reg = %Imm } { li %2, %1 }
.define { [%Reg + %Imm] = %Reg } { store %3, [%1 + %2] }
.define { [%Reg - %Imm] = %Reg } { store %3, [%1 - %2] }
.define { [%Reg] = %Reg } { store %2, [%1] }
.define { [%Imm] = %Reg } { store %2, [%1] }
.define { %Reg = cmp %Reg %Reg } { cmp %2, %3, %1 }
.define { %Reg = fcmp %Reg %Reg } { fcmp %2, %3, %1 }
.define { %Reg = read } { read %1 }
.define { %Reg = write %Reg } { write %2 %1 }
.define { %Reg = %Reg } { mov %2, %1 }
.define { %Reg = -%Reg } { neg %2, %1 }
.define { %Reg = -%Reg } { fneg %2, %1 }
.define { %Reg += %Reg } { %1 = %1 + %2 }
.define { %Reg += %Imm } { %1 = %1 + %2 }
.define { %Reg -= %Reg } { %1 = %1 - %2 }
.define { %Reg -= %Imm } { %1 = %1 - %2 }
.define { %Reg++ } { %1 += 1 }
.define { %Reg-- } { %1 -= 1 }
.define { %Reg *= %Reg } { %1 = %1 * %2 }

#スタックとヒープの初期化
	li      0x1000, $hp
	sll		$hp, 4, $hp
	sll     $hp, 3, $sp

######################################################################
#
# 		↑　ここまで macro.s
#
######################################################################
	li      25, $i1
	li      l.14551, $i2
	load    0($i2), $f1
	store   $f1, 0($sp)
	li      l.14553, $i2
	load    0($i2), $f2
	store   $f2, 1($sp)
	li      l.14555, $i2
	load    0($i2), $f3
	store   $f3, 2($sp)
	mov     $hp, $i2
	store   $i2, 3($sp)
	add     $hp, 2, $hp
	li      cordic_sin.2737, $i3
	store   $i3, 0($i2)
	store   $i1, 1($i2)
	mov     $hp, $i3
	store   $i3, 4($sp)
	add     $hp, 2, $hp
	li      cordic_cos.2739, $i4
	store   $i4, 0($i3)
	store   $i1, 1($i3)
	mov     $hp, $i4
	store   $i4, 5($sp)
	add     $hp, 2, $hp
	li      cordic_atan.2741, $i5
	store   $i5, 0($i4)
	store   $i1, 1($i4)
	mov     $hp, $i1
	store   $i1, 6($sp)
	add     $hp, 5, $hp
	li      sin.2743, $i4
	store   $i4, 0($i1)
	store   $f3, 4($i1)
	store   $f2, 3($i1)
	store   $f1, 2($i1)
	store   $i2, 1($i1)
	mov     $hp, $i1
	store   $i1, 7($sp)
	add     $hp, 5, $hp
	li      cos.2745, $i2
	store   $i2, 0($i1)
	store   $f3, 4($i1)
	store   $f2, 3($i1)
	store   $f1, 2($i1)
	store   $i3, 1($i1)
	li      1, $i1
	li      0, $i2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	li      0, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_float_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      60, $i2
	li      0, $i3
	li      0, $i4
	li      0, $i5
	li      0, $i6
	li      0, $i7
	mov     $hp, $i8
	add     $hp, 11, $hp
	store   $i1, 10($i8)
	store   $i1, 9($i8)
	store   $i1, 8($i8)
	store   $i1, 7($i8)
	store   $i7, 6($i8)
	store   $i1, 5($i8)
	store   $i1, 4($i8)
	store   $i6, 3($i8)
	store   $i5, 2($i8)
	store   $i4, 1($i8)
	store   $i3, 0($i8)
	mov     $i8, $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $i1, 9($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_float_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $i1, 11($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_float_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $i1, 12($sp)
	li      1, $i1
	li      l.14284, $i2
	load    0($i2), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_float_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $i1, 13($sp)
	li      50, $i1
	store   $i1, 14($sp)
	li      1, $i1
	li      -1, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $i1, $i2
	load    14($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $i1, 15($sp)
	li      1, $i2
	store   $i2, 16($sp)
	li      1, $i2
	load    0($i1), $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	mov     $i1, $i2
	load    16($sp), $i1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	store   $i1, 17($sp)
	li      1, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_float_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	store   $i1, 18($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	store   $i1, 19($sp)
	li      1, $i1
	li      l.14248, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	store   $i1, 20($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_float_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	store   $i1, 21($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_create_array
	sub     $sp, 23, $sp
	load    22($sp), $ra
	store   $i1, 22($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_create_float_array
	sub     $sp, 24, $sp
	load    23($sp), $ra
	store   $i1, 23($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_create_float_array
	sub     $sp, 25, $sp
	load    24($sp), $ra
	store   $i1, 24($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_create_float_array
	sub     $sp, 26, $sp
	load    25($sp), $ra
	store   $i1, 25($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_create_float_array
	sub     $sp, 27, $sp
	load    26($sp), $ra
	store   $i1, 26($sp)
	li      2, $i1
	li      0, $i2
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_create_array
	sub     $sp, 28, $sp
	load    27($sp), $ra
	store   $i1, 27($sp)
	li      2, $i1
	li      0, $i2
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_create_array
	sub     $sp, 29, $sp
	load    28($sp), $ra
	store   $i1, 28($sp)
	li      1, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_create_float_array
	sub     $sp, 30, $sp
	load    29($sp), $ra
	store   $i1, 29($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_create_float_array
	sub     $sp, 31, $sp
	load    30($sp), $ra
	store   $i1, 30($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_create_float_array
	sub     $sp, 32, $sp
	load    31($sp), $ra
	store   $i1, 31($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_float_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	store   $i1, 32($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_create_float_array
	sub     $sp, 34, $sp
	load    33($sp), $ra
	store   $i1, 33($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_create_float_array
	sub     $sp, 35, $sp
	load    34($sp), $ra
	store   $i1, 34($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_create_float_array
	sub     $sp, 36, $sp
	load    35($sp), $ra
	store   $i1, 35($sp)
	li      0, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_create_float_array
	sub     $sp, 37, $sp
	load    36($sp), $ra
	mov     $i1, $i2
	store   $i2, 36($sp)
	li      0, $i1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      0, $i2
	mov     $hp, $i3
	add     $hp, 2, $hp
	store   $i1, 1($i3)
	load    36($sp), $i1
	store   $i1, 0($i3)
	mov     $i3, $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	store   $i1, 37($sp)
	li      0, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_float_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	store   $i1, 38($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_create_float_array
	sub     $sp, 40, $sp
	load    39($sp), $ra
	store   $i1, 39($sp)
	li      60, $i1
	load    38($sp), $i2
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_create_array
	sub     $sp, 41, $sp
	load    40($sp), $ra
	store   $i1, 40($sp)
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    39($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	store   $i1, 41($sp)
	li      0, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     min_caml_create_float_array
	sub     $sp, 43, $sp
	load    42($sp), $ra
	mov     $i1, $i2
	store   $i2, 42($sp)
	li      0, $i1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_create_array
	sub     $sp, 44, $sp
	load    43($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    42($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	li      180, $i2
	li      0, $i3
	li      l.14001, $i4
	load    0($i4), $f1
	mov     $hp, $i4
	add     $hp, 3, $hp
	store   $f1, 2($i4)
	store   $i1, 1($i4)
	store   $i3, 0($i4)
	mov     $i4, $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_create_array
	sub     $sp, 44, $sp
	load    43($sp), $ra
	store   $i1, 43($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 44($sp)
	add     $sp, 45, $sp
	jal     min_caml_create_array
	sub     $sp, 45, $sp
	load    44($sp), $ra
	store   $i1, 44($sp)
	mov     $hp, $i1
	store   $i1, 45($sp)
	add     $hp, 13, $hp
	li      read_screen_settings.2917, $i2
	store   $i2, 0($i1)
	load    11($sp), $i2
	store   $i2, 12($i1)
	load    6($sp), $i2
	store   $i2, 11($i1)
	load    34($sp), $i3
	store   $i3, 10($i1)
	load    33($sp), $i3
	store   $i3, 9($i1)
	load    32($sp), $i3
	store   $i3, 8($i1)
	load    10($sp), $i3
	store   $i3, 7($i1)
	load    2($sp), $f1
	store   $f1, 6($i1)
	load    1($sp), $f2
	store   $f2, 5($i1)
	load    0($sp), $f3
	store   $f3, 4($i1)
	load    7($sp), $i3
	store   $i3, 3($i1)
	load    3($sp), $i4
	store   $i4, 2($i1)
	load    4($sp), $i5
	store   $i5, 1($i1)
	mov     $hp, $i1
	store   $i1, 46($sp)
	add     $hp, 10, $hp
	li      read_light.2919, $i6
	store   $i6, 0($i1)
	store   $i2, 9($i1)
	store   $f1, 8($i1)
	store   $f2, 7($i1)
	store   $f3, 6($i1)
	load    12($sp), $i6
	store   $i6, 5($i1)
	store   $i3, 4($i1)
	store   $i4, 3($i1)
	store   $i5, 2($i1)
	load    13($sp), $i7
	store   $i7, 1($i1)
	mov     $hp, $i1
	add     $hp, 8, $hp
	li      rotate_quadratic_matrix.2921, $i7
	store   $i7, 0($i1)
	store   $i2, 7($i1)
	store   $f1, 6($i1)
	store   $f2, 5($i1)
	store   $f3, 4($i1)
	store   $i3, 3($i1)
	store   $i4, 2($i1)
	store   $i5, 1($i1)
	mov     $hp, $i2
	store   $i2, 47($sp)
	add     $hp, 3, $hp
	li      read_nth_object.2924, $i3
	store   $i3, 0($i2)
	store   $i1, 2($i2)
	load    9($sp), $i1
	store   $i1, 1($i2)
	mov     $hp, $i3
	store   $i3, 48($sp)
	add     $hp, 3, $hp
	li      read_object.2926, $i4
	store   $i4, 0($i3)
	store   $i2, 2($i3)
	load    8($sp), $i2
	store   $i2, 1($i3)
	mov     $hp, $i2
	store   $i2, 49($sp)
	add     $hp, 2, $hp
	li      read_and_network.2934, $i3
	store   $i3, 0($i2)
	load    15($sp), $i3
	store   $i3, 1($i2)
	mov     $hp, $i2
	store   $i2, 50($sp)
	add     $hp, 2, $hp
	li      solver_rect_surface.2938, $i4
	store   $i4, 0($i2)
	load    18($sp), $i4
	store   $i4, 1($i2)
	mov     $hp, $i5
	store   $i5, 51($sp)
	add     $hp, 2, $hp
	li      solver_surface.2953, $i7
	store   $i7, 0($i5)
	store   $i4, 1($i5)
	mov     $hp, $i5
	store   $i5, 52($sp)
	add     $hp, 2, $hp
	li      solver_second.2972, $i7
	store   $i7, 0($i5)
	store   $i4, 1($i5)
	mov     $hp, $i7
	store   $i7, 53($sp)
	add     $hp, 5, $hp
	li      solver.2978, $i8
	store   $i8, 0($i7)
	store   $i5, 4($i7)
	store   $i2, 3($i7)
	store   $i4, 2($i7)
	store   $i1, 1($i7)
	mov     $hp, $i2
	store   $i2, 54($sp)
	add     $hp, 2, $hp
	li      solver_rect_fast.2982, $i5
	store   $i5, 0($i2)
	store   $i4, 1($i2)
	mov     $hp, $i5
	add     $hp, 2, $hp
	li      solver_second_fast.2995, $i7
	store   $i7, 0($i5)
	store   $i4, 1($i5)
	mov     $hp, $i7
	store   $i7, 55($sp)
	add     $hp, 2, $hp
	li      solver_second_fast2.3012, $i8
	store   $i8, 0($i7)
	store   $i4, 1($i7)
	mov     $hp, $i8
	store   $i8, 56($sp)
	add     $hp, 5, $hp
	li      solver_fast2.3019, $i9
	store   $i9, 0($i8)
	store   $i7, 4($i8)
	store   $i2, 3($i8)
	store   $i4, 2($i8)
	store   $i1, 1($i8)
	mov     $hp, $i7
	store   $i7, 57($sp)
	add     $hp, 2, $hp
	li      iter_setup_dirvec_constants.3031, $i8
	store   $i8, 0($i7)
	store   $i1, 1($i7)
	mov     $hp, $i7
	store   $i7, 58($sp)
	add     $hp, 2, $hp
	li      setup_startp_constants.3036, $i8
	store   $i8, 0($i7)
	store   $i1, 1($i7)
	mov     $hp, $i7
	store   $i7, 59($sp)
	add     $hp, 2, $hp
	li      check_all_inside.3061, $i8
	store   $i8, 0($i7)
	store   $i1, 1($i7)
	mov     $hp, $i8
	add     $hp, 10, $hp
	li      shadow_check_and_group.3067, $i9
	store   $i9, 0($i8)
	load    39($sp), $i9
	store   $i9, 9($i8)
	store   $i5, 8($i8)
	store   $i2, 7($i8)
	store   $i4, 6($i8)
	store   $i1, 5($i8)
	store   $i6, 4($i8)
	load    21($sp), $i6
	store   $i6, 3($i8)
	load    40($sp), $i10
	store   $i10, 2($i8)
	store   $i7, 1($i8)
	mov     $hp, $i7
	add     $hp, 3, $hp
	li      shadow_check_one_or_group.3070, $i11
	store   $i11, 0($i7)
	store   $i8, 2($i7)
	store   $i3, 1($i7)
	mov     $hp, $i3
	store   $i3, 60($sp)
	add     $hp, 11, $hp
	li      shadow_check_one_or_matrix.3073, $i11
	store   $i11, 0($i3)
	store   $i9, 10($i3)
	store   $i5, 9($i3)
	store   $i2, 8($i3)
	store   $i4, 7($i3)
	store   $i7, 6($i3)
	store   $i8, 5($i3)
	store   $i1, 4($i3)
	store   $i6, 3($i3)
	store   $i10, 2($i3)
	load    15($sp), $i2
	store   $i2, 1($i3)
	mov     $hp, $i3
	add     $hp, 12, $hp
	li      solve_each_element.3076, $i5
	store   $i5, 0($i3)
	load    20($sp), $i5
	store   $i5, 11($i3)
	load    30($sp), $i7
	store   $i7, 10($i3)
	load    51($sp), $i8
	store   $i8, 9($i3)
	load    52($sp), $i9
	store   $i9, 8($i3)
	load    50($sp), $i10
	store   $i10, 7($i3)
	store   $i4, 6($i3)
	store   $i1, 5($i3)
	load    19($sp), $i11
	store   $i11, 4($i3)
	store   $i6, 3($i3)
	load    22($sp), $i6
	store   $i6, 2($i3)
	load    59($sp), $i6
	store   $i6, 1($i3)
	mov     $hp, $i6
	add     $hp, 3, $hp
	li      solve_one_or_network.3080, $i11
	store   $i11, 0($i6)
	store   $i3, 2($i6)
	store   $i2, 1($i6)
	mov     $hp, $i2
	store   $i2, 61($sp)
	add     $hp, 12, $hp
	li      trace_or_matrix.3084, $i11
	store   $i11, 0($i2)
	store   $i5, 11($i2)
	store   $i7, 10($i2)
	store   $i8, 9($i2)
	store   $i9, 8($i2)
	store   $i10, 7($i2)
	store   $i4, 6($i2)
	load    53($sp), $i7
	store   $i7, 5($i2)
	store   $i6, 4($i2)
	store   $i3, 3($i2)
	store   $i1, 2($i2)
	load    15($sp), $i3
	store   $i3, 1($i2)
	mov     $hp, $i2
	add     $hp, 11, $hp
	li      solve_each_element_fast.3090, $i6
	store   $i6, 0($i2)
	store   $i5, 10($i2)
	load    31($sp), $i6
	store   $i6, 9($i2)
	load    55($sp), $i6
	store   $i6, 8($i2)
	load    54($sp), $i7
	store   $i7, 7($i2)
	store   $i4, 6($i2)
	store   $i1, 5($i2)
	load    19($sp), $i8
	store   $i8, 4($i2)
	load    21($sp), $i8
	store   $i8, 3($i2)
	load    22($sp), $i9
	store   $i9, 2($i2)
	load    59($sp), $i9
	store   $i9, 1($i2)
	mov     $hp, $i9
	add     $hp, 3, $hp
	li      solve_one_or_network_fast.3094, $i10
	store   $i10, 0($i9)
	store   $i2, 2($i9)
	store   $i3, 1($i9)
	mov     $hp, $i10
	store   $i10, 62($sp)
	add     $hp, 10, $hp
	li      trace_or_matrix_fast.3098, $i11
	store   $i11, 0($i10)
	store   $i5, 9($i10)
	store   $i6, 8($i10)
	store   $i7, 7($i10)
	load    56($sp), $i6
	store   $i6, 6($i10)
	store   $i4, 5($i10)
	store   $i9, 4($i10)
	store   $i2, 3($i10)
	store   $i1, 2($i10)
	store   $i3, 1($i10)
	mov     $hp, $i7
	store   $i7, 63($sp)
	add     $hp, 9, $hp
	li      judge_intersection_fast.3102, $i11
	store   $i11, 0($i7)
	store   $i10, 8($i7)
	store   $i5, 7($i7)
	store   $i6, 6($i7)
	store   $i4, 5($i7)
	store   $i9, 4($i7)
	store   $i2, 3($i7)
	load    17($sp), $i2
	store   $i2, 2($i7)
	store   $i3, 1($i7)
	mov     $hp, $i3
	store   $i3, 64($sp)
	add     $hp, 3, $hp
	li      get_nvector_second.3108, $i4
	store   $i4, 0($i3)
	load    23($sp), $i4
	store   $i4, 2($i3)
	store   $i8, 1($i3)
	mov     $hp, $i6
	store   $i6, 65($sp)
	add     $hp, 4, $hp
	li      get_nvector.3110, $i7
	store   $i7, 0($i6)
	store   $i4, 3($i6)
	load    19($sp), $i7
	store   $i7, 2($i6)
	store   $i3, 1($i6)
	mov     $hp, $i3
	add     $hp, 10, $hp
	li      utexture.3113, $i6
	store   $i6, 0($i3)
	load    24($sp), $i6
	store   $i6, 9($i3)
	load    6($sp), $i8
	store   $i8, 8($i3)
	store   $f1, 7($i3)
	store   $f2, 6($i3)
	store   $f3, 5($i3)
	load    7($sp), $i8
	store   $i8, 4($i3)
	load    3($sp), $i8
	store   $i8, 3($i3)
	load    4($sp), $i8
	store   $i8, 2($i3)
	load    5($sp), $i8
	store   $i8, 1($i3)
	mov     $hp, $i8
	add     $hp, 11, $hp
	li      trace_reflections.3120, $i9
	store   $i9, 0($i8)
	store   $i10, 10($i8)
	store   $i5, 9($i8)
	store   $i6, 8($i8)
	load    60($sp), $i9
	store   $i9, 7($i8)
	load    26($sp), $i10
	store   $i10, 6($i8)
	load    43($sp), $i11
	store   $i11, 5($i8)
	store   $i2, 4($i8)
	store   $i4, 3($i8)
	store   $i7, 2($i8)
	load    22($sp), $i7
	store   $i7, 1($i8)
	mov     $hp, $i7
	store   $i7, 66($sp)
	add     $hp, 22, $hp
	li      trace_ray.3125, $i11
	store   $i11, 0($i7)
	store   $i3, 21($i7)
	store   $i8, 20($i7)
	load    61($sp), $i8
	store   $i8, 19($i7)
	store   $i5, 18($i7)
	store   $i6, 17($i7)
	load    31($sp), $i8
	store   $i8, 16($i7)
	load    30($sp), $i8
	store   $i8, 15($i7)
	store   $i9, 14($i7)
	load    58($sp), $i8
	store   $i8, 13($i7)
	store   $i10, 12($i7)
	store   $i2, 11($i7)
	store   $i1, 10($i7)
	store   $i4, 9($i7)
	load    44($sp), $i8
	store   $i8, 8($i7)
	load    8($sp), $i8
	store   $i8, 7($i7)
	load    12($sp), $i8
	store   $i8, 6($i7)
	load    19($sp), $i10
	store   $i10, 5($i7)
	load    21($sp), $i11
	store   $i11, 4($i7)
	load    22($sp), $i11
	store   $i11, 3($i7)
	load    64($sp), $i11
	store   $i11, 2($i7)
	load    13($sp), $i11
	store   $i11, 1($i7)
	mov     $hp, $i7
	add     $hp, 15, $hp
	li      trace_diffuse_ray.3131, $i11
	store   $i11, 0($i7)
	store   $i3, 14($i7)
	load    62($sp), $i11
	store   $i11, 13($i7)
	store   $i5, 12($i7)
	store   $i6, 11($i7)
	store   $i9, 10($i7)
	store   $i2, 9($i7)
	store   $i1, 8($i7)
	store   $i4, 7($i7)
	store   $i8, 6($i7)
	store   $i10, 5($i7)
	load    21($sp), $i5
	store   $i5, 4($i7)
	load    22($sp), $i10
	store   $i10, 3($i7)
	load    64($sp), $i10
	store   $i10, 2($i7)
	load    25($sp), $i10
	store   $i10, 1($i7)
	mov     $hp, $i10
	store   $i10, 67($sp)
	add     $hp, 14, $hp
	li      iter_trace_diffuse_rays.3134, $i11
	store   $i11, 0($i10)
	store   $i3, 13($i10)
	store   $i7, 12($i10)
	store   $i6, 11($i10)
	store   $i9, 10($i10)
	store   $i2, 9($i10)
	store   $i1, 8($i10)
	store   $i4, 7($i10)
	store   $i8, 6($i10)
	load    63($sp), $i1
	store   $i1, 5($i10)
	store   $i5, 4($i10)
	load    22($sp), $i1
	store   $i1, 3($i10)
	load    65($sp), $i1
	store   $i1, 2($i10)
	load    25($sp), $i1
	store   $i1, 1($i10)
	mov     $hp, $i2
	add     $hp, 6, $hp
	li      trace_diffuse_ray_80percent.3143, $i3
	store   $i3, 0($i2)
	load    31($sp), $i3
	store   $i3, 5($i2)
	load    58($sp), $i4
	store   $i4, 4($i2)
	load    8($sp), $i5
	store   $i5, 3($i2)
	store   $i10, 2($i2)
	load    37($sp), $i6
	store   $i6, 1($i2)
	mov     $hp, $i8
	store   $i8, 68($sp)
	add     $hp, 9, $hp
	li      calc_diffuse_using_1point.3147, $i9
	store   $i9, 0($i8)
	store   $i7, 8($i8)
	store   $i3, 7($i8)
	store   $i4, 6($i8)
	load    26($sp), $i9
	store   $i9, 5($i8)
	store   $i5, 4($i8)
	store   $i10, 3($i8)
	store   $i6, 2($i8)
	store   $i1, 1($i8)
	mov     $hp, $i6
	store   $i6, 69($sp)
	add     $hp, 3, $hp
	li      calc_diffuse_using_5points.3150, $i10
	store   $i10, 0($i6)
	store   $i9, 2($i6)
	store   $i1, 1($i6)
	mov     $hp, $i10
	store   $i10, 70($sp)
	add     $hp, 5, $hp
	li      do_without_neighbors.3156, $i11
	store   $i11, 0($i10)
	store   $i2, 4($i10)
	store   $i9, 3($i10)
	store   $i1, 2($i10)
	store   $i8, 1($i10)
	mov     $hp, $i2
	store   $i2, 71($sp)
	add     $hp, 4, $hp
	li      try_exploit_neighbors.3172, $i11
	store   $i11, 0($i2)
	store   $i10, 3($i2)
	store   $i6, 2($i2)
	store   $i8, 1($i2)
	mov     $hp, $i2
	store   $i2, 72($sp)
	add     $hp, 2, $hp
	li      write_rgb.3183, $i6
	store   $i6, 0($i2)
	store   $i9, 1($i2)
	mov     $hp, $i2
	add     $hp, 8, $hp
	li      pretrace_diffuse_rays.3185, $i6
	store   $i6, 0($i2)
	store   $i7, 7($i2)
	store   $i3, 6($i2)
	store   $i4, 5($i2)
	store   $i5, 4($i2)
	load    67($sp), $i6
	store   $i6, 3($i2)
	load    37($sp), $i8
	store   $i8, 2($i2)
	store   $i1, 1($i2)
	mov     $hp, $i10
	add     $hp, 17, $hp
	li      pretrace_pixels.3188, $i11
	store   $i11, 0($i10)
	load    11($sp), $i11
	store   $i11, 16($i10)
	load    66($sp), $i11
	store   $i11, 15($i10)
	store   $i7, 14($i10)
	store   $i3, 13($i10)
	load    30($sp), $i3
	store   $i3, 12($i10)
	store   $i4, 11($i10)
	load    32($sp), $i3
	store   $i3, 10($i10)
	load    29($sp), $i3
	store   $i3, 9($i10)
	store   $i9, 8($i10)
	load    35($sp), $i4
	store   $i4, 7($i10)
	store   $i2, 6($i10)
	store   $i5, 5($i10)
	store   $i6, 4($i10)
	load    28($sp), $i2
	store   $i2, 3($i10)
	store   $i8, 2($i10)
	store   $i1, 1($i10)
	mov     $hp, $i1
	store   $i1, 73($sp)
	add     $hp, 7, $hp
	li      pretrace_line.3195, $i4
	store   $i4, 0($i1)
	load    34($sp), $i4
	store   $i4, 6($i1)
	load    33($sp), $i4
	store   $i4, 5($i1)
	store   $i3, 4($i1)
	store   $i10, 3($i1)
	load    27($sp), $i3
	store   $i3, 2($i1)
	store   $i2, 1($i1)
	mov     $hp, $i2
	add     $hp, 8, $hp
	li      scan_pixel.3199, $i4
	store   $i4, 0($i2)
	load    72($sp), $i4
	store   $i4, 7($i2)
	load    71($sp), $i6
	store   $i6, 6($i2)
	store   $i9, 5($i2)
	store   $i3, 4($i2)
	load    70($sp), $i7
	store   $i7, 3($i2)
	load    69($sp), $i10
	store   $i10, 2($i2)
	load    68($sp), $i10
	store   $i10, 1($i2)
	mov     $hp, $i10
	add     $hp, 8, $hp
	li      scan_line.3205, $i11
	store   $i11, 0($i10)
	store   $i4, 7($i10)
	store   $i6, 6($i10)
	store   $i2, 5($i10)
	store   $i9, 4($i10)
	store   $i1, 3($i10)
	store   $i3, 2($i10)
	store   $i7, 1($i10)
	mov     $hp, $i1
	add     $hp, 10, $hp
	li      calc_dirvec.3225, $i3
	store   $i3, 0($i1)
	load    6($sp), $i3
	store   $i3, 9($i1)
	store   $f1, 8($i1)
	store   $f2, 7($i1)
	store   $f3, 6($i1)
	store   $i8, 5($i1)
	load    7($sp), $i3
	store   $i3, 4($i1)
	load    3($sp), $i3
	store   $i3, 3($i1)
	load    4($sp), $i3
	store   $i3, 2($i1)
	load    5($sp), $i3
	store   $i3, 1($i1)
	mov     $hp, $i3
	add     $hp, 2, $hp
	li      calc_dirvecs.3233, $i4
	store   $i4, 0($i3)
	store   $i1, 1($i3)
	mov     $hp, $i1
	store   $i1, 74($sp)
	add     $hp, 2, $hp
	li      calc_dirvec_rows.3238, $i4
	store   $i4, 0($i1)
	store   $i3, 1($i1)
	mov     $hp, $i1
	add     $hp, 2, $hp
	li      create_dirvec_elements.3244, $i3
	store   $i3, 0($i1)
	store   $i5, 1($i1)
	mov     $hp, $i3
	store   $i3, 75($sp)
	add     $hp, 4, $hp
	li      create_dirvecs.3247, $i4
	store   $i4, 0($i3)
	store   $i5, 3($i3)
	store   $i8, 2($i3)
	store   $i1, 1($i3)
	mov     $hp, $i1
	store   $i1, 76($sp)
	add     $hp, 4, $hp
	li      init_dirvec_constants.3249, $i3
	store   $i3, 0($i1)
	load    9($sp), $i3
	store   $i3, 3($i1)
	store   $i5, 2($i1)
	load    57($sp), $i4
	store   $i4, 1($i1)
	mov     $hp, $i6
	store   $i6, 77($sp)
	add     $hp, 6, $hp
	li      init_vecset_constants.3252, $i7
	store   $i7, 0($i6)
	store   $i3, 5($i6)
	store   $i5, 4($i6)
	store   $i4, 3($i6)
	store   $i1, 2($i6)
	store   $i8, 1($i6)
	mov     $hp, $i1
	add     $hp, 7, $hp
	li      setup_rect_reflection.3263, $i6
	store   $i6, 0($i1)
	load    43($sp), $i6
	store   $i6, 6($i1)
	store   $i3, 5($i1)
	load    44($sp), $i7
	store   $i7, 4($i1)
	store   $i5, 3($i1)
	load    12($sp), $i8
	store   $i8, 2($i1)
	store   $i4, 1($i1)
	mov     $hp, $i9
	add     $hp, 7, $hp
	li      setup_surface_reflection.3266, $i11
	store   $i11, 0($i9)
	store   $i6, 6($i9)
	store   $i3, 5($i9)
	store   $i7, 4($i9)
	store   $i5, 3($i9)
	store   $i8, 2($i9)
	store   $i4, 1($i9)
	mov     $hp, $i11
	add     $hp, 26, $hp
	li      rt.3271, $i6
	store   $i6, 0($i11)
	load    39($sp), $i6
	store   $i6, 25($i11)
	store   $i9, 24($i11)
	store   $i1, 23($i11)
	store   $i2, 22($i11)
	load    29($sp), $i1
	store   $i1, 21($i11)
	store   $i10, 20($i11)
	load    45($sp), $i1
	store   $i1, 19($i11)
	load    48($sp), $i1
	store   $i1, 18($i11)
	load    47($sp), $i1
	store   $i1, 17($i11)
	load    46($sp), $i1
	store   $i1, 16($i11)
	load    49($sp), $i1
	store   $i1, 15($i11)
	load    73($sp), $i1
	store   $i1, 14($i11)
	load    17($sp), $i1
	store   $i1, 13($i11)
	store   $i3, 12($i11)
	store   $i5, 11($i11)
	load    41($sp), $i1
	store   $i1, 10($i11)
	store   $i8, 9($i11)
	store   $i4, 8($i11)
	load    77($sp), $i1
	store   $i1, 7($i11)
	load    76($sp), $i1
	store   $i1, 6($i11)
	load    27($sp), $i1
	store   $i1, 5($i11)
	load    28($sp), $i1
	store   $i1, 4($i11)
	load    37($sp), $i1
	store   $i1, 3($i11)
	load    75($sp), $i1
	store   $i1, 2($i11)
	load    74($sp), $i1
	store   $i1, 1($i11)
	li      128, $i1
	li      128, $i2
	store   $ra, 78($sp)
	load    0($i11), $i10
	li      cls.24164, $ra
	add     $sp, 79, $sp
	jr      $i10
cls.24164:
	sub     $sp, 79, $sp
	load    78($sp), $ra
	li      0, $i12
	halt
cordic_rec.6623:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.24165
	mov     $f2, $f1
	ret
be_else.24165:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.24166
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.24167
	ret
be_else.24167:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.24168
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24168:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24166:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.24169
	ret
be_else.24169:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.24170
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24170:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_sin.2737:
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6623, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24171
	li      1, $i1
	li      l.14003, $i2
	load    0($i2), $f1
	li      l.14008, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.13994, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.24171:
	li      1, $i1
	li      l.14003, $i2
	load    0($i2), $f1
	li      l.14003, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.13994, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
cordic_rec.6591:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.24172
	ret
be_else.24172:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.24173
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.24174
	mov     $f6, $f1
	ret
be_else.24174:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.24175
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24175:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24173:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.24176
	mov     $f6, $f1
	ret
be_else.24176:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.24177
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24177:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.13994, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_cos.2739:
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6591, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24178
	li      1, $i1
	li      l.14003, $i2
	load    0($i2), $f1
	li      l.14008, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.13994, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.24178:
	li      1, $i1
	li      l.14003, $i2
	load    0($i2), $f1
	li      l.14003, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.13994, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
cordic_rec.6558:
	load    1($i11), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.24179
	mov     $f3, $f1
	ret
be_else.24179:
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f2, $f5, $i12
	bg      $i12, ble_else.24180
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fsub    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fsub    $f3, $f1, $f3
	li      l.13994, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24180:
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fadd    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fadd    $f3, $f1, $f3
	li      l.13994, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
cordic_atan.2741:
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 2, $hp
	li      cordic_rec.6558, $i2
	store   $i2, 0($i11)
	store   $i1, 1($i11)
	li      0, $i1
	li      l.14035, $i2
	load    0($i2), $f2
	li      l.14001, $i2
	load    0($i2), $f3
	li      l.14035, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
sin.2743:
	load    4($i11), $f2
	load    3($i11), $f3
	load    2($i11), $f4
	load    1($i11), $i1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24181
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24182
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24183
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24184
	fsub    $f1, $f3, $f1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24185
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24186
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24187
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24188
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24188:
	fsub    $f3, $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24189, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24189:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.24187:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24186:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24185:
	fneg    $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24190, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24190:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.24184:
	fsub    $f3, $f1, $f1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24191
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24193
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24195
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24197
	fsub    $f1, $f3, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24199, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24199:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       ble_cont.24198
ble_else.24197:
	fsub    $f3, $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24200, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24200:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.24198:
	b       ble_cont.24196
ble_else.24195:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24201, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24201:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.24196:
	b       ble_cont.24194
ble_else.24193:
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24202, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24202:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.24194:
	b       ble_cont.24192
ble_else.24191:
	fneg    $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24203, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24203:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.24192:
	fneg    $f1, $f1
	ret
ble_else.24183:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24182:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24181:
	fneg    $f1, $f1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24204
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24206
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24208
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24210
	fsub    $f1, $f3, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24212, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24212:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       ble_cont.24211
ble_else.24210:
	fsub    $f3, $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24213, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24213:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.24211:
	b       ble_cont.24209
ble_else.24208:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24214, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24214:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.24209:
	b       ble_cont.24207
ble_else.24206:
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24215, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24215:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.24207:
	b       ble_cont.24205
ble_else.24204:
	fneg    $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24216, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24216:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.24205:
	fneg    $f1, $f1
	ret
cos.2745:
	load    4($i11), $f2
	load    3($i11), $f3
	load    2($i11), $f4
	load    1($i11), $i1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24217
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24218
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24219
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24220
	fsub    $f1, $f3, $f1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24221
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24222
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24223
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24224
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24224:
	fsub    $f3, $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24223:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24225, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24225:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.24222:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24221:
	fneg    $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24220:
	fsub    $f3, $f1, $f1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24226
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24227
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24228
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24229
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24229:
	fsub    $f3, $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24228:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24230, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24230:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.24227:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24226:
	fneg    $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24219:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24231, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24231:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.24218:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24217:
	fneg    $f1, $f1
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.24232
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24233
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24234
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.24235
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24235:
	fsub    $f3, $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.24234:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.24236, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.24236:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.24233:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.24232:
	fneg    $f1, $f1
	load    0($i11), $i10
	jr      $i10
get_sqrt_init_rec.6532.10574:
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24237
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.24237:
	li      l.14050, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24238
	li      l.14050, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24239
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.24239:
	li      l.14050, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24240
	li      l.14050, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24241
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.24241:
	li      l.14050, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24242
	li      l.14050, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24243
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.24243:
	li      l.14050, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24244
	li      l.14050, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	b       get_sqrt_init_rec.6532.10574
ble_else.24244:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.24242:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.24240:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.24238:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
sqrt.2751:
	li      l.14035, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24245
	store   $f1, 0($sp)
	li      l.14050, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24246
	li      l.14050, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.14050, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24248
	li      l.14050, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.14050, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24250
	li      l.14050, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      3, $i1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     get_sqrt_init_rec.6532.10574
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       ble_cont.24251
ble_else.24250:
	li      min_caml_rsqrt_table, $i1
	load    2($i1), $f1
ble_cont.24251:
	b       ble_cont.24249
ble_else.24248:
	li      min_caml_rsqrt_table, $i1
	load    1($i1), $f1
ble_cont.24249:
	b       ble_cont.24247
ble_else.24246:
	li      min_caml_rsqrt_table, $i1
	load    0($i1), $f1
ble_cont.24247:
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	load    0($sp), $f4
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.13994, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.14077, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	fmul    $f1, $f4, $f1
	ret
ble_else.24245:
	li      l.13994, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f1, $f15, $f3
	fadd    $f1, $f3, $f3
	fmul    $f2, $f3, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	fadd    $f2, $f1, $f1
	fmul    $f3, $f1, $f1
	ret
vecunit_sgn.2816:
	store   $i1, 0($sp)
	store   $i2, 1($sp)
	load    0($i1), $f1
	fmul    $f1, $f1, $f1
	load    1($i1), $f2
	fmul    $f2, $f2, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	fmul    $f2, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     sqrt.2751
	sub     $sp, 3, $sp
	load    2($sp), $ra
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24252
	li      1, $i1
	b       be_cont.24253
be_else.24252:
	li      0, $i1
be_cont.24253:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24254
	load    1($sp), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24256
	li      l.14035, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.24257
be_else.24256:
	li      l.14099, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
be_cont.24257:
	b       be_cont.24255
be_else.24254:
	li      l.14035, $i1
	load    0($i1), $f1
be_cont.24255:
	load    0($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 2($i1)
	ret
vecaccumv.2840:
	load    0($i1), $f1
	load    0($i2), $f2
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i1)
	load    1($i1), $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i1)
	load    2($i1), $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i1)
	ret
read_screen_settings.2917:
	load    12($i11), $i1
	store   $i1, 0($sp)
	load    11($i11), $i1
	store   $i1, 1($sp)
	load    10($i11), $i1
	store   $i1, 2($sp)
	load    9($i11), $i1
	store   $i1, 3($sp)
	load    8($i11), $i1
	store   $i1, 4($sp)
	load    7($i11), $i1
	store   $i1, 5($sp)
	load    6($i11), $f1
	store   $f1, 6($sp)
	load    5($i11), $f1
	store   $f1, 7($sp)
	load    4($i11), $f1
	store   $f1, 8($sp)
	load    3($i11), $i1
	store   $i1, 9($sp)
	load    2($i11), $i1
	store   $i1, 10($sp)
	load    1($i11), $i1
	store   $i1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    5($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    5($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    5($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      l.14102, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 12($sp)
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24260
	load    6($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24262
	load    8($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24264
	load    7($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24266
	fsub    $f1, $f2, $f1
	load    9($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24268, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24268:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	b       ble_cont.24267
ble_else.24266:
	fsub    $f2, $f1, $f1
	load    9($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24269, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24269:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.24267:
	b       ble_cont.24265
ble_else.24264:
	fsub    $f2, $f1, $f1
	load    11($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24270, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24270:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	fneg    $f1, $f1
ble_cont.24265:
	b       ble_cont.24263
ble_else.24262:
	load    11($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24271, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24271:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.24263:
	b       ble_cont.24261
ble_else.24260:
	fneg    $f1, $f1
	load    9($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24272, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24272:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.24261:
	store   $f1, 13($sp)
	li      l.14001, $i1
	load    0($i1), $f1
	load    12($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24273
	load    6($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24275
	load    8($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24277
	load    7($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24279
	fsub    $f2, $f1, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24281, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24281:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       ble_cont.24280
ble_else.24279:
	fsub    $f1, $f2, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24282, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24282:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.24280:
	b       ble_cont.24278
ble_else.24277:
	fsub    $f1, $f2, $f1
	load    10($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24283, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24283:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.24278:
	b       ble_cont.24276
ble_else.24275:
	load    10($sp), $i11
	mov     $f2, $f1
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24284, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24284:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.24276:
	b       ble_cont.24274
ble_else.24273:
	fneg    $f2, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24285, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24285:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.24274:
	store   $f1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_read_float
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      l.14102, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 15($sp)
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24286
	load    6($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24288
	load    8($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24290
	load    7($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24292
	fsub    $f1, $f2, $f1
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24294, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24294:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	b       ble_cont.24293
ble_else.24292:
	fsub    $f2, $f1, $f1
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24295, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24295:
	sub     $sp, 17, $sp
	load    16($sp), $ra
ble_cont.24293:
	b       ble_cont.24291
ble_else.24290:
	fsub    $f2, $f1, $f1
	load    11($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24296, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24296:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	fneg    $f1, $f1
ble_cont.24291:
	b       ble_cont.24289
ble_else.24288:
	load    11($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24297, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24297:
	sub     $sp, 17, $sp
	load    16($sp), $ra
ble_cont.24289:
	b       ble_cont.24287
ble_else.24286:
	fneg    $f1, $f1
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24298, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24298:
	sub     $sp, 17, $sp
	load    16($sp), $ra
ble_cont.24287:
	store   $f1, 16($sp)
	li      l.14001, $i1
	load    0($i1), $f1
	load    15($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24299
	load    6($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24301
	load    8($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24303
	load    7($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24305
	fsub    $f2, $f1, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.24307, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.24307:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       ble_cont.24306
ble_else.24305:
	fsub    $f1, $f2, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.24308, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.24308:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	fneg    $f1, $f1
ble_cont.24306:
	b       ble_cont.24304
ble_else.24303:
	fsub    $f1, $f2, $f1
	load    10($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.24309, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.24309:
	sub     $sp, 18, $sp
	load    17($sp), $ra
ble_cont.24304:
	b       ble_cont.24302
ble_else.24301:
	load    10($sp), $i11
	mov     $f2, $f1
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.24310, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.24310:
	sub     $sp, 18, $sp
	load    17($sp), $ra
ble_cont.24302:
	b       ble_cont.24300
ble_else.24299:
	fneg    $f2, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.24311, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.24311:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	fneg    $f1, $f1
ble_cont.24300:
	load    13($sp), $f2
	fmul    $f2, $f1, $f3
	li      l.14109, $i1
	load    0($i1), $f4
	fmul    $f3, $f4, $f3
	load    2($sp), $i1
	store   $f3, 0($i1)
	li      l.14111, $i2
	load    0($i2), $f3
	load    14($sp), $f4
	fmul    $f4, $f3, $f3
	store   $f3, 1($i1)
	load    16($sp), $f3
	fmul    $f2, $f3, $f5
	li      l.14109, $i2
	load    0($i2), $f6
	fmul    $f5, $f6, $f5
	store   $f5, 2($i1)
	load    4($sp), $i2
	store   $f3, 0($i2)
	li      l.14001, $i3
	load    0($i3), $f5
	store   $f5, 1($i2)
	fneg    $f1, $f5
	store   $f5, 2($i2)
	fneg    $f4, $f5
	fmul    $f5, $f1, $f1
	load    3($sp), $i2
	store   $f1, 0($i2)
	fneg    $f2, $f1
	store   $f1, 1($i2)
	fneg    $f4, $f1
	fmul    $f1, $f3, $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	load    0($sp), $i3
	store   $f1, 0($i3)
	load    1($i2), $f1
	load    1($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 1($i3)
	load    2($i2), $f1
	load    2($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 2($i3)
	ret
read_light.2919:
	load    9($i11), $i1
	store   $i1, 0($sp)
	load    8($i11), $f1
	store   $f1, 1($sp)
	load    7($i11), $f1
	store   $f1, 2($sp)
	load    6($i11), $f1
	store   $f1, 3($sp)
	load    5($i11), $i1
	store   $i1, 4($sp)
	load    4($i11), $i1
	store   $i1, 5($sp)
	load    3($i11), $i1
	store   $i1, 6($sp)
	load    2($i11), $i1
	store   $i1, 7($sp)
	load    1($i11), $i1
	store   $i1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read_int
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read_float
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      l.14102, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 9($sp)
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24313
	load    1($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24315
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24317
	load    2($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24319
	fsub    $f1, $f2, $f1
	load    0($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24321, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24321:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       ble_cont.24320
ble_else.24319:
	fsub    $f2, $f1, $f1
	load    0($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24322, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24322:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	fneg    $f1, $f1
ble_cont.24320:
	b       ble_cont.24318
ble_else.24317:
	fsub    $f2, $f1, $f1
	load    6($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24323, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24323:
	sub     $sp, 11, $sp
	load    10($sp), $ra
ble_cont.24318:
	b       ble_cont.24316
ble_else.24315:
	load    6($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24324, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24324:
	sub     $sp, 11, $sp
	load    10($sp), $ra
ble_cont.24316:
	b       ble_cont.24314
ble_else.24313:
	fneg    $f1, $f1
	load    0($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24325, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24325:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	fneg    $f1, $f1
ble_cont.24314:
	fneg    $f1, $f1
	load    4($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read_float
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      l.14102, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 10($sp)
	li      l.14001, $i1
	load    0($i1), $f1
	load    9($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24326
	load    1($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24328
	load    3($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24330
	load    2($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24332
	fsub    $f2, $f1, $f1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24334, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24334:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       ble_cont.24333
ble_else.24332:
	fsub    $f1, $f2, $f1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24335, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24335:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.24333:
	b       ble_cont.24331
ble_else.24330:
	fsub    $f1, $f2, $f1
	load    7($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24336, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24336:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	fneg    $f1, $f1
ble_cont.24331:
	b       ble_cont.24329
ble_else.24328:
	load    7($sp), $i11
	mov     $f2, $f1
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24337, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24337:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.24329:
	b       ble_cont.24327
ble_else.24326:
	fneg    $f2, $f1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24338, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24338:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.24327:
	store   $f1, 11($sp)
	li      l.14001, $i1
	load    0($i1), $f1
	load    10($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24339
	load    1($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24341
	load    3($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24343
	load    2($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24345
	fsub    $f2, $f1, $f1
	load    0($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24347, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24347:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	b       ble_cont.24346
ble_else.24345:
	fsub    $f1, $f2, $f1
	load    0($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24348, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24348:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.24346:
	b       ble_cont.24344
ble_else.24343:
	fsub    $f1, $f2, $f1
	load    6($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24349, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24349:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.24344:
	b       ble_cont.24342
ble_else.24341:
	load    6($sp), $i11
	mov     $f2, $f1
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24350, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24350:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.24342:
	b       ble_cont.24340
ble_else.24339:
	fneg    $f2, $f1
	load    0($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24351, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24351:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.24340:
	load    11($sp), $f2
	fmul    $f2, $f1, $f1
	load    4($sp), $i1
	store   $f1, 0($i1)
	li      l.14001, $i1
	load    0($i1), $f1
	load    10($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24352
	load    1($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24354
	load    3($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24356
	load    2($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24358
	fsub    $f2, $f1, $f1
	load    5($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24360, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24360:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	b       ble_cont.24359
ble_else.24358:
	fsub    $f1, $f2, $f1
	load    5($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24361, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24361:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.24359:
	b       ble_cont.24357
ble_else.24356:
	fsub    $f1, $f2, $f1
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24362, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24362:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.24357:
	b       ble_cont.24355
ble_else.24354:
	load    7($sp), $i11
	mov     $f2, $f1
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24363, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24363:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.24355:
	b       ble_cont.24353
ble_else.24352:
	fneg    $f2, $f1
	load    5($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24364, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24364:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.24353:
	load    11($sp), $f2
	fmul    $f2, $f1, $f1
	load    4($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    8($sp), $i1
	store   $f1, 0($i1)
	ret
rotate_quadratic_matrix.2921:
	store   $i1, 0($sp)
	store   $i2, 1($sp)
	load    7($i11), $i1
	store   $i1, 2($sp)
	load    6($i11), $f1
	store   $f1, 3($sp)
	load    5($i11), $f2
	store   $f2, 4($sp)
	load    4($i11), $f3
	store   $f3, 5($sp)
	load    3($i11), $i1
	store   $i1, 6($sp)
	load    2($i11), $i3
	store   $i3, 7($sp)
	load    1($i11), $i11
	store   $i11, 8($sp)
	load    0($i2), $f4
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f4, $i12
	bg      $i12, ble_else.24366
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.24368
	fcmp    $f3, $f4, $i12
	bg      $i12, ble_else.24370
	fcmp    $f2, $f4, $i12
	bg      $i12, ble_else.24372
	fsub    $f4, $f2, $f1
	mov     $i1, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.24374, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.24374:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	b       ble_cont.24373
ble_else.24372:
	fsub    $f2, $f4, $f1
	mov     $i1, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.24375, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.24375:
	sub     $sp, 10, $sp
	load    9($sp), $ra
ble_cont.24373:
	b       ble_cont.24371
ble_else.24370:
	fsub    $f3, $f4, $f1
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.24376, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.24376:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	fneg    $f1, $f1
ble_cont.24371:
	b       ble_cont.24369
ble_else.24368:
	mov     $f4, $f1
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.24377, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.24377:
	sub     $sp, 10, $sp
	load    9($sp), $ra
ble_cont.24369:
	b       ble_cont.24367
ble_else.24366:
	fneg    $f4, $f1
	mov     $i1, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.24378, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.24378:
	sub     $sp, 10, $sp
	load    9($sp), $ra
ble_cont.24367:
	store   $f1, 9($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24379
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24381
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24383
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24385
	fsub    $f1, $f2, $f1
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24387, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24387:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       ble_cont.24386
ble_else.24385:
	fsub    $f2, $f1, $f1
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24388, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24388:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	fneg    $f1, $f1
ble_cont.24386:
	b       ble_cont.24384
ble_else.24383:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24389, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24389:
	sub     $sp, 11, $sp
	load    10($sp), $ra
ble_cont.24384:
	b       ble_cont.24382
ble_else.24381:
	load    7($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24390, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24390:
	sub     $sp, 11, $sp
	load    10($sp), $ra
ble_cont.24382:
	b       ble_cont.24380
ble_else.24379:
	fneg    $f1, $f1
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24391, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24391:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	fneg    $f1, $f1
ble_cont.24380:
	store   $f1, 10($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24392
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24394
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24396
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24398
	fsub    $f1, $f2, $f1
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24400, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24400:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       ble_cont.24399
ble_else.24398:
	fsub    $f2, $f1, $f1
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24401, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24401:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.24399:
	b       ble_cont.24397
ble_else.24396:
	fsub    $f2, $f1, $f1
	load    8($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24402, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24402:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	fneg    $f1, $f1
ble_cont.24397:
	b       ble_cont.24395
ble_else.24394:
	load    8($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24403, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24403:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.24395:
	b       ble_cont.24393
ble_else.24392:
	fneg    $f1, $f1
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24404, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24404:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.24393:
	store   $f1, 11($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24405
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24407
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24409
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24411
	fsub    $f1, $f2, $f1
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24413, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24413:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	b       ble_cont.24412
ble_else.24411:
	fsub    $f2, $f1, $f1
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24414, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24414:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.24412:
	b       ble_cont.24410
ble_else.24409:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24415, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24415:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.24410:
	b       ble_cont.24408
ble_else.24407:
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24416, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24416:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.24408:
	b       ble_cont.24406
ble_else.24405:
	fneg    $f1, $f1
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.24417, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.24417:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.24406:
	store   $f1, 12($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24418
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24420
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24422
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24424
	fsub    $f1, $f2, $f1
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24426, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24426:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	b       ble_cont.24425
ble_else.24424:
	fsub    $f2, $f1, $f1
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24427, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24427:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.24425:
	b       ble_cont.24423
ble_else.24422:
	fsub    $f2, $f1, $f1
	load    8($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24428, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24428:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	fneg    $f1, $f1
ble_cont.24423:
	b       ble_cont.24421
ble_else.24420:
	load    8($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24429, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24429:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.24421:
	b       ble_cont.24419
ble_else.24418:
	fneg    $f1, $f1
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24430, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24430:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.24419:
	store   $f1, 13($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24431
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24433
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24435
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24437
	fsub    $f1, $f2, $f1
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24439, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24439:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       ble_cont.24438
ble_else.24437:
	fsub    $f2, $f1, $f1
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24440, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24440:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.24438:
	b       ble_cont.24436
ble_else.24435:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24441, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24441:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.24436:
	b       ble_cont.24434
ble_else.24433:
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24442, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24442:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.24434:
	b       ble_cont.24432
ble_else.24431:
	fneg    $f1, $f1
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24443, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24443:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.24432:
	load    13($sp), $f2
	load    11($sp), $f3
	fmul    $f3, $f2, $f4
	load    12($sp), $f5
	load    10($sp), $f6
	fmul    $f6, $f5, $f7
	fmul    $f7, $f2, $f7
	load    9($sp), $f8
	fmul    $f8, $f1, $f9
	fsub    $f7, $f9, $f7
	fmul    $f8, $f5, $f9
	fmul    $f9, $f2, $f9
	fmul    $f6, $f1, $f10
	fadd    $f9, $f10, $f9
	fmul    $f3, $f1, $f10
	fmul    $f6, $f5, $f11
	fmul    $f11, $f1, $f11
	fmul    $f8, $f2, $f12
	fadd    $f11, $f12, $f11
	store   $f11, 14($sp)
	fmul    $f8, $f5, $f12
	fmul    $f12, $f1, $f1
	fmul    $f6, $f2, $f2
	fsub    $f1, $f2, $f1
	fneg    $f5, $f2
	fmul    $f6, $f3, $f5
	fmul    $f8, $f3, $f3
	load    0($sp), $i1
	load    0($i1), $f6
	load    1($i1), $f8
	load    2($i1), $f12
	fmul    $f4, $f4, $f13
	fmul    $f6, $f13, $f13
	fmul    $f10, $f10, $f14
	fmul    $f8, $f14, $f14
	fadd    $f13, $f14, $f13
	fmul    $f2, $f2, $f14
	fmul    $f12, $f14, $f14
	fadd    $f13, $f14, $f13
	store   $f13, 0($i1)
	fmul    $f7, $f7, $f13
	fmul    $f6, $f13, $f13
	fmul    $f11, $f11, $f14
	fmul    $f8, $f14, $f14
	fadd    $f13, $f14, $f13
	fmul    $f5, $f5, $f14
	fmul    $f12, $f14, $f14
	fadd    $f13, $f14, $f13
	store   $f13, 1($i1)
	fmul    $f9, $f9, $f13
	fmul    $f6, $f13, $f13
	fmul    $f1, $f1, $f14
	fmul    $f8, $f14, $f14
	fadd    $f13, $f14, $f13
	fmul    $f3, $f3, $f14
	fmul    $f12, $f14, $f14
	fadd    $f13, $f14, $f13
	store   $f13, 2($i1)
	li      l.14050, $i1
	load    0($i1), $f13
	fmul    $f6, $f7, $f14
	fmul    $f14, $f9, $f14
	fmul    $f8, $f11, $f11
	fmul    $f11, $f1, $f11
	fadd    $f14, $f11, $f11
	fmul    $f12, $f5, $f14
	fmul    $f14, $f3, $f14
	fadd    $f11, $f14, $f11
	fmul    $f13, $f11, $f11
	load    1($sp), $i1
	store   $f11, 0($i1)
	li      l.14050, $i2
	load    0($i2), $f11
	fmul    $f6, $f4, $f13
	fmul    $f13, $f9, $f9
	fmul    $f8, $f10, $f13
	fmul    $f13, $f1, $f1
	fadd    $f9, $f1, $f1
	fmul    $f12, $f2, $f9
	fmul    $f9, $f3, $f3
	fadd    $f1, $f3, $f1
	fmul    $f11, $f1, $f1
	store   $f1, 1($i1)
	li      l.14050, $i2
	load    0($i2), $f1
	fmul    $f6, $f4, $f3
	fmul    $f3, $f7, $f3
	fmul    $f8, $f10, $f4
	load    14($sp), $f6
	fmul    $f4, $f6, $f4
	fadd    $f3, $f4, $f3
	fmul    $f12, $f2, $f2
	fmul    $f2, $f5, $f2
	fadd    $f3, $f2, $f2
	fmul    $f1, $f2, $f1
	store   $f1, 2($i1)
	ret
read_nth_object.2924:
	store   $i1, 0($sp)
	load    2($i11), $i1
	store   $i1, 1($sp)
	load    1($i11), $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read_int
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24445
	li      0, $i1
	ret
be_else.24445:
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read_int
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_read_int
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_read_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_read_float
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_read_float
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_read_float
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	store   $f1, 2($i1)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read_float
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read_float
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read_float
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read_float
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24446
	li      0, $i1
	b       ble_cont.24447
ble_else.24446:
	li      1, $i1
ble_cont.24447:
	store   $i1, 9($sp)
	li      2, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_read_float
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_read_float
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	store   $f1, 1($i1)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_float_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $i1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read_float
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	store   $f1, 2($i1)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_float_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $i1, 12($sp)
	load    6($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24448
	b       be_cont.24449
be_else.24448:
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_read_float
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      l.14102, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    12($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_read_float
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      l.14102, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    12($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_read_float
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      l.14102, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    12($sp), $i1
	store   $f1, 2($i1)
be_cont.24449:
	load    4($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24450
	li      1, $i1
	b       be_cont.24451
be_else.24450:
	load    9($sp), $i1
be_cont.24451:
	store   $i1, 13($sp)
	li      4, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	mov     $hp, $i2
	add     $hp, 11, $hp
	store   $i1, 10($i2)
	load    12($sp), $i1
	store   $i1, 9($i2)
	load    11($sp), $i1
	store   $i1, 8($i2)
	load    10($sp), $i1
	store   $i1, 7($i2)
	load    13($sp), $i1
	store   $i1, 6($i2)
	load    8($sp), $i1
	store   $i1, 5($i2)
	load    7($sp), $i1
	store   $i1, 4($i2)
	load    6($sp), $i3
	store   $i3, 3($i2)
	load    5($sp), $i3
	store   $i3, 2($i2)
	load    4($sp), $i3
	store   $i3, 1($i2)
	load    3($sp), $i4
	store   $i4, 0($i2)
	load    0($sp), $i4
	load    2($sp), $i5
	add     $i5, $i4, $i12
	store   $i2, 0($i12)
	li      3, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24452
	load    0($i1), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24454
	li      1, $i2
	b       be_cont.24455
be_else.24454:
	li      0, $i2
be_cont.24455:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24456
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24458
	li      1, $i2
	b       be_cont.24459
be_else.24458:
	li      0, $i2
be_cont.24459:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24460
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24462
	li      0, $i2
	b       ble_cont.24463
ble_else.24462:
	li      1, $i2
ble_cont.24463:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24464
	li      l.14099, $i2
	load    0($i2), $f2
	b       be_cont.24465
be_else.24464:
	li      l.14035, $i2
	load    0($i2), $f2
be_cont.24465:
	b       be_cont.24461
be_else.24460:
	li      l.14001, $i2
	load    0($i2), $f2
be_cont.24461:
	fmul    $f1, $f1, $f1
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.24457
be_else.24456:
	li      l.14001, $i2
	load    0($i2), $f1
be_cont.24457:
	store   $f1, 0($i1)
	load    1($i1), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24466
	li      1, $i2
	b       be_cont.24467
be_else.24466:
	li      0, $i2
be_cont.24467:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24468
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24470
	li      1, $i2
	b       be_cont.24471
be_else.24470:
	li      0, $i2
be_cont.24471:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24472
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24474
	li      0, $i2
	b       ble_cont.24475
ble_else.24474:
	li      1, $i2
ble_cont.24475:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24476
	li      l.14099, $i2
	load    0($i2), $f2
	b       be_cont.24477
be_else.24476:
	li      l.14035, $i2
	load    0($i2), $f2
be_cont.24477:
	b       be_cont.24473
be_else.24472:
	li      l.14001, $i2
	load    0($i2), $f2
be_cont.24473:
	fmul    $f1, $f1, $f1
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.24469
be_else.24468:
	li      l.14001, $i2
	load    0($i2), $f1
be_cont.24469:
	store   $f1, 1($i1)
	load    2($i1), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24478
	li      1, $i2
	b       be_cont.24479
be_else.24478:
	li      0, $i2
be_cont.24479:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24480
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24482
	li      1, $i2
	b       be_cont.24483
be_else.24482:
	li      0, $i2
be_cont.24483:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24484
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24486
	li      0, $i2
	b       ble_cont.24487
ble_else.24486:
	li      1, $i2
ble_cont.24487:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24488
	li      l.14099, $i2
	load    0($i2), $f2
	b       be_cont.24489
be_else.24488:
	li      l.14035, $i2
	load    0($i2), $f2
be_cont.24489:
	b       be_cont.24485
be_else.24484:
	li      l.14001, $i2
	load    0($i2), $f2
be_cont.24485:
	fmul    $f1, $f1, $f1
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.24481
be_else.24480:
	li      l.14001, $i2
	load    0($i2), $f1
be_cont.24481:
	store   $f1, 2($i1)
	b       be_cont.24453
be_else.24452:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24490
	load    9($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24492
	li      1, $i2
	b       be_cont.24493
be_else.24492:
	li      0, $i2
be_cont.24493:
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     vecunit_sgn.2816
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       be_cont.24491
be_else.24490:
be_cont.24491:
be_cont.24453:
	load    6($sp), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24494
	b       be_cont.24495
be_else.24494:
	load    7($sp), $i1
	load    12($sp), $i2
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.24496, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.24496:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.24495:
	li      1, $i1
	ret
read_object.2926:
	load    2($i11), $i2
	load    1($i11), $i3
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.24497
	ret
bge_else.24497:
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	store   $i3, 2($sp)
	store   $i1, 3($sp)
	mov     $i2, $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.24499, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.24499:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24500
	load    2($sp), $i1
	load    3($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.24500:
	load    3($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.24502
	ret
bge_else.24502:
	store   $i1, 4($sp)
	load    1($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.24504, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.24504:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24505
	load    2($sp), $i1
	load    4($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.24505:
	load    4($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.24507
	ret
bge_else.24507:
	store   $i1, 5($sp)
	load    1($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.24509, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.24509:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24510
	load    2($sp), $i1
	load    5($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.24510:
	load    5($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.24512
	ret
bge_else.24512:
	store   $i1, 6($sp)
	load    1($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.24514, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.24514:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24515
	load    2($sp), $i1
	load    6($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.24515:
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
read_net_item.2930:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read_int
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24517
	load    0($sp), $i1
	add     $i1, 1, $i1
	li      -1, $i2
	b       min_caml_create_array
be_else.24517:
	store   $i1, 1($sp)
	load    0($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read_int
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24518
	load    2($sp), $i1
	add     $i1, 1, $i1
	li      -1, $i2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       be_cont.24519
be_else.24518:
	store   $i1, 3($sp)
	load    2($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_read_int
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24520
	load    4($sp), $i1
	add     $i1, 1, $i1
	li      -1, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	b       be_cont.24521
be_else.24520:
	store   $i1, 5($sp)
	load    4($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_read_int
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24522
	load    6($sp), $i1
	add     $i1, 1, $i1
	li      -1, $i2
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	b       be_cont.24523
be_else.24522:
	store   $i1, 7($sp)
	load    6($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     read_net_item.2930
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    6($sp), $i2
	load    7($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.24523:
	load    4($sp), $i2
	load    5($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.24521:
	load    2($sp), $i2
	load    3($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.24519:
	load    0($sp), $i2
	load    1($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
	ret
read_or_network.2932:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read_int
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24524
	li      1, $i1
	li      -1, $i2
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       be_cont.24525
be_else.24524:
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read_int
	sub     $sp, 3, $sp
	load    2($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24526
	li      2, $i1
	li      -1, $i2
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	b       be_cont.24527
be_else.24526:
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read_int
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24528
	li      3, $i1
	li      -1, $i2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       be_cont.24529
be_else.24528:
	store   $i1, 3($sp)
	li      3, $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_net_item.2930
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	store   $i2, 2($i1)
be_cont.24529:
	load    2($sp), $i2
	store   $i2, 1($i1)
be_cont.24527:
	load    1($sp), $i2
	store   $i2, 0($i1)
be_cont.24525:
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24530
	load    0($sp), $i1
	add     $i1, 1, $i1
	b       min_caml_create_array
be_else.24530:
	store   $i2, 4($sp)
	load    0($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_read_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24531
	li      1, $i1
	li      -1, $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	b       be_cont.24532
be_else.24531:
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_read_int
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24533
	li      2, $i1
	li      -1, $i2
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	b       be_cont.24534
be_else.24533:
	store   $i1, 7($sp)
	li      2, $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     read_net_item.2930
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i2, 1($i1)
be_cont.24534:
	load    6($sp), $i2
	store   $i2, 0($i1)
be_cont.24532:
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24535
	load    5($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	b       be_cont.24536
be_else.24535:
	store   $i2, 8($sp)
	load    5($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_or_network.2932
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    5($sp), $i2
	load    8($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.24536:
	load    0($sp), $i2
	load    4($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
	ret
read_and_network.2934:
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	load    1($i11), $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read_int
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24537
	li      1, $i1
	li      -1, $i2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       be_cont.24538
be_else.24537:
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read_int
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24539
	li      2, $i1
	li      -1, $i2
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	b       be_cont.24540
be_else.24539:
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_read_int
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24541
	li      3, $i1
	li      -1, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	b       be_cont.24542
be_else.24541:
	store   $i1, 5($sp)
	li      3, $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     read_net_item.2930
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	store   $i2, 2($i1)
be_cont.24542:
	load    4($sp), $i2
	store   $i2, 1($i1)
be_cont.24540:
	load    3($sp), $i2
	store   $i2, 0($i1)
be_cont.24538:
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24543
	ret
be_else.24543:
	load    1($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_read_int
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24545
	li      1, $i1
	li      -1, $i2
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	b       be_cont.24546
be_else.24545:
	store   $i1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_read_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24547
	li      2, $i1
	li      -1, $i2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	b       be_cont.24548
be_else.24547:
	store   $i1, 8($sp)
	li      2, $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_net_item.2930
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i2
	store   $i2, 1($i1)
be_cont.24548:
	load    7($sp), $i2
	store   $i2, 0($i1)
be_cont.24546:
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24549
	ret
be_else.24549:
	load    6($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
solver_rect_surface.2938:
	load    1($i11), $i6
	add     $i2, $i3, $i12
	load    0($i12), $f4
	li      l.14001, $i7
	load    0($i7), $f5
	fcmp    $f4, $f5, $i12
	bne     $i12, be_else.24551
	li      1, $i7
	b       be_cont.24552
be_else.24551:
	li      0, $i7
be_cont.24552:
	li      0, $i12
	cmp     $i7, $i12, $i12
	bne     $i12, be_else.24553
	load    4($i1), $i7
	load    6($i1), $i1
	add     $i2, $i3, $i12
	load    0($i12), $f4
	li      l.14001, $i8
	load    0($i8), $f5
	fcmp    $f5, $f4, $i12
	bg      $i12, ble_else.24554
	li      0, $i8
	b       ble_cont.24555
ble_else.24554:
	li      1, $i8
ble_cont.24555:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24556
	mov     $i8, $i1
	b       be_cont.24557
be_else.24556:
	li      0, $i12
	cmp     $i8, $i12, $i12
	bne     $i12, be_else.24558
	li      1, $i1
	b       be_cont.24559
be_else.24558:
	li      0, $i1
be_cont.24559:
be_cont.24557:
	add     $i7, $i3, $i12
	load    0($i12), $f4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24560
	fneg    $f4, $f4
	b       be_cont.24561
be_else.24560:
be_cont.24561:
	fsub    $f4, $f1, $f1
	add     $i2, $i3, $i12
	load    0($i12), $f4
	finv    $f4, $f15
	fmul    $f1, $f15, $f1
	add     $i2, $i4, $i12
	load    0($i12), $f4
	fmul    $f1, $f4, $f4
	fadd    $f4, $f2, $f2
	li      l.14001, $i1
	load    0($i1), $f4
	fcmp    $f4, $f2, $i12
	bg      $i12, ble_else.24562
	b       ble_cont.24563
ble_else.24562:
	fneg    $f2, $f2
ble_cont.24563:
	add     $i7, $i4, $i12
	load    0($i12), $f4
	fcmp    $f4, $f2, $i12
	bg      $i12, ble_else.24564
	li      0, $i1
	b       ble_cont.24565
ble_else.24564:
	li      1, $i1
ble_cont.24565:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24566
	li      0, $i1
	ret
be_else.24566:
	add     $i2, $i5, $i12
	load    0($i12), $f2
	fmul    $f1, $f2, $f2
	fadd    $f2, $f3, $f2
	li      l.14001, $i1
	load    0($i1), $f3
	fcmp    $f3, $f2, $i12
	bg      $i12, ble_else.24567
	b       ble_cont.24568
ble_else.24567:
	fneg    $f2, $f2
ble_cont.24568:
	add     $i7, $i5, $i12
	load    0($i12), $f3
	fcmp    $f3, $f2, $i12
	bg      $i12, ble_else.24569
	li      0, $i1
	b       ble_cont.24570
ble_else.24569:
	li      1, $i1
ble_cont.24570:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24571
	li      0, $i1
	ret
be_else.24571:
	store   $f1, 0($i6)
	li      1, $i1
	ret
be_else.24553:
	li      0, $i1
	ret
solver_surface.2953:
	load    1($i11), $i3
	load    4($i1), $i1
	load    0($i2), $f4
	load    0($i1), $f5
	fmul    $f4, $f5, $f4
	load    1($i2), $f5
	load    1($i1), $f6
	fmul    $f5, $f6, $f5
	fadd    $f4, $f5, $f4
	load    2($i2), $f5
	load    2($i1), $f6
	fmul    $f5, $f6, $f5
	fadd    $f4, $f5, $f4
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f4, $f5, $i12
	bg      $i12, ble_else.24572
	li      0, $i2
	b       ble_cont.24573
ble_else.24572:
	li      1, $i2
ble_cont.24573:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24574
	li      0, $i1
	ret
be_else.24574:
	load    0($i1), $f5
	fmul    $f5, $f1, $f1
	load    1($i1), $f5
	fmul    $f5, $f2, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	fneg    $f1, $f1
	finv    $f4, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 0($i3)
	li      1, $i1
	ret
quadratic.2959:
	fmul    $f1, $f1, $f4
	load    4($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fmul    $f2, $f2, $f5
	load    4($i1), $i2
	load    1($i2), $f6
	fmul    $f5, $f6, $f5
	fadd    $f4, $f5, $f4
	fmul    $f3, $f3, $f5
	load    4($i1), $i2
	load    2($i2), $f6
	fmul    $f5, $f6, $f5
	fadd    $f4, $f5, $f4
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24575
	mov     $f4, $f1
	ret
be_else.24575:
	fmul    $f2, $f3, $f5
	load    9($i1), $i2
	load    0($i2), $f6
	fmul    $f5, $f6, $f5
	fadd    $f4, $f5, $f4
	fmul    $f3, $f1, $f3
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f3, $f5, $f3
	fadd    $f4, $f3, $f3
	fmul    $f1, $f2, $f1
	load    9($i1), $i1
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	fadd    $f3, $f1, $f1
	ret
bilinear.2964:
	fmul    $f1, $f4, $f7
	load    4($i1), $i2
	load    0($i2), $f8
	fmul    $f7, $f8, $f7
	fmul    $f2, $f5, $f8
	load    4($i1), $i2
	load    1($i2), $f9
	fmul    $f8, $f9, $f8
	fadd    $f7, $f8, $f7
	fmul    $f3, $f6, $f8
	load    4($i1), $i2
	load    2($i2), $f9
	fmul    $f8, $f9, $f8
	fadd    $f7, $f8, $f7
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24576
	mov     $f7, $f1
	ret
be_else.24576:
	fmul    $f3, $f5, $f8
	fmul    $f2, $f6, $f9
	fadd    $f8, $f9, $f8
	load    9($i1), $i2
	load    0($i2), $f9
	fmul    $f8, $f9, $f8
	fmul    $f1, $f6, $f6
	fmul    $f3, $f4, $f3
	fadd    $f6, $f3, $f3
	load    9($i1), $i2
	load    1($i2), $f6
	fmul    $f3, $f6, $f3
	fadd    $f8, $f3, $f3
	fmul    $f1, $f5, $f1
	fmul    $f2, $f4, $f2
	fadd    $f1, $f2, $f1
	load    9($i1), $i1
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	fadd    $f3, $f1, $f1
	li      l.14050, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	fadd    $f7, $f1, $f1
	ret
solver_second.2972:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $f1, 2($sp)
	store   $i1, 3($sp)
	store   $i2, 4($sp)
	load    1($i11), $i3
	store   $i3, 5($sp)
	load    0($i2), $f1
	load    1($i2), $f2
	load    2($i2), $f3
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     quadratic.2959
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24577
	li      1, $i1
	b       be_cont.24578
be_else.24577:
	li      0, $i1
be_cont.24578:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24579
	store   $f1, 6($sp)
	load    4($sp), $i1
	load    0($i1), $f1
	load    1($i1), $f2
	load    2($i1), $f3
	load    2($sp), $f4
	load    1($sp), $f5
	load    0($sp), $f6
	load    3($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     bilinear.2964
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $f1, 7($sp)
	load    2($sp), $f1
	load    1($sp), $f2
	load    0($sp), $f3
	load    3($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     quadratic.2959
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    3($sp), $i1
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24580
	li      l.14035, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.24581
be_else.24580:
be_cont.24581:
	load    7($sp), $f2
	fmul    $f2, $f2, $f3
	load    6($sp), $f4
	fmul    $f4, $f1, $f1
	fsub    $f3, $f1, $f1
	li      l.14001, $i2
	load    0($i2), $f3
	fcmp    $f1, $f3, $i12
	bg      $i12, ble_else.24582
	li      0, $i2
	b       ble_cont.24583
ble_else.24582:
	li      1, $i2
ble_cont.24583:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24584
	li      0, $i1
	ret
be_else.24584:
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     sqrt.2751
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    3($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24585
	fneg    $f1, $f1
	b       be_cont.24586
be_else.24585:
be_cont.24586:
	load    7($sp), $f2
	fsub    $f1, $f2, $f1
	load    6($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.24579:
	li      0, $i1
	ret
solver.2978:
	load    4($i11), $i4
	load    3($i11), $i5
	load    2($i11), $i6
	load    1($i11), $i7
	add     $i7, $i1, $i12
	load    0($i12), $i1
	load    0($i3), $f1
	load    5($i1), $i7
	load    0($i7), $f2
	fsub    $f1, $f2, $f1
	load    1($i3), $f2
	load    5($i1), $i7
	load    1($i7), $f3
	fsub    $f2, $f3, $f2
	load    2($i3), $f3
	load    5($i1), $i3
	load    2($i3), $f4
	fsub    $f3, $f4, $f3
	load    1($i1), $i3
	li      1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24587
	store   $f1, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $i2, 3($sp)
	store   $i1, 4($sp)
	store   $i5, 5($sp)
	li      0, $i3
	li      1, $i4
	li      2, $i6
	mov     $i5, $i11
	mov     $i6, $i5
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.24588, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.24588:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24589
	li      1, $i3
	li      2, $i4
	li      0, $i5
	load    2($sp), $f1
	load    1($sp), $f2
	load    0($sp), $f3
	load    4($sp), $i1
	load    3($sp), $i2
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.24590, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.24590:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24591
	li      2, $i3
	li      0, $i4
	li      1, $i5
	load    1($sp), $f1
	load    0($sp), $f2
	load    2($sp), $f3
	load    4($sp), $i1
	load    3($sp), $i2
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.24592, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.24592:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24593
	li      0, $i1
	ret
be_else.24593:
	li      3, $i1
	ret
be_else.24591:
	li      2, $i1
	ret
be_else.24589:
	li      1, $i1
	ret
be_else.24587:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24594
	load    4($i1), $i1
	load    0($i2), $f4
	load    0($i1), $f5
	fmul    $f4, $f5, $f4
	load    1($i2), $f5
	load    1($i1), $f6
	fmul    $f5, $f6, $f5
	fadd    $f4, $f5, $f4
	load    2($i2), $f5
	load    2($i1), $f6
	fmul    $f5, $f6, $f5
	fadd    $f4, $f5, $f4
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f4, $f5, $i12
	bg      $i12, ble_else.24595
	li      0, $i2
	b       ble_cont.24596
ble_else.24595:
	li      1, $i2
ble_cont.24596:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24597
	li      0, $i1
	ret
be_else.24597:
	load    0($i1), $f5
	fmul    $f5, $f1, $f1
	load    1($i1), $f5
	fmul    $f5, $f2, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	fneg    $f1, $f1
	finv    $f4, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 0($i6)
	li      1, $i1
	ret
be_else.24594:
	mov     $i4, $i11
	load    0($i11), $i10
	jr      $i10
solver_rect_fast.2982:
	load    1($i11), $i4
	load    0($i3), $f4
	fsub    $f4, $f1, $f4
	load    1($i3), $f5
	fmul    $f4, $f5, $f4
	load    1($i2), $f5
	fmul    $f4, $f5, $f5
	fadd    $f5, $f2, $f5
	li      l.14001, $i5
	load    0($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24598
	b       ble_cont.24599
ble_else.24598:
	fneg    $f5, $f5
ble_cont.24599:
	load    4($i1), $i5
	load    1($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24600
	li      0, $i5
	b       ble_cont.24601
ble_else.24600:
	li      1, $i5
ble_cont.24601:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24602
	li      0, $i5
	b       be_cont.24603
be_else.24602:
	load    2($i2), $f5
	fmul    $f4, $f5, $f5
	fadd    $f5, $f3, $f5
	li      l.14001, $i5
	load    0($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24604
	b       ble_cont.24605
ble_else.24604:
	fneg    $f5, $f5
ble_cont.24605:
	load    4($i1), $i5
	load    2($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24606
	li      0, $i5
	b       ble_cont.24607
ble_else.24606:
	li      1, $i5
ble_cont.24607:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24608
	li      0, $i5
	b       be_cont.24609
be_else.24608:
	load    1($i3), $f5
	li      l.14001, $i5
	load    0($i5), $f6
	fcmp    $f5, $f6, $i12
	bne     $i12, be_else.24610
	li      1, $i5
	b       be_cont.24611
be_else.24610:
	li      0, $i5
be_cont.24611:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24612
	li      1, $i5
	b       be_cont.24613
be_else.24612:
	li      0, $i5
be_cont.24613:
be_cont.24609:
be_cont.24603:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24614
	load    2($i3), $f4
	fsub    $f4, $f2, $f4
	load    3($i3), $f5
	fmul    $f4, $f5, $f4
	load    0($i2), $f5
	fmul    $f4, $f5, $f5
	fadd    $f5, $f1, $f5
	li      l.14001, $i5
	load    0($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24615
	b       ble_cont.24616
ble_else.24615:
	fneg    $f5, $f5
ble_cont.24616:
	load    4($i1), $i5
	load    0($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24617
	li      0, $i5
	b       ble_cont.24618
ble_else.24617:
	li      1, $i5
ble_cont.24618:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24619
	li      0, $i5
	b       be_cont.24620
be_else.24619:
	load    2($i2), $f5
	fmul    $f4, $f5, $f5
	fadd    $f5, $f3, $f5
	li      l.14001, $i5
	load    0($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24621
	b       ble_cont.24622
ble_else.24621:
	fneg    $f5, $f5
ble_cont.24622:
	load    4($i1), $i5
	load    2($i5), $f6
	fcmp    $f6, $f5, $i12
	bg      $i12, ble_else.24623
	li      0, $i5
	b       ble_cont.24624
ble_else.24623:
	li      1, $i5
ble_cont.24624:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24625
	li      0, $i5
	b       be_cont.24626
be_else.24625:
	load    3($i3), $f5
	li      l.14001, $i5
	load    0($i5), $f6
	fcmp    $f5, $f6, $i12
	bne     $i12, be_else.24627
	li      1, $i5
	b       be_cont.24628
be_else.24627:
	li      0, $i5
be_cont.24628:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24629
	li      1, $i5
	b       be_cont.24630
be_else.24629:
	li      0, $i5
be_cont.24630:
be_cont.24626:
be_cont.24620:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24631
	load    4($i3), $f4
	fsub    $f4, $f3, $f3
	load    5($i3), $f4
	fmul    $f3, $f4, $f3
	load    0($i2), $f4
	fmul    $f3, $f4, $f4
	fadd    $f4, $f1, $f1
	li      l.14001, $i5
	load    0($i5), $f4
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24632
	b       ble_cont.24633
ble_else.24632:
	fneg    $f1, $f1
ble_cont.24633:
	load    4($i1), $i5
	load    0($i5), $f4
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24634
	li      0, $i5
	b       ble_cont.24635
ble_else.24634:
	li      1, $i5
ble_cont.24635:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24636
	li      0, $i1
	b       be_cont.24637
be_else.24636:
	load    1($i2), $f1
	fmul    $f3, $f1, $f1
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24638
	b       ble_cont.24639
ble_else.24638:
	fneg    $f1, $f1
ble_cont.24639:
	load    4($i1), $i1
	load    1($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24640
	li      0, $i1
	b       ble_cont.24641
ble_else.24640:
	li      1, $i1
ble_cont.24641:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24642
	li      0, $i1
	b       be_cont.24643
be_else.24642:
	load    5($i3), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24644
	li      1, $i1
	b       be_cont.24645
be_else.24644:
	li      0, $i1
be_cont.24645:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24646
	li      1, $i1
	b       be_cont.24647
be_else.24646:
	li      0, $i1
be_cont.24647:
be_cont.24643:
be_cont.24637:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24648
	li      0, $i1
	ret
be_else.24648:
	store   $f3, 0($i4)
	li      3, $i1
	ret
be_else.24631:
	store   $f4, 0($i4)
	li      2, $i1
	ret
be_else.24614:
	store   $f4, 0($i4)
	li      1, $i1
	ret
solver_second_fast.2995:
	load    1($i11), $i3
	load    0($i2), $f4
	li      l.14001, $i4
	load    0($i4), $f5
	fcmp    $f4, $f5, $i12
	bne     $i12, be_else.24649
	li      1, $i4
	b       be_cont.24650
be_else.24649:
	li      0, $i4
be_cont.24650:
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24651
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $f4, 2($sp)
	store   $i1, 3($sp)
	load    1($i2), $f4
	fmul    $f4, $f1, $f4
	load    2($i2), $f5
	fmul    $f5, $f2, $f5
	fadd    $f4, $f5, $f4
	load    3($i2), $f5
	fmul    $f5, $f3, $f5
	fadd    $f4, $f5, $f4
	store   $f4, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     quadratic.2959
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    3($sp), $i1
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24652
	li      l.14035, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.24653
be_else.24652:
be_cont.24653:
	load    4($sp), $f2
	fmul    $f2, $f2, $f3
	load    2($sp), $f4
	fmul    $f4, $f1, $f1
	fsub    $f3, $f1, $f1
	li      l.14001, $i2
	load    0($i2), $f3
	fcmp    $f1, $f3, $i12
	bg      $i12, ble_else.24654
	li      0, $i2
	b       ble_cont.24655
ble_else.24654:
	li      1, $i2
ble_cont.24655:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24656
	li      0, $i1
	ret
be_else.24656:
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24657
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     sqrt.2751
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $f2
	fsub    $f2, $f1, $f1
	load    1($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.24658
be_else.24657:
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     sqrt.2751
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
be_cont.24658:
	li      1, $i1
	ret
be_else.24651:
	li      0, $i1
	ret
solver_second_fast2.3012:
	load    1($i11), $i4
	load    0($i2), $f4
	li      l.14001, $i5
	load    0($i5), $f5
	fcmp    $f4, $f5, $i12
	bne     $i12, be_else.24659
	li      1, $i5
	b       be_cont.24660
be_else.24659:
	li      0, $i5
be_cont.24660:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24661
	load    1($i2), $f5
	fmul    $f5, $f1, $f1
	load    2($i2), $f5
	fmul    $f5, $f2, $f2
	fadd    $f1, $f2, $f1
	load    3($i2), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i3), $f2
	fmul    $f1, $f1, $f3
	fmul    $f4, $f2, $f2
	fsub    $f3, $f2, $f2
	li      l.14001, $i3
	load    0($i3), $f3
	fcmp    $f2, $f3, $i12
	bg      $i12, ble_else.24662
	li      0, $i3
	b       ble_cont.24663
ble_else.24662:
	li      1, $i3
ble_cont.24663:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24664
	li      0, $i1
	ret
be_else.24664:
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24665
	store   $i4, 0($sp)
	store   $i2, 1($sp)
	store   $f1, 2($sp)
	mov     $f2, $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     sqrt.2751
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $f2
	fsub    $f2, $f1, $f1
	load    1($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.24666
be_else.24665:
	store   $i4, 0($sp)
	store   $i2, 1($sp)
	store   $f1, 2($sp)
	mov     $f2, $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     sqrt.2751
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
be_cont.24666:
	li      1, $i1
	ret
be_else.24661:
	li      0, $i1
	ret
solver_fast2.3019:
	load    4($i11), $i3
	load    3($i11), $i4
	load    2($i11), $i5
	load    1($i11), $i6
	add     $i6, $i1, $i12
	load    0($i12), $i6
	load    10($i6), $i7
	load    0($i7), $f1
	load    1($i7), $f2
	load    2($i7), $f3
	load    1($i2), $i8
	add     $i8, $i1, $i12
	load    0($i12), $i1
	load    1($i6), $i8
	li      1, $i12
	cmp     $i8, $i12, $i12
	bne     $i12, be_else.24667
	load    0($i2), $i2
	mov     $i1, $i3
	mov     $i4, $i11
	mov     $i6, $i1
	load    0($i11), $i10
	jr      $i10
be_else.24667:
	li      2, $i12
	cmp     $i8, $i12, $i12
	bne     $i12, be_else.24668
	load    0($i1), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24669
	li      0, $i2
	b       ble_cont.24670
ble_else.24669:
	li      1, $i2
ble_cont.24670:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24671
	li      0, $i1
	ret
be_else.24671:
	load    0($i1), $f1
	load    3($i7), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 0($i5)
	li      1, $i1
	ret
be_else.24668:
	mov     $i1, $i2
	mov     $i3, $i11
	mov     $i7, $i3
	mov     $i6, $i1
	load    0($i11), $i10
	jr      $i10
setup_rect_table.3022:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      6, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	load    0($i2), $f1
	li      l.14001, $i3
	load    0($i3), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24672
	li      1, $i3
	b       be_cont.24673
be_else.24672:
	li      0, $i3
be_cont.24673:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24674
	load    0($sp), $i3
	load    6($i3), $i4
	load    0($i2), $f1
	li      l.14001, $i5
	load    0($i5), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24676
	li      0, $i5
	b       ble_cont.24677
ble_else.24676:
	li      1, $i5
ble_cont.24677:
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24678
	mov     $i5, $i4
	b       be_cont.24679
be_else.24678:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24680
	li      1, $i4
	b       be_cont.24681
be_else.24680:
	li      0, $i4
be_cont.24681:
be_cont.24679:
	load    4($i3), $i3
	load    0($i3), $f1
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24682
	fneg    $f1, $f1
	b       be_cont.24683
be_else.24682:
be_cont.24683:
	store   $f1, 0($i1)
	li      l.14035, $i3
	load    0($i3), $f1
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 1($i1)
	b       be_cont.24675
be_else.24674:
	li      l.14001, $i3
	load    0($i3), $f1
	store   $f1, 1($i1)
be_cont.24675:
	load    1($i2), $f1
	li      l.14001, $i3
	load    0($i3), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24684
	li      1, $i3
	b       be_cont.24685
be_else.24684:
	li      0, $i3
be_cont.24685:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24686
	load    0($sp), $i3
	load    6($i3), $i4
	load    1($i2), $f1
	li      l.14001, $i5
	load    0($i5), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24688
	li      0, $i5
	b       ble_cont.24689
ble_else.24688:
	li      1, $i5
ble_cont.24689:
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24690
	mov     $i5, $i4
	b       be_cont.24691
be_else.24690:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24692
	li      1, $i4
	b       be_cont.24693
be_else.24692:
	li      0, $i4
be_cont.24693:
be_cont.24691:
	load    4($i3), $i3
	load    1($i3), $f1
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24694
	fneg    $f1, $f1
	b       be_cont.24695
be_else.24694:
be_cont.24695:
	store   $f1, 2($i1)
	li      l.14035, $i3
	load    0($i3), $f1
	load    1($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 3($i1)
	b       be_cont.24687
be_else.24686:
	li      l.14001, $i3
	load    0($i3), $f1
	store   $f1, 3($i1)
be_cont.24687:
	load    2($i2), $f1
	li      l.14001, $i3
	load    0($i3), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24696
	li      1, $i3
	b       be_cont.24697
be_else.24696:
	li      0, $i3
be_cont.24697:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24698
	load    0($sp), $i3
	load    6($i3), $i4
	load    2($i2), $f1
	li      l.14001, $i5
	load    0($i5), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24700
	li      0, $i5
	b       ble_cont.24701
ble_else.24700:
	li      1, $i5
ble_cont.24701:
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24702
	mov     $i5, $i4
	b       be_cont.24703
be_else.24702:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24704
	li      1, $i4
	b       be_cont.24705
be_else.24704:
	li      0, $i4
be_cont.24705:
be_cont.24703:
	load    4($i3), $i3
	load    2($i3), $f1
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24706
	fneg    $f1, $f1
	b       be_cont.24707
be_else.24706:
be_cont.24707:
	store   $f1, 4($i1)
	li      l.14035, $i3
	load    0($i3), $f1
	load    2($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 5($i1)
	b       be_cont.24699
be_else.24698:
	li      l.14001, $i2
	load    0($i2), $f1
	store   $f1, 5($i1)
be_cont.24699:
	ret
setup_surface_table.3025:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      4, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	load    0($i2), $f1
	load    0($sp), $i3
	load    4($i3), $i4
	load    0($i4), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    4($i3), $i4
	load    1($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    4($i3), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24708
	li      0, $i2
	b       ble_cont.24709
ble_else.24708:
	li      1, $i2
ble_cont.24709:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24710
	li      l.14001, $i2
	load    0($i2), $f1
	store   $f1, 0($i1)
	b       be_cont.24711
be_else.24710:
	li      l.14099, $i2
	load    0($i2), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f2
	store   $f2, 0($i1)
	load    4($i3), $i2
	load    0($i2), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f2
	fneg    $f2, $f2
	store   $f2, 1($i1)
	load    4($i3), $i2
	load    1($i2), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f2
	fneg    $f2, $f2
	store   $f2, 2($i1)
	load    4($i3), $i2
	load    2($i2), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	fneg    $f1, $f1
	store   $f1, 3($i1)
be_cont.24711:
	ret
setup_second_table.3028:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      5, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $i1, 2($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	load    1($i1), $f2
	load    2($i1), $f3
	load    0($sp), $i1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     quadratic.2959
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    1($sp), $i1
	load    0($i1), $f2
	load    0($sp), $i2
	load    4($i2), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fneg    $f2, $f2
	load    1($i1), $f3
	load    4($i2), $i3
	load    1($i3), $f4
	fmul    $f3, $f4, $f3
	fneg    $f3, $f3
	load    2($i1), $f4
	load    4($i2), $i3
	load    2($i3), $f5
	fmul    $f4, $f5, $f4
	fneg    $f4, $f4
	load    2($sp), $i3
	store   $f1, 0($i3)
	load    3($i2), $i4
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24712
	store   $f2, 1($i3)
	store   $f3, 2($i3)
	store   $f4, 3($i3)
	b       be_cont.24713
be_else.24712:
	load    2($i1), $f5
	load    9($i2), $i4
	load    1($i4), $f6
	fmul    $f5, $f6, $f5
	load    1($i1), $f6
	load    9($i2), $i4
	load    2($i4), $f7
	fmul    $f6, $f7, $f6
	fadd    $f5, $f6, $f5
	li      l.14050, $i4
	load    0($i4), $f6
	finv    $f6, $f15
	fmul    $f5, $f15, $f5
	fsub    $f2, $f5, $f2
	store   $f2, 1($i3)
	load    2($i1), $f2
	load    9($i2), $i4
	load    0($i4), $f5
	fmul    $f2, $f5, $f2
	load    0($i1), $f5
	load    9($i2), $i4
	load    2($i4), $f6
	fmul    $f5, $f6, $f5
	fadd    $f2, $f5, $f2
	li      l.14050, $i4
	load    0($i4), $f5
	finv    $f5, $f15
	fmul    $f2, $f15, $f2
	fsub    $f3, $f2, $f2
	store   $f2, 2($i3)
	load    1($i1), $f2
	load    9($i2), $i4
	load    0($i4), $f3
	fmul    $f2, $f3, $f2
	load    0($i1), $f3
	load    9($i2), $i1
	load    1($i1), $f5
	fmul    $f3, $f5, $f3
	fadd    $f2, $f3, $f2
	li      l.14050, $i1
	load    0($i1), $f3
	finv    $f3, $f15
	fmul    $f2, $f15, $f2
	fsub    $f4, $f2, $f2
	store   $f2, 3($i3)
be_cont.24713:
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.24714
	li      1, $i1
	b       be_cont.24715
be_else.24714:
	li      0, $i1
be_cont.24715:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24716
	li      l.14035, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $f1, 4($i3)
	b       be_cont.24717
be_else.24716:
be_cont.24717:
	mov     $i3, $i1
	ret
iter_setup_dirvec_constants.3031:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.24718
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	store   $i3, 2($sp)
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24719
	store   $i2, 3($sp)
	store   $i4, 4($sp)
	mov     $i3, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     setup_rect_table.3022
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    3($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.24720
be_else.24719:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24721
	store   $i2, 3($sp)
	store   $i4, 4($sp)
	mov     $i3, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     setup_surface_table.3025
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    3($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.24722
be_else.24721:
	store   $i2, 3($sp)
	store   $i4, 4($sp)
	mov     $i3, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     setup_second_table.3028
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    3($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.24722:
be_cont.24720:
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.24723
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    1($sp), $i3
	load    1($i3), $i4
	load    0($i3), $i3
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24724
	store   $i1, 5($sp)
	store   $i4, 6($sp)
	mov     $i3, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     setup_rect_table.3022
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i2
	load    6($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.24725
be_else.24724:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24726
	store   $i1, 5($sp)
	store   $i4, 6($sp)
	mov     $i3, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     setup_surface_table.3025
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i2
	load    6($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.24727
be_else.24726:
	store   $i1, 5($sp)
	store   $i4, 6($sp)
	mov     $i3, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     setup_second_table.3028
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i2
	load    6($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.24727:
be_cont.24725:
	sub     $i2, 1, $i2
	load    1($sp), $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.24723:
	ret
bge_else.24718:
	ret
setup_startp_constants.3036:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.24730
	store   $i1, 0($sp)
	store   $i11, 1($sp)
	store   $i2, 2($sp)
	add     $i3, $i2, $i12
	load    0($i12), $i2
	load    10($i2), $i3
	load    1($i2), $i4
	load    0($i1), $f1
	load    5($i2), $i5
	load    0($i5), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 0($i3)
	load    1($i1), $f1
	load    5($i2), $i5
	load    1($i5), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 1($i3)
	load    2($i1), $f1
	load    5($i2), $i1
	load    2($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 2($i3)
	li      2, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24731
	load    4($i2), $i1
	load    0($i3), $f1
	load    1($i3), $f2
	load    2($i3), $f3
	load    0($i1), $f4
	fmul    $f4, $f1, $f1
	load    1($i1), $f4
	fmul    $f4, $f2, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 3($i3)
	b       be_cont.24732
be_else.24731:
	li      2, $i12
	cmp     $i4, $i12, $i12
	bg      $i12, ble_else.24733
	b       ble_cont.24734
ble_else.24733:
	store   $i3, 3($sp)
	store   $i4, 4($sp)
	load    0($i3), $f1
	load    1($i3), $f2
	load    2($i3), $f3
	mov     $i2, $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     quadratic.2959
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24735
	li      l.14035, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.24736
be_else.24735:
be_cont.24736:
	load    3($sp), $i1
	store   $f1, 3($i1)
ble_cont.24734:
be_cont.24732:
	load    2($sp), $i1
	sub     $i1, 1, $i2
	load    0($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.24730:
	ret
is_rect_outside.3041:
	li      l.14001, $i2
	load    0($i2), $f4
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24738
	b       ble_cont.24739
ble_else.24738:
	fneg    $f1, $f1
ble_cont.24739:
	load    4($i1), $i2
	load    0($i2), $f4
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24740
	li      0, $i2
	b       ble_cont.24741
ble_else.24740:
	li      1, $i2
ble_cont.24741:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24742
	li      0, $i2
	b       be_cont.24743
be_else.24742:
	li      l.14001, $i2
	load    0($i2), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24744
	mov     $f2, $f1
	b       ble_cont.24745
ble_else.24744:
	fneg    $f2, $f1
ble_cont.24745:
	load    4($i1), $i2
	load    1($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24746
	li      0, $i2
	b       ble_cont.24747
ble_else.24746:
	li      1, $i2
ble_cont.24747:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24748
	li      0, $i2
	b       be_cont.24749
be_else.24748:
	li      l.14001, $i2
	load    0($i2), $f1
	fcmp    $f1, $f3, $i12
	bg      $i12, ble_else.24750
	mov     $f3, $f1
	b       ble_cont.24751
ble_else.24750:
	fneg    $f3, $f1
ble_cont.24751:
	load    4($i1), $i2
	load    2($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24752
	li      0, $i2
	b       ble_cont.24753
ble_else.24752:
	li      1, $i2
ble_cont.24753:
be_cont.24749:
be_cont.24743:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24754
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24755
	li      1, $i1
	ret
be_else.24755:
	li      0, $i1
	ret
be_else.24754:
	load    6($i1), $i1
	ret
is_outside.3056:
	load    5($i1), $i2
	load    0($i2), $f4
	fsub    $f1, $f4, $f1
	load    5($i1), $i2
	load    1($i2), $f4
	fsub    $f2, $f4, $f2
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f3, $f4, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24756
	li      l.14001, $i2
	load    0($i2), $f4
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24757
	b       ble_cont.24758
ble_else.24757:
	fneg    $f1, $f1
ble_cont.24758:
	load    4($i1), $i2
	load    0($i2), $f4
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.24759
	li      0, $i2
	b       ble_cont.24760
ble_else.24759:
	li      1, $i2
ble_cont.24760:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24761
	li      0, $i2
	b       be_cont.24762
be_else.24761:
	li      l.14001, $i2
	load    0($i2), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24763
	mov     $f2, $f1
	b       ble_cont.24764
ble_else.24763:
	fneg    $f2, $f1
ble_cont.24764:
	load    4($i1), $i2
	load    1($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24765
	li      0, $i2
	b       ble_cont.24766
ble_else.24765:
	li      1, $i2
ble_cont.24766:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24767
	li      0, $i2
	b       be_cont.24768
be_else.24767:
	li      l.14001, $i2
	load    0($i2), $f1
	fcmp    $f1, $f3, $i12
	bg      $i12, ble_else.24769
	mov     $f3, $f1
	b       ble_cont.24770
ble_else.24769:
	fneg    $f3, $f1
ble_cont.24770:
	load    4($i1), $i2
	load    2($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24771
	li      0, $i2
	b       ble_cont.24772
ble_else.24771:
	li      1, $i2
ble_cont.24772:
be_cont.24768:
be_cont.24762:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24773
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24774
	li      1, $i1
	ret
be_else.24774:
	li      0, $i1
	ret
be_else.24773:
	load    6($i1), $i1
	ret
be_else.24756:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24775
	load    4($i1), $i2
	load    0($i2), $f4
	fmul    $f4, $f1, $f1
	load    1($i2), $f4
	fmul    $f4, $f2, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    6($i1), $i1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24776
	li      0, $i2
	b       ble_cont.24777
ble_else.24776:
	li      1, $i2
ble_cont.24777:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24778
	mov     $i2, $i1
	b       be_cont.24779
be_else.24778:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24780
	li      1, $i1
	b       be_cont.24781
be_else.24780:
	li      0, $i1
be_cont.24781:
be_cont.24779:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24782
	li      1, $i1
	ret
be_else.24782:
	li      0, $i1
	ret
be_else.24775:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     quadratic.2959
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i1
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24783
	li      l.14035, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.24784
be_else.24783:
be_cont.24784:
	load    6($i1), $i1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24785
	li      0, $i2
	b       ble_cont.24786
ble_else.24785:
	li      1, $i2
ble_cont.24786:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24787
	mov     $i2, $i1
	b       be_cont.24788
be_else.24787:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24789
	li      1, $i1
	b       be_cont.24790
be_else.24789:
	li      0, $i1
be_cont.24790:
be_cont.24788:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24791
	li      1, $i1
	ret
be_else.24791:
	li      0, $i1
	ret
check_all_inside.3061:
	load    1($i11), $i3
	add     $i2, $i1, $i12
	load    0($i12), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.24792
	li      1, $i1
	ret
be_else.24792:
	store   $i11, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	store   $i3, 4($sp)
	store   $i2, 5($sp)
	store   $i1, 6($sp)
	add     $i3, $i4, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f4
	fsub    $f1, $f4, $f1
	load    5($i1), $i2
	load    1($i2), $f4
	fsub    $f2, $f4, $f2
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f3, $f4, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24793
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     is_rect_outside.3041
	sub     $sp, 8, $sp
	load    7($sp), $ra
	b       be_cont.24794
be_else.24793:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24795
	load    4($i1), $i2
	load    0($i2), $f4
	fmul    $f4, $f1, $f1
	load    1($i2), $f4
	fmul    $f4, $f2, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    6($i1), $i1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24797
	li      0, $i2
	b       ble_cont.24798
ble_else.24797:
	li      1, $i2
ble_cont.24798:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24799
	mov     $i2, $i1
	b       be_cont.24800
be_else.24799:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24801
	li      1, $i1
	b       be_cont.24802
be_else.24801:
	li      0, $i1
be_cont.24802:
be_cont.24800:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24803
	li      1, $i1
	b       be_cont.24804
be_else.24803:
	li      0, $i1
be_cont.24804:
	b       be_cont.24796
be_else.24795:
	store   $i1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     quadratic.2959
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24805
	li      l.14035, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.24806
be_else.24805:
be_cont.24806:
	load    6($i1), $i1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24807
	li      0, $i2
	b       ble_cont.24808
ble_else.24807:
	li      1, $i2
ble_cont.24808:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24809
	mov     $i2, $i1
	b       be_cont.24810
be_else.24809:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24811
	li      1, $i1
	b       be_cont.24812
be_else.24811:
	li      0, $i1
be_cont.24812:
be_cont.24810:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24813
	li      1, $i1
	b       be_cont.24814
be_else.24813:
	li      0, $i1
be_cont.24814:
be_cont.24796:
be_cont.24794:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24815
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24816
	li      1, $i1
	ret
be_else.24816:
	store   $i1, 8($sp)
	load    4($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i1
	load    3($sp), $f1
	load    2($sp), $f2
	load    1($sp), $f3
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     is_outside.3056
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24817
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $f1
	load    2($sp), $f2
	load    1($sp), $f3
	load    5($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.24817:
	li      0, $i1
	ret
be_else.24815:
	li      0, $i1
	ret
shadow_check_and_group.3067:
	load    9($i11), $i3
	load    8($i11), $i4
	store   $i4, 0($sp)
	load    7($i11), $i4
	load    6($i11), $i5
	load    5($i11), $i6
	load    4($i11), $i7
	load    3($i11), $i8
	load    2($i11), $i9
	load    1($i11), $i10
	store   $i10, 1($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.24818
	li      0, $i1
	ret
be_else.24818:
	store   $i8, 2($sp)
	store   $i11, 3($sp)
	store   $i1, 4($sp)
	store   $i6, 5($sp)
	store   $i5, 6($sp)
	store   $i2, 7($sp)
	store   $i7, 8($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 9($sp)
	add     $i6, $i1, $i12
	load    0($i12), $i2
	load    0($i8), $f1
	load    5($i2), $i6
	load    0($i6), $f2
	fsub    $f1, $f2, $f1
	load    1($i8), $f2
	load    5($i2), $i6
	load    1($i6), $f3
	fsub    $f2, $f3, $f2
	load    2($i8), $f3
	load    5($i2), $i6
	load    2($i6), $f4
	fsub    $f3, $f4, $f3
	add     $i9, $i1, $i12
	load    0($i12), $i1
	load    1($i2), $i6
	li      1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.24819
	mov     $i4, $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i2, $i1
	mov     $i10, $i2
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24821, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24821:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       be_cont.24820
be_else.24819:
	li      2, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.24822
	load    0($i1), $f4
	li      l.14001, $i2
	load    0($i2), $f5
	fcmp    $f5, $f4, $i12
	bg      $i12, ble_else.24824
	li      0, $i2
	b       ble_cont.24825
ble_else.24824:
	li      1, $i2
ble_cont.24825:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24826
	li      0, $i1
	b       be_cont.24827
be_else.24826:
	load    1($i1), $f4
	fmul    $f4, $f1, $f1
	load    2($i1), $f4
	fmul    $f4, $f2, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i5)
	li      1, $i1
be_cont.24827:
	b       be_cont.24823
be_else.24822:
	load    0($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.24828, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.24828:
	sub     $sp, 11, $sp
	load    10($sp), $ra
be_cont.24823:
be_cont.24820:
	load    6($sp), $i2
	load    0($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24829
	li      0, $i1
	b       be_cont.24830
be_else.24829:
	li      l.14235, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24831
	li      0, $i1
	b       ble_cont.24832
ble_else.24831:
	li      1, $i1
ble_cont.24832:
be_cont.24830:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24833
	load    9($sp), $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24834
	li      0, $i1
	ret
be_else.24834:
	load    4($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.24833:
	li      l.14237, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	load    8($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    2($sp), $i2
	load    0($i2), $f3
	fadd    $f2, $f3, $f2
	load    1($i1), $f3
	fmul    $f3, $f1, $f3
	load    1($i2), $f4
	fadd    $f3, $f4, $f3
	load    2($i1), $f4
	fmul    $f4, $f1, $f1
	load    2($i2), $f4
	fadd    $f1, $f4, $f1
	load    7($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24835
	li      1, $i1
	b       be_cont.24836
be_else.24835:
	store   $f1, 10($sp)
	store   $f3, 11($sp)
	store   $f2, 12($sp)
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     is_outside.3056
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24837
	li      1, $i1
	load    12($sp), $f1
	load    11($sp), $f2
	load    10($sp), $f3
	load    7($sp), $i2
	load    1($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.24839, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.24839:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	b       be_cont.24838
be_else.24837:
	li      0, $i1
be_cont.24838:
be_cont.24836:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24840
	load    4($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.24840:
	li      1, $i1
	ret
shadow_check_one_or_group.3070:
	load    2($i11), $i3
	load    1($i11), $i4
	add     $i2, $i1, $i12
	load    0($i12), $i5
	li      -1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.24841
	li      0, $i1
	ret
be_else.24841:
	store   $i11, 0($sp)
	store   $i3, 1($sp)
	store   $i4, 2($sp)
	store   $i2, 3($sp)
	store   $i1, 4($sp)
	add     $i4, $i5, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i3, $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.24842, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.24842:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24843
	load    4($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24844
	li      0, $i1
	ret
be_else.24844:
	store   $i1, 5($sp)
	load    2($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.24845, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.24845:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24846
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24847
	li      0, $i1
	ret
be_else.24847:
	store   $i1, 6($sp)
	load    2($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.24848, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.24848:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24849
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24850
	li      0, $i1
	ret
be_else.24850:
	store   $i1, 7($sp)
	load    2($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.24851, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.24851:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24852
	load    7($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.24852:
	li      1, $i1
	ret
be_else.24849:
	li      1, $i1
	ret
be_else.24846:
	li      1, $i1
	ret
be_else.24843:
	li      1, $i1
	ret
shadow_check_one_or_matrix.3073:
	load    10($i11), $i3
	store   $i3, 0($sp)
	load    9($i11), $i3
	store   $i3, 1($sp)
	load    8($i11), $i3
	store   $i3, 2($sp)
	load    7($i11), $i3
	store   $i3, 3($sp)
	load    6($i11), $i3
	load    5($i11), $i4
	load    4($i11), $i5
	load    3($i11), $i6
	load    2($i11), $i7
	load    1($i11), $i8
	add     $i2, $i1, $i12
	load    0($i12), $i9
	load    0($i9), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.24853
	li      0, $i1
	ret
be_else.24853:
	store   $i3, 4($sp)
	store   $i4, 5($sp)
	store   $i8, 6($sp)
	store   $i9, 7($sp)
	store   $i2, 8($sp)
	store   $i11, 9($sp)
	store   $i1, 10($sp)
	li      99, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.24854
	li      1, $i1
	b       be_cont.24855
be_else.24854:
	add     $i5, $i10, $i12
	load    0($i12), $i1
	load    0($i6), $f1
	load    5($i1), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	load    1($i6), $f2
	load    5($i1), $i2
	load    1($i2), $f3
	fsub    $f2, $f3, $f2
	load    2($i6), $f3
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f3, $f4, $f3
	add     $i7, $i10, $i12
	load    0($i12), $i3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24856
	load    0($sp), $i2
	load    2($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24858, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24858:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       be_cont.24857
be_else.24856:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24859
	load    0($i3), $f4
	li      l.14001, $i1
	load    0($i1), $f5
	fcmp    $f5, $f4, $i12
	bg      $i12, ble_else.24861
	li      0, $i1
	b       ble_cont.24862
ble_else.24861:
	li      1, $i1
ble_cont.24862:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24863
	li      0, $i1
	b       be_cont.24864
be_else.24863:
	load    1($i3), $f4
	fmul    $f4, $f1, $f1
	load    2($i3), $f4
	fmul    $f4, $f2, $f2
	fadd    $f1, $f2, $f1
	load    3($i3), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.24864:
	b       be_cont.24860
be_else.24859:
	load    1($sp), $i11
	mov     $i3, $i2
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24865, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24865:
	sub     $sp, 12, $sp
	load    11($sp), $ra
be_cont.24860:
be_cont.24857:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24866
	li      0, $i1
	b       be_cont.24867
be_else.24866:
	load    3($sp), $i1
	load    0($i1), $f1
	li      l.14240, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24868
	li      0, $i1
	b       ble_cont.24869
ble_else.24868:
	li      1, $i1
ble_cont.24869:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24870
	li      0, $i1
	b       be_cont.24871
be_else.24870:
	load    7($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24872
	li      0, $i1
	b       be_cont.24873
be_else.24872:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24874, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24874:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24875
	load    7($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24877
	li      0, $i1
	b       be_cont.24878
be_else.24877:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24879, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24879:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24880
	load    7($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24882
	li      0, $i1
	b       be_cont.24883
be_else.24882:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24884, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24884:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24885
	li      4, $i1
	load    7($sp), $i2
	load    4($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24887, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24887:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       be_cont.24886
be_else.24885:
	li      1, $i1
be_cont.24886:
be_cont.24883:
	b       be_cont.24881
be_else.24880:
	li      1, $i1
be_cont.24881:
be_cont.24878:
	b       be_cont.24876
be_else.24875:
	li      1, $i1
be_cont.24876:
be_cont.24873:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24888
	li      0, $i1
	b       be_cont.24889
be_else.24888:
	li      1, $i1
be_cont.24889:
be_cont.24871:
be_cont.24867:
be_cont.24855:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24890
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    8($sp), $i2
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.24890:
	load    7($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24891
	li      0, $i1
	b       be_cont.24892
be_else.24891:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24893, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24893:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24894
	load    7($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24896
	li      0, $i1
	b       be_cont.24897
be_else.24896:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24898, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24898:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24899
	load    7($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24901
	li      0, $i1
	b       be_cont.24902
be_else.24901:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24903, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24903:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24904
	li      4, $i1
	load    7($sp), $i2
	load    4($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.24906, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.24906:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       be_cont.24905
be_else.24904:
	li      1, $i1
be_cont.24905:
be_cont.24902:
	b       be_cont.24900
be_else.24899:
	li      1, $i1
be_cont.24900:
be_cont.24897:
	b       be_cont.24895
be_else.24894:
	li      1, $i1
be_cont.24895:
be_cont.24892:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24907
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    8($sp), $i2
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.24907:
	li      1, $i1
	ret
solve_each_element.3076:
	load    11($i11), $i4
	load    10($i11), $i5
	load    9($i11), $i6
	store   $i6, 0($sp)
	load    8($i11), $i6
	store   $i6, 1($sp)
	load    7($i11), $i6
	load    6($i11), $i7
	load    5($i11), $i8
	load    4($i11), $i9
	store   $i9, 2($sp)
	load    3($i11), $i9
	load    2($i11), $i10
	store   $i10, 3($sp)
	load    1($i11), $i10
	store   $i10, 4($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.24908
	ret
be_else.24908:
	store   $i5, 5($sp)
	store   $i7, 6($sp)
	store   $i3, 7($sp)
	store   $i2, 8($sp)
	store   $i11, 9($sp)
	store   $i1, 10($sp)
	store   $i10, 11($sp)
	store   $i8, 12($sp)
	store   $i4, 13($sp)
	store   $i9, 14($sp)
	add     $i8, $i10, $i12
	load    0($i12), $i1
	load    0($i5), $f1
	load    5($i1), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	load    1($i5), $f2
	load    5($i1), $i2
	load    1($i2), $f3
	fsub    $f2, $f3, $f2
	load    2($i5), $f3
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f3, $f4, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24910
	store   $f1, 15($sp)
	store   $f3, 16($sp)
	store   $f2, 17($sp)
	store   $i1, 18($sp)
	store   $i6, 19($sp)
	li      0, $i2
	li      1, $i4
	li      2, $i5
	mov     $i6, $i11
	mov     $i3, $i10
	mov     $i2, $i3
	mov     $i10, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24912, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24912:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24913
	li      1, $i3
	li      2, $i4
	li      0, $i5
	load    17($sp), $f1
	load    16($sp), $f2
	load    15($sp), $f3
	load    18($sp), $i1
	load    7($sp), $i2
	load    19($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24915, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24915:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24916
	li      2, $i3
	li      0, $i4
	li      1, $i5
	load    16($sp), $f1
	load    15($sp), $f2
	load    17($sp), $f3
	load    18($sp), $i1
	load    7($sp), $i2
	load    19($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24918, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24918:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24919
	li      0, $i1
	b       be_cont.24920
be_else.24919:
	li      3, $i1
be_cont.24920:
	b       be_cont.24917
be_else.24916:
	li      2, $i1
be_cont.24917:
	b       be_cont.24914
be_else.24913:
	li      1, $i1
be_cont.24914:
	b       be_cont.24911
be_else.24910:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24921
	load    0($sp), $i11
	mov     $i3, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24923, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24923:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	b       be_cont.24922
be_else.24921:
	load    1($sp), $i11
	mov     $i3, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24924, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24924:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.24922:
be_cont.24911:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24925
	load    11($sp), $i1
	load    12($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24926
	ret
be_else.24926:
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    8($sp), $i2
	load    7($sp), $i3
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.24925:
	load    6($sp), $i2
	load    0($i2), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.24928
	li      0, $i2
	b       ble_cont.24929
ble_else.24928:
	li      1, $i2
ble_cont.24929:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24930
	b       be_cont.24931
be_else.24930:
	load    13($sp), $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24932
	li      0, $i3
	b       ble_cont.24933
ble_else.24932:
	li      1, $i3
ble_cont.24933:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24934
	b       be_cont.24935
be_else.24934:
	store   $i1, 20($sp)
	li      l.14237, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 21($sp)
	load    7($sp), $i3
	load    0($i3), $f2
	fmul    $f2, $f1, $f2
	load    5($sp), $i1
	load    0($i1), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 22($sp)
	load    1($i3), $f3
	fmul    $f3, $f1, $f3
	load    1($i1), $f4
	fadd    $f3, $f4, $f3
	store   $f3, 23($sp)
	load    2($i3), $f4
	fmul    $f4, $f1, $f1
	load    2($i1), $f4
	fadd    $f1, $f4, $f1
	store   $f1, 24($sp)
	load    8($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24936
	li      1, $i1
	b       be_cont.24937
be_else.24936:
	load    12($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     is_outside.3056
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24938
	li      1, $i1
	load    22($sp), $f1
	load    23($sp), $f2
	load    24($sp), $f3
	load    8($sp), $i2
	load    4($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.24940, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.24940:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	b       be_cont.24939
be_else.24938:
	li      0, $i1
be_cont.24939:
be_cont.24937:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24941
	b       be_cont.24942
be_else.24941:
	load    13($sp), $i1
	load    21($sp), $f1
	store   $f1, 0($i1)
	load    14($sp), $i1
	load    22($sp), $f1
	store   $f1, 0($i1)
	load    23($sp), $f1
	store   $f1, 1($i1)
	load    24($sp), $f1
	store   $f1, 2($i1)
	load    3($sp), $i1
	load    11($sp), $i2
	store   $i2, 0($i1)
	load    2($sp), $i1
	load    20($sp), $i2
	store   $i2, 0($i1)
be_cont.24942:
be_cont.24935:
be_cont.24931:
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    8($sp), $i2
	load    7($sp), $i3
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_one_or_network.3080:
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i2, $i1, $i12
	load    0($i12), $i6
	li      -1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.24943
	ret
be_else.24943:
	store   $i11, 0($sp)
	store   $i3, 1($sp)
	store   $i4, 2($sp)
	store   $i5, 3($sp)
	store   $i2, 4($sp)
	store   $i1, 5($sp)
	add     $i5, $i6, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.24945, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.24945:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24946
	ret
be_else.24946:
	store   $i1, 6($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.24948, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.24948:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24949
	ret
be_else.24949:
	store   $i1, 7($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.24951, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.24951:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.24952
	ret
be_else.24952:
	store   $i1, 8($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.24954, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.24954:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	load    1($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
trace_or_matrix.3084:
	load    11($i11), $i4
	store   $i4, 0($sp)
	load    10($i11), $i4
	load    9($i11), $i5
	store   $i5, 1($sp)
	load    8($i11), $i5
	store   $i5, 2($sp)
	load    7($i11), $i5
	store   $i5, 3($sp)
	load    6($i11), $i5
	store   $i5, 4($sp)
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	store   $i8, 5($sp)
	load    1($i11), $i8
	add     $i2, $i1, $i12
	load    0($i12), $i9
	load    0($i9), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.24955
	ret
be_else.24955:
	store   $i4, 6($sp)
	store   $i5, 7($sp)
	store   $i6, 8($sp)
	store   $i7, 9($sp)
	store   $i8, 10($sp)
	store   $i3, 11($sp)
	store   $i11, 12($sp)
	store   $i2, 13($sp)
	store   $i1, 14($sp)
	li      99, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.24957
	load    1($i9), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24959
	b       be_cont.24960
be_else.24959:
	store   $i9, 15($sp)
	add     $i8, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i7, $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24961, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24961:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24962
	b       be_cont.24963
be_else.24962:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24964, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24964:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24965
	b       be_cont.24966
be_else.24965:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24967, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24967:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      4, $i1
	load    15($sp), $i2
	load    11($sp), $i3
	load    8($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.24968, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.24968:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.24966:
be_cont.24963:
be_cont.24960:
	b       be_cont.24958
be_else.24957:
	store   $i9, 15($sp)
	load    5($sp), $i1
	add     $i1, $i10, $i12
	load    0($i12), $i1
	load    0($i4), $f1
	load    5($i1), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	load    1($i4), $f2
	load    5($i1), $i2
	load    1($i2), $f3
	fsub    $f2, $f3, $f2
	load    2($i4), $f3
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f3, $f4, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24969
	store   $f1, 16($sp)
	store   $f3, 17($sp)
	store   $f2, 18($sp)
	store   $i1, 19($sp)
	li      0, $i2
	li      1, $i4
	li      2, $i5
	load    3($sp), $i11
	mov     $i3, $i10
	mov     $i2, $i3
	mov     $i10, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24971, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24971:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24972
	li      1, $i3
	li      2, $i4
	li      0, $i5
	load    18($sp), $f1
	load    17($sp), $f2
	load    16($sp), $f3
	load    19($sp), $i1
	load    11($sp), $i2
	load    3($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24974, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24974:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24975
	li      2, $i3
	li      0, $i4
	li      1, $i5
	load    17($sp), $f1
	load    16($sp), $f2
	load    18($sp), $f3
	load    19($sp), $i1
	load    11($sp), $i2
	load    3($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24977, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24977:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24978
	li      0, $i1
	b       be_cont.24979
be_else.24978:
	li      3, $i1
be_cont.24979:
	b       be_cont.24976
be_else.24975:
	li      2, $i1
be_cont.24976:
	b       be_cont.24973
be_else.24972:
	li      1, $i1
be_cont.24973:
	b       be_cont.24970
be_else.24969:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24980
	load    1($sp), $i11
	mov     $i3, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24982, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24982:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	b       be_cont.24981
be_else.24980:
	load    2($sp), $i11
	mov     $i3, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24983, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24983:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.24981:
be_cont.24970:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24984
	b       be_cont.24985
be_else.24984:
	load    4($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.24986
	li      0, $i1
	b       ble_cont.24987
ble_else.24986:
	li      1, $i1
ble_cont.24987:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.24988
	b       be_cont.24989
be_else.24988:
	load    15($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24990
	b       be_cont.24991
be_else.24990:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24992, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24992:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    15($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24993
	b       be_cont.24994
be_else.24993:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24995, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24995:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    15($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.24996
	b       be_cont.24997
be_else.24996:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24998, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24998:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      4, $i1
	load    15($sp), $i2
	load    11($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.24999, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.24999:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.24997:
be_cont.24994:
be_cont.24991:
be_cont.24989:
be_cont.24985:
be_cont.24958:
	load    14($sp), $i1
	add     $i1, 1, $i1
	load    13($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.25000
	ret
be_else.25000:
	store   $i1, 20($sp)
	li      99, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.25002
	load    1($i3), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25004
	b       be_cont.25005
be_else.25004:
	store   $i3, 21($sp)
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25006, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25006:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25007
	b       be_cont.25008
be_else.25007:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25009, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25009:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      3, $i1
	load    21($sp), $i2
	load    11($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25010, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25010:
	sub     $sp, 23, $sp
	load    22($sp), $ra
be_cont.25008:
be_cont.25005:
	b       be_cont.25003
be_else.25002:
	store   $i3, 21($sp)
	load    11($sp), $i2
	load    6($sp), $i3
	load    7($sp), $i11
	mov     $i4, $i1
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25011, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25011:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25012
	b       be_cont.25013
be_else.25012:
	load    4($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25014
	li      0, $i1
	b       ble_cont.25015
ble_else.25014:
	li      1, $i1
ble_cont.25015:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25016
	b       be_cont.25017
be_else.25016:
	load    21($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25018
	b       be_cont.25019
be_else.25018:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25020, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25020:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25021
	b       be_cont.25022
be_else.25021:
	load    10($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i3
	load    9($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25023, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25023:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      3, $i1
	load    21($sp), $i2
	load    11($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25024, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25024:
	sub     $sp, 23, $sp
	load    22($sp), $ra
be_cont.25022:
be_cont.25019:
be_cont.25017:
be_cont.25013:
be_cont.25003:
	load    20($sp), $i1
	add     $i1, 1, $i1
	load    13($sp), $i2
	load    11($sp), $i3
	load    12($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_each_element_fast.3090:
	load    10($i11), $i4
	load    9($i11), $i5
	load    8($i11), $i6
	store   $i6, 0($sp)
	load    7($i11), $i6
	load    6($i11), $i7
	load    5($i11), $i8
	load    4($i11), $i9
	store   $i9, 1($sp)
	load    3($i11), $i9
	store   $i9, 2($sp)
	load    2($i11), $i9
	store   $i9, 3($sp)
	load    1($i11), $i9
	store   $i9, 4($sp)
	load    0($i3), $i9
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.25025
	ret
be_else.25025:
	store   $i7, 5($sp)
	store   $i3, 6($sp)
	store   $i2, 7($sp)
	store   $i11, 8($sp)
	store   $i1, 9($sp)
	store   $i10, 10($sp)
	store   $i8, 11($sp)
	store   $i4, 12($sp)
	store   $i9, 13($sp)
	store   $i5, 14($sp)
	add     $i8, $i10, $i12
	load    0($i12), $i1
	load    10($i1), $i2
	store   $i2, 15($sp)
	load    0($i2), $f1
	load    1($i2), $f2
	load    2($i2), $f3
	load    1($i3), $i2
	add     $i2, $i10, $i12
	load    0($i12), $i2
	load    1($i1), $i4
	li      1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.25027
	load    0($i3), $i3
	mov     $i6, $i11
	mov     $i3, $i10
	mov     $i2, $i3
	mov     $i10, $i2
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25029, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25029:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	b       be_cont.25028
be_else.25027:
	li      2, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.25030
	load    0($i2), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25032
	li      0, $i1
	b       ble_cont.25033
ble_else.25032:
	li      1, $i1
ble_cont.25033:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25034
	li      0, $i1
	b       be_cont.25035
be_else.25034:
	load    0($i2), $f1
	load    15($sp), $i1
	load    3($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 0($i7)
	li      1, $i1
be_cont.25035:
	b       be_cont.25031
be_else.25030:
	load    15($sp), $i3
	load    0($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25036, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25036:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.25031:
be_cont.25028:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25037
	load    10($sp), $i1
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25038
	ret
be_else.25038:
	load    9($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    6($sp), $i3
	load    8($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.25037:
	load    5($sp), $i2
	load    0($i2), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25040
	li      0, $i2
	b       ble_cont.25041
ble_else.25040:
	li      1, $i2
ble_cont.25041:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25042
	b       be_cont.25043
be_else.25042:
	load    12($sp), $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25044
	li      0, $i3
	b       ble_cont.25045
ble_else.25044:
	li      1, $i3
ble_cont.25045:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25046
	b       be_cont.25047
be_else.25046:
	store   $i1, 16($sp)
	li      l.14237, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 17($sp)
	load    13($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    14($sp), $i2
	load    0($i2), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 18($sp)
	load    1($i1), $f3
	fmul    $f3, $f1, $f3
	load    1($i2), $f4
	fadd    $f3, $f4, $f3
	store   $f3, 19($sp)
	load    2($i1), $f4
	fmul    $f4, $f1, $f1
	load    2($i2), $f4
	fadd    $f1, $f4, $f1
	store   $f1, 20($sp)
	load    7($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25048
	li      1, $i1
	b       be_cont.25049
be_else.25048:
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     is_outside.3056
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25050
	li      1, $i1
	load    18($sp), $f1
	load    19($sp), $f2
	load    20($sp), $f3
	load    7($sp), $i2
	load    4($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.25052, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.25052:
	sub     $sp, 22, $sp
	load    21($sp), $ra
	b       be_cont.25051
be_else.25050:
	li      0, $i1
be_cont.25051:
be_cont.25049:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25053
	b       be_cont.25054
be_else.25053:
	load    12($sp), $i1
	load    17($sp), $f1
	store   $f1, 0($i1)
	load    2($sp), $i1
	load    18($sp), $f1
	store   $f1, 0($i1)
	load    19($sp), $f1
	store   $f1, 1($i1)
	load    20($sp), $f1
	store   $f1, 2($i1)
	load    3($sp), $i1
	load    10($sp), $i2
	store   $i2, 0($i1)
	load    1($sp), $i1
	load    16($sp), $i2
	store   $i2, 0($i1)
be_cont.25054:
be_cont.25047:
be_cont.25043:
	load    9($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    6($sp), $i3
	load    8($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_one_or_network_fast.3094:
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i2, $i1, $i12
	load    0($i12), $i6
	li      -1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.25055
	ret
be_else.25055:
	store   $i11, 0($sp)
	store   $i3, 1($sp)
	store   $i4, 2($sp)
	store   $i5, 3($sp)
	store   $i2, 4($sp)
	store   $i1, 5($sp)
	add     $i5, $i6, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25057, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25057:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25058
	ret
be_else.25058:
	store   $i1, 6($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.25060, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.25060:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25061
	ret
be_else.25061:
	store   $i1, 7($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.25063, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.25063:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25064
	ret
be_else.25064:
	store   $i1, 8($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25066, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25066:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	load    1($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
trace_or_matrix_fast.3098:
	load    9($i11), $i4
	store   $i4, 0($sp)
	load    8($i11), $i4
	store   $i4, 1($sp)
	load    7($i11), $i4
	store   $i4, 2($sp)
	load    6($i11), $i4
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	store   $i8, 3($sp)
	load    1($i11), $i8
	add     $i2, $i1, $i12
	load    0($i12), $i9
	load    0($i9), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.25067
	ret
be_else.25067:
	store   $i5, 4($sp)
	store   $i4, 5($sp)
	store   $i6, 6($sp)
	store   $i7, 7($sp)
	store   $i8, 8($sp)
	store   $i3, 9($sp)
	store   $i11, 10($sp)
	store   $i2, 11($sp)
	store   $i1, 12($sp)
	li      99, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.25069
	load    1($i9), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25071
	b       be_cont.25072
be_else.25071:
	store   $i9, 13($sp)
	add     $i8, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i7, $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25073, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25073:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25074
	b       be_cont.25075
be_else.25074:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25076, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25076:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25077
	b       be_cont.25078
be_else.25077:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25079, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25079:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      4, $i1
	load    13($sp), $i2
	load    9($sp), $i3
	load    6($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25080, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25080:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25078:
be_cont.25075:
be_cont.25072:
	b       be_cont.25070
be_else.25069:
	store   $i9, 13($sp)
	load    3($sp), $i1
	add     $i1, $i10, $i12
	load    0($i12), $i1
	load    10($i1), $i2
	load    0($i2), $f1
	load    1($i2), $f2
	load    2($i2), $f3
	load    1($i3), $i4
	add     $i4, $i10, $i12
	load    0($i12), $i4
	load    1($i1), $i6
	li      1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.25081
	load    0($i3), $i2
	load    2($sp), $i11
	mov     $i4, $i3
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25083, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25083:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       be_cont.25082
be_else.25081:
	li      2, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.25084
	load    0($i4), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25086
	li      0, $i1
	b       ble_cont.25087
ble_else.25086:
	li      1, $i1
ble_cont.25087:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25088
	li      0, $i1
	b       be_cont.25089
be_else.25088:
	load    0($i4), $f1
	load    3($i2), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 0($i5)
	li      1, $i1
be_cont.25089:
	b       be_cont.25085
be_else.25084:
	load    1($sp), $i11
	mov     $i2, $i3
	mov     $i4, $i2
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25090, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25090:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25085:
be_cont.25082:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25091
	b       be_cont.25092
be_else.25091:
	load    4($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25093
	li      0, $i1
	b       ble_cont.25094
ble_else.25093:
	li      1, $i1
ble_cont.25094:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25095
	b       be_cont.25096
be_else.25095:
	load    13($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25097
	b       be_cont.25098
be_else.25097:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25099, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25099:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25100
	b       be_cont.25101
be_else.25100:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25102, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25102:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25103
	b       be_cont.25104
be_else.25103:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25105, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25105:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      4, $i1
	load    13($sp), $i2
	load    9($sp), $i3
	load    6($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25106, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25106:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25104:
be_cont.25101:
be_cont.25098:
be_cont.25096:
be_cont.25092:
be_cont.25070:
	load    12($sp), $i1
	add     $i1, 1, $i1
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.25107
	ret
be_else.25107:
	store   $i1, 14($sp)
	li      99, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.25109
	load    1($i3), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25111
	b       be_cont.25112
be_else.25111:
	store   $i3, 15($sp)
	load    8($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25113, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25113:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25114
	b       be_cont.25115
be_else.25114:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25116, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25116:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      3, $i1
	load    15($sp), $i2
	load    9($sp), $i3
	load    6($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25117, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25117:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.25115:
be_cont.25112:
	b       be_cont.25110
be_else.25109:
	store   $i3, 15($sp)
	load    9($sp), $i2
	load    5($sp), $i11
	mov     $i4, $i1
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25118, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25118:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25119
	b       be_cont.25120
be_else.25119:
	load    4($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25121
	li      0, $i1
	b       ble_cont.25122
ble_else.25121:
	li      1, $i1
ble_cont.25122:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25123
	b       be_cont.25124
be_else.25123:
	load    15($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25125
	b       be_cont.25126
be_else.25125:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25127, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25127:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25128
	b       be_cont.25129
be_else.25128:
	load    8($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    9($sp), $i3
	load    7($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25130, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25130:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      3, $i1
	load    15($sp), $i2
	load    9($sp), $i3
	load    6($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25131, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25131:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.25129:
be_cont.25126:
be_cont.25124:
be_cont.25120:
be_cont.25110:
	load    14($sp), $i1
	add     $i1, 1, $i1
	load    11($sp), $i2
	load    9($sp), $i3
	load    10($sp), $i11
	load    0($i11), $i10
	jr      $i10
judge_intersection_fast.3102:
	load    8($i11), $i2
	load    7($i11), $i3
	store   $i3, 0($sp)
	load    6($i11), $i4
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	load    1($i11), $i9
	li      l.14248, $i10
	load    0($i10), $f1
	store   $f1, 0($i3)
	load    0($i8), $i8
	load    0($i8), $i10
	load    0($i10), $i11
	li      -1, $i12
	cmp     $i11, $i12, $i12
	bne     $i12, be_else.25132
	b       be_cont.25133
be_else.25132:
	store   $i1, 1($sp)
	store   $i8, 2($sp)
	store   $i2, 3($sp)
	li      99, $i12
	cmp     $i11, $i12, $i12
	bne     $i12, be_else.25134
	load    1($i10), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25136
	b       be_cont.25137
be_else.25136:
	store   $i6, 4($sp)
	store   $i7, 5($sp)
	store   $i9, 6($sp)
	store   $i10, 7($sp)
	add     $i9, $i2, $i12
	load    0($i12), $i2
	li      0, $i3
	mov     $i7, $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.25138, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.25138:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25139
	b       be_cont.25140
be_else.25139:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    5($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.25141, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.25141:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      3, $i1
	load    7($sp), $i2
	load    1($sp), $i3
	load    4($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.25142, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.25142:
	sub     $sp, 9, $sp
	load    8($sp), $ra
be_cont.25140:
be_cont.25137:
	b       be_cont.25135
be_else.25134:
	store   $i6, 4($sp)
	store   $i7, 5($sp)
	store   $i9, 6($sp)
	store   $i10, 7($sp)
	store   $i5, 8($sp)
	mov     $i1, $i2
	mov     $i11, $i1
	mov     $i4, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25143, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25143:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25144
	b       be_cont.25145
be_else.25144:
	load    8($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25146
	li      0, $i1
	b       ble_cont.25147
ble_else.25146:
	li      1, $i1
ble_cont.25147:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25148
	b       be_cont.25149
be_else.25148:
	load    7($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25150
	b       be_cont.25151
be_else.25150:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    5($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25152, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25152:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    7($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25153
	b       be_cont.25154
be_else.25153:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    5($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25155, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25155:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      3, $i1
	load    7($sp), $i2
	load    1($sp), $i3
	load    4($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25156, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25156:
	sub     $sp, 10, $sp
	load    9($sp), $ra
be_cont.25154:
be_cont.25151:
be_cont.25149:
be_cont.25145:
be_cont.25135:
	li      1, $i1
	load    2($sp), $i2
	load    1($sp), $i3
	load    3($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25157, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25157:
	sub     $sp, 10, $sp
	load    9($sp), $ra
be_cont.25133:
	load    0($sp), $i1
	load    0($i1), $f1
	li      l.14240, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25158
	li      0, $i1
	b       ble_cont.25159
ble_else.25158:
	li      1, $i1
ble_cont.25159:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25160
	li      0, $i1
	ret
be_else.25160:
	li      l.14251, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25161
	li      0, $i1
	ret
ble_else.25161:
	li      1, $i1
	ret
get_nvector_second.3108:
	load    2($i11), $i2
	load    1($i11), $i3
	load    0($i3), $f1
	load    5($i1), $i4
	load    0($i4), $f2
	fsub    $f1, $f2, $f1
	load    1($i3), $f2
	load    5($i1), $i4
	load    1($i4), $f3
	fsub    $f2, $f3, $f2
	load    2($i3), $f3
	load    5($i1), $i3
	load    2($i3), $f4
	fsub    $f3, $f4, $f3
	load    4($i1), $i3
	load    0($i3), $f4
	fmul    $f1, $f4, $f4
	load    4($i1), $i3
	load    1($i3), $f5
	fmul    $f2, $f5, $f5
	load    4($i1), $i3
	load    2($i3), $f6
	fmul    $f3, $f6, $f6
	load    3($i1), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25162
	store   $f4, 0($i2)
	store   $f5, 1($i2)
	store   $f6, 2($i2)
	b       be_cont.25163
be_else.25162:
	load    9($i1), $i3
	load    2($i3), $f7
	fmul    $f2, $f7, $f7
	load    9($i1), $i3
	load    1($i3), $f8
	fmul    $f3, $f8, $f8
	fadd    $f7, $f8, $f7
	li      l.14050, $i3
	load    0($i3), $f8
	finv    $f8, $f15
	fmul    $f7, $f15, $f7
	fadd    $f4, $f7, $f4
	store   $f4, 0($i2)
	load    9($i1), $i3
	load    2($i3), $f4
	fmul    $f1, $f4, $f4
	load    9($i1), $i3
	load    0($i3), $f7
	fmul    $f3, $f7, $f3
	fadd    $f4, $f3, $f3
	li      l.14050, $i3
	load    0($i3), $f4
	finv    $f4, $f15
	fmul    $f3, $f15, $f3
	fadd    $f5, $f3, $f3
	store   $f3, 1($i2)
	load    9($i1), $i3
	load    1($i3), $f3
	fmul    $f1, $f3, $f1
	load    9($i1), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14050, $i3
	load    0($i3), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	fadd    $f6, $f1, $f1
	store   $f1, 2($i2)
be_cont.25163:
	load    6($i1), $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	b       vecunit_sgn.2816
get_nvector.3110:
	load    3($i11), $i3
	load    2($i11), $i4
	load    1($i11), $i11
	load    1($i1), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25164
	load    0($i4), $i1
	li      l.14001, $i4
	load    0($i4), $f1
	store   $f1, 0($i3)
	store   $f1, 1($i3)
	store   $f1, 2($i3)
	sub     $i1, 1, $i4
	sub     $i1, 1, $i1
	add     $i2, $i1, $i12
	load    0($i12), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.25165
	li      1, $i1
	b       be_cont.25166
be_else.25165:
	li      0, $i1
be_cont.25166:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25167
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25169
	li      0, $i1
	b       ble_cont.25170
ble_else.25169:
	li      1, $i1
ble_cont.25170:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25171
	li      l.14099, $i1
	load    0($i1), $f1
	b       be_cont.25172
be_else.25171:
	li      l.14035, $i1
	load    0($i1), $f1
be_cont.25172:
	b       be_cont.25168
be_else.25167:
	li      l.14001, $i1
	load    0($i1), $f1
be_cont.25168:
	fneg    $f1, $f1
	add     $i3, $i4, $i12
	store   $f1, 0($i12)
	ret
be_else.25164:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25174
	load    4($i1), $i2
	load    0($i2), $f1
	fneg    $f1, $f1
	store   $f1, 0($i3)
	load    4($i1), $i2
	load    1($i2), $f1
	fneg    $f1, $f1
	store   $f1, 1($i3)
	load    4($i1), $i1
	load    2($i1), $f1
	fneg    $f1, $f1
	store   $f1, 2($i3)
	ret
be_else.25174:
	load    0($i11), $i10
	jr      $i10
utexture.3113:
	load    9($i11), $i3
	load    8($i11), $i4
	load    7($i11), $f1
	load    6($i11), $f2
	load    5($i11), $f3
	load    4($i11), $i5
	load    3($i11), $i6
	load    2($i11), $i7
	load    1($i11), $i8
	load    0($i1), $i9
	load    8($i1), $i10
	load    0($i10), $f4
	store   $f4, 0($i3)
	load    8($i1), $i10
	load    1($i10), $f4
	store   $f4, 1($i3)
	load    8($i1), $i10
	load    2($i10), $f4
	store   $f4, 2($i3)
	li      1, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.25176
	store   $i3, 0($sp)
	store   $i1, 1($sp)
	store   $i2, 2($sp)
	load    0($i2), $f1
	load    5($i1), $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 3($sp)
	li      l.14301, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_floor
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      l.14303, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.14288, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25177
	li      0, $i1
	b       ble_cont.25178
ble_else.25177:
	li      1, $i1
ble_cont.25178:
	store   $i1, 4($sp)
	load    2($sp), $i1
	load    2($i1), $f1
	load    1($sp), $i1
	load    5($i1), $i1
	load    2($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 5($sp)
	li      l.14301, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_floor
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.14303, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    5($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.14288, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25179
	li      0, $i1
	b       ble_cont.25180
ble_else.25179:
	li      1, $i1
ble_cont.25180:
	load    4($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25181
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25183
	li      l.14284, $i1
	load    0($i1), $f1
	b       be_cont.25184
be_else.25183:
	li      l.14001, $i1
	load    0($i1), $f1
be_cont.25184:
	b       be_cont.25182
be_else.25181:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25185
	li      l.14001, $i1
	load    0($i1), $f1
	b       be_cont.25186
be_else.25185:
	li      l.14284, $i1
	load    0($i1), $f1
be_cont.25186:
be_cont.25182:
	load    0($sp), $i1
	store   $f1, 1($i1)
	ret
be_else.25176:
	li      2, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.25188
	store   $i3, 0($sp)
	load    1($i2), $f4
	li      l.14295, $i1
	load    0($i1), $f5
	fmul    $f4, $f5, $f4
	li      l.14001, $i1
	load    0($i1), $f5
	fcmp    $f5, $f4, $i12
	bg      $i12, ble_else.25189
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.25191
	fcmp    $f3, $f4, $i12
	bg      $i12, ble_else.25193
	fcmp    $f2, $f4, $i12
	bg      $i12, ble_else.25195
	fsub    $f4, $f2, $f1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25197, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25197:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	b       ble_cont.25196
ble_else.25195:
	fsub    $f2, $f4, $f1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25198, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25198:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	fneg    $f1, $f1
ble_cont.25196:
	b       ble_cont.25194
ble_else.25193:
	fsub    $f3, $f4, $f1
	mov     $i6, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25199, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25199:
	sub     $sp, 7, $sp
	load    6($sp), $ra
ble_cont.25194:
	b       ble_cont.25192
ble_else.25191:
	mov     $i6, $i11
	mov     $f4, $f1
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25200, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25200:
	sub     $sp, 7, $sp
	load    6($sp), $ra
ble_cont.25192:
	b       ble_cont.25190
ble_else.25189:
	fneg    $f4, $f1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25201, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25201:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	fneg    $f1, $f1
ble_cont.25190:
	fmul    $f1, $f1, $f1
	li      l.14284, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    0($sp), $i1
	store   $f2, 0($i1)
	li      l.14284, $i2
	load    0($i2), $f2
	li      l.14035, $i2
	load    0($i2), $f3
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	store   $f1, 1($i1)
	ret
be_else.25188:
	li      3, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.25203
	store   $i7, 6($sp)
	store   $i3, 0($sp)
	store   $i5, 7($sp)
	store   $f2, 8($sp)
	store   $f3, 9($sp)
	store   $f1, 10($sp)
	load    0($i2), $f1
	load    5($i1), $i3
	load    0($i3), $f2
	fsub    $f1, $f2, $f1
	load    2($i2), $f2
	load    5($i1), $i1
	load    2($i1), $f3
	fsub    $f2, $f3, $f2
	fmul    $f1, $f1, $f1
	fmul    $f2, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2751
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      l.14288, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_floor
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.14270, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25204
	load    10($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25206
	load    9($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25208
	load    8($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25210
	fsub    $f1, $f2, $f1
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.25212, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.25212:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	b       ble_cont.25211
ble_else.25210:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.25213, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.25213:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.25211:
	b       ble_cont.25209
ble_else.25208:
	fsub    $f2, $f1, $f1
	load    6($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.25214, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.25214:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.25209:
	b       ble_cont.25207
ble_else.25206:
	load    6($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.25215, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.25215:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.25207:
	b       ble_cont.25205
ble_else.25204:
	fneg    $f1, $f1
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.25216, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.25216:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.25205:
	fmul    $f1, $f1, $f1
	li      l.14284, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    0($sp), $i1
	store   $f2, 1($i1)
	li      l.14035, $i2
	load    0($i2), $f2
	fsub    $f2, $f1, $f1
	li      l.14284, $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 2($i1)
	ret
be_else.25203:
	li      4, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.25218
	store   $i3, 0($sp)
	store   $i8, 12($sp)
	store   $i1, 1($sp)
	store   $i2, 2($sp)
	load    0($i2), $f1
	load    5($i1), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 13($sp)
	load    4($i1), $i1
	load    0($i1), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     sqrt.2751
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 14($sp)
	load    2($sp), $i1
	load    2($i1), $f1
	load    1($sp), $i1
	load    5($i1), $i2
	load    2($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 15($sp)
	load    4($i1), $i1
	load    2($i1), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     sqrt.2751
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f2, $f1, $f1
	load    14($sp), $f2
	fmul    $f2, $f2, $f3
	fmul    $f1, $f1, $f4
	fadd    $f3, $f4, $f3
	store   $f3, 16($sp)
	li      l.14001, $i1
	load    0($i1), $f3
	fcmp    $f3, $f2, $i12
	bg      $i12, ble_else.25219
	mov     $f2, $f3
	b       ble_cont.25220
ble_else.25219:
	fneg    $f2, $f3
ble_cont.25220:
	li      l.14263, $i1
	load    0($i1), $f4
	fcmp    $f4, $f3, $i12
	bg      $i12, ble_else.25221
	li      0, $i1
	b       ble_cont.25222
ble_else.25221:
	li      1, $i1
ble_cont.25222:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25223
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25225
	b       ble_cont.25226
ble_else.25225:
	fneg    $f1, $f1
ble_cont.25226:
	load    12($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25227, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25227:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      l.14268, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.14270, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.25224
be_else.25223:
	li      l.14265, $i1
	load    0($i1), $f1
be_cont.25224:
	store   $f1, 17($sp)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_floor
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 18($sp)
	load    2($sp), $i1
	load    1($i1), $f1
	load    1($sp), $i1
	load    5($i1), $i2
	load    1($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 19($sp)
	load    4($i1), $i1
	load    1($i1), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     sqrt.2751
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $f2
	fmul    $f2, $f1, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	load    16($sp), $f3
	fcmp    $f2, $f3, $i12
	bg      $i12, ble_else.25228
	mov     $f3, $f2
	b       ble_cont.25229
ble_else.25228:
	fneg    $f3, $f2
ble_cont.25229:
	li      l.14263, $i1
	load    0($i1), $f4
	fcmp    $f4, $f2, $i12
	bg      $i12, ble_else.25230
	li      0, $i1
	b       ble_cont.25231
ble_else.25230:
	li      1, $i1
ble_cont.25231:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25232
	finv    $f3, $f15
	fmul    $f1, $f15, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25234
	b       ble_cont.25235
ble_else.25234:
	fneg    $f1, $f1
ble_cont.25235:
	load    12($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25236, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25236:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      l.14268, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.14270, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.25233
be_else.25232:
	li      l.14265, $i1
	load    0($i1), $f1
be_cont.25233:
	store   $f1, 20($sp)
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_floor
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    20($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.14278, $i1
	load    0($i1), $f2
	li      l.13994, $i1
	load    0($i1), $f3
	load    18($sp), $f4
	fsub    $f3, $f4, $f3
	fmul    $f3, $f3, $f3
	fsub    $f2, $f3, $f2
	li      l.13994, $i1
	load    0($i1), $f3
	fsub    $f3, $f1, $f1
	fmul    $f1, $f1, $f1
	fsub    $f2, $f1, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25237
	li      0, $i1
	b       ble_cont.25238
ble_else.25237:
	li      1, $i1
ble_cont.25238:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25239
	b       be_cont.25240
be_else.25239:
	li      l.14001, $i1
	load    0($i1), $f1
be_cont.25240:
	li      l.14284, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f1
	li      l.14286, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    0($sp), $i1
	store   $f1, 2($i1)
	ret
be_else.25218:
	ret
trace_reflections.3120:
	load    10($i11), $i3
	load    9($i11), $i4
	load    8($i11), $i5
	store   $i5, 0($sp)
	load    7($i11), $i5
	load    6($i11), $i6
	store   $i6, 1($sp)
	load    5($i11), $i6
	load    4($i11), $i7
	load    3($i11), $i8
	load    2($i11), $i9
	load    1($i11), $i10
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25243
	store   $i9, 2($sp)
	store   $i10, 3($sp)
	store   $f2, 4($sp)
	store   $f1, 5($sp)
	store   $i2, 6($sp)
	store   $i11, 7($sp)
	store   $i1, 8($sp)
	store   $i4, 9($sp)
	store   $i7, 10($sp)
	store   $i5, 11($sp)
	store   $i8, 12($sp)
	add     $i6, $i1, $i12
	load    0($i12), $i1
	store   $i1, 13($sp)
	load    1($i1), $i1
	store   $i1, 14($sp)
	li      l.14248, $i2
	load    0($i2), $f1
	store   $f1, 0($i4)
	li      0, $i2
	load    0($i7), $i4
	mov     $i3, $i11
	mov     $i1, $i3
	mov     $i2, $i1
	mov     $i4, $i2
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25244, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25244:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    9($sp), $i1
	load    0($i1), $f1
	li      l.14240, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25245
	li      0, $i1
	b       ble_cont.25246
ble_else.25245:
	li      1, $i1
ble_cont.25246:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25247
	li      0, $i1
	b       be_cont.25248
be_else.25247:
	li      l.14251, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25249
	li      0, $i1
	b       ble_cont.25250
ble_else.25249:
	li      1, $i1
ble_cont.25250:
be_cont.25248:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25251
	b       be_cont.25252
be_else.25251:
	load    3($sp), $i1
	load    0($i1), $i1
	sll     $i1, 2, $i1
	load    2($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	load    13($sp), $i2
	load    0($i2), $i3
	cmp     $i1, $i3, $i12
	bne     $i12, be_else.25253
	li      0, $i1
	load    10($sp), $i2
	load    0($i2), $i2
	load    11($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25255, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25255:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25256
	load    14($sp), $i1
	load    0($i1), $i2
	load    12($sp), $i3
	load    0($i3), $f1
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	load    1($i3), $f2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i3), $f2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    13($sp), $i2
	load    2($i2), $f2
	load    5($sp), $f3
	fmul    $f2, $f3, $f3
	fmul    $f3, $f1, $f1
	load    0($i1), $i1
	load    6($sp), $i2
	load    0($i2), $f3
	load    0($i1), $f4
	fmul    $f3, $f4, $f3
	load    1($i2), $f4
	load    1($i1), $f5
	fmul    $f4, $f5, $f4
	fadd    $f3, $f4, $f3
	load    2($i2), $f4
	load    2($i1), $f5
	fmul    $f4, $f5, $f4
	fadd    $f3, $f4, $f3
	fmul    $f2, $f3, $f2
	li      l.14001, $i1
	load    0($i1), $f3
	fcmp    $f1, $f3, $i12
	bg      $i12, ble_else.25258
	li      0, $i1
	b       ble_cont.25259
ble_else.25258:
	li      1, $i1
ble_cont.25259:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25260
	b       be_cont.25261
be_else.25260:
	load    1($sp), $i1
	load    0($i1), $f3
	load    0($sp), $i2
	load    0($i2), $f4
	fmul    $f1, $f4, $f4
	fadd    $f3, $f4, $f3
	store   $f3, 0($i1)
	load    1($i1), $f3
	load    1($i2), $f4
	fmul    $f1, $f4, $f4
	fadd    $f3, $f4, $f3
	store   $f3, 1($i1)
	load    2($i1), $f3
	load    2($i2), $f4
	fmul    $f1, $f4, $f1
	fadd    $f3, $f1, $f1
	store   $f1, 2($i1)
be_cont.25261:
	li      l.14001, $i1
	load    0($i1), $f1
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25262
	li      0, $i1
	b       ble_cont.25263
ble_else.25262:
	li      1, $i1
ble_cont.25263:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25264
	b       be_cont.25265
be_else.25264:
	fmul    $f2, $f2, $f1
	fmul    $f1, $f1, $f1
	load    4($sp), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $i1
	load    0($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
be_cont.25265:
	b       be_cont.25257
be_else.25256:
be_cont.25257:
	b       be_cont.25254
be_else.25253:
be_cont.25254:
be_cont.25252:
	load    8($sp), $i1
	sub     $i1, 1, $i1
	load    5($sp), $f1
	load    4($sp), $f2
	load    6($sp), $i2
	load    7($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25243:
	ret
trace_ray.3125:
	store   $i11, 0($sp)
	load    21($i11), $i4
	store   $i4, 1($sp)
	load    20($i11), $i4
	store   $i4, 2($sp)
	load    19($i11), $i4
	load    18($i11), $i5
	load    17($i11), $i6
	store   $i6, 3($sp)
	load    16($i11), $i6
	store   $i6, 4($sp)
	load    15($i11), $i6
	store   $i6, 5($sp)
	load    14($i11), $i6
	store   $i6, 6($sp)
	load    13($i11), $i6
	store   $i6, 7($sp)
	load    12($i11), $i6
	load    11($i11), $i7
	load    10($i11), $i8
	store   $i8, 8($sp)
	load    9($i11), $i8
	store   $i8, 9($sp)
	load    8($i11), $i8
	store   $i8, 10($sp)
	load    7($i11), $i8
	store   $i8, 11($sp)
	load    6($i11), $i8
	load    5($i11), $i9
	store   $i9, 12($sp)
	load    4($i11), $i9
	store   $i9, 13($sp)
	load    3($i11), $i9
	load    2($i11), $i10
	load    1($i11), $i11
	li      4, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25267
	store   $f2, 14($sp)
	store   $i9, 15($sp)
	store   $i6, 16($sp)
	store   $i11, 17($sp)
	store   $f1, 18($sp)
	store   $i8, 19($sp)
	store   $i2, 20($sp)
	store   $i1, 21($sp)
	store   $i5, 22($sp)
	store   $i7, 23($sp)
	store   $i3, 24($sp)
	store   $i10, 25($sp)
	load    2($i3), $i1
	store   $i1, 26($sp)
	li      l.14248, $i1
	load    0($i1), $f1
	store   $f1, 0($i5)
	li      0, $i1
	load    0($i7), $i3
	mov     $i4, $i11
	mov     $i3, $i10
	mov     $i2, $i3
	mov     $i10, $i2
	store   $ra, 27($sp)
	load    0($i11), $i10
	li      cls.25268, $ra
	add     $sp, 28, $sp
	jr      $i10
cls.25268:
	sub     $sp, 28, $sp
	load    27($sp), $ra
	load    22($sp), $i1
	load    0($i1), $f1
	li      l.14240, $i2
	load    0($i2), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25269
	li      0, $i2
	b       ble_cont.25270
ble_else.25269:
	li      1, $i2
ble_cont.25270:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25271
	li      0, $i2
	b       be_cont.25272
be_else.25271:
	li      l.14251, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25273
	li      0, $i2
	b       ble_cont.25274
ble_else.25273:
	li      1, $i2
ble_cont.25274:
be_cont.25272:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25275
	li      -1, $i1
	load    21($sp), $i2
	load    26($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25276
	ret
be_else.25276:
	load    20($sp), $i1
	load    0($i1), $f1
	load    19($sp), $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	fneg    $f1, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25278
	li      0, $i1
	b       ble_cont.25279
ble_else.25278:
	li      1, $i1
ble_cont.25279:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25280
	ret
be_else.25280:
	fmul    $f1, $f1, $f2
	fmul    $f2, $f1, $f1
	load    18($sp), $f2
	fmul    $f1, $f2, $f1
	load    17($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    16($sp), $i1
	load    0($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
	ret
be_else.25275:
	load    15($sp), $i1
	load    0($i1), $i1
	store   $i1, 27($sp)
	load    8($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 28($sp)
	load    2($i1), $i2
	store   $i2, 29($sp)
	load    7($i1), $i2
	load    0($i2), $f1
	load    18($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 30($sp)
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25283
	load    12($sp), $i1
	load    0($i1), $i1
	li      l.14001, $i2
	load    0($i2), $f1
	load    9($sp), $i2
	store   $f1, 0($i2)
	store   $f1, 1($i2)
	store   $f1, 2($i2)
	sub     $i1, 1, $i3
	sub     $i1, 1, $i1
	load    20($sp), $i4
	add     $i4, $i1, $i12
	load    0($i12), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.25285
	li      1, $i1
	b       be_cont.25286
be_else.25285:
	li      0, $i1
be_cont.25286:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25287
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25289
	li      0, $i1
	b       ble_cont.25290
ble_else.25289:
	li      1, $i1
ble_cont.25290:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25291
	li      l.14099, $i1
	load    0($i1), $f1
	b       be_cont.25292
be_else.25291:
	li      l.14035, $i1
	load    0($i1), $f1
be_cont.25292:
	b       be_cont.25288
be_else.25287:
	li      l.14001, $i1
	load    0($i1), $f1
be_cont.25288:
	fneg    $f1, $f1
	add     $i2, $i3, $i12
	store   $f1, 0($i12)
	b       be_cont.25284
be_else.25283:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25293
	load    4($i1), $i2
	load    0($i2), $f1
	fneg    $f1, $f1
	load    9($sp), $i2
	store   $f1, 0($i2)
	load    4($i1), $i3
	load    1($i3), $f1
	fneg    $f1, $f1
	store   $f1, 1($i2)
	load    4($i1), $i1
	load    2($i1), $f1
	fneg    $f1, $f1
	store   $f1, 2($i2)
	b       be_cont.25294
be_else.25293:
	load    25($sp), $i11
	store   $ra, 31($sp)
	load    0($i11), $i10
	li      cls.25295, $ra
	add     $sp, 32, $sp
	jr      $i10
cls.25295:
	sub     $sp, 32, $sp
	load    31($sp), $ra
be_cont.25294:
be_cont.25284:
	load    13($sp), $i2
	load    0($i2), $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
	load    1($i2), $f1
	store   $f1, 1($i1)
	load    2($i2), $f1
	store   $f1, 2($i1)
	load    28($sp), $i1
	load    1($sp), $i11
	store   $ra, 31($sp)
	load    0($i11), $i10
	li      cls.25296, $ra
	add     $sp, 32, $sp
	jr      $i10
cls.25296:
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    27($sp), $i1
	sll     $i1, 2, $i1
	load    12($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	load    21($sp), $i2
	load    26($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    24($sp), $i1
	load    1($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    13($sp), $i4
	load    0($i4), $f1
	store   $f1, 0($i3)
	load    1($i4), $f1
	store   $f1, 1($i3)
	load    2($i4), $f1
	store   $f1, 2($i3)
	load    3($i1), $i3
	load    28($sp), $i4
	load    7($i4), $i5
	load    0($i5), $f1
	li      l.13994, $i5
	load    0($i5), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25297
	li      0, $i5
	b       ble_cont.25298
ble_else.25297:
	li      1, $i5
ble_cont.25298:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25299
	li      1, $i5
	add     $i3, $i2, $i12
	store   $i5, 0($i12)
	load    4($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i5
	load    3($sp), $i6
	load    0($i6), $f1
	store   $f1, 0($i5)
	load    1($i6), $f1
	store   $f1, 1($i5)
	load    2($i6), $f1
	store   $f1, 2($i5)
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      l.14328, $i5
	load    0($i5), $f1
	load    30($sp), $f2
	fmul    $f1, $f2, $f1
	load    0($i3), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 0($i3)
	load    1($i3), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 1($i3)
	load    2($i3), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 2($i3)
	load    7($i1), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    9($sp), $i2
	load    0($i2), $f1
	store   $f1, 0($i1)
	load    1($i2), $f1
	store   $f1, 1($i1)
	load    2($i2), $f1
	store   $f1, 2($i1)
	b       be_cont.25300
be_else.25299:
	li      0, $i1
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25300:
	li      l.14330, $i1
	load    0($i1), $f1
	load    20($sp), $i1
	load    0($i1), $f2
	load    9($sp), $i2
	load    0($i2), $f3
	fmul    $f2, $f3, $f2
	load    1($i1), $f3
	load    1($i2), $f4
	fmul    $f3, $f4, $f3
	fadd    $f2, $f3, $f2
	load    2($i1), $f3
	load    2($i2), $f4
	fmul    $f3, $f4, $f3
	fadd    $f2, $f3, $f2
	fmul    $f1, $f2, $f1
	load    0($i1), $f2
	load    0($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f1, $f3, $f1
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
	load    7($i4), $i1
	load    1($i1), $f1
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 31($sp)
	li      0, $i1
	load    23($sp), $i2
	load    0($i2), $i2
	load    6($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.25301, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.25301:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25302
	load    9($sp), $i1
	load    0($i1), $f1
	load    19($sp), $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	fneg    $f1, $f1
	load    30($sp), $f2
	fmul    $f1, $f2, $f1
	load    20($sp), $i1
	load    0($i1), $f2
	load    0($i2), $f3
	fmul    $f2, $f3, $f2
	load    1($i1), $f3
	load    1($i2), $f4
	fmul    $f3, $f4, $f3
	fadd    $f2, $f3, $f2
	load    2($i1), $f3
	load    2($i2), $f4
	fmul    $f3, $f4, $f3
	fadd    $f2, $f3, $f2
	fneg    $f2, $f2
	li      l.14001, $i1
	load    0($i1), $f3
	fcmp    $f1, $f3, $i12
	bg      $i12, ble_else.25304
	li      0, $i1
	b       ble_cont.25305
ble_else.25304:
	li      1, $i1
ble_cont.25305:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25306
	b       be_cont.25307
be_else.25306:
	load    16($sp), $i1
	load    0($i1), $f3
	load    3($sp), $i2
	load    0($i2), $f4
	fmul    $f1, $f4, $f4
	fadd    $f3, $f4, $f3
	store   $f3, 0($i1)
	load    1($i1), $f3
	load    1($i2), $f4
	fmul    $f1, $f4, $f4
	fadd    $f3, $f4, $f3
	store   $f3, 1($i1)
	load    2($i1), $f3
	load    2($i2), $f4
	fmul    $f1, $f4, $f1
	fadd    $f3, $f1, $f1
	store   $f1, 2($i1)
be_cont.25307:
	li      l.14001, $i1
	load    0($i1), $f1
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25308
	li      0, $i1
	b       ble_cont.25309
ble_else.25308:
	li      1, $i1
ble_cont.25309:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25310
	b       be_cont.25311
be_else.25310:
	fmul    $f2, $f2, $f1
	fmul    $f1, $f1, $f1
	load    31($sp), $f2
	fmul    $f1, $f2, $f1
	load    16($sp), $i1
	load    0($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
be_cont.25311:
	b       be_cont.25303
be_else.25302:
be_cont.25303:
	load    13($sp), $i1
	load    0($i1), $f1
	load    4($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    11($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    7($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.25312, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.25312:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    10($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    30($sp), $f1
	load    31($sp), $f2
	load    20($sp), $i2
	load    2($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.25313, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.25313:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	li      l.14334, $i1
	load    0($i1), $f1
	load    18($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25314
	li      0, $i1
	b       ble_cont.25315
ble_else.25314:
	li      1, $i1
ble_cont.25315:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25316
	ret
be_else.25316:
	load    21($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25318
	b       bge_cont.25319
bge_else.25318:
	add     $i1, 1, $i1
	li      -1, $i2
	load    26($sp), $i3
	add     $i3, $i1, $i12
	store   $i2, 0($i12)
bge_cont.25319:
	load    29($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25320
	li      l.14035, $i1
	load    0($i1), $f1
	load    28($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	load    21($sp), $i1
	add     $i1, 1, $i1
	load    22($sp), $i2
	load    0($i2), $f2
	load    14($sp), $f3
	fadd    $f3, $f2, $f2
	load    20($sp), $i2
	load    24($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.25320:
	ret
ble_else.25267:
	ret
trace_diffuse_ray.3131:
	store   $f1, 0($sp)
	store   $i1, 1($sp)
	load    14($i11), $i2
	store   $i2, 2($sp)
	load    13($i11), $i2
	load    12($i11), $i3
	store   $i3, 3($sp)
	load    11($i11), $i4
	store   $i4, 4($sp)
	load    10($i11), $i4
	store   $i4, 5($sp)
	load    9($i11), $i4
	store   $i4, 6($sp)
	load    8($i11), $i5
	store   $i5, 7($sp)
	load    7($i11), $i5
	store   $i5, 8($sp)
	load    6($i11), $i5
	store   $i5, 9($sp)
	load    5($i11), $i5
	store   $i5, 10($sp)
	load    4($i11), $i5
	store   $i5, 11($sp)
	load    3($i11), $i5
	store   $i5, 12($sp)
	load    2($i11), $i5
	store   $i5, 13($sp)
	load    1($i11), $i5
	store   $i5, 14($sp)
	li      l.14248, $i5
	load    0($i5), $f1
	store   $f1, 0($i3)
	li      0, $i3
	load    0($i4), $i4
	mov     $i2, $i11
	mov     $i4, $i2
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25323, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25323:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    3($sp), $i1
	load    0($i1), $f1
	li      l.14240, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25324
	li      0, $i1
	b       ble_cont.25325
ble_else.25324:
	li      1, $i1
ble_cont.25325:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25326
	li      0, $i1
	b       be_cont.25327
be_else.25326:
	li      l.14251, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25328
	li      0, $i1
	b       ble_cont.25329
ble_else.25328:
	li      1, $i1
ble_cont.25329:
be_cont.25327:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25330
	ret
be_else.25330:
	load    12($sp), $i1
	load    0($i1), $i1
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 15($sp)
	load    1($sp), $i2
	load    0($i2), $i2
	load    1($i1), $i3
	li      1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25332
	load    10($sp), $i1
	load    0($i1), $i1
	li      l.14001, $i3
	load    0($i3), $f1
	load    8($sp), $i3
	store   $f1, 0($i3)
	store   $f1, 1($i3)
	store   $f1, 2($i3)
	sub     $i1, 1, $i4
	sub     $i1, 1, $i1
	add     $i2, $i1, $i12
	load    0($i12), $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bne     $i12, be_else.25334
	li      1, $i1
	b       be_cont.25335
be_else.25334:
	li      0, $i1
be_cont.25335:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25336
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25338
	li      0, $i1
	b       ble_cont.25339
ble_else.25338:
	li      1, $i1
ble_cont.25339:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25340
	li      l.14099, $i1
	load    0($i1), $f1
	b       be_cont.25341
be_else.25340:
	li      l.14035, $i1
	load    0($i1), $f1
be_cont.25341:
	b       be_cont.25337
be_else.25336:
	li      l.14001, $i1
	load    0($i1), $f1
be_cont.25337:
	fneg    $f1, $f1
	add     $i3, $i4, $i12
	store   $f1, 0($i12)
	b       be_cont.25333
be_else.25332:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25342
	load    4($i1), $i2
	load    0($i2), $f1
	fneg    $f1, $f1
	load    8($sp), $i2
	store   $f1, 0($i2)
	load    4($i1), $i3
	load    1($i3), $f1
	fneg    $f1, $f1
	store   $f1, 1($i2)
	load    4($i1), $i1
	load    2($i1), $f1
	fneg    $f1, $f1
	store   $f1, 2($i2)
	b       be_cont.25343
be_else.25342:
	load    13($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25344, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25344:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.25343:
be_cont.25333:
	load    15($sp), $i1
	load    11($sp), $i2
	load    2($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25345, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25345:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i1
	load    6($sp), $i2
	load    0($i2), $i2
	load    5($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25346, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25346:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25347
	load    8($sp), $i1
	load    0($i1), $f1
	load    9($sp), $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	fneg    $f1, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25348
	li      0, $i1
	b       ble_cont.25349
ble_else.25348:
	li      1, $i1
ble_cont.25349:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25350
	li      l.14001, $i1
	load    0($i1), $f1
	b       be_cont.25351
be_else.25350:
be_cont.25351:
	load    0($sp), $f2
	fmul    $f2, $f1, $f1
	load    15($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    14($sp), $i1
	load    0($i1), $f2
	load    4($sp), $i2
	load    0($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f1, $f3, $f1
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
	ret
be_else.25347:
	ret
iter_trace_diffuse_rays.3134:
	load    13($i11), $i5
	store   $i5, 0($sp)
	load    12($i11), $i5
	load    11($i11), $i6
	store   $i6, 1($sp)
	load    10($i11), $i6
	store   $i6, 2($sp)
	load    9($i11), $i6
	store   $i6, 3($sp)
	load    8($i11), $i6
	load    7($i11), $i7
	store   $i7, 4($sp)
	load    6($i11), $i7
	store   $i7, 5($sp)
	load    5($i11), $i7
	load    4($i11), $i8
	store   $i8, 6($sp)
	load    3($i11), $i8
	load    2($i11), $i9
	load    1($i11), $i10
	li      0, $i12
	cmp     $i4, $i12, $i12
	bl      $i12, bge_else.25354
	store   $i3, 7($sp)
	store   $i11, 8($sp)
	store   $i5, 9($sp)
	store   $i2, 10($sp)
	store   $i1, 11($sp)
	store   $i4, 12($sp)
	store   $i10, 13($sp)
	add     $i1, $i4, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    0($i3), $f1
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	load    1($i3), $f2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i3), $f2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25355
	li      0, $i2
	b       ble_cont.25356
ble_else.25355:
	li      1, $i2
ble_cont.25356:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25357
	store   $i9, 14($sp)
	store   $i6, 15($sp)
	store   $i8, 16($sp)
	add     $i1, $i4, $i12
	load    0($i12), $i1
	store   $i1, 17($sp)
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 18($sp)
	mov     $i7, $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25359, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25359:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25360
	b       be_cont.25361
be_else.25360:
	load    16($sp), $i1
	load    0($i1), $i1
	load    15($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 19($sp)
	load    17($sp), $i2
	load    0($i2), $i2
	load    14($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25362, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25362:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i1
	load    6($sp), $i2
	load    0($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25363, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25363:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i1
	load    3($sp), $i2
	load    0($i2), $i2
	load    2($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25364, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25364:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25365
	load    4($sp), $i1
	load    0($i1), $f1
	load    5($sp), $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	fneg    $f1, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25367
	li      0, $i1
	b       ble_cont.25368
ble_else.25367:
	li      1, $i1
ble_cont.25368:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25369
	li      l.14001, $i1
	load    0($i1), $f1
	b       be_cont.25370
be_else.25369:
be_cont.25370:
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	load    19($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    13($sp), $i1
	load    0($i1), $f2
	load    1($sp), $i2
	load    0($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f1, $f3, $f1
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
	b       be_cont.25366
be_else.25365:
be_cont.25366:
be_cont.25361:
	b       be_cont.25358
be_else.25357:
	store   $i9, 14($sp)
	store   $i6, 15($sp)
	store   $i8, 16($sp)
	add     $i4, 1, $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	store   $i1, 20($sp)
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 21($sp)
	mov     $i7, $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25371, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25371:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25372
	b       be_cont.25373
be_else.25372:
	load    16($sp), $i1
	load    0($i1), $i1
	load    15($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 22($sp)
	load    20($sp), $i2
	load    0($i2), $i2
	load    14($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.25374, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.25374:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    22($sp), $i1
	load    6($sp), $i2
	load    0($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.25375, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.25375:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i1
	load    3($sp), $i2
	load    0($i2), $i2
	load    2($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.25376, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.25376:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25377
	load    4($sp), $i1
	load    0($i1), $f1
	load    5($sp), $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	fneg    $f1, $f1
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25379
	li      0, $i1
	b       ble_cont.25380
ble_else.25379:
	li      1, $i1
ble_cont.25380:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25381
	li      l.14001, $i1
	load    0($i1), $f1
	b       be_cont.25382
be_else.25381:
be_cont.25382:
	load    21($sp), $f2
	fmul    $f2, $f1, $f1
	load    22($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    13($sp), $i1
	load    0($i1), $f2
	load    1($sp), $i2
	load    0($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	load    1($i2), $f3
	fmul    $f1, $f3, $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	load    2($i2), $f3
	fmul    $f1, $f3, $f1
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
	b       be_cont.25378
be_else.25377:
be_cont.25378:
be_cont.25373:
be_cont.25358:
	load    12($sp), $i1
	sub     $i1, 2, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25383
	store   $i1, 23($sp)
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    0($i3), $f1
	load    10($sp), $i4
	load    0($i4), $f2
	fmul    $f1, $f2, $f1
	load    1($i3), $f2
	load    1($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i3), $f2
	load    2($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i3
	load    0($i3), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25384
	li      0, $i3
	b       ble_cont.25385
ble_else.25384:
	li      1, $i3
ble_cont.25385:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25386
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    9($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25388, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25388:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       be_cont.25387
be_else.25386:
	add     $i1, 1, $i1
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    9($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25389, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25389:
	sub     $sp, 25, $sp
	load    24($sp), $ra
be_cont.25387:
	load    23($sp), $i1
	sub     $i1, 2, $i4
	load    11($sp), $i1
	load    10($sp), $i2
	load    7($sp), $i3
	load    8($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25383:
	ret
bge_else.25354:
	ret
trace_diffuse_ray_80percent.3143:
	store   $i2, 0($sp)
	store   $i3, 1($sp)
	store   $i1, 2($sp)
	load    5($i11), $i4
	store   $i4, 3($sp)
	load    4($i11), $i5
	store   $i5, 4($sp)
	load    3($i11), $i6
	store   $i6, 5($sp)
	load    2($i11), $i7
	store   $i7, 6($sp)
	load    1($i11), $i8
	store   $i8, 7($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25392
	b       be_cont.25393
be_else.25392:
	load    0($i8), $i1
	store   $i1, 8($sp)
	load    0($i3), $f1
	store   $f1, 0($i4)
	load    1($i3), $f1
	store   $f1, 1($i4)
	load    2($i3), $f1
	store   $f1, 2($i4)
	load    0($i6), $i1
	sub     $i1, 1, $i2
	mov     $i3, $i1
	mov     $i5, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25394, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25394:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      118, $i4
	load    8($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.25395, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.25395:
	sub     $sp, 10, $sp
	load    9($sp), $ra
be_cont.25393:
	load    2($sp), $i1
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25396
	b       be_cont.25397
be_else.25396:
	load    7($sp), $i1
	load    1($i1), $i1
	store   $i1, 9($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	load    3($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    4($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.25398, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.25398:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      118, $i4
	load    9($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.25399, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.25399:
	sub     $sp, 11, $sp
	load    10($sp), $ra
be_cont.25397:
	load    2($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25400
	b       be_cont.25401
be_else.25400:
	load    7($sp), $i1
	load    2($i1), $i1
	store   $i1, 10($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	load    3($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    4($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.25402, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.25402:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      118, $i4
	load    10($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.25403, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.25403:
	sub     $sp, 12, $sp
	load    11($sp), $ra
be_cont.25401:
	load    2($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25404
	b       be_cont.25405
be_else.25404:
	load    7($sp), $i1
	load    3($i1), $i1
	store   $i1, 11($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	load    3($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    4($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.25406, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.25406:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      118, $i4
	load    11($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.25407, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.25407:
	sub     $sp, 13, $sp
	load    12($sp), $ra
be_cont.25405:
	load    2($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25408
	ret
be_else.25408:
	load    7($sp), $i1
	load    4($i1), $i1
	store   $i1, 12($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	load    3($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    4($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25410, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25410:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      118, $i4
	load    12($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	load    0($i11), $i10
	jr      $i10
calc_diffuse_using_1point.3147:
	store   $i2, 0($sp)
	load    8($i11), $i3
	store   $i3, 1($sp)
	load    7($i11), $i3
	store   $i3, 2($sp)
	load    6($i11), $i4
	store   $i4, 3($sp)
	load    5($i11), $i4
	store   $i4, 4($sp)
	load    4($i11), $i4
	store   $i4, 5($sp)
	load    3($i11), $i5
	store   $i5, 6($sp)
	load    2($i11), $i5
	store   $i5, 7($sp)
	load    1($i11), $i6
	store   $i6, 8($sp)
	load    5($i1), $i7
	load    7($i1), $i8
	load    1($i1), $i9
	load    4($i1), $i10
	store   $i10, 9($sp)
	add     $i7, $i2, $i12
	load    0($i12), $i7
	load    0($i7), $f1
	store   $f1, 0($i6)
	load    1($i7), $f1
	store   $f1, 1($i6)
	load    2($i7), $f1
	store   $f1, 2($i6)
	load    6($i1), $i1
	load    0($i1), $i1
	store   $i1, 10($sp)
	add     $i8, $i2, $i12
	load    0($i12), $i6
	store   $i6, 11($sp)
	add     $i9, $i2, $i12
	load    0($i12), $i2
	store   $i2, 12($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25411
	b       be_cont.25412
be_else.25411:
	load    0($i5), $i1
	store   $i1, 13($sp)
	load    0($i2), $f1
	store   $f1, 0($i3)
	load    1($i2), $f1
	store   $f1, 1($i3)
	load    2($i2), $f1
	store   $f1, 2($i3)
	load    0($i4), $i1
	sub     $i1, 1, $i1
	load    3($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25413, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25413:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i1
	load    118($i1), $i2
	load    0($i2), $i2
	load    0($i2), $f1
	load    11($sp), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25414
	li      0, $i2
	b       ble_cont.25415
ble_else.25414:
	li      1, $i2
ble_cont.25415:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25416
	load    118($i1), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25418, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25418:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       be_cont.25417
be_else.25416:
	load    119($i1), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25419, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25419:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25417:
	li      116, $i4
	load    13($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25420, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25420:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25412:
	load    10($sp), $i1
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25421
	b       be_cont.25422
be_else.25421:
	load    7($sp), $i1
	load    1($i1), $i1
	store   $i1, 14($sp)
	load    12($sp), $i1
	load    0($i1), $f1
	load    2($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    3($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25423, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25423:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	load    118($i1), $i2
	load    0($i2), $i2
	load    0($i2), $f1
	load    11($sp), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25424
	li      0, $i2
	b       ble_cont.25425
ble_else.25424:
	li      1, $i2
ble_cont.25425:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25426
	load    118($i1), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25428, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25428:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       be_cont.25427
be_else.25426:
	load    119($i1), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25429, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25429:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.25427:
	li      116, $i4
	load    14($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25430, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25430:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.25422:
	load    10($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25431
	b       be_cont.25432
be_else.25431:
	load    7($sp), $i1
	load    2($i1), $i1
	store   $i1, 15($sp)
	load    12($sp), $i1
	load    0($i1), $f1
	load    2($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    3($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25433, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25433:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    118($i1), $i2
	load    0($i2), $i2
	load    0($i2), $f1
	load    11($sp), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25434
	li      0, $i2
	b       ble_cont.25435
ble_else.25434:
	li      1, $i2
ble_cont.25435:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25436
	load    118($i1), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25438, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25438:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	b       be_cont.25437
be_else.25436:
	load    119($i1), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25439, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25439:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.25437:
	li      116, $i4
	load    15($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25440, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25440:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.25432:
	load    10($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25441
	b       be_cont.25442
be_else.25441:
	load    7($sp), $i1
	load    3($i1), $i1
	store   $i1, 16($sp)
	load    12($sp), $i1
	load    0($i1), $f1
	load    2($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    3($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25443, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25443:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $i1
	load    118($i1), $i2
	load    0($i2), $i2
	load    0($i2), $f1
	load    11($sp), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25444
	li      0, $i2
	b       ble_cont.25445
ble_else.25444:
	li      1, $i2
ble_cont.25445:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25446
	load    118($i1), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25448, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25448:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       be_cont.25447
be_else.25446:
	load    119($i1), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25449, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25449:
	sub     $sp, 18, $sp
	load    17($sp), $ra
be_cont.25447:
	li      116, $i4
	load    16($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25450, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25450:
	sub     $sp, 18, $sp
	load    17($sp), $ra
be_cont.25442:
	load    10($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25451
	b       be_cont.25452
be_else.25451:
	load    7($sp), $i1
	load    4($i1), $i1
	store   $i1, 17($sp)
	load    12($sp), $i1
	load    0($i1), $f1
	load    2($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    5($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    3($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.25453, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.25453:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $i1
	load    118($i1), $i2
	load    0($i2), $i2
	load    0($i2), $f1
	load    11($sp), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25454
	li      0, $i2
	b       ble_cont.25455
ble_else.25454:
	li      1, $i2
ble_cont.25455:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25456
	load    118($i1), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.25458, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.25458:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	b       be_cont.25457
be_else.25456:
	load    119($i1), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.25459, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.25459:
	sub     $sp, 19, $sp
	load    18($sp), $ra
be_cont.25457:
	li      116, $i4
	load    17($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.25460, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.25460:
	sub     $sp, 19, $sp
	load    18($sp), $ra
be_cont.25452:
	load    0($sp), $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    4($sp), $i1
	load    8($sp), $i3
	b       vecaccumv.2840
calc_diffuse_using_5points.3150:
	load    2($i11), $i6
	load    1($i11), $i7
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($i2), $i2
	sub     $i1, 1, $i8
	add     $i3, $i8, $i12
	load    0($i12), $i8
	load    5($i8), $i8
	add     $i3, $i1, $i12
	load    0($i12), $i9
	load    5($i9), $i9
	add     $i1, 1, $i10
	add     $i3, $i10, $i12
	load    0($i12), $i10
	load    5($i10), $i10
	add     $i4, $i1, $i12
	load    0($i12), $i4
	load    5($i4), $i4
	add     $i2, $i5, $i12
	load    0($i12), $i2
	load    0($i2), $f1
	store   $f1, 0($i7)
	load    1($i2), $f1
	store   $f1, 1($i7)
	load    2($i2), $f1
	store   $f1, 2($i7)
	add     $i8, $i5, $i12
	load    0($i12), $i2
	load    0($i7), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i7)
	load    1($i7), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i7)
	load    2($i7), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i7)
	add     $i9, $i5, $i12
	load    0($i12), $i2
	load    0($i7), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i7)
	load    1($i7), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i7)
	load    2($i7), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i7)
	add     $i10, $i5, $i12
	load    0($i12), $i2
	load    0($i7), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i7)
	load    1($i7), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i7)
	load    2($i7), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i7)
	add     $i4, $i5, $i12
	load    0($i12), $i2
	load    0($i7), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i7)
	load    1($i7), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i7)
	load    2($i7), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i7)
	add     $i3, $i1, $i12
	load    0($i12), $i1
	load    4($i1), $i1
	add     $i1, $i5, $i12
	load    0($i12), $i2
	mov     $i7, $i3
	mov     $i6, $i1
	b       vecaccumv.2840
do_without_neighbors.3156:
	load    4($i11), $i3
	load    3($i11), $i4
	load    2($i11), $i5
	load    1($i11), $i6
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.25461
	load    2($i1), $i7
	add     $i7, $i2, $i12
	load    0($i12), $i7
	li      0, $i12
	cmp     $i7, $i12, $i12
	bl      $i12, bge_else.25462
	store   $i6, 0($sp)
	store   $i11, 1($sp)
	store   $i1, 2($sp)
	store   $i2, 3($sp)
	load    3($i1), $i6
	add     $i6, $i2, $i12
	load    0($i12), $i6
	li      0, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.25463
	b       be_cont.25464
be_else.25463:
	store   $i5, 4($sp)
	store   $i4, 5($sp)
	load    5($i1), $i4
	load    7($i1), $i6
	load    1($i1), $i7
	load    4($i1), $i8
	store   $i8, 6($sp)
	add     $i4, $i2, $i12
	load    0($i12), $i4
	load    0($i4), $f1
	store   $f1, 0($i5)
	load    1($i4), $f1
	store   $f1, 1($i5)
	load    2($i4), $f1
	store   $f1, 2($i5)
	load    6($i1), $i1
	load    0($i1), $i1
	add     $i6, $i2, $i12
	load    0($i12), $i4
	add     $i7, $i2, $i12
	load    0($i12), $i2
	mov     $i3, $i11
	mov     $i2, $i3
	mov     $i4, $i2
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.25465, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.25465:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    3($sp), $i1
	load    6($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($sp), $i1
	load    4($sp), $i3
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     vecaccumv.2840
	sub     $sp, 8, $sp
	load    7($sp), $ra
be_cont.25464:
	load    3($sp), $i1
	add     $i1, 1, $i2
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.25466
	load    2($sp), $i1
	load    2($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.25467
	store   $i2, 7($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25468
	b       be_cont.25469
be_else.25468:
	load    0($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.25470, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.25470:
	sub     $sp, 9, $sp
	load    8($sp), $ra
be_cont.25469:
	load    7($sp), $i1
	add     $i1, 1, $i2
	load    2($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25467:
	ret
ble_else.25466:
	ret
bge_else.25462:
	ret
ble_else.25461:
	ret
try_exploit_neighbors.3172:
	load    3($i11), $i7
	load    2($i11), $i8
	load    1($i11), $i9
	add     $i4, $i1, $i12
	load    0($i12), $i10
	li      4, $i12
	cmp     $i6, $i12, $i12
	bg      $i12, ble_else.25475
	store   $i8, 0($sp)
	load    2($i10), $i8
	add     $i8, $i6, $i12
	load    0($i12), $i8
	li      0, $i12
	cmp     $i8, $i12, $i12
	bl      $i12, bge_else.25476
	store   $i2, 1($sp)
	add     $i4, $i1, $i12
	load    0($i12), $i2
	load    2($i2), $i2
	add     $i2, $i6, $i12
	load    0($i12), $i2
	add     $i3, $i1, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i6, $i12
	load    0($i12), $i8
	cmp     $i8, $i2, $i12
	bne     $i12, be_else.25477
	add     $i5, $i1, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i6, $i12
	load    0($i12), $i8
	cmp     $i8, $i2, $i12
	bne     $i12, be_else.25479
	sub     $i1, 1, $i8
	add     $i4, $i8, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i6, $i12
	load    0($i12), $i8
	cmp     $i8, $i2, $i12
	bne     $i12, be_else.25481
	add     $i1, 1, $i8
	add     $i4, $i8, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i6, $i12
	load    0($i12), $i8
	cmp     $i8, $i2, $i12
	bne     $i12, be_else.25483
	li      1, $i2
	b       be_cont.25484
be_else.25483:
	li      0, $i2
be_cont.25484:
	b       be_cont.25482
be_else.25481:
	li      0, $i2
be_cont.25482:
	b       be_cont.25480
be_else.25479:
	li      0, $i2
be_cont.25480:
	b       be_cont.25478
be_else.25477:
	li      0, $i2
be_cont.25478:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25485
	add     $i4, $i1, $i12
	load    0($i12), $i1
	li      4, $i12
	cmp     $i6, $i12, $i12
	bg      $i12, ble_else.25486
	load    2($i1), $i2
	add     $i2, $i6, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25487
	store   $i1, 2($sp)
	store   $i7, 3($sp)
	store   $i6, 4($sp)
	load    3($i1), $i2
	add     $i2, $i6, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25488
	b       be_cont.25489
be_else.25488:
	mov     $i6, $i2
	mov     $i9, $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.25490, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.25490:
	sub     $sp, 6, $sp
	load    5($sp), $ra
be_cont.25489:
	load    4($sp), $i1
	add     $i1, 1, $i2
	load    2($sp), $i1
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25487:
	ret
ble_else.25486:
	ret
be_else.25485:
	store   $i11, 5($sp)
	store   $i7, 3($sp)
	store   $i5, 6($sp)
	store   $i3, 7($sp)
	store   $i1, 8($sp)
	store   $i4, 9($sp)
	store   $i6, 4($sp)
	load    3($i10), $i2
	add     $i2, $i6, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25493
	b       be_cont.25494
be_else.25493:
	load    0($sp), $i11
	mov     $i3, $i2
	mov     $i4, $i3
	mov     $i5, $i4
	mov     $i6, $i5
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.25495, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.25495:
	sub     $sp, 11, $sp
	load    10($sp), $ra
be_cont.25494:
	load    4($sp), $i1
	add     $i1, 1, $i2
	load    8($sp), $i1
	load    9($sp), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i4
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.25496
	load    2($i4), $i5
	add     $i5, $i2, $i12
	load    0($i12), $i5
	li      0, $i12
	cmp     $i5, $i12, $i12
	bl      $i12, bge_else.25497
	add     $i3, $i1, $i12
	load    0($i12), $i5
	load    2($i5), $i5
	add     $i5, $i2, $i12
	load    0($i12), $i5
	load    7($sp), $i6
	add     $i6, $i1, $i12
	load    0($i12), $i7
	load    2($i7), $i7
	add     $i7, $i2, $i12
	load    0($i12), $i7
	cmp     $i7, $i5, $i12
	bne     $i12, be_else.25498
	load    6($sp), $i7
	add     $i7, $i1, $i12
	load    0($i12), $i7
	load    2($i7), $i7
	add     $i7, $i2, $i12
	load    0($i12), $i7
	cmp     $i7, $i5, $i12
	bne     $i12, be_else.25500
	sub     $i1, 1, $i7
	add     $i3, $i7, $i12
	load    0($i12), $i7
	load    2($i7), $i7
	add     $i7, $i2, $i12
	load    0($i12), $i7
	cmp     $i7, $i5, $i12
	bne     $i12, be_else.25502
	add     $i1, 1, $i7
	add     $i3, $i7, $i12
	load    0($i12), $i7
	load    2($i7), $i7
	add     $i7, $i2, $i12
	load    0($i12), $i7
	cmp     $i7, $i5, $i12
	bne     $i12, be_else.25504
	li      1, $i5
	b       be_cont.25505
be_else.25504:
	li      0, $i5
be_cont.25505:
	b       be_cont.25503
be_else.25502:
	li      0, $i5
be_cont.25503:
	b       be_cont.25501
be_else.25500:
	li      0, $i5
be_cont.25501:
	b       be_cont.25499
be_else.25498:
	li      0, $i5
be_cont.25499:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25506
	add     $i3, $i1, $i12
	load    0($i12), $i1
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.25506:
	store   $i2, 10($sp)
	load    3($i4), $i4
	add     $i4, $i2, $i12
	load    0($i12), $i4
	li      0, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.25507
	b       be_cont.25508
be_else.25507:
	load    6($sp), $i4
	load    0($sp), $i11
	mov     $i2, $i5
	mov     $i6, $i2
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.25509, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.25509:
	sub     $sp, 12, $sp
	load    11($sp), $ra
be_cont.25508:
	load    10($sp), $i1
	add     $i1, 1, $i6
	load    8($sp), $i1
	load    1($sp), $i2
	load    7($sp), $i3
	load    9($sp), $i4
	load    6($sp), $i5
	load    5($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25497:
	ret
ble_else.25496:
	ret
bge_else.25476:
	ret
ble_else.25475:
	ret
write_ppm_header.3179:
	li      80, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      54, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      10, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      49, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      50, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      56, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      32, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      49, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      50, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      56, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      32, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      50, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      53, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      53, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_write
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      10, $i1
	b       min_caml_write
write_rgb.3183:
	load    1($i11), $i1
	store   $i1, 0($sp)
	load    0($i1), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_int_of_float
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25514
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25516
	b       bge_cont.25517
bge_else.25516:
	li      0, $i1
bge_cont.25517:
	b       ble_cont.25515
ble_else.25514:
	li      255, $i1
ble_cont.25515:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_write
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i1
	load    1($i1), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_int_of_float
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25518
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25520
	b       bge_cont.25521
bge_else.25520:
	li      0, $i1
bge_cont.25521:
	b       ble_cont.25519
ble_else.25518:
	li      255, $i1
ble_cont.25519:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_write
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i1
	load    2($i1), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_int_of_float
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25522
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25524
	b       bge_cont.25525
bge_else.25524:
	li      0, $i1
bge_cont.25525:
	b       ble_cont.25523
ble_else.25522:
	li      255, $i1
ble_cont.25523:
	b       min_caml_write
pretrace_diffuse_rays.3185:
	load    7($i11), $i3
	load    6($i11), $i4
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	load    1($i11), $i9
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.25526
	load    2($i1), $i10
	add     $i10, $i2, $i12
	load    0($i12), $i10
	li      0, $i12
	cmp     $i10, $i12, $i12
	bl      $i12, bge_else.25527
	store   $i7, 0($sp)
	store   $i3, 1($sp)
	store   $i5, 2($sp)
	store   $i6, 3($sp)
	store   $i4, 4($sp)
	store   $i8, 5($sp)
	store   $i9, 6($sp)
	store   $i11, 7($sp)
	store   $i2, 8($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25528
	b       be_cont.25529
be_else.25528:
	store   $i1, 9($sp)
	load    6($i1), $i3
	load    0($i3), $i3
	li      l.14001, $i7
	load    0($i7), $f1
	store   $f1, 0($i9)
	store   $f1, 1($i9)
	store   $f1, 2($i9)
	load    7($i1), $i7
	load    1($i1), $i1
	add     $i8, $i3, $i12
	load    0($i12), $i3
	store   $i3, 10($sp)
	add     $i7, $i2, $i12
	load    0($i12), $i3
	store   $i3, 11($sp)
	add     $i1, $i2, $i12
	load    0($i12), $i1
	store   $i1, 12($sp)
	load    0($i1), $f1
	store   $f1, 0($i4)
	load    1($i1), $f1
	store   $f1, 1($i4)
	load    2($i1), $f1
	store   $f1, 2($i4)
	load    0($i6), $i2
	sub     $i2, 1, $i2
	mov     $i5, $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25530, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25530:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      118, $i4
	load    10($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    0($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25531, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25531:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    9($sp), $i1
	load    5($i1), $i2
	load    8($sp), $i3
	add     $i2, $i3, $i12
	load    0($i12), $i2
	load    6($sp), $i3
	load    0($i3), $f1
	store   $f1, 0($i2)
	load    1($i3), $f1
	store   $f1, 1($i2)
	load    2($i3), $f1
	store   $f1, 2($i2)
be_cont.25529:
	load    8($sp), $i2
	add     $i2, 1, $i2
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.25532
	load    2($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.25533
	store   $i2, 13($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25534
	b       be_cont.25535
be_else.25534:
	store   $i1, 9($sp)
	load    6($i1), $i3
	load    0($i3), $i3
	li      l.14001, $i4
	load    0($i4), $f1
	load    6($sp), $i4
	store   $f1, 0($i4)
	store   $f1, 1($i4)
	store   $f1, 2($i4)
	load    7($i1), $i4
	load    1($i1), $i1
	load    5($sp), $i5
	add     $i5, $i3, $i12
	load    0($i12), $i3
	store   $i3, 14($sp)
	add     $i4, $i2, $i12
	load    0($i12), $i3
	store   $i3, 15($sp)
	add     $i1, $i2, $i12
	load    0($i12), $i1
	store   $i1, 16($sp)
	load    0($i1), $f1
	load    4($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    3($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    2($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25536, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25536:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    14($sp), $i1
	load    118($i1), $i2
	load    0($i2), $i2
	load    0($i2), $f1
	load    15($sp), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25537
	li      0, $i2
	b       ble_cont.25538
ble_else.25537:
	li      1, $i2
ble_cont.25538:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25539
	load    118($i1), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25541, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25541:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       be_cont.25540
be_else.25539:
	load    119($i1), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25542, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25542:
	sub     $sp, 18, $sp
	load    17($sp), $ra
be_cont.25540:
	li      116, $i4
	load    14($sp), $i1
	load    15($sp), $i2
	load    16($sp), $i3
	load    0($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25543, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25543:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    9($sp), $i1
	load    5($i1), $i2
	load    13($sp), $i3
	add     $i2, $i3, $i12
	load    0($i12), $i2
	load    6($sp), $i3
	load    0($i3), $f1
	store   $f1, 0($i2)
	load    1($i3), $f1
	store   $f1, 1($i2)
	load    2($i3), $f1
	store   $f1, 2($i2)
be_cont.25535:
	load    13($sp), $i2
	add     $i2, 1, $i2
	load    7($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25533:
	ret
ble_else.25532:
	ret
bge_else.25527:
	ret
ble_else.25526:
	ret
pretrace_pixels.3188:
	store   $i3, 0($sp)
	store   $i11, 1($sp)
	load    16($i11), $i3
	load    15($i11), $i4
	store   $i4, 2($sp)
	load    14($i11), $i4
	store   $i4, 3($sp)
	load    13($i11), $i4
	store   $i4, 4($sp)
	load    12($i11), $i4
	load    11($i11), $i5
	store   $i5, 5($sp)
	load    10($i11), $i5
	load    9($i11), $i6
	load    8($i11), $i7
	load    7($i11), $i8
	load    6($i11), $i9
	store   $i9, 6($sp)
	load    5($i11), $i9
	store   $i9, 7($sp)
	load    4($i11), $i9
	store   $i9, 8($sp)
	load    3($i11), $i9
	load    2($i11), $i10
	load    1($i11), $i11
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25548
	store   $i10, 9($sp)
	store   $i11, 10($sp)
	store   $i2, 11($sp)
	store   $i1, 12($sp)
	store   $i4, 13($sp)
	store   $i3, 14($sp)
	store   $i7, 15($sp)
	store   $f3, 16($sp)
	store   $f2, 17($sp)
	store   $i8, 18($sp)
	store   $f1, 19($sp)
	store   $i5, 20($sp)
	load    0($i6), $f1
	store   $f1, 21($sp)
	load    0($i9), $i1
	sub     $i2, $i1, $i1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_float_of_int
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $f2
	fmul    $f2, $f1, $f1
	load    20($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    19($sp), $f3
	fadd    $f2, $f3, $f2
	load    18($sp), $i2
	store   $f2, 0($i2)
	load    1($i1), $f2
	fmul    $f1, $f2, $f2
	load    17($sp), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i2)
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	load    16($sp), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
	li      0, $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     vecunit_sgn.2816
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      l.14001, $i1
	load    0($i1), $f1
	load    15($sp), $i1
	store   $f1, 0($i1)
	store   $f1, 1($i1)
	store   $f1, 2($i1)
	load    14($sp), $i1
	load    0($i1), $f1
	load    13($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	li      0, $i1
	li      l.14035, $i2
	load    0($i2), $f1
	load    11($sp), $i2
	load    12($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      l.14001, $i2
	load    0($i2), $f2
	load    18($sp), $i2
	load    2($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.25549, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.25549:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    11($sp), $i1
	load    12($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    15($sp), $i4
	load    0($i4), $f1
	store   $f1, 0($i3)
	load    1($i4), $f1
	store   $f1, 1($i3)
	load    2($i4), $f1
	store   $f1, 2($i3)
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    6($i3), $i3
	load    0($sp), $i4
	store   $i4, 0($i3)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    2($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25550
	load    3($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25552
	b       be_cont.25553
be_else.25552:
	store   $i1, 22($sp)
	load    6($i1), $i2
	load    0($i2), $i2
	li      l.14001, $i3
	load    0($i3), $f1
	load    10($sp), $i3
	store   $f1, 0($i3)
	store   $f1, 1($i3)
	store   $f1, 2($i3)
	load    7($i1), $i3
	load    1($i1), $i1
	load    9($sp), $i4
	add     $i4, $i2, $i12
	load    0($i12), $i2
	store   $i2, 23($sp)
	load    0($i3), $i2
	store   $i2, 24($sp)
	load    0($i1), $i1
	store   $i1, 25($sp)
	load    0($i1), $f1
	load    4($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    7($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    5($sp), $i11
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.25554, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.25554:
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    23($sp), $i1
	load    118($i1), $i2
	load    0($i2), $i2
	load    0($i2), $f1
	load    24($sp), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14001, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25555
	li      0, $i2
	b       ble_cont.25556
ble_else.25555:
	li      1, $i2
ble_cont.25556:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25557
	load    118($i1), $i1
	li      l.14354, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    3($sp), $i11
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.25559, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.25559:
	sub     $sp, 27, $sp
	load    26($sp), $ra
	b       be_cont.25558
be_else.25557:
	load    119($i1), $i1
	li      l.14350, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    3($sp), $i11
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.25560, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.25560:
	sub     $sp, 27, $sp
	load    26($sp), $ra
be_cont.25558:
	li      116, $i4
	load    23($sp), $i1
	load    24($sp), $i2
	load    25($sp), $i3
	load    8($sp), $i11
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.25561, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.25561:
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    22($sp), $i1
	load    5($i1), $i2
	load    0($i2), $i2
	load    10($sp), $i3
	load    0($i3), $f1
	store   $f1, 0($i2)
	load    1($i3), $f1
	store   $f1, 1($i2)
	load    2($i3), $f1
	store   $f1, 2($i2)
be_cont.25553:
	li      1, $i2
	load    6($sp), $i11
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.25562, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.25562:
	sub     $sp, 27, $sp
	load    26($sp), $ra
	b       bge_cont.25551
bge_else.25550:
bge_cont.25551:
	load    11($sp), $i1
	sub     $i1, 1, $i2
	load    0($sp), $i1
	add     $i1, 1, $i1
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25563
	sub     $i1, 5, $i1
	b       bge_cont.25564
bge_else.25563:
bge_cont.25564:
	mov     $i1, $i3
	load    19($sp), $f1
	load    17($sp), $f2
	load    16($sp), $f3
	load    12($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25548:
	ret
pretrace_line.3195:
	store   $i3, 0($sp)
	store   $i1, 1($sp)
	load    6($i11), $i1
	store   $i1, 2($sp)
	load    5($i11), $i1
	store   $i1, 3($sp)
	load    4($i11), $i1
	load    3($i11), $i3
	store   $i3, 4($sp)
	load    2($i11), $i3
	store   $i3, 5($sp)
	load    1($i11), $i3
	load    0($i1), $f1
	store   $f1, 6($sp)
	load    1($i3), $i1
	sub     $i2, $i1, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_float_of_int
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	load    3($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    2($sp), $i2
	load    0($i2), $f3
	fadd    $f2, $f3, $f2
	load    1($i1), $f3
	fmul    $f1, $f3, $f3
	load    1($i2), $f4
	fadd    $f3, $f4, $f3
	load    2($i1), $f4
	fmul    $f1, $f4, $f1
	load    2($i2), $f4
	fadd    $f1, $f4, $f1
	load    5($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i2
	load    1($sp), $i1
	load    0($sp), $i3
	load    4($sp), $i11
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
scan_pixel.3199:
	load    7($i11), $i6
	load    6($i11), $i7
	store   $i7, 0($sp)
	load    5($i11), $i7
	load    4($i11), $i8
	load    3($i11), $i9
	load    2($i11), $i10
	store   $i10, 1($sp)
	load    1($i11), $i10
	store   $i10, 2($sp)
	load    0($i8), $i10
	cmp     $i10, $i1, $i12
	bg      $i12, ble_else.25566
	ret
ble_else.25566:
	store   $i3, 3($sp)
	store   $i11, 4($sp)
	store   $i6, 5($sp)
	store   $i9, 6($sp)
	store   $i2, 7($sp)
	store   $i4, 8($sp)
	store   $i8, 9($sp)
	store   $i1, 10($sp)
	store   $i7, 11($sp)
	store   $i5, 12($sp)
	add     $i4, $i1, $i12
	load    0($i12), $i5
	load    0($i5), $i5
	load    0($i5), $f1
	store   $f1, 0($i7)
	load    1($i5), $f1
	store   $f1, 1($i7)
	load    2($i5), $f1
	store   $f1, 2($i7)
	load    1($i8), $i5
	add     $i2, 1, $i6
	cmp     $i5, $i6, $i12
	bg      $i12, ble_else.25568
	li      0, $i5
	b       ble_cont.25569
ble_else.25568:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.25570
	li      0, $i5
	b       ble_cont.25571
ble_else.25570:
	load    0($i8), $i5
	add     $i1, 1, $i6
	cmp     $i5, $i6, $i12
	bg      $i12, ble_else.25572
	li      0, $i5
	b       ble_cont.25573
ble_else.25572:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25574
	li      0, $i5
	b       ble_cont.25575
ble_else.25574:
	li      1, $i5
ble_cont.25575:
ble_cont.25573:
ble_cont.25571:
ble_cont.25569:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25576
	add     $i4, $i1, $i12
	load    0($i12), $i1
	li      0, $i2
	load    2($i1), $i3
	load    0($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.25578
	store   $i1, 13($sp)
	load    3($i1), $i3
	load    0($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25580
	b       be_cont.25581
be_else.25580:
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25582, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25582:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25581:
	li      1, $i2
	load    13($sp), $i1
	load    6($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25583, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25583:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       bge_cont.25579
bge_else.25578:
bge_cont.25579:
	b       be_cont.25577
be_else.25576:
	li      0, $i5
	add     $i4, $i1, $i12
	load    0($i12), $i6
	load    2($i6), $i7
	load    0($i7), $i7
	li      0, $i12
	cmp     $i7, $i12, $i12
	bl      $i12, bge_else.25584
	add     $i4, $i1, $i12
	load    0($i12), $i7
	load    2($i7), $i7
	load    0($i7), $i7
	add     $i3, $i1, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	load    0($i8), $i8
	cmp     $i8, $i7, $i12
	bne     $i12, be_else.25586
	load    12($sp), $i8
	add     $i8, $i1, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	load    0($i8), $i8
	cmp     $i8, $i7, $i12
	bne     $i12, be_else.25588
	sub     $i1, 1, $i8
	add     $i4, $i8, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	load    0($i8), $i8
	cmp     $i8, $i7, $i12
	bne     $i12, be_else.25590
	add     $i1, 1, $i8
	add     $i4, $i8, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	load    0($i8), $i8
	cmp     $i8, $i7, $i12
	bne     $i12, be_else.25592
	li      1, $i7
	b       be_cont.25593
be_else.25592:
	li      0, $i7
be_cont.25593:
	b       be_cont.25591
be_else.25590:
	li      0, $i7
be_cont.25591:
	b       be_cont.25589
be_else.25588:
	li      0, $i7
be_cont.25589:
	b       be_cont.25587
be_else.25586:
	li      0, $i7
be_cont.25587:
	li      0, $i12
	cmp     $i7, $i12, $i12
	bne     $i12, be_else.25594
	add     $i4, $i1, $i12
	load    0($i12), $i1
	mov     $i5, $i2
	mov     $i9, $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25596, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25596:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       be_cont.25595
be_else.25594:
	load    3($i6), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25597
	b       be_cont.25598
be_else.25597:
	load    12($sp), $i2
	load    1($sp), $i11
	mov     $i4, $i10
	mov     $i2, $i4
	mov     $i3, $i2
	mov     $i10, $i3
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25599, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25599:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25598:
	li      1, $i6
	load    10($sp), $i1
	load    7($sp), $i2
	load    3($sp), $i3
	load    8($sp), $i4
	load    12($sp), $i5
	load    0($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25600, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25600:
	sub     $sp, 15, $sp
	load    14($sp), $ra
be_cont.25595:
	b       bge_cont.25585
bge_else.25584:
bge_cont.25585:
be_cont.25577:
	load    11($sp), $i1
	load    0($i1), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_int_of_float
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25601
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25603
	b       bge_cont.25604
bge_else.25603:
	li      0, $i1
bge_cont.25604:
	b       ble_cont.25602
ble_else.25601:
	li      255, $i1
ble_cont.25602:
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_write
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    11($sp), $i1
	load    1($i1), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_int_of_float
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25605
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25607
	b       bge_cont.25608
bge_else.25607:
	li      0, $i1
bge_cont.25608:
	b       ble_cont.25606
ble_else.25605:
	li      255, $i1
ble_cont.25606:
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_write
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    11($sp), $i1
	load    2($i1), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_int_of_float
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25609
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25611
	b       bge_cont.25612
bge_else.25611:
	li      0, $i1
bge_cont.25612:
	b       ble_cont.25610
ble_else.25609:
	li      255, $i1
ble_cont.25610:
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_write
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    9($sp), $i2
	load    0($i2), $i3
	cmp     $i3, $i1, $i12
	bg      $i12, ble_else.25613
	ret
ble_else.25613:
	store   $i1, 14($sp)
	load    8($sp), $i4
	add     $i4, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    0($i3), $f1
	load    11($sp), $i5
	store   $f1, 0($i5)
	load    1($i3), $f1
	store   $f1, 1($i5)
	load    2($i3), $f1
	store   $f1, 2($i5)
	load    1($i2), $i3
	load    7($sp), $i5
	add     $i5, 1, $i6
	cmp     $i3, $i6, $i12
	bg      $i12, ble_else.25615
	li      0, $i2
	b       ble_cont.25616
ble_else.25615:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bg      $i12, ble_else.25617
	li      0, $i2
	b       ble_cont.25618
ble_else.25617:
	load    0($i2), $i2
	add     $i1, 1, $i3
	cmp     $i2, $i3, $i12
	bg      $i12, ble_else.25619
	li      0, $i2
	b       ble_cont.25620
ble_else.25619:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25621
	li      0, $i2
	b       ble_cont.25622
ble_else.25621:
	li      1, $i2
ble_cont.25622:
ble_cont.25620:
ble_cont.25618:
ble_cont.25616:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25623
	add     $i4, $i1, $i12
	load    0($i12), $i1
	li      0, $i2
	load    6($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25625, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25625:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       be_cont.25624
be_else.25623:
	li      0, $i6
	load    3($sp), $i3
	load    12($sp), $i2
	load    0($sp), $i11
	mov     $i5, $i10
	mov     $i2, $i5
	mov     $i10, $i2
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25626, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25626:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.25624:
	load    5($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25627, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25627:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    3($sp), $i3
	load    8($sp), $i4
	load    12($sp), $i5
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
scan_line.3205:
	load    7($i11), $i6
	store   $i6, 0($sp)
	load    6($i11), $i6
	store   $i6, 1($sp)
	load    5($i11), $i6
	load    4($i11), $i7
	load    3($i11), $i8
	load    2($i11), $i9
	load    1($i11), $i10
	store   $i10, 2($sp)
	load    1($i9), $i10
	cmp     $i10, $i1, $i12
	bg      $i12, ble_else.25628
	ret
ble_else.25628:
	store   $i7, 3($sp)
	store   $i8, 4($sp)
	store   $i11, 5($sp)
	store   $i2, 6($sp)
	store   $i4, 7($sp)
	store   $i3, 8($sp)
	store   $i6, 9($sp)
	store   $i5, 10($sp)
	store   $i1, 11($sp)
	store   $i9, 12($sp)
	load    1($i9), $i2
	sub     $i2, 1, $i2
	cmp     $i2, $i1, $i12
	bg      $i12, ble_else.25630
	b       ble_cont.25631
ble_else.25630:
	add     $i1, 1, $i2
	mov     $i5, $i3
	mov     $i4, $i1
	mov     $i8, $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25632, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25632:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.25631:
	li      0, $i1
	load    12($sp), $i2
	load    0($i2), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bg      $i12, ble_else.25633
	b       ble_cont.25634
ble_else.25633:
	load    8($sp), $i4
	load    0($i4), $i3
	load    0($i3), $i3
	load    0($i3), $f1
	load    3($sp), $i5
	store   $f1, 0($i5)
	load    1($i3), $f1
	store   $f1, 1($i5)
	load    2($i3), $f1
	store   $f1, 2($i5)
	load    1($i2), $i3
	load    11($sp), $i5
	add     $i5, 1, $i6
	cmp     $i3, $i6, $i12
	bg      $i12, ble_else.25635
	li      0, $i2
	b       ble_cont.25636
ble_else.25635:
	li      0, $i12
	cmp     $i5, $i12, $i12
	bg      $i12, ble_else.25637
	li      0, $i2
	b       ble_cont.25638
ble_else.25637:
	load    0($i2), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.25639
	li      0, $i2
	b       ble_cont.25640
ble_else.25639:
	li      0, $i2
ble_cont.25640:
ble_cont.25638:
ble_cont.25636:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.25641
	load    0($i4), $i1
	li      0, $i2
	load    2($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25643, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25643:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	b       be_cont.25642
be_else.25641:
	li      0, $i6
	load    6($sp), $i3
	load    7($sp), $i2
	load    1($sp), $i11
	mov     $i5, $i10
	mov     $i2, $i5
	mov     $i10, $i2
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25644, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25644:
	sub     $sp, 14, $sp
	load    13($sp), $ra
be_cont.25642:
	load    0($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25645, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25645:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      1, $i1
	load    11($sp), $i2
	load    6($sp), $i3
	load    8($sp), $i4
	load    7($sp), $i5
	load    9($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.25646, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.25646:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.25634:
	load    11($sp), $i1
	add     $i1, 1, $i2
	load    10($sp), $i1
	add     $i1, 2, $i1
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25647
	sub     $i1, 5, $i1
	b       bge_cont.25648
bge_else.25647:
bge_cont.25648:
	mov     $i1, $i3
	load    12($sp), $i1
	load    1($i1), $i4
	cmp     $i4, $i2, $i12
	bg      $i12, ble_else.25649
	ret
ble_else.25649:
	store   $i3, 13($sp)
	store   $i2, 14($sp)
	load    1($i1), $i1
	sub     $i1, 1, $i1
	cmp     $i1, $i2, $i12
	bg      $i12, ble_else.25651
	b       ble_cont.25652
ble_else.25651:
	add     $i2, 1, $i2
	load    6($sp), $i1
	load    4($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25653, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25653:
	sub     $sp, 16, $sp
	load    15($sp), $ra
ble_cont.25652:
	li      0, $i1
	load    14($sp), $i2
	load    8($sp), $i3
	load    7($sp), $i4
	load    6($sp), $i5
	load    9($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25654, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25654:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	add     $i1, 1, $i1
	load    13($sp), $i2
	add     $i2, 2, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25655
	sub     $i2, 5, $i2
	b       bge_cont.25656
bge_else.25655:
bge_cont.25656:
	mov     $i2, $i5
	load    7($sp), $i2
	load    6($sp), $i3
	load    8($sp), $i4
	load    5($sp), $i11
	load    0($i11), $i10
	jr      $i10
create_float5x3array.3211:
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_create_float_array
	sub     $sp, 1, $sp
	load    0($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_create_array
	sub     $sp, 1, $sp
	load    0($sp), $ra
	store   $i1, 0($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	store   $i1, 4($i2)
	mov     $i2, $i1
	ret
init_line_elements.3215:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25657
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     create_float5x3array.3211
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $i1, 3($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     create_float5x3array.3211
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     create_float5x3array.3211
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     create_float5x3array.3211
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $hp, $i2
	add     $hp, 8, $hp
	store   $i1, 7($i2)
	load    8($sp), $i1
	store   $i1, 6($i2)
	load    7($sp), $i1
	store   $i1, 5($i2)
	load    6($sp), $i1
	store   $i1, 4($i2)
	load    5($sp), $i1
	store   $i1, 3($i2)
	load    4($sp), $i1
	store   $i1, 2($i2)
	load    3($sp), $i1
	store   $i1, 1($i2)
	load    2($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    0($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25658
	store   $i1, 9($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     create_float5x3array.3211
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $i1, 11($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $i1, 12($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $i1, 13($sp)
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     create_float5x3array.3211
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $i1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     create_float5x3array.3211
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $i1, 15($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	store   $i1, 16($sp)
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     create_float5x3array.3211
	sub     $sp, 18, $sp
	load    17($sp), $ra
	mov     $hp, $i2
	add     $hp, 8, $hp
	store   $i1, 7($i2)
	load    16($sp), $i1
	store   $i1, 6($i2)
	load    15($sp), $i1
	store   $i1, 5($i2)
	load    14($sp), $i1
	store   $i1, 4($i2)
	load    13($sp), $i1
	store   $i1, 3($i2)
	load    12($sp), $i1
	store   $i1, 2($i2)
	load    11($sp), $i1
	store   $i1, 1($i2)
	load    10($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    9($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	mov     $i3, $i1
	b       init_line_elements.3215
bge_else.25658:
	mov     $i3, $i1
	ret
bge_else.25657:
	ret
calc_dirvec.3225:
	load    9($i11), $i4
	load    8($i11), $f5
	load    7($i11), $f6
	load    6($i11), $f7
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	load    1($i11), $i9
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25659
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i5, 2($sp)
	store   $f2, 3($sp)
	store   $f1, 4($sp)
	fmul    $f1, $f1, $f1
	fmul    $f2, $f2, $f2
	fadd    $f1, $f2, $f1
	li      l.14035, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     sqrt.2751
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f2
	load    3($sp), $f3
	finv    $f1, $f15
	fmul    $f3, $f15, $f3
	li      l.14035, $i1
	load    0($i1), $f4
	finv    $f1, $f15
	fmul    $f4, $f15, $f1
	load    1($sp), $i1
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    0($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	store   $f2, 0($i3)
	store   $f3, 1($i3)
	store   $f1, 2($i3)
	add     $i2, 40, $i3
	add     $i1, $i3, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	fneg    $f3, $f4
	store   $f2, 0($i3)
	store   $f1, 1($i3)
	store   $f4, 2($i3)
	add     $i2, 80, $i3
	add     $i1, $i3, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	fneg    $f2, $f4
	fneg    $f3, $f5
	store   $f1, 0($i3)
	store   $f4, 1($i3)
	store   $f5, 2($i3)
	add     $i2, 1, $i3
	add     $i1, $i3, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	fneg    $f2, $f4
	fneg    $f3, $f5
	fneg    $f1, $f6
	store   $f4, 0($i3)
	store   $f5, 1($i3)
	store   $f6, 2($i3)
	add     $i2, 41, $i3
	add     $i1, $i3, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	fneg    $f2, $f4
	fneg    $f1, $f5
	store   $f4, 0($i3)
	store   $f5, 1($i3)
	store   $f3, 2($i3)
	add     $i2, 81, $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    0($i1), $i1
	fneg    $f1, $f1
	store   $f1, 0($i1)
	store   $f2, 1($i1)
	store   $f3, 2($i1)
	ret
bge_else.25659:
	store   $i7, 5($sp)
	store   $i8, 6($sp)
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 7($sp)
	store   $f4, 8($sp)
	store   $i1, 9($sp)
	store   $i6, 10($sp)
	store   $i4, 11($sp)
	store   $f6, 12($sp)
	store   $f7, 13($sp)
	store   $f5, 14($sp)
	store   $f3, 15($sp)
	store   $i9, 16($sp)
	fmul    $f2, $f2, $f1
	li      l.14334, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     sqrt.2751
	sub     $sp, 18, $sp
	load    17($sp), $ra
	store   $f1, 17($sp)
	li      l.14035, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    16($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.25661, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.25661:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    15($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 18($sp)
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25662
	load    14($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25664
	load    13($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25666
	load    12($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25668
	fsub    $f1, $f2, $f1
	load    11($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25670, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25670:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	b       ble_cont.25669
ble_else.25668:
	fsub    $f2, $f1, $f1
	load    11($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25671, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25671:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	fneg    $f1, $f1
ble_cont.25669:
	b       ble_cont.25667
ble_else.25666:
	fsub    $f2, $f1, $f1
	load    5($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25672, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25672:
	sub     $sp, 20, $sp
	load    19($sp), $ra
ble_cont.25667:
	b       ble_cont.25665
ble_else.25664:
	load    5($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25673, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25673:
	sub     $sp, 20, $sp
	load    19($sp), $ra
ble_cont.25665:
	b       ble_cont.25663
ble_else.25662:
	fneg    $f1, $f1
	load    11($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25674, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25674:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	fneg    $f1, $f1
ble_cont.25663:
	store   $f1, 19($sp)
	li      l.14001, $i1
	load    0($i1), $f1
	load    18($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25675
	load    14($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25677
	load    13($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25679
	load    12($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25681
	fsub    $f2, $f1, $f1
	load    10($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25683, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25683:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	b       ble_cont.25682
ble_else.25681:
	fsub    $f1, $f2, $f1
	load    10($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25684, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25684:
	sub     $sp, 21, $sp
	load    20($sp), $ra
ble_cont.25682:
	b       ble_cont.25680
ble_else.25679:
	fsub    $f1, $f2, $f1
	load    6($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25685, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25685:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	fneg    $f1, $f1
ble_cont.25680:
	b       ble_cont.25678
ble_else.25677:
	load    6($sp), $i11
	mov     $f2, $f1
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25686, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25686:
	sub     $sp, 21, $sp
	load    20($sp), $ra
ble_cont.25678:
	b       ble_cont.25676
ble_else.25675:
	fneg    $f2, $f1
	load    10($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.25687, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.25687:
	sub     $sp, 21, $sp
	load    20($sp), $ra
ble_cont.25676:
	load    19($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    17($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 20($sp)
	load    9($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 21($sp)
	fmul    $f1, $f1, $f1
	li      l.14334, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     sqrt.2751
	sub     $sp, 23, $sp
	load    22($sp), $ra
	store   $f1, 22($sp)
	li      l.14035, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    16($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.25688, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.25688:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    8($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 23($sp)
	li      l.14001, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25689
	load    14($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25691
	load    13($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25693
	load    12($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25695
	fsub    $f1, $f2, $f1
	load    11($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25697, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25697:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       ble_cont.25696
ble_else.25695:
	fsub    $f2, $f1, $f1
	load    11($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25698, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25698:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	fneg    $f1, $f1
ble_cont.25696:
	b       ble_cont.25694
ble_else.25693:
	fsub    $f2, $f1, $f1
	load    5($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25699, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25699:
	sub     $sp, 25, $sp
	load    24($sp), $ra
ble_cont.25694:
	b       ble_cont.25692
ble_else.25691:
	load    5($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25700, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25700:
	sub     $sp, 25, $sp
	load    24($sp), $ra
ble_cont.25692:
	b       ble_cont.25690
ble_else.25689:
	fneg    $f1, $f1
	load    11($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25701, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25701:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	fneg    $f1, $f1
ble_cont.25690:
	store   $f1, 24($sp)
	li      l.14001, $i1
	load    0($i1), $f1
	load    23($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25702
	load    14($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25704
	load    13($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25706
	load    12($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.25708
	fsub    $f2, $f1, $f1
	load    10($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.25710, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.25710:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	b       ble_cont.25709
ble_else.25708:
	fsub    $f1, $f2, $f1
	load    10($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.25711, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.25711:
	sub     $sp, 26, $sp
	load    25($sp), $ra
ble_cont.25709:
	b       ble_cont.25707
ble_else.25706:
	fsub    $f1, $f2, $f1
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.25712, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.25712:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	fneg    $f1, $f1
ble_cont.25707:
	b       ble_cont.25705
ble_else.25704:
	load    6($sp), $i11
	mov     $f2, $f1
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.25713, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.25713:
	sub     $sp, 26, $sp
	load    25($sp), $ra
ble_cont.25705:
	b       ble_cont.25703
ble_else.25702:
	fneg    $f2, $f1
	load    10($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.25714, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.25714:
	sub     $sp, 26, $sp
	load    25($sp), $ra
ble_cont.25703:
	load    24($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    22($sp), $f2
	fmul    $f1, $f2, $f2
	load    20($sp), $f1
	load    15($sp), $f3
	load    8($sp), $f4
	load    21($sp), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    7($sp), $i11
	load    0($i11), $i10
	jr      $i10
calc_dirvecs.3233:
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25715
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	store   $f1, 2($sp)
	store   $i3, 3($sp)
	store   $i2, 4($sp)
	store   $i4, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_float_of_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.14423, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.14425, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f3
	li      0, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	load    2($sp), $f4
	load    4($sp), $i2
	load    3($sp), $i3
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25716, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25716:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_float_of_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.14423, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.14334, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f3
	li      0, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	li      l.14001, $i2
	load    0($i2), $f2
	load    3($sp), $i2
	add     $i2, 2, $i3
	load    2($sp), $f4
	load    4($sp), $i2
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25717, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25717:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i1
	sub     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, 1, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25718
	sub     $i2, 5, $i2
	b       bge_cont.25719
bge_else.25718:
bge_cont.25719:
	load    2($sp), $f1
	load    3($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25715:
	ret
calc_dirvec_rows.3238:
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25721
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	store   $i3, 2($sp)
	store   $i2, 3($sp)
	store   $i4, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_float_of_int
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      l.14423, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.14425, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	li      4, $i1
	load    3($sp), $i2
	load    2($sp), $i3
	load    4($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.25722, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.25722:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    1($sp), $i1
	sub     $i1, 1, $i1
	load    3($sp), $i2
	add     $i2, 2, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25723
	sub     $i2, 5, $i2
	b       bge_cont.25724
bge_else.25723:
bge_cont.25724:
	load    2($sp), $i3
	add     $i3, 4, $i3
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25725
	store   $i1, 5($sp)
	store   $i3, 6($sp)
	store   $i2, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_float_of_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      l.14423, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.14425, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	li      4, $i1
	load    7($sp), $i2
	load    6($sp), $i3
	load    4($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.25726, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.25726:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    5($sp), $i1
	sub     $i1, 1, $i1
	load    7($sp), $i2
	add     $i2, 2, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25727
	sub     $i2, 5, $i2
	b       bge_cont.25728
bge_else.25727:
bge_cont.25728:
	load    6($sp), $i3
	add     $i3, 4, $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25725:
	ret
bge_else.25721:
	ret
create_dirvec_elements.3244:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25731
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	store   $i1, 2($sp)
	store   $i3, 3($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_float_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	mov     $i1, $i2
	store   $i2, 4($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    4($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    1($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25732
	store   $i1, 5($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	mov     $i1, $i2
	store   $i2, 6($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    6($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    5($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25733
	store   $i1, 7($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	mov     $i1, $i2
	store   $i2, 8($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    8($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    7($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25734
	store   $i1, 9($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	mov     $i1, $i2
	store   $i2, 10($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    10($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    9($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	load    0($sp), $i11
	mov     $i3, $i1
	load    0($i11), $i10
	jr      $i10
bge_else.25734:
	ret
bge_else.25733:
	ret
bge_else.25732:
	ret
bge_else.25731:
	ret
create_dirvecs.3247:
	load    3($i11), $i2
	load    2($i11), $i3
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25739
	store   $i11, 0($sp)
	store   $i4, 1($sp)
	store   $i1, 2($sp)
	store   $i3, 3($sp)
	store   $i2, 4($sp)
	li      120, $i1
	store   $i1, 5($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	mov     $i1, $i2
	store   $i2, 6($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    6($sp), $i1
	store   $i1, 0($i2)
	load    5($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    2($sp), $i2
	load    3($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i3, $i2, $i12
	load    0($i12), $i1
	store   $i1, 7($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	mov     $i1, $i2
	store   $i2, 8($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    8($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    7($sp), $i2
	store   $i1, 118($i2)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_float_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $i1, $i2
	store   $i2, 9($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    9($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    7($sp), $i2
	store   $i1, 117($i2)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	mov     $i1, $i2
	store   $i2, 10($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    10($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    7($sp), $i2
	store   $i1, 116($i2)
	li      115, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.25740, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.25740:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    2($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25741
	store   $i1, 11($sp)
	li      120, $i1
	store   $i1, 12($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_float_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	mov     $i1, $i2
	store   $i2, 13($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    13($sp), $i1
	store   $i1, 0($i2)
	load    12($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    11($sp), $i2
	load    3($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i3, $i2, $i12
	load    0($i12), $i1
	store   $i1, 14($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_float_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $i1, $i2
	store   $i2, 15($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    15($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    14($sp), $i2
	store   $i1, 118($i2)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_float_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	mov     $i1, $i2
	store   $i2, 16($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    16($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    14($sp), $i2
	store   $i1, 117($i2)
	li      116, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.25742, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.25742:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    11($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25741:
	ret
bge_else.25739:
	ret
init_dirvec_constants.3249:
	load    3($i11), $i3
	load    2($i11), $i4
	load    1($i11), $i5
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25745
	store   $i11, 0($sp)
	store   $i5, 1($sp)
	store   $i3, 2($sp)
	store   $i4, 3($sp)
	store   $i1, 4($sp)
	store   $i2, 5($sp)
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    0($i4), $i2
	sub     $i2, 1, $i2
	mov     $i5, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.25746, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.25746:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25747
	store   $i1, 6($sp)
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    3($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25748
	store   $i1, 7($sp)
	load    2($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25750
	store   $i2, 8($sp)
	store   $i4, 9($sp)
	mov     $i3, $i2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     setup_rect_table.3022
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25751
be_else.25750:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25752
	store   $i2, 8($sp)
	store   $i4, 9($sp)
	mov     $i3, $i2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     setup_surface_table.3025
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25753
be_else.25752:
	store   $i2, 8($sp)
	store   $i4, 9($sp)
	mov     $i3, $i2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     setup_second_table.3028
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25753:
be_cont.25751:
	sub     $i2, 1, $i2
	load    7($sp), $i1
	load    1($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.25754, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.25754:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       bge_cont.25749
bge_else.25748:
bge_cont.25749:
	load    6($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25755
	store   $i1, 10($sp)
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    3($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    1($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.25756, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.25756:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25757
	store   $i1, 11($sp)
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    3($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25758
	store   $i1, 12($sp)
	load    2($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25760
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	mov     $i3, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_rect_table.3022
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25761
be_else.25760:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25762
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	mov     $i3, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_surface_table.3025
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25763
be_else.25762:
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	mov     $i3, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_second_table.3028
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25763:
be_cont.25761:
	sub     $i2, 1, $i2
	load    12($sp), $i1
	load    1($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25764, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25764:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       bge_cont.25759
bge_else.25758:
bge_cont.25759:
	load    11($sp), $i1
	sub     $i1, 1, $i2
	load    4($sp), $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25757:
	ret
bge_else.25755:
	ret
bge_else.25747:
	ret
bge_else.25745:
	ret
init_vecset_constants.3252:
	load    5($i11), $i2
	load    4($i11), $i3
	load    3($i11), $i4
	load    2($i11), $i5
	load    1($i11), $i6
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25769
	store   $i11, 0($sp)
	store   $i6, 1($sp)
	store   $i1, 2($sp)
	store   $i5, 3($sp)
	store   $i2, 4($sp)
	store   $i4, 5($sp)
	store   $i3, 6($sp)
	add     $i6, $i1, $i12
	load    0($i12), $i1
	store   $i1, 7($sp)
	load    119($i1), $i1
	load    0($i3), $i3
	sub     $i3, 1, $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.25770
	store   $i1, 8($sp)
	add     $i2, $i3, $i12
	load    0($i12), $i2
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25772
	store   $i3, 9($sp)
	store   $i4, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_rect_table.3022
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25773
be_else.25772:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25774
	store   $i3, 9($sp)
	store   $i4, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_surface_table.3025
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25775
be_else.25774:
	store   $i3, 9($sp)
	store   $i4, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_second_table.3028
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25775:
be_cont.25773:
	sub     $i2, 1, $i2
	load    8($sp), $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.25776, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.25776:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       bge_cont.25771
bge_else.25770:
bge_cont.25771:
	load    7($sp), $i1
	load    118($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.25777, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.25777:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    7($sp), $i1
	load    117($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25778
	store   $i1, 11($sp)
	load    4($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25780
	store   $i2, 12($sp)
	store   $i4, 13($sp)
	mov     $i3, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     setup_rect_table.3022
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    12($sp), $i2
	load    13($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25781
be_else.25780:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25782
	store   $i2, 12($sp)
	store   $i4, 13($sp)
	mov     $i3, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     setup_surface_table.3025
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    12($sp), $i2
	load    13($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25783
be_else.25782:
	store   $i2, 12($sp)
	store   $i4, 13($sp)
	mov     $i3, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     setup_second_table.3028
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    12($sp), $i2
	load    13($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25783:
be_cont.25781:
	sub     $i2, 1, $i2
	load    11($sp), $i1
	load    5($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25784, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25784:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       bge_cont.25779
bge_else.25778:
bge_cont.25779:
	li      116, $i2
	load    7($sp), $i1
	load    3($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.25785, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.25785:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    2($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25786
	store   $i1, 14($sp)
	load    1($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 15($sp)
	load    119($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    5($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.25787, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.25787:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    118($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25788
	store   $i1, 16($sp)
	load    4($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25790
	store   $i2, 17($sp)
	store   $i4, 18($sp)
	mov     $i3, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     setup_rect_table.3022
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    17($sp), $i2
	load    18($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25791
be_else.25790:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25792
	store   $i2, 17($sp)
	store   $i4, 18($sp)
	mov     $i3, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     setup_surface_table.3025
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    17($sp), $i2
	load    18($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25793
be_else.25792:
	store   $i2, 17($sp)
	store   $i4, 18($sp)
	mov     $i3, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     setup_second_table.3028
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    17($sp), $i2
	load    18($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25793:
be_cont.25791:
	sub     $i2, 1, $i2
	load    16($sp), $i1
	load    5($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25794, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25794:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	b       bge_cont.25789
bge_else.25788:
bge_cont.25789:
	li      117, $i2
	load    15($sp), $i1
	load    3($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.25795, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.25795:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    14($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25796
	store   $i1, 19($sp)
	load    1($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 20($sp)
	load    119($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25797
	store   $i1, 21($sp)
	load    4($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25799
	store   $i2, 22($sp)
	store   $i4, 23($sp)
	mov     $i3, $i2
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     setup_rect_table.3022
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    22($sp), $i2
	load    23($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25800
be_else.25799:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25801
	store   $i2, 22($sp)
	store   $i4, 23($sp)
	mov     $i3, $i2
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     setup_surface_table.3025
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    22($sp), $i2
	load    23($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25802
be_else.25801:
	store   $i2, 22($sp)
	store   $i4, 23($sp)
	mov     $i3, $i2
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     setup_second_table.3028
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    22($sp), $i2
	load    23($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25802:
be_cont.25800:
	sub     $i2, 1, $i2
	load    21($sp), $i1
	load    5($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25803, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25803:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       bge_cont.25798
bge_else.25797:
bge_cont.25798:
	li      118, $i2
	load    20($sp), $i1
	load    3($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.25804, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.25804:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    19($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25805
	store   $i1, 24($sp)
	load    1($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      119, $i2
	load    3($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.25806, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.25806:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.25805:
	ret
bge_else.25796:
	ret
bge_else.25786:
	ret
bge_else.25769:
	ret
setup_rect_reflection.3263:
	load    6($i11), $i3
	store   $i3, 0($sp)
	load    5($i11), $i3
	store   $i3, 1($sp)
	load    4($i11), $i3
	store   $i3, 2($sp)
	load    3($i11), $i4
	store   $i4, 3($sp)
	load    2($i11), $i4
	store   $i4, 4($sp)
	load    1($i11), $i5
	store   $i5, 5($sp)
	sll     $i1, 2, $i1
	store   $i1, 6($sp)
	load    0($i3), $i3
	store   $i3, 7($sp)
	li      l.14035, $i3
	load    0($i3), $f1
	load    7($i2), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 8($sp)
	load    0($i4), $f1
	fneg    $f1, $f1
	store   $f1, 9($sp)
	load    1($i4), $f1
	fneg    $f1, $f1
	store   $f1, 10($sp)
	load    2($i4), $f1
	fneg    $f1, $f1
	store   $f1, 11($sp)
	add     $i1, 1, $i1
	store   $i1, 12($sp)
	load    0($i4), $f1
	store   $f1, 13($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	mov     $i1, $i2
	store   $i2, 14($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    14($sp), $i3
	store   $i3, 0($i2)
	store   $i2, 15($sp)
	load    13($sp), $f1
	store   $f1, 0($i3)
	load    10($sp), $f1
	store   $f1, 1($i3)
	load    11($sp), $f1
	store   $f1, 2($i3)
	load    3($sp), $i4
	load    0($i4), $i4
	sub     $i4, 1, $i4
	li      0, $i12
	cmp     $i4, $i12, $i12
	bl      $i12, bge_else.25811
	load    1($sp), $i2
	add     $i2, $i4, $i12
	load    0($i12), $i2
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25813
	store   $i4, 16($sp)
	store   $i1, 17($sp)
	mov     $i3, $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     setup_rect_table.3022
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    16($sp), $i2
	load    17($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25814
be_else.25813:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25815
	store   $i4, 16($sp)
	store   $i1, 17($sp)
	mov     $i3, $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     setup_surface_table.3025
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    16($sp), $i2
	load    17($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25816
be_else.25815:
	store   $i4, 16($sp)
	store   $i1, 17($sp)
	mov     $i3, $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     setup_second_table.3028
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    16($sp), $i2
	load    17($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25816:
be_cont.25814:
	sub     $i2, 1, $i2
	load    15($sp), $i1
	load    5($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.25817, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.25817:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	b       bge_cont.25812
bge_else.25811:
bge_cont.25812:
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    8($sp), $f1
	store   $f1, 2($i1)
	load    15($sp), $i2
	store   $i2, 1($i1)
	load    12($sp), $i2
	store   $i2, 0($i1)
	load    7($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	store   $i1, 18($sp)
	load    6($sp), $i1
	add     $i1, 2, $i1
	store   $i1, 19($sp)
	load    4($sp), $i1
	load    1($i1), $f1
	store   $f1, 20($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_float_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	mov     $i1, $i2
	store   $i2, 21($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_create_array
	sub     $sp, 23, $sp
	load    22($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    21($sp), $i3
	store   $i3, 0($i2)
	store   $i2, 22($sp)
	load    9($sp), $f1
	store   $f1, 0($i3)
	load    20($sp), $f1
	store   $f1, 1($i3)
	load    11($sp), $f1
	store   $f1, 2($i3)
	load    3($sp), $i4
	load    0($i4), $i4
	sub     $i4, 1, $i4
	li      0, $i12
	cmp     $i4, $i12, $i12
	bl      $i12, bge_else.25818
	load    1($sp), $i2
	add     $i2, $i4, $i12
	load    0($i12), $i2
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25820
	store   $i4, 23($sp)
	store   $i1, 24($sp)
	mov     $i3, $i1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     setup_rect_table.3022
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    23($sp), $i2
	load    24($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25821
be_else.25820:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25822
	store   $i4, 23($sp)
	store   $i1, 24($sp)
	mov     $i3, $i1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     setup_surface_table.3025
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    23($sp), $i2
	load    24($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25823
be_else.25822:
	store   $i4, 23($sp)
	store   $i1, 24($sp)
	mov     $i3, $i1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     setup_second_table.3028
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    23($sp), $i2
	load    24($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25823:
be_cont.25821:
	sub     $i2, 1, $i2
	load    22($sp), $i1
	load    5($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.25824, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.25824:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	b       bge_cont.25819
bge_else.25818:
bge_cont.25819:
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    8($sp), $f1
	store   $f1, 2($i1)
	load    22($sp), $i2
	store   $i2, 1($i1)
	load    19($sp), $i2
	store   $i2, 0($i1)
	load    18($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    7($sp), $i1
	add     $i1, 2, $i1
	store   $i1, 25($sp)
	load    6($sp), $i1
	add     $i1, 3, $i1
	store   $i1, 26($sp)
	load    4($sp), $i1
	load    2($i1), $f1
	store   $f1, 27($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_create_float_array
	sub     $sp, 29, $sp
	load    28($sp), $ra
	mov     $i1, $i2
	store   $i2, 28($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_create_array
	sub     $sp, 30, $sp
	load    29($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    28($sp), $i3
	store   $i3, 0($i2)
	store   $i2, 29($sp)
	load    9($sp), $f1
	store   $f1, 0($i3)
	load    10($sp), $f1
	store   $f1, 1($i3)
	load    27($sp), $f1
	store   $f1, 2($i3)
	load    3($sp), $i4
	load    0($i4), $i4
	sub     $i4, 1, $i4
	li      0, $i12
	cmp     $i4, $i12, $i12
	bl      $i12, bge_else.25825
	load    1($sp), $i2
	add     $i2, $i4, $i12
	load    0($i12), $i2
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25827
	store   $i4, 30($sp)
	store   $i1, 31($sp)
	mov     $i3, $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     setup_rect_table.3022
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    30($sp), $i2
	load    31($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25828
be_else.25827:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25829
	store   $i4, 30($sp)
	store   $i1, 31($sp)
	mov     $i3, $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     setup_surface_table.3025
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    30($sp), $i2
	load    31($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25830
be_else.25829:
	store   $i4, 30($sp)
	store   $i1, 31($sp)
	mov     $i3, $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     setup_second_table.3028
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    30($sp), $i2
	load    31($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25830:
be_cont.25828:
	sub     $i2, 1, $i2
	load    29($sp), $i1
	load    5($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.25831, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.25831:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	b       bge_cont.25826
bge_else.25825:
bge_cont.25826:
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    8($sp), $f1
	store   $f1, 2($i1)
	load    29($sp), $i2
	store   $i2, 1($i1)
	load    26($sp), $i2
	store   $i2, 0($i1)
	load    25($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    7($sp), $i1
	add     $i1, 3, $i1
	load    2($sp), $i2
	store   $i1, 0($i2)
	ret
setup_surface_reflection.3266:
	load    6($i11), $i3
	store   $i3, 0($sp)
	load    5($i11), $i3
	store   $i3, 1($sp)
	load    4($i11), $i3
	store   $i3, 2($sp)
	load    3($i11), $i4
	store   $i4, 3($sp)
	load    2($i11), $i4
	load    1($i11), $i5
	store   $i5, 4($sp)
	sll     $i1, 2, $i1
	add     $i1, 1, $i1
	store   $i1, 5($sp)
	load    0($i3), $i1
	store   $i1, 6($sp)
	li      l.14035, $i1
	load    0($i1), $f1
	load    7($i2), $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 7($sp)
	load    4($i2), $i1
	load    0($i4), $f1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($i4), $f2
	load    1($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i4), $f2
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	li      l.14050, $i1
	load    0($i1), $f2
	load    4($i2), $i1
	load    0($i1), $f3
	fmul    $f2, $f3, $f2
	fmul    $f2, $f1, $f2
	load    0($i4), $f3
	fsub    $f2, $f3, $f2
	store   $f2, 8($sp)
	li      l.14050, $i1
	load    0($i1), $f2
	load    4($i2), $i1
	load    1($i1), $f3
	fmul    $f2, $f3, $f2
	fmul    $f2, $f1, $f2
	load    1($i4), $f3
	fsub    $f2, $f3, $f2
	store   $f2, 9($sp)
	li      l.14050, $i1
	load    0($i1), $f2
	load    4($i2), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fmul    $f2, $f1, $f1
	load    2($i4), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 10($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_float_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $i1, $i2
	store   $i2, 11($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    11($sp), $i3
	store   $i3, 0($i2)
	store   $i2, 12($sp)
	load    8($sp), $f1
	store   $f1, 0($i3)
	load    9($sp), $f1
	store   $f1, 1($i3)
	load    10($sp), $f1
	store   $f1, 2($i3)
	load    3($sp), $i4
	load    0($i4), $i4
	sub     $i4, 1, $i4
	li      0, $i12
	cmp     $i4, $i12, $i12
	bl      $i12, bge_else.25833
	load    1($sp), $i2
	add     $i2, $i4, $i12
	load    0($i12), $i2
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25835
	store   $i4, 13($sp)
	store   $i1, 14($sp)
	mov     $i3, $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_rect_table.3022
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25836
be_else.25835:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25837
	store   $i4, 13($sp)
	store   $i1, 14($sp)
	mov     $i3, $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_surface_table.3025
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25838
be_else.25837:
	store   $i4, 13($sp)
	store   $i1, 14($sp)
	mov     $i3, $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_second_table.3028
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25838:
be_cont.25836:
	sub     $i2, 1, $i2
	load    12($sp), $i1
	load    4($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.25839, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.25839:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       bge_cont.25834
bge_else.25833:
bge_cont.25834:
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    7($sp), $f1
	store   $f1, 2($i1)
	load    12($sp), $i2
	store   $i2, 1($i1)
	load    5($sp), $i2
	store   $i2, 0($i1)
	load    6($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	load    2($sp), $i2
	store   $i1, 0($i2)
	ret
rt.3271:
	load    25($i11), $i3
	store   $i3, 0($sp)
	load    24($i11), $i3
	store   $i3, 1($sp)
	load    23($i11), $i3
	store   $i3, 2($sp)
	load    22($i11), $i3
	store   $i3, 3($sp)
	load    21($i11), $i3
	store   $i3, 4($sp)
	load    20($i11), $i3
	store   $i3, 5($sp)
	load    19($i11), $i3
	store   $i3, 6($sp)
	load    18($i11), $i3
	store   $i3, 7($sp)
	load    17($i11), $i3
	store   $i3, 8($sp)
	load    16($i11), $i3
	store   $i3, 9($sp)
	load    15($i11), $i3
	store   $i3, 10($sp)
	load    14($i11), $i3
	store   $i3, 11($sp)
	load    13($i11), $i3
	store   $i3, 12($sp)
	load    12($i11), $i3
	store   $i3, 13($sp)
	load    11($i11), $i3
	store   $i3, 14($sp)
	load    10($i11), $i3
	store   $i3, 15($sp)
	load    9($i11), $i3
	store   $i3, 16($sp)
	load    8($i11), $i3
	store   $i3, 17($sp)
	load    7($i11), $i3
	store   $i3, 18($sp)
	load    6($i11), $i3
	store   $i3, 19($sp)
	load    5($i11), $i3
	store   $i3, 20($sp)
	load    4($i11), $i4
	load    3($i11), $i5
	store   $i5, 21($sp)
	load    2($i11), $i5
	store   $i5, 22($sp)
	load    1($i11), $i5
	store   $i5, 23($sp)
	store   $i1, 0($i3)
	store   $i2, 1($i3)
	srl     $i1, 1, $i3
	store   $i3, 0($i4)
	srl     $i2, 1, $i2
	store   $i2, 1($i4)
	li      l.14518, $i2
	load    0($i2), $f1
	store   $f1, 24($sp)
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_float_of_int
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    4($sp), $i1
	store   $f1, 0($i1)
	load    20($sp), $i1
	load    0($i1), $i1
	store   $i1, 25($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_create_float_array
	sub     $sp, 27, $sp
	load    26($sp), $ra
	store   $i1, 26($sp)
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     create_float5x3array.3211
	sub     $sp, 28, $sp
	load    27($sp), $ra
	store   $i1, 27($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_create_array
	sub     $sp, 29, $sp
	load    28($sp), $ra
	store   $i1, 28($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_create_array
	sub     $sp, 30, $sp
	load    29($sp), $ra
	store   $i1, 29($sp)
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     create_float5x3array.3211
	sub     $sp, 31, $sp
	load    30($sp), $ra
	store   $i1, 30($sp)
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     create_float5x3array.3211
	sub     $sp, 32, $sp
	load    31($sp), $ra
	store   $i1, 31($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	store   $i1, 32($sp)
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     create_float5x3array.3211
	sub     $sp, 34, $sp
	load    33($sp), $ra
	mov     $hp, $i2
	add     $hp, 8, $hp
	store   $i1, 7($i2)
	load    32($sp), $i1
	store   $i1, 6($i2)
	load    31($sp), $i1
	store   $i1, 5($i2)
	load    30($sp), $i1
	store   $i1, 4($i2)
	load    29($sp), $i1
	store   $i1, 3($i2)
	load    28($sp), $i1
	store   $i1, 2($i2)
	load    27($sp), $i1
	store   $i1, 1($i2)
	load    26($sp), $i1
	store   $i1, 0($i2)
	load    25($sp), $i1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_create_array
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    20($sp), $i2
	load    0($i2), $i2
	sub     $i2, 2, $i2
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     init_line_elements.3215
	sub     $sp, 34, $sp
	load    33($sp), $ra
	store   $i1, 33($sp)
	load    20($sp), $i1
	load    0($i1), $i1
	store   $i1, 34($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_create_float_array
	sub     $sp, 36, $sp
	load    35($sp), $ra
	store   $i1, 35($sp)
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     create_float5x3array.3211
	sub     $sp, 37, $sp
	load    36($sp), $ra
	store   $i1, 36($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	store   $i1, 37($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	store   $i1, 38($sp)
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     create_float5x3array.3211
	sub     $sp, 40, $sp
	load    39($sp), $ra
	store   $i1, 39($sp)
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     create_float5x3array.3211
	sub     $sp, 41, $sp
	load    40($sp), $ra
	store   $i1, 40($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_create_array
	sub     $sp, 42, $sp
	load    41($sp), $ra
	store   $i1, 41($sp)
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     create_float5x3array.3211
	sub     $sp, 43, $sp
	load    42($sp), $ra
	mov     $hp, $i2
	add     $hp, 8, $hp
	store   $i1, 7($i2)
	load    41($sp), $i1
	store   $i1, 6($i2)
	load    40($sp), $i1
	store   $i1, 5($i2)
	load    39($sp), $i1
	store   $i1, 4($i2)
	load    38($sp), $i1
	store   $i1, 3($i2)
	load    37($sp), $i1
	store   $i1, 2($i2)
	load    36($sp), $i1
	store   $i1, 1($i2)
	load    35($sp), $i1
	store   $i1, 0($i2)
	load    34($sp), $i1
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     min_caml_create_array
	sub     $sp, 43, $sp
	load    42($sp), $ra
	load    20($sp), $i2
	load    0($i2), $i2
	sub     $i2, 2, $i2
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     init_line_elements.3215
	sub     $sp, 43, $sp
	load    42($sp), $ra
	store   $i1, 42($sp)
	load    20($sp), $i1
	load    0($i1), $i1
	store   $i1, 43($sp)
	li      3, $i1
	li      l.14001, $i2
	load    0($i2), $f1
	store   $ra, 44($sp)
	add     $sp, 45, $sp
	jal     min_caml_create_float_array
	sub     $sp, 45, $sp
	load    44($sp), $ra
	store   $i1, 44($sp)
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     create_float5x3array.3211
	sub     $sp, 46, $sp
	load    45($sp), $ra
	store   $i1, 45($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 46($sp)
	add     $sp, 47, $sp
	jal     min_caml_create_array
	sub     $sp, 47, $sp
	load    46($sp), $ra
	store   $i1, 46($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 47($sp)
	add     $sp, 48, $sp
	jal     min_caml_create_array
	sub     $sp, 48, $sp
	load    47($sp), $ra
	store   $i1, 47($sp)
	store   $ra, 48($sp)
	add     $sp, 49, $sp
	jal     create_float5x3array.3211
	sub     $sp, 49, $sp
	load    48($sp), $ra
	store   $i1, 48($sp)
	store   $ra, 49($sp)
	add     $sp, 50, $sp
	jal     create_float5x3array.3211
	sub     $sp, 50, $sp
	load    49($sp), $ra
	store   $i1, 49($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 50($sp)
	add     $sp, 51, $sp
	jal     min_caml_create_array
	sub     $sp, 51, $sp
	load    50($sp), $ra
	store   $i1, 50($sp)
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     create_float5x3array.3211
	sub     $sp, 52, $sp
	load    51($sp), $ra
	mov     $hp, $i2
	add     $hp, 8, $hp
	store   $i1, 7($i2)
	load    50($sp), $i1
	store   $i1, 6($i2)
	load    49($sp), $i1
	store   $i1, 5($i2)
	load    48($sp), $i1
	store   $i1, 4($i2)
	load    47($sp), $i1
	store   $i1, 3($i2)
	load    46($sp), $i1
	store   $i1, 2($i2)
	load    45($sp), $i1
	store   $i1, 1($i2)
	load    44($sp), $i1
	store   $i1, 0($i2)
	load    43($sp), $i1
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_create_array
	sub     $sp, 52, $sp
	load    51($sp), $ra
	load    20($sp), $i2
	load    0($i2), $i2
	sub     $i2, 2, $i2
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     init_line_elements.3215
	sub     $sp, 52, $sp
	load    51($sp), $ra
	store   $i1, 51($sp)
	load    6($sp), $i11
	store   $ra, 52($sp)
	load    0($i11), $i10
	li      cls.25841, $ra
	add     $sp, 53, $sp
	jr      $i10
cls.25841:
	sub     $sp, 53, $sp
	load    52($sp), $ra
	load    9($sp), $i11
	store   $ra, 52($sp)
	load    0($i11), $i10
	li      cls.25842, $ra
	add     $sp, 53, $sp
	jr      $i10
cls.25842:
	sub     $sp, 53, $sp
	load    52($sp), $ra
	li      0, $i1
	store   $i1, 52($sp)
	load    8($sp), $i11
	store   $ra, 53($sp)
	load    0($i11), $i10
	li      cls.25843, $ra
	add     $sp, 54, $sp
	jr      $i10
cls.25843:
	sub     $sp, 54, $sp
	load    53($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.25844
	load    14($sp), $i1
	load    52($sp), $i2
	store   $i2, 0($i1)
	b       be_cont.25845
be_else.25844:
	li      1, $i1
	load    7($sp), $i11
	store   $ra, 53($sp)
	load    0($i11), $i10
	li      cls.25846, $ra
	add     $sp, 54, $sp
	jr      $i10
cls.25846:
	sub     $sp, 54, $sp
	load    53($sp), $ra
be_cont.25845:
	li      0, $i1
	load    10($sp), $i11
	store   $ra, 53($sp)
	load    0($i11), $i10
	li      cls.25847, $ra
	add     $sp, 54, $sp
	jr      $i10
cls.25847:
	sub     $sp, 54, $sp
	load    53($sp), $ra
	li      0, $i1
	store   $ra, 53($sp)
	add     $sp, 54, $sp
	jal     read_or_network.2932
	sub     $sp, 54, $sp
	load    53($sp), $ra
	load    12($sp), $i2
	store   $i1, 0($i2)
	store   $ra, 53($sp)
	add     $sp, 54, $sp
	jal     write_ppm_header.3179
	sub     $sp, 54, $sp
	load    53($sp), $ra
	li      4, $i1
	load    22($sp), $i11
	store   $ra, 53($sp)
	load    0($i11), $i10
	li      cls.25848, $ra
	add     $sp, 54, $sp
	jr      $i10
cls.25848:
	sub     $sp, 54, $sp
	load    53($sp), $ra
	li      9, $i1
	li      0, $i2
	li      0, $i3
	load    23($sp), $i11
	store   $ra, 53($sp)
	load    0($i11), $i10
	li      cls.25849, $ra
	add     $sp, 54, $sp
	jr      $i10
cls.25849:
	sub     $sp, 54, $sp
	load    53($sp), $ra
	load    21($sp), $i1
	load    4($i1), $i1
	store   $i1, 53($sp)
	load    119($i1), $i1
	load    14($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.25850
	store   $i1, 54($sp)
	load    13($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25852
	store   $i2, 55($sp)
	store   $i4, 56($sp)
	mov     $i3, $i2
	store   $ra, 57($sp)
	add     $sp, 58, $sp
	jal     setup_rect_table.3022
	sub     $sp, 58, $sp
	load    57($sp), $ra
	load    55($sp), $i2
	load    56($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25853
be_else.25852:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.25854
	store   $i2, 55($sp)
	store   $i4, 56($sp)
	mov     $i3, $i2
	store   $ra, 57($sp)
	add     $sp, 58, $sp
	jal     setup_surface_table.3025
	sub     $sp, 58, $sp
	load    57($sp), $ra
	load    55($sp), $i2
	load    56($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.25855
be_else.25854:
	store   $i2, 55($sp)
	store   $i4, 56($sp)
	mov     $i3, $i2
	store   $ra, 57($sp)
	add     $sp, 58, $sp
	jal     setup_second_table.3028
	sub     $sp, 58, $sp
	load    57($sp), $ra
	load    55($sp), $i2
	load    56($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.25855:
be_cont.25853:
	sub     $i2, 1, $i2
	load    54($sp), $i1
	load    17($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25856, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25856:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	b       bge_cont.25851
bge_else.25850:
bge_cont.25851:
	li      118, $i2
	load    53($sp), $i1
	load    19($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25857, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25857:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	load    21($sp), $i1
	load    3($i1), $i1
	li      119, $i2
	load    19($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25858, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25858:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	li      2, $i1
	load    18($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25859, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25859:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	load    16($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    14($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i2
	load    15($sp), $i1
	load    17($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25860, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25860:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	load    14($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.25861
	load    13($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    2($i2), $i3
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25863
	load    7($i2), $i3
	load    0($i3), $f1
	li      l.14035, $i3
	load    0($i3), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.25865
	li      0, $i3
	b       ble_cont.25866
ble_else.25865:
	li      1, $i3
ble_cont.25866:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25867
	b       be_cont.25868
be_else.25867:
	load    1($i2), $i3
	li      1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25869
	load    2($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25871, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25871:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	b       be_cont.25870
be_else.25869:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.25872
	load    1($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25874, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25874:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	b       be_cont.25873
be_else.25872:
be_cont.25873:
be_cont.25870:
be_cont.25868:
	b       be_cont.25864
be_else.25863:
be_cont.25864:
	b       bge_cont.25862
bge_else.25861:
bge_cont.25862:
	li      0, $i2
	li      0, $i3
	load    42($sp), $i1
	load    11($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.25875, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.25875:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	li      0, $i2
	li      2, $i3
	load    20($sp), $i1
	load    1($i1), $i4
	li      0, $i12
	cmp     $i4, $i12, $i12
	bg      $i12, ble_else.25876
	ret
ble_else.25876:
	store   $i2, 57($sp)
	load    1($i1), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.25878
	b       ble_cont.25879
ble_else.25878:
	li      1, $i2
	load    51($sp), $i1
	load    11($sp), $i11
	store   $ra, 58($sp)
	load    0($i11), $i10
	li      cls.25880, $ra
	add     $sp, 59, $sp
	jr      $i10
cls.25880:
	sub     $sp, 59, $sp
	load    58($sp), $ra
ble_cont.25879:
	li      0, $i1
	load    57($sp), $i2
	load    33($sp), $i3
	load    42($sp), $i4
	load    51($sp), $i5
	load    3($sp), $i11
	store   $ra, 58($sp)
	load    0($i11), $i10
	li      cls.25881, $ra
	add     $sp, 59, $sp
	jr      $i10
cls.25881:
	sub     $sp, 59, $sp
	load    58($sp), $ra
	li      1, $i1
	li      4, $i5
	load    42($sp), $i2
	load    51($sp), $i3
	load    33($sp), $i4
	load    5($sp), $i11
	load    0($i11), $i10
	jr      $i10
l.14555:	.float  1.5707963268E+00
l.14553:	.float  6.2831853072E+00
l.14551:	.float  3.1415926536E+00
l.14518:	.float  1.2800000000E+02
l.14425:	.float  9.0000000000E-01
l.14423:	.float  2.0000000000E-01
l.14354:	.float  1.5000000000E+02
l.14350:	.float  -1.5000000000E+02
l.14334:	.float  1.0000000000E-01
l.14330:	.float  -2.0000000000E+00
l.14328:	.float  3.9062500000E-03
l.14303:	.float  2.0000000000E+01
l.14301:	.float  5.0000000000E-02
l.14295:	.float  2.5000000000E-01
l.14288:	.float  1.0000000000E+01
l.14286:	.float  3.0000000000E-01
l.14284:	.float  2.5500000000E+02
l.14278:	.float  1.5000000000E-01
l.14270:	.float  3.1415927000E+00
l.14268:	.float  3.0000000000E+01
l.14265:	.float  1.5000000000E+01
l.14263:	.float  1.0000000000E-04
l.14251:	.float  1.0000000000E+08
l.14248:	.float  1.0000000000E+09
l.14240:	.float  -1.0000000000E-01
l.14237:	.float  1.0000000000E-02
l.14235:	.float  -2.0000000000E-01
l.14111:	.float  -2.0000000000E+02
l.14109:	.float  2.0000000000E+02
l.14102:	.float  1.7453293000E-02
l.14099:	.float  -1.0000000000E+00
l.14077:	.float  3.0000000000E+00
l.14050:	.float  2.0000000000E+00
l.14035:	.float  1.0000000000E+00
l.14008:	.float  -6.0725293501E-01
l.14003:	.float  6.0725293501E-01
l.14001:	.float  0.0000000000E+00
l.13994:	.float  5.0000000000E-01
######################################################################
#
# 		↓　ここから lib_asm.s
#
######################################################################

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
# * 算術関数用定数テーブル
######################################################################
min_caml_atan_table:
	.float 0.785398163397448279
	.float 0.463647609000806094
	.float 0.244978663126864143
	.float 0.124354994546761438
	.float 0.06241880999595735
	.float 0.0312398334302682774
	.float 0.0156237286204768313
	.float 0.00781234106010111114
	.float 0.00390623013196697176
	.float 0.00195312251647881876
	.float 0.000976562189559319459
	.float 0.00048828121119489829
	.float 0.000244140620149361771
	.float 0.000122070311893670208
	.float 6.10351561742087726e-05
	.float 3.05175781155260957e-05
	.float 1.52587890613157615e-05
	.float 7.62939453110197e-06
	.float 3.81469726560649614e-06
	.float 1.90734863281018696e-06
	.float 9.53674316405960844e-07
	.float 4.76837158203088842e-07
	.float 2.38418579101557974e-07
	.float 1.19209289550780681e-07
	.float 5.96046447753905522e-08
min_caml_rsqrt_table:
	.float 1.0
	.float 0.707106781186547462
	.float 0.5
	.float 0.353553390593273731
	.float 0.25
	.float 0.176776695296636865
	.float 0.125
	.float 0.0883883476483184327
	.float 0.0625
	.float 0.0441941738241592164
	.float 0.03125
	.float 0.0220970869120796082
	.float 0.015625
	.float 0.0110485434560398041
	.float 0.0078125
	.float 0.00552427172801990204
	.float 0.00390625
	.float 0.00276213586400995102
	.float 0.001953125
	.float 0.00138106793200497551
	.float 0.0009765625
	.float 0.000690533966002487756
	.float 0.00048828125
	.float 0.000345266983001243878
	.float 0.000244140625
	.float 0.000172633491500621939
	.float 0.0001220703125
	.float 8.63167457503109694e-05
	.float 6.103515625e-05
	.float 4.31583728751554847e-05
	.float 3.0517578125e-05
	.float 2.15791864375777424e-05
	.float 1.52587890625e-05
	.float 1.07895932187888712e-05
	.float 7.62939453125e-06
	.float 5.39479660939443559e-06
	.float 3.814697265625e-06
	.float 2.6973983046972178e-06
	.float 1.9073486328125e-06
	.float 1.3486991523486089e-06
	.float 9.5367431640625e-07
	.float 6.74349576174304449e-07
	.float 4.76837158203125e-07
	.float 3.37174788087152224e-07
	.float 2.384185791015625e-07
	.float 1.68587394043576112e-07
	.float 1.1920928955078125e-07
	.float 8.42936970217880561e-08
	.float 5.9604644775390625e-08
	.float 4.21468485108940281e-08

######################################################################
# * floor
######################################################################
# floor(f) = itof(ftoi(f)) という適当仕様
# これじゃおそらく明らかに誤差るので、まだ要実装
min_caml_floor:
	store $sp $ra 0
	addi $sp $sp 1
	jal min_caml_int_of_float
	jal min_caml_float_of_int
	addi $sp $sp -1
	load $sp $ra 0
	jr $ra


######################################################################
# * float_of_int
######################################################################
min_caml_float_of_int:
	cmp $i1 $zero $cond
	bge $cond ITOF_MAIN		# if ($i1 >= 0) goto ITOF_MAIN
	sub $zero $i1 $i1		# 正の値にしてitofした後に、マイナスにしてかえす
	store $sp $ra 0
	addi $sp $sp 1
	jal min_caml_float_of_int	# $f1 = float_of_int(-$i1)
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
# * int_of_float
######################################################################
min_caml_int_of_float:
	fcmp $f1 $fzero $cond
	bge $cond FTOI_MAIN		# if ($f1 >= 0) goto FTOI_MAIN
	fsub $fzero $f1 $f1		# 正の値にしてftoiした後に、マイナスにしてかえす
	store $sp $ra 0
	addi $sp $sp 1
	jal min_caml_int_of_float	# $i1 = float_of_int(-$f1)
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
# * read_int
# * intバイナリ読み込み
######################################################################
min_caml_read_int:
read_int_1:
	read $i1
	li 255, $i2
	cmp $i1, $i2, $i2
	bg $i2, read_int_1
	sll $i1, 24, $i1
read_int_2:
	read $i2
	li 255, $i3
	cmp $i2, $i3, $i3
	bg $i3, read_int_2
	sll $i2, 16, $i2
	add $i1, $i2, $i1
read_int_3:
	read $i2
	li 255, $i3
	cmp $i2, $i3, $i3
	bg $i3, read_int_3
	sll $i2, 8, $i2
	add $i1, $i2, $i1
read_int_4:
	read $i2
	li 255, $i3
	cmp $i2, $i3, $i3
	bg $i3, read_int_4
	add $i1, $i2, $i1
	ret

######################################################################
# * read_float
# * floatバイナリ読み込み
######################################################################
min_caml_read_float:
read_float_1:
	read $i1
	li 255, $i2
	cmp $i1, $i2, $i2
	bg $i2, read_float_1
	sll $i1, 24, $i1
read_float_2:
	read $i2
	li 255, $i3
	cmp $i2, $i3, $i3
	bg $i3, read_float_2
	sll $i2, 16, $i2
	add $i1, $i2, $i1
read_float_3:
	read $i2
	li 255, $i3
	cmp $i2, $i3, $i3
	bg $i3, read_float_3
	sll $i2, 8, $i2
	add $i1, $i2, $i1
read_float_4:
	read $i2
	li 255, $i3
	cmp $i2, $i3, $i3
	bg $i3, read_float_4
	add $i1, $i2, $i1
	mov $i1, $f1 #intレジスタからfloatレジスタへ移動
	ret

######################################################################
# * read
# * バイト読み込み
# * 失敗してたらループ
######################################################################
min_caml_read:
	read $i1
	li 255, $i2
	cmp $i1, $i2, $i3
	bg $i3, min_caml_read
	ret

######################################################################
# * write
# * バイト出力
# * 失敗してたらループ
######################################################################
min_caml_write:
	write $i1, $i2
	cmp $i2, $zero, $i3
	bg $i3, min_caml_write
	ret

######################################################################
# * create_array
######################################################################
min_caml_create_array:
	add $i1, $hp, $i3
	mov $hp, $i1
CREATE_ARRAY_LOOP:
	cmp $hp, $i3, $i4
	bge $i4, CREATE_ARRAY_END
	store $i2, 0($hp)
	add $hp, 1, $hp
	b CREATE_ARRAY_LOOP
CREATE_ARRAY_END:
	ret

######################################################################
# * create_float_array
######################################################################
min_caml_create_float_array:
	add $i1, $hp, $i3
	mov $hp, $i1
CREATE_FLOAT_ARRAY_LOOP:
	cmp $hp, $i3, $i4
	bge $i4, CREATE_FLOAT_ARRAY_END
	store $f1, 0($hp)
	add $hp, 1, $hp
	b CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	ret


######################################################################
#
# 		↑　ここまで lib_asm.s
#
######################################################################
