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
	li      0x7fff, $hp
	sll     $hp, 4, $sp

######################################################################
#
# 		↑　ここまで macro.s
#
######################################################################
	li      25, $i1
	store   $i1, 0($sp)
	li      l.26558, $i2
	load    0($i2), $f1
	store   $f1, 1($sp)
	li      l.26560, $i2
	load    0($i2), $f2
	store   $f2, 2($sp)
	li      l.26562, $i2
	load    0($i2), $f3
	store   $f3, 3($sp)
	mov     $hp, $i2
	store   $i2, 4($sp)
	add     $hp, 2, $hp
	li      cordic_sin.2715, $i3
	store   $i3, 0($i2)
	store   $i1, 1($i2)
	mov     $hp, $i3
	store   $i3, 5($sp)
	add     $hp, 2, $hp
	li      cordic_cos.2717, $i4
	store   $i4, 0($i3)
	store   $i1, 1($i3)
	mov     $hp, $i4
	store   $i4, 6($sp)
	add     $hp, 2, $hp
	li      cordic_atan.2719, $i5
	store   $i5, 0($i4)
	store   $i1, 1($i4)
	mov     $hp, $i4
	store   $i4, 7($sp)
	add     $hp, 6, $hp
	li      sin.2721, $i5
	store   $i5, 0($i4)
	store   $f3, 5($i4)
	store   $f2, 4($i4)
	store   $f1, 3($i4)
	store   $i2, 2($i4)
	store   $i1, 1($i4)
	mov     $hp, $i2
	store   $i2, 8($sp)
	add     $hp, 6, $hp
	li      cos.2723, $i4
	store   $i4, 0($i2)
	store   $f3, 5($i2)
	store   $f2, 4($i2)
	store   $f1, 3($i2)
	store   $i1, 2($i2)
	store   $i3, 1($i2)
	li      1, $i1
	li      0, $i2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $i1, 9($sp)
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
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
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_float_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $i1, 11($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_float_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $i1, 12($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_float_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $i1, 13($sp)
	li      1, $i1
	li      l.26096, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $i1, 14($sp)
	li      50, $i1
	store   $i1, 15($sp)
	li      1, $i1
	li      -1, $i2
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	mov     $i1, $i2
	load    15($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	store   $i1, 16($sp)
	li      1, $i2
	store   $i2, 17($sp)
	li      1, $i2
	load    0($i1), $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	mov     $i1, $i2
	load    17($sp), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	store   $i1, 18($sp)
	li      1, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_float_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	store   $i1, 19($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	store   $i1, 20($sp)
	li      1, $i1
	li      l.26124, $i2
	load    0($i2), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_float_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	store   $i1, 21($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_create_float_array
	sub     $sp, 23, $sp
	load    22($sp), $ra
	store   $i1, 22($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_create_array
	sub     $sp, 24, $sp
	load    23($sp), $ra
	store   $i1, 23($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_create_float_array
	sub     $sp, 25, $sp
	load    24($sp), $ra
	store   $i1, 24($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_create_float_array
	sub     $sp, 26, $sp
	load    25($sp), $ra
	store   $i1, 25($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_create_float_array
	sub     $sp, 27, $sp
	load    26($sp), $ra
	store   $i1, 26($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_create_float_array
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
	li      2, $i1
	li      0, $i2
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_create_array
	sub     $sp, 30, $sp
	load    29($sp), $ra
	store   $i1, 29($sp)
	li      1, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_create_float_array
	sub     $sp, 31, $sp
	load    30($sp), $ra
	store   $i1, 30($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_create_float_array
	sub     $sp, 32, $sp
	load    31($sp), $ra
	store   $i1, 31($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_float_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	store   $i1, 32($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_create_float_array
	sub     $sp, 34, $sp
	load    33($sp), $ra
	store   $i1, 33($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_create_float_array
	sub     $sp, 35, $sp
	load    34($sp), $ra
	store   $i1, 34($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_create_float_array
	sub     $sp, 36, $sp
	load    35($sp), $ra
	store   $i1, 35($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_create_float_array
	sub     $sp, 37, $sp
	load    36($sp), $ra
	store   $i1, 36($sp)
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_float_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	mov     $i1, $i2
	store   $i2, 37($sp)
	li      0, $i1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	li      0, $i2
	mov     $hp, $i3
	add     $hp, 2, $hp
	store   $i1, 1($i3)
	load    37($sp), $i1
	store   $i1, 0($i3)
	mov     $i3, $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	store   $i1, 38($sp)
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_create_float_array
	sub     $sp, 40, $sp
	load    39($sp), $ra
	store   $i1, 39($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_create_float_array
	sub     $sp, 41, $sp
	load    40($sp), $ra
	store   $i1, 40($sp)
	li      60, $i1
	load    39($sp), $i2
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_create_array
	sub     $sp, 42, $sp
	load    41($sp), $ra
	store   $i1, 41($sp)
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    40($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	store   $i1, 42($sp)
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_create_float_array
	sub     $sp, 44, $sp
	load    43($sp), $ra
	mov     $i1, $i2
	store   $i2, 43($sp)
	li      0, $i1
	store   $ra, 44($sp)
	add     $sp, 45, $sp
	jal     min_caml_create_array
	sub     $sp, 45, $sp
	load    44($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    43($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	li      180, $i2
	li      0, $i3
	li      l.25703, $i4
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
	store   $ra, 44($sp)
	add     $sp, 45, $sp
	jal     min_caml_create_array
	sub     $sp, 45, $sp
	load    44($sp), $ra
	store   $i1, 44($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_create_array
	sub     $sp, 46, $sp
	load    45($sp), $ra
	store   $i1, 45($sp)
	mov     $hp, $i1
	add     $hp, 13, $hp
	li      read_screen_settings.2895, $i2
	store   $i2, 0($i1)
	load    12($sp), $i2
	store   $i2, 12($i1)
	load    7($sp), $i2
	store   $i2, 11($i1)
	load    35($sp), $i3
	store   $i3, 10($i1)
	load    34($sp), $i3
	store   $i3, 9($i1)
	load    33($sp), $i3
	store   $i3, 8($i1)
	load    11($sp), $i3
	store   $i3, 7($i1)
	load    3($sp), $f1
	store   $f1, 6($i1)
	load    2($sp), $f2
	store   $f2, 5($i1)
	load    1($sp), $f3
	store   $f3, 4($i1)
	load    8($sp), $i3
	store   $i3, 3($i1)
	load    4($sp), $i4
	store   $i4, 2($i1)
	load    5($sp), $i5
	store   $i5, 1($i1)
	mov     $hp, $i6
	add     $hp, 8, $hp
	li      rotate_quadratic_matrix.2899, $i7
	store   $i7, 0($i6)
	store   $i2, 7($i6)
	store   $f1, 6($i6)
	store   $f2, 5($i6)
	store   $f3, 4($i6)
	store   $i3, 3($i6)
	store   $i4, 2($i6)
	store   $i5, 1($i6)
	mov     $hp, $i4
	add     $hp, 3, $hp
	li      read_nth_object.2902, $i5
	store   $i5, 0($i4)
	store   $i6, 2($i4)
	load    10($sp), $i5
	store   $i5, 1($i4)
	mov     $hp, $i6
	add     $hp, 3, $hp
	li      read_object.2904, $i7
	store   $i7, 0($i6)
	store   $i4, 2($i6)
	load    9($sp), $i7
	store   $i7, 1($i6)
	mov     $hp, $i8
	add     $hp, 2, $hp
	li      read_and_network.2912, $i9
	store   $i9, 0($i8)
	load    16($sp), $i9
	store   $i9, 1($i8)
	mov     $hp, $i10
	store   $i10, 46($sp)
	add     $hp, 12, $hp
	li      read_parameter.2914, $i11
	store   $i11, 0($i10)
	store   $i2, 11($i10)
	store   $i1, 10($i10)
	store   $i6, 9($i10)
	store   $i4, 8($i10)
	store   $i8, 7($i10)
	load    18($sp), $i1
	store   $i1, 6($i10)
	store   $i7, 5($i10)
	load    13($sp), $i1
	store   $i1, 4($i10)
	store   $i3, 3($i10)
	load    14($sp), $i2
	store   $i2, 2($i10)
	store   $i9, 1($i10)
	mov     $hp, $i2
	store   $i2, 47($sp)
	add     $hp, 2, $hp
	li      solver_rect.2925, $i3
	store   $i3, 0($i2)
	load    19($sp), $i3
	store   $i3, 1($i2)
	mov     $hp, $i2
	store   $i2, 48($sp)
	add     $hp, 2, $hp
	li      solver_second.2950, $i4
	store   $i4, 0($i2)
	store   $i3, 1($i2)
	mov     $hp, $i2
	store   $i2, 49($sp)
	add     $hp, 3, $hp
	li      solver.2956, $i4
	store   $i4, 0($i2)
	store   $i3, 2($i2)
	store   $i5, 1($i2)
	mov     $hp, $i2
	store   $i2, 50($sp)
	add     $hp, 2, $hp
	li      solver_rect_fast.2960, $i4
	store   $i4, 0($i2)
	store   $i3, 1($i2)
	mov     $hp, $i4
	store   $i4, 51($sp)
	add     $hp, 2, $hp
	li      solver_second_fast.2973, $i6
	store   $i6, 0($i4)
	store   $i3, 1($i4)
	mov     $hp, $i6
	store   $i6, 52($sp)
	add     $hp, 4, $hp
	li      solver_fast.2979, $i7
	store   $i7, 0($i6)
	store   $i2, 3($i6)
	store   $i3, 2($i6)
	store   $i5, 1($i6)
	mov     $hp, $i7
	store   $i7, 53($sp)
	add     $hp, 4, $hp
	li      solver_fast2.2997, $i8
	store   $i8, 0($i7)
	store   $i2, 3($i7)
	store   $i3, 2($i7)
	store   $i5, 1($i7)
	mov     $hp, $i7
	store   $i7, 54($sp)
	add     $hp, 2, $hp
	li      iter_setup_dirvec_constants.3009, $i8
	store   $i8, 0($i7)
	store   $i5, 1($i7)
	mov     $hp, $i7
	store   $i7, 55($sp)
	add     $hp, 2, $hp
	li      setup_startp_constants.3014, $i8
	store   $i8, 0($i7)
	store   $i5, 1($i7)
	mov     $hp, $i7
	store   $i7, 56($sp)
	add     $hp, 2, $hp
	li      check_all_inside.3039, $i8
	store   $i8, 0($i7)
	store   $i5, 1($i7)
	mov     $hp, $i8
	add     $hp, 12, $hp
	li      shadow_check_and_group.3045, $i10
	store   $i10, 0($i8)
	load    40($sp), $i10
	store   $i10, 11($i8)
	store   $i4, 10($i8)
	store   $i2, 9($i8)
	store   $i6, 8($i8)
	store   $i3, 7($i8)
	store   $i5, 6($i8)
	load    42($sp), $i2
	store   $i2, 5($i8)
	store   $i1, 4($i8)
	load    22($sp), $i4
	store   $i4, 3($i8)
	load    41($sp), $i10
	store   $i10, 2($i8)
	store   $i7, 1($i8)
	mov     $hp, $i10
	store   $i10, 57($sp)
	add     $hp, 10, $hp
	li      shadow_check_one_or_group.3048, $i11
	store   $i11, 0($i10)
	store   $i6, 9($i10)
	store   $i3, 8($i10)
	store   $i8, 7($i10)
	store   $i5, 6($i10)
	store   $i2, 5($i10)
	store   $i1, 4($i10)
	store   $i4, 3($i10)
	store   $i7, 2($i10)
	store   $i9, 1($i10)
	mov     $hp, $i1
	store   $i1, 58($sp)
	add     $hp, 13, $hp
	li      shadow_check_one_or_matrix.3051, $i11
	store   $i11, 0($i1)
	load    40($sp), $i11
	store   $i11, 12($i1)
	load    51($sp), $i11
	store   $i11, 11($i1)
	load    50($sp), $i11
	store   $i11, 10($i1)
	store   $i6, 9($i1)
	store   $i3, 8($i1)
	store   $i10, 7($i1)
	store   $i8, 6($i1)
	store   $i5, 5($i1)
	store   $i2, 4($i1)
	store   $i4, 3($i1)
	load    41($sp), $i2
	store   $i2, 2($i1)
	store   $i9, 1($i1)
	mov     $hp, $i1
	add     $hp, 11, $hp
	li      solve_each_element.3054, $i2
	store   $i2, 0($i1)
	load    21($sp), $i2
	store   $i2, 10($i1)
	load    31($sp), $i6
	store   $i6, 9($i1)
	load    48($sp), $i8
	store   $i8, 8($i1)
	load    47($sp), $i10
	store   $i10, 7($i1)
	store   $i3, 6($i1)
	store   $i5, 5($i1)
	load    20($sp), $i11
	store   $i11, 4($i1)
	store   $i4, 3($i1)
	load    23($sp), $i4
	store   $i4, 2($i1)
	store   $i7, 1($i1)
	mov     $hp, $i4
	add     $hp, 3, $hp
	li      solve_one_or_network.3058, $i7
	store   $i7, 0($i4)
	store   $i1, 2($i4)
	store   $i9, 1($i4)
	mov     $hp, $i7
	store   $i7, 59($sp)
	add     $hp, 11, $hp
	li      trace_or_matrix.3062, $i11
	store   $i11, 0($i7)
	store   $i2, 10($i7)
	store   $i6, 9($i7)
	store   $i8, 8($i7)
	store   $i10, 7($i7)
	store   $i3, 6($i7)
	load    49($sp), $i6
	store   $i6, 5($i7)
	store   $i4, 4($i7)
	store   $i1, 3($i7)
	store   $i5, 2($i7)
	store   $i9, 1($i7)
	mov     $hp, $i1
	store   $i1, 60($sp)
	add     $hp, 10, $hp
	li      solve_each_element_fast.3068, $i4
	store   $i4, 0($i1)
	store   $i2, 9($i1)
	load    32($sp), $i4
	store   $i4, 8($i1)
	load    50($sp), $i4
	store   $i4, 7($i1)
	store   $i3, 6($i1)
	store   $i5, 5($i1)
	load    20($sp), $i6
	store   $i6, 4($i1)
	load    22($sp), $i7
	store   $i7, 3($i1)
	load    23($sp), $i8
	store   $i8, 2($i1)
	load    56($sp), $i8
	store   $i8, 1($i1)
	mov     $hp, $i8
	store   $i8, 61($sp)
	add     $hp, 3, $hp
	li      solve_one_or_network_fast.3072, $i10
	store   $i10, 0($i8)
	store   $i1, 2($i8)
	store   $i9, 1($i8)
	mov     $hp, $i10
	add     $hp, 9, $hp
	li      trace_or_matrix_fast.3076, $i11
	store   $i11, 0($i10)
	store   $i2, 8($i10)
	store   $i4, 7($i10)
	load    53($sp), $i4
	store   $i4, 6($i10)
	store   $i3, 5($i10)
	store   $i8, 4($i10)
	store   $i1, 3($i10)
	store   $i5, 2($i10)
	store   $i9, 1($i10)
	mov     $hp, $i5
	store   $i5, 62($sp)
	add     $hp, 3, $hp
	li      get_nvector_second.3086, $i9
	store   $i9, 0($i5)
	load    24($sp), $i9
	store   $i9, 2($i5)
	store   $i7, 1($i5)
	mov     $hp, $i5
	store   $i5, 63($sp)
	add     $hp, 10, $hp
	li      utexture.3091, $i7
	store   $i7, 0($i5)
	load    25($sp), $i7
	store   $i7, 9($i5)
	load    7($sp), $i11
	store   $i11, 8($i5)
	store   $f1, 7($i5)
	store   $f2, 6($i5)
	store   $f3, 5($i5)
	load    8($sp), $i11
	store   $i11, 4($i5)
	load    4($sp), $i11
	store   $i11, 3($i5)
	load    5($sp), $i11
	store   $i11, 2($i5)
	load    6($sp), $i11
	store   $i11, 1($i5)
	mov     $hp, $i5
	add     $hp, 20, $hp
	li      trace_reflections.3098, $i11
	store   $i11, 0($i5)
	store   $i10, 19($i5)
	store   $i2, 18($i5)
	store   $i7, 17($i5)
	store   $i4, 16($i5)
	load    52($sp), $i11
	store   $i11, 15($i5)
	store   $i3, 14($i5)
	store   $i8, 13($i5)
	store   $i1, 12($i5)
	load    58($sp), $i1
	store   $i1, 11($i5)
	load    57($sp), $i1
	store   $i1, 10($i5)
	load    27($sp), $i1
	store   $i1, 9($i5)
	load    44($sp), $i1
	store   $i1, 8($i5)
	load    18($sp), $i1
	store   $i1, 7($i5)
	store   $i9, 6($i5)
	load    42($sp), $i9
	store   $i9, 5($i5)
	store   $i6, 4($i5)
	load    22($sp), $i6
	store   $i6, 3($i5)
	load    23($sp), $i6
	store   $i6, 2($i5)
	load    16($sp), $i6
	store   $i6, 1($i5)
	mov     $hp, $i6
	store   $i6, 64($sp)
	add     $hp, 32, $hp
	li      trace_ray.3103, $i9
	store   $i9, 0($i6)
	load    63($sp), $i9
	store   $i9, 31($i6)
	store   $i5, 30($i6)
	store   $i10, 29($i6)
	load    59($sp), $i5
	store   $i5, 28($i6)
	store   $i2, 27($i6)
	store   $i7, 26($i6)
	load    32($sp), $i5
	store   $i5, 25($i6)
	load    31($sp), $i5
	store   $i5, 24($i6)
	store   $i4, 23($i6)
	store   $i11, 22($i6)
	store   $i3, 21($i6)
	store   $i8, 20($i6)
	load    60($sp), $i4
	store   $i4, 19($i6)
	load    58($sp), $i4
	store   $i4, 18($i6)
	load    57($sp), $i5
	store   $i5, 17($i6)
	load    55($sp), $i8
	store   $i8, 16($i6)
	load    27($sp), $i8
	store   $i8, 15($i6)
	load    44($sp), $i8
	store   $i8, 14($i6)
	store   $i1, 13($i6)
	load    10($sp), $i8
	store   $i8, 12($i6)
	load    24($sp), $i8
	store   $i8, 11($i6)
	load    45($sp), $i8
	store   $i8, 10($i6)
	load    9($sp), $i8
	store   $i8, 9($i6)
	load    42($sp), $i8
	store   $i8, 8($i6)
	load    13($sp), $i8
	store   $i8, 7($i6)
	load    20($sp), $i8
	store   $i8, 6($i6)
	load    22($sp), $i8
	store   $i8, 5($i6)
	load    23($sp), $i8
	store   $i8, 4($i6)
	load    62($sp), $i8
	store   $i8, 3($i6)
	load    14($sp), $i8
	store   $i8, 2($i6)
	load    16($sp), $i8
	store   $i8, 1($i6)
	mov     $hp, $i6
	store   $i6, 65($sp)
	add     $hp, 19, $hp
	li      trace_diffuse_ray.3109, $i8
	store   $i8, 0($i6)
	store   $i9, 18($i6)
	store   $i10, 17($i6)
	store   $i2, 16($i6)
	store   $i7, 15($i6)
	store   $i11, 14($i6)
	store   $i3, 13($i6)
	store   $i4, 12($i6)
	store   $i5, 11($i6)
	store   $i1, 10($i6)
	load    10($sp), $i5
	store   $i5, 9($i6)
	load    24($sp), $i8
	store   $i8, 8($i6)
	load    42($sp), $i8
	store   $i8, 7($i6)
	load    13($sp), $i8
	store   $i8, 6($i6)
	load    20($sp), $i8
	store   $i8, 5($i6)
	load    22($sp), $i8
	store   $i8, 4($i6)
	load    23($sp), $i8
	store   $i8, 3($i6)
	load    62($sp), $i8
	store   $i8, 2($i6)
	load    26($sp), $i8
	store   $i8, 1($i6)
	mov     $hp, $i8
	add     $hp, 21, $hp
	li      iter_trace_diffuse_rays.3112, $i11
	store   $i11, 0($i8)
	store   $i9, 20($i8)
	store   $i10, 19($i8)
	store   $i6, 18($i8)
	store   $i2, 17($i8)
	store   $i7, 16($i8)
	load    53($sp), $i2
	store   $i2, 15($i8)
	store   $i3, 14($i8)
	load    61($sp), $i2
	store   $i2, 13($i8)
	load    60($sp), $i2
	store   $i2, 12($i8)
	store   $i4, 11($i8)
	store   $i1, 10($i8)
	store   $i5, 9($i8)
	load    24($sp), $i1
	store   $i1, 8($i8)
	load    13($sp), $i1
	store   $i1, 7($i8)
	load    20($sp), $i1
	store   $i1, 6($i8)
	load    22($sp), $i1
	store   $i1, 5($i8)
	load    23($sp), $i1
	store   $i1, 4($i8)
	load    62($sp), $i1
	store   $i1, 3($i8)
	load    26($sp), $i1
	store   $i1, 2($i8)
	load    16($sp), $i2
	store   $i2, 1($i8)
	mov     $hp, $i2
	store   $i2, 66($sp)
	add     $hp, 6, $hp
	li      trace_diffuse_ray_80percent.3121, $i3
	store   $i3, 0($i2)
	load    32($sp), $i3
	store   $i3, 5($i2)
	load    55($sp), $i4
	store   $i4, 4($i2)
	load    9($sp), $i5
	store   $i5, 3($i2)
	store   $i8, 2($i2)
	load    38($sp), $i7
	store   $i7, 1($i2)
	mov     $hp, $i9
	store   $i9, 67($sp)
	add     $hp, 9, $hp
	li      calc_diffuse_using_1point.3125, $i10
	store   $i10, 0($i9)
	store   $i6, 8($i9)
	store   $i3, 7($i9)
	store   $i4, 6($i9)
	load    27($sp), $i6
	store   $i6, 5($i9)
	store   $i5, 4($i9)
	store   $i8, 3($i9)
	store   $i7, 2($i9)
	store   $i1, 1($i9)
	mov     $hp, $i10
	store   $i10, 68($sp)
	add     $hp, 3, $hp
	li      calc_diffuse_using_5points.3128, $i11
	store   $i11, 0($i10)
	store   $i6, 2($i10)
	store   $i1, 1($i10)
	mov     $hp, $i10
	store   $i10, 69($sp)
	add     $hp, 10, $hp
	li      do_without_neighbors.3134, $i11
	store   $i11, 0($i10)
	store   $i2, 9($i10)
	store   $i3, 8($i10)
	store   $i4, 7($i10)
	store   $i6, 6($i10)
	store   $i5, 5($i10)
	store   $i8, 4($i10)
	store   $i7, 3($i10)
	store   $i1, 2($i10)
	store   $i9, 1($i10)
	mov     $hp, $i7
	store   $i7, 70($sp)
	add     $hp, 7, $hp
	li      try_exploit_neighbors.3150, $i11
	store   $i11, 0($i7)
	store   $i2, 6($i7)
	store   $i6, 5($i7)
	store   $i10, 4($i7)
	store   $i1, 3($i7)
	load    68($sp), $i2
	store   $i2, 2($i7)
	store   $i9, 1($i7)
	mov     $hp, $i2
	add     $hp, 8, $hp
	li      pretrace_diffuse_rays.3163, $i7
	store   $i7, 0($i2)
	load    65($sp), $i7
	store   $i7, 7($i2)
	store   $i3, 6($i2)
	store   $i4, 5($i2)
	store   $i5, 4($i2)
	store   $i8, 3($i2)
	load    38($sp), $i9
	store   $i9, 2($i2)
	store   $i1, 1($i2)
	mov     $hp, $i10
	add     $hp, 17, $hp
	li      pretrace_pixels.3166, $i11
	store   $i11, 0($i10)
	load    12($sp), $i11
	store   $i11, 16($i10)
	load    64($sp), $i11
	store   $i11, 15($i10)
	store   $i7, 14($i10)
	store   $i3, 13($i10)
	load    31($sp), $i3
	store   $i3, 12($i10)
	store   $i4, 11($i10)
	load    33($sp), $i4
	store   $i4, 10($i10)
	load    30($sp), $i7
	store   $i7, 9($i10)
	store   $i6, 8($i10)
	load    36($sp), $i6
	store   $i6, 7($i10)
	store   $i2, 6($i10)
	store   $i5, 5($i10)
	store   $i8, 4($i10)
	load    29($sp), $i5
	store   $i5, 3($i10)
	store   $i9, 2($i10)
	store   $i1, 1($i10)
	mov     $hp, $i8
	store   $i8, 71($sp)
	add     $hp, 14, $hp
	li      pretrace_line.3173, $i9
	store   $i9, 0($i8)
	load    12($sp), $i9
	store   $i9, 13($i8)
	store   $i11, 12($i8)
	store   $i3, 11($i8)
	load    35($sp), $i3
	store   $i3, 10($i8)
	load    34($sp), $i9
	store   $i9, 9($i8)
	store   $i4, 8($i8)
	store   $i7, 7($i8)
	load    27($sp), $i4
	store   $i4, 6($i8)
	store   $i6, 5($i8)
	store   $i10, 4($i8)
	store   $i2, 3($i8)
	load    28($sp), $i2
	store   $i2, 2($i8)
	store   $i5, 1($i8)
	mov     $hp, $i5
	add     $hp, 9, $hp
	li      scan_pixel.3177, $i6
	store   $i6, 0($i5)
	load    70($sp), $i6
	store   $i6, 8($i5)
	load    66($sp), $i11
	store   $i11, 7($i5)
	store   $i4, 6($i5)
	store   $i2, 5($i5)
	load    69($sp), $i2
	store   $i2, 4($i5)
	store   $i1, 3($i5)
	load    68($sp), $i1
	store   $i1, 2($i5)
	load    67($sp), $i1
	store   $i1, 1($i5)
	mov     $hp, $i1
	store   $i1, 72($sp)
	add     $hp, 15, $hp
	li      scan_line.3183, $i2
	store   $i2, 0($i1)
	store   $i6, 14($i1)
	store   $i11, 13($i1)
	store   $i3, 12($i1)
	store   $i9, 11($i1)
	store   $i5, 10($i1)
	store   $i7, 9($i1)
	store   $i4, 8($i1)
	store   $i10, 7($i1)
	store   $i8, 6($i1)
	load    28($sp), $i2
	store   $i2, 5($i1)
	load    29($sp), $i3
	store   $i3, 4($i1)
	load    69($sp), $i4
	store   $i4, 3($i1)
	load    26($sp), $i4
	store   $i4, 2($i1)
	load    67($sp), $i4
	store   $i4, 1($i1)
	mov     $hp, $i1
	add     $hp, 10, $hp
	li      calc_dirvec.3203, $i4
	store   $i4, 0($i1)
	load    7($sp), $i4
	store   $i4, 9($i1)
	store   $f1, 8($i1)
	store   $f2, 7($i1)
	store   $f3, 6($i1)
	load    38($sp), $i4
	store   $i4, 5($i1)
	load    8($sp), $i5
	store   $i5, 4($i1)
	load    4($sp), $i5
	store   $i5, 3($i1)
	load    0($sp), $i5
	store   $i5, 2($i1)
	load    5($sp), $i5
	store   $i5, 1($i1)
	mov     $hp, $i5
	store   $i5, 73($sp)
	add     $hp, 2, $hp
	li      calc_dirvecs.3211, $i6
	store   $i6, 0($i5)
	store   $i1, 1($i5)
	mov     $hp, $i6
	store   $i6, 74($sp)
	add     $hp, 3, $hp
	li      calc_dirvec_rows.3216, $i7
	store   $i7, 0($i6)
	store   $i5, 2($i6)
	store   $i1, 1($i6)
	mov     $hp, $i1
	store   $i1, 75($sp)
	add     $hp, 2, $hp
	li      create_dirvec_elements.3222, $i5
	store   $i5, 0($i1)
	load    9($sp), $i5
	store   $i5, 1($i1)
	mov     $hp, $i6
	store   $i6, 76($sp)
	add     $hp, 4, $hp
	li      create_dirvecs.3225, $i7
	store   $i7, 0($i6)
	store   $i5, 3($i6)
	store   $i4, 2($i6)
	store   $i1, 1($i6)
	mov     $hp, $i1
	store   $i1, 77($sp)
	add     $hp, 4, $hp
	li      init_dirvec_constants.3227, $i6
	store   $i6, 0($i1)
	load    10($sp), $i6
	store   $i6, 3($i1)
	store   $i5, 2($i1)
	load    54($sp), $i7
	store   $i7, 1($i1)
	mov     $hp, $i8
	store   $i8, 78($sp)
	add     $hp, 6, $hp
	li      init_vecset_constants.3230, $i9
	store   $i9, 0($i8)
	store   $i6, 5($i8)
	store   $i5, 4($i8)
	store   $i7, 3($i8)
	store   $i1, 2($i8)
	store   $i4, 1($i8)
	mov     $hp, $i1
	store   $i1, 79($sp)
	add     $hp, 7, $hp
	li      setup_reflections.3247, $i4
	store   $i4, 0($i1)
	load    44($sp), $i4
	store   $i4, 6($i1)
	store   $i6, 5($i1)
	load    45($sp), $i4
	store   $i4, 4($i1)
	store   $i5, 3($i1)
	load    13($sp), $i4
	store   $i4, 2($i1)
	store   $i7, 1($i1)
	li      128, $i1
	li      128, $i4
	store   $i1, 0($i2)
	store   $i4, 1($i2)
	srl     $i1, 1, $i2
	store   $i2, 0($i3)
	srl     $i4, 1, $i2
	store   $i2, 1($i3)
	li      l.26613, $i2
	load    0($i2), $f1
	store   $f1, 80($sp)
	store   $ra, 81($sp)
	add     $sp, 82, $sp
	jal     min_caml_float_of_int
	sub     $sp, 82, $sp
	load    81($sp), $ra
	load    80($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    30($sp), $i1
	store   $f1, 0($i1)
	load    28($sp), $i1
	load    0($i1), $i1
	store   $i1, 81($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 82($sp)
	add     $sp, 83, $sp
	jal     min_caml_create_float_array
	sub     $sp, 83, $sp
	load    82($sp), $ra
	store   $i1, 82($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 83($sp)
	add     $sp, 84, $sp
	jal     min_caml_create_float_array
	sub     $sp, 84, $sp
	load    83($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 83($sp)
	add     $sp, 84, $sp
	jal     min_caml_create_array
	sub     $sp, 84, $sp
	load    83($sp), $ra
	store   $i1, 83($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 84($sp)
	add     $sp, 85, $sp
	jal     min_caml_create_float_array
	sub     $sp, 85, $sp
	load    84($sp), $ra
	load    83($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 84($sp)
	add     $sp, 85, $sp
	jal     min_caml_create_float_array
	sub     $sp, 85, $sp
	load    84($sp), $ra
	load    83($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 84($sp)
	add     $sp, 85, $sp
	jal     min_caml_create_float_array
	sub     $sp, 85, $sp
	load    84($sp), $ra
	load    83($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 84($sp)
	add     $sp, 85, $sp
	jal     min_caml_create_float_array
	sub     $sp, 85, $sp
	load    84($sp), $ra
	load    83($sp), $i2
	store   $i1, 4($i2)
	li      5, $i1
	li      0, $i2
	store   $ra, 84($sp)
	add     $sp, 85, $sp
	jal     min_caml_create_array
	sub     $sp, 85, $sp
	load    84($sp), $ra
	store   $i1, 84($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 85($sp)
	add     $sp, 86, $sp
	jal     min_caml_create_array
	sub     $sp, 86, $sp
	load    85($sp), $ra
	store   $i1, 85($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 86($sp)
	add     $sp, 87, $sp
	jal     min_caml_create_float_array
	sub     $sp, 87, $sp
	load    86($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 86($sp)
	add     $sp, 87, $sp
	jal     min_caml_create_array
	sub     $sp, 87, $sp
	load    86($sp), $ra
	store   $i1, 86($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 87($sp)
	add     $sp, 88, $sp
	jal     min_caml_create_float_array
	sub     $sp, 88, $sp
	load    87($sp), $ra
	load    86($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 87($sp)
	add     $sp, 88, $sp
	jal     min_caml_create_float_array
	sub     $sp, 88, $sp
	load    87($sp), $ra
	load    86($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 87($sp)
	add     $sp, 88, $sp
	jal     min_caml_create_float_array
	sub     $sp, 88, $sp
	load    87($sp), $ra
	load    86($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 87($sp)
	add     $sp, 88, $sp
	jal     min_caml_create_float_array
	sub     $sp, 88, $sp
	load    87($sp), $ra
	load    86($sp), $i2
	store   $i1, 4($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 87($sp)
	add     $sp, 88, $sp
	jal     min_caml_create_float_array
	sub     $sp, 88, $sp
	load    87($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 87($sp)
	add     $sp, 88, $sp
	jal     min_caml_create_array
	sub     $sp, 88, $sp
	load    87($sp), $ra
	store   $i1, 87($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 88($sp)
	add     $sp, 89, $sp
	jal     min_caml_create_float_array
	sub     $sp, 89, $sp
	load    88($sp), $ra
	load    87($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 88($sp)
	add     $sp, 89, $sp
	jal     min_caml_create_float_array
	sub     $sp, 89, $sp
	load    88($sp), $ra
	load    87($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 88($sp)
	add     $sp, 89, $sp
	jal     min_caml_create_float_array
	sub     $sp, 89, $sp
	load    88($sp), $ra
	load    87($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 88($sp)
	add     $sp, 89, $sp
	jal     min_caml_create_float_array
	sub     $sp, 89, $sp
	load    88($sp), $ra
	load    87($sp), $i2
	store   $i1, 4($i2)
	li      1, $i1
	li      0, $i2
	store   $ra, 88($sp)
	add     $sp, 89, $sp
	jal     min_caml_create_array
	sub     $sp, 89, $sp
	load    88($sp), $ra
	store   $i1, 88($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 89($sp)
	add     $sp, 90, $sp
	jal     min_caml_create_float_array
	sub     $sp, 90, $sp
	load    89($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 89($sp)
	add     $sp, 90, $sp
	jal     min_caml_create_array
	sub     $sp, 90, $sp
	load    89($sp), $ra
	store   $i1, 89($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 90($sp)
	add     $sp, 91, $sp
	jal     min_caml_create_float_array
	sub     $sp, 91, $sp
	load    90($sp), $ra
	load    89($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 90($sp)
	add     $sp, 91, $sp
	jal     min_caml_create_float_array
	sub     $sp, 91, $sp
	load    90($sp), $ra
	load    89($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 90($sp)
	add     $sp, 91, $sp
	jal     min_caml_create_float_array
	sub     $sp, 91, $sp
	load    90($sp), $ra
	load    89($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 90($sp)
	add     $sp, 91, $sp
	jal     min_caml_create_float_array
	sub     $sp, 91, $sp
	load    90($sp), $ra
	load    89($sp), $i2
	store   $i1, 4($i2)
	mov     $hp, $i1
	add     $hp, 8, $hp
	store   $i2, 7($i1)
	load    88($sp), $i2
	store   $i2, 6($i1)
	load    87($sp), $i2
	store   $i2, 5($i1)
	load    86($sp), $i2
	store   $i2, 4($i1)
	load    85($sp), $i2
	store   $i2, 3($i1)
	load    84($sp), $i2
	store   $i2, 2($i1)
	load    83($sp), $i2
	store   $i2, 1($i1)
	load    82($sp), $i2
	store   $i2, 0($i1)
	mov     $i1, $i2
	load    81($sp), $i1
	store   $ra, 90($sp)
	add     $sp, 91, $sp
	jal     min_caml_create_array
	sub     $sp, 91, $sp
	load    90($sp), $ra
	load    28($sp), $i2
	load    0($i2), $i2
	sub     $i2, 2, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.58640
	store   $i2, 90($sp)
	store   $i1, 91($sp)
	store   $ra, 92($sp)
	add     $sp, 93, $sp
	jal     create_pixel.3191
	sub     $sp, 93, $sp
	load    92($sp), $ra
	load    90($sp), $i2
	load    91($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	mov     $i3, $i1
	store   $ra, 92($sp)
	add     $sp, 93, $sp
	jal     init_line_elements.3193
	sub     $sp, 93, $sp
	load    92($sp), $ra
	b       bge_cont.58641
bge_else.58640:
bge_cont.58641:
	store   $i1, 92($sp)
	load    28($sp), $i1
	load    0($i1), $i1
	store   $i1, 93($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 94($sp)
	add     $sp, 95, $sp
	jal     min_caml_create_float_array
	sub     $sp, 95, $sp
	load    94($sp), $ra
	store   $i1, 94($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 95($sp)
	add     $sp, 96, $sp
	jal     min_caml_create_float_array
	sub     $sp, 96, $sp
	load    95($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 95($sp)
	add     $sp, 96, $sp
	jal     min_caml_create_array
	sub     $sp, 96, $sp
	load    95($sp), $ra
	store   $i1, 95($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 96($sp)
	add     $sp, 97, $sp
	jal     min_caml_create_float_array
	sub     $sp, 97, $sp
	load    96($sp), $ra
	load    95($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 96($sp)
	add     $sp, 97, $sp
	jal     min_caml_create_float_array
	sub     $sp, 97, $sp
	load    96($sp), $ra
	load    95($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 96($sp)
	add     $sp, 97, $sp
	jal     min_caml_create_float_array
	sub     $sp, 97, $sp
	load    96($sp), $ra
	load    95($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 96($sp)
	add     $sp, 97, $sp
	jal     min_caml_create_float_array
	sub     $sp, 97, $sp
	load    96($sp), $ra
	load    95($sp), $i2
	store   $i1, 4($i2)
	li      5, $i1
	li      0, $i2
	store   $ra, 96($sp)
	add     $sp, 97, $sp
	jal     min_caml_create_array
	sub     $sp, 97, $sp
	load    96($sp), $ra
	store   $i1, 96($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 97($sp)
	add     $sp, 98, $sp
	jal     min_caml_create_array
	sub     $sp, 98, $sp
	load    97($sp), $ra
	store   $i1, 97($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 98($sp)
	add     $sp, 99, $sp
	jal     min_caml_create_float_array
	sub     $sp, 99, $sp
	load    98($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 98($sp)
	add     $sp, 99, $sp
	jal     min_caml_create_array
	sub     $sp, 99, $sp
	load    98($sp), $ra
	store   $i1, 98($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 99($sp)
	add     $sp, 100, $sp
	jal     min_caml_create_float_array
	sub     $sp, 100, $sp
	load    99($sp), $ra
	load    98($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 99($sp)
	add     $sp, 100, $sp
	jal     min_caml_create_float_array
	sub     $sp, 100, $sp
	load    99($sp), $ra
	load    98($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 99($sp)
	add     $sp, 100, $sp
	jal     min_caml_create_float_array
	sub     $sp, 100, $sp
	load    99($sp), $ra
	load    98($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 99($sp)
	add     $sp, 100, $sp
	jal     min_caml_create_float_array
	sub     $sp, 100, $sp
	load    99($sp), $ra
	load    98($sp), $i2
	store   $i1, 4($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 99($sp)
	add     $sp, 100, $sp
	jal     min_caml_create_float_array
	sub     $sp, 100, $sp
	load    99($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 99($sp)
	add     $sp, 100, $sp
	jal     min_caml_create_array
	sub     $sp, 100, $sp
	load    99($sp), $ra
	store   $i1, 99($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 100($sp)
	add     $sp, 101, $sp
	jal     min_caml_create_float_array
	sub     $sp, 101, $sp
	load    100($sp), $ra
	load    99($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 100($sp)
	add     $sp, 101, $sp
	jal     min_caml_create_float_array
	sub     $sp, 101, $sp
	load    100($sp), $ra
	load    99($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 100($sp)
	add     $sp, 101, $sp
	jal     min_caml_create_float_array
	sub     $sp, 101, $sp
	load    100($sp), $ra
	load    99($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 100($sp)
	add     $sp, 101, $sp
	jal     min_caml_create_float_array
	sub     $sp, 101, $sp
	load    100($sp), $ra
	load    99($sp), $i2
	store   $i1, 4($i2)
	li      1, $i1
	li      0, $i2
	store   $ra, 100($sp)
	add     $sp, 101, $sp
	jal     min_caml_create_array
	sub     $sp, 101, $sp
	load    100($sp), $ra
	store   $i1, 100($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 101($sp)
	add     $sp, 102, $sp
	jal     min_caml_create_float_array
	sub     $sp, 102, $sp
	load    101($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 101($sp)
	add     $sp, 102, $sp
	jal     min_caml_create_array
	sub     $sp, 102, $sp
	load    101($sp), $ra
	store   $i1, 101($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 102($sp)
	add     $sp, 103, $sp
	jal     min_caml_create_float_array
	sub     $sp, 103, $sp
	load    102($sp), $ra
	load    101($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 102($sp)
	add     $sp, 103, $sp
	jal     min_caml_create_float_array
	sub     $sp, 103, $sp
	load    102($sp), $ra
	load    101($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 102($sp)
	add     $sp, 103, $sp
	jal     min_caml_create_float_array
	sub     $sp, 103, $sp
	load    102($sp), $ra
	load    101($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 102($sp)
	add     $sp, 103, $sp
	jal     min_caml_create_float_array
	sub     $sp, 103, $sp
	load    102($sp), $ra
	load    101($sp), $i2
	store   $i1, 4($i2)
	mov     $hp, $i1
	add     $hp, 8, $hp
	store   $i2, 7($i1)
	load    100($sp), $i2
	store   $i2, 6($i1)
	load    99($sp), $i2
	store   $i2, 5($i1)
	load    98($sp), $i2
	store   $i2, 4($i1)
	load    97($sp), $i2
	store   $i2, 3($i1)
	load    96($sp), $i2
	store   $i2, 2($i1)
	load    95($sp), $i2
	store   $i2, 1($i1)
	load    94($sp), $i2
	store   $i2, 0($i1)
	mov     $i1, $i2
	load    93($sp), $i1
	store   $ra, 102($sp)
	add     $sp, 103, $sp
	jal     min_caml_create_array
	sub     $sp, 103, $sp
	load    102($sp), $ra
	load    28($sp), $i2
	load    0($i2), $i2
	sub     $i2, 2, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.58642
	store   $i2, 102($sp)
	store   $i1, 103($sp)
	store   $ra, 104($sp)
	add     $sp, 105, $sp
	jal     create_pixel.3191
	sub     $sp, 105, $sp
	load    104($sp), $ra
	load    102($sp), $i2
	load    103($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	mov     $i3, $i1
	store   $ra, 104($sp)
	add     $sp, 105, $sp
	jal     init_line_elements.3193
	sub     $sp, 105, $sp
	load    104($sp), $ra
	b       bge_cont.58643
bge_else.58642:
bge_cont.58643:
	store   $i1, 104($sp)
	load    28($sp), $i1
	load    0($i1), $i1
	store   $i1, 105($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 106($sp)
	add     $sp, 107, $sp
	jal     min_caml_create_float_array
	sub     $sp, 107, $sp
	load    106($sp), $ra
	store   $i1, 106($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 107($sp)
	add     $sp, 108, $sp
	jal     min_caml_create_float_array
	sub     $sp, 108, $sp
	load    107($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 107($sp)
	add     $sp, 108, $sp
	jal     min_caml_create_array
	sub     $sp, 108, $sp
	load    107($sp), $ra
	store   $i1, 107($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 108($sp)
	add     $sp, 109, $sp
	jal     min_caml_create_float_array
	sub     $sp, 109, $sp
	load    108($sp), $ra
	load    107($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 108($sp)
	add     $sp, 109, $sp
	jal     min_caml_create_float_array
	sub     $sp, 109, $sp
	load    108($sp), $ra
	load    107($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 108($sp)
	add     $sp, 109, $sp
	jal     min_caml_create_float_array
	sub     $sp, 109, $sp
	load    108($sp), $ra
	load    107($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 108($sp)
	add     $sp, 109, $sp
	jal     min_caml_create_float_array
	sub     $sp, 109, $sp
	load    108($sp), $ra
	load    107($sp), $i2
	store   $i1, 4($i2)
	li      5, $i1
	li      0, $i2
	store   $ra, 108($sp)
	add     $sp, 109, $sp
	jal     min_caml_create_array
	sub     $sp, 109, $sp
	load    108($sp), $ra
	store   $i1, 108($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 109($sp)
	add     $sp, 110, $sp
	jal     min_caml_create_array
	sub     $sp, 110, $sp
	load    109($sp), $ra
	store   $i1, 109($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 110($sp)
	add     $sp, 111, $sp
	jal     min_caml_create_float_array
	sub     $sp, 111, $sp
	load    110($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 110($sp)
	add     $sp, 111, $sp
	jal     min_caml_create_array
	sub     $sp, 111, $sp
	load    110($sp), $ra
	store   $i1, 110($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 111($sp)
	add     $sp, 112, $sp
	jal     min_caml_create_float_array
	sub     $sp, 112, $sp
	load    111($sp), $ra
	load    110($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 111($sp)
	add     $sp, 112, $sp
	jal     min_caml_create_float_array
	sub     $sp, 112, $sp
	load    111($sp), $ra
	load    110($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 111($sp)
	add     $sp, 112, $sp
	jal     min_caml_create_float_array
	sub     $sp, 112, $sp
	load    111($sp), $ra
	load    110($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 111($sp)
	add     $sp, 112, $sp
	jal     min_caml_create_float_array
	sub     $sp, 112, $sp
	load    111($sp), $ra
	load    110($sp), $i2
	store   $i1, 4($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 111($sp)
	add     $sp, 112, $sp
	jal     min_caml_create_float_array
	sub     $sp, 112, $sp
	load    111($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 111($sp)
	add     $sp, 112, $sp
	jal     min_caml_create_array
	sub     $sp, 112, $sp
	load    111($sp), $ra
	store   $i1, 111($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 112($sp)
	add     $sp, 113, $sp
	jal     min_caml_create_float_array
	sub     $sp, 113, $sp
	load    112($sp), $ra
	load    111($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 112($sp)
	add     $sp, 113, $sp
	jal     min_caml_create_float_array
	sub     $sp, 113, $sp
	load    112($sp), $ra
	load    111($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 112($sp)
	add     $sp, 113, $sp
	jal     min_caml_create_float_array
	sub     $sp, 113, $sp
	load    112($sp), $ra
	load    111($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 112($sp)
	add     $sp, 113, $sp
	jal     min_caml_create_float_array
	sub     $sp, 113, $sp
	load    112($sp), $ra
	load    111($sp), $i2
	store   $i1, 4($i2)
	li      1, $i1
	li      0, $i2
	store   $ra, 112($sp)
	add     $sp, 113, $sp
	jal     min_caml_create_array
	sub     $sp, 113, $sp
	load    112($sp), $ra
	store   $i1, 112($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 113($sp)
	add     $sp, 114, $sp
	jal     min_caml_create_float_array
	sub     $sp, 114, $sp
	load    113($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 113($sp)
	add     $sp, 114, $sp
	jal     min_caml_create_array
	sub     $sp, 114, $sp
	load    113($sp), $ra
	store   $i1, 113($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 114($sp)
	add     $sp, 115, $sp
	jal     min_caml_create_float_array
	sub     $sp, 115, $sp
	load    114($sp), $ra
	load    113($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 114($sp)
	add     $sp, 115, $sp
	jal     min_caml_create_float_array
	sub     $sp, 115, $sp
	load    114($sp), $ra
	load    113($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 114($sp)
	add     $sp, 115, $sp
	jal     min_caml_create_float_array
	sub     $sp, 115, $sp
	load    114($sp), $ra
	load    113($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 114($sp)
	add     $sp, 115, $sp
	jal     min_caml_create_float_array
	sub     $sp, 115, $sp
	load    114($sp), $ra
	load    113($sp), $i2
	store   $i1, 4($i2)
	mov     $hp, $i1
	add     $hp, 8, $hp
	store   $i2, 7($i1)
	load    112($sp), $i2
	store   $i2, 6($i1)
	load    111($sp), $i2
	store   $i2, 5($i1)
	load    110($sp), $i2
	store   $i2, 4($i1)
	load    109($sp), $i2
	store   $i2, 3($i1)
	load    108($sp), $i2
	store   $i2, 2($i1)
	load    107($sp), $i2
	store   $i2, 1($i1)
	load    106($sp), $i2
	store   $i2, 0($i1)
	mov     $i1, $i2
	load    105($sp), $i1
	store   $ra, 114($sp)
	add     $sp, 115, $sp
	jal     min_caml_create_array
	sub     $sp, 115, $sp
	load    114($sp), $ra
	load    28($sp), $i2
	load    0($i2), $i2
	sub     $i2, 2, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.58644
	store   $i2, 114($sp)
	store   $i1, 115($sp)
	store   $ra, 116($sp)
	add     $sp, 117, $sp
	jal     create_pixel.3191
	sub     $sp, 117, $sp
	load    116($sp), $ra
	load    114($sp), $i2
	load    115($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	mov     $i3, $i1
	store   $ra, 116($sp)
	add     $sp, 117, $sp
	jal     init_line_elements.3193
	sub     $sp, 117, $sp
	load    116($sp), $ra
	b       bge_cont.58645
bge_else.58644:
bge_cont.58645:
	store   $i1, 116($sp)
	load    46($sp), $i11
	store   $ra, 117($sp)
	load    0($i11), $i10
	li      cls.58646, $ra
	add     $sp, 118, $sp
	jr      $i10
cls.58646:
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      80, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      54, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      10, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      49, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      50, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      56, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      32, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      49, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      50, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      56, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      32, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      50, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      53, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      53, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      10, $i1
	store   $ra, 117($sp)
	add     $sp, 118, $sp
	jal     min_caml_write
	sub     $sp, 118, $sp
	load    117($sp), $ra
	li      120, $i1
	store   $i1, 117($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 118($sp)
	add     $sp, 119, $sp
	jal     min_caml_create_float_array
	sub     $sp, 119, $sp
	load    118($sp), $ra
	mov     $i1, $i2
	store   $i2, 118($sp)
	load    9($sp), $i1
	load    0($i1), $i1
	store   $ra, 119($sp)
	add     $sp, 120, $sp
	jal     min_caml_create_array
	sub     $sp, 120, $sp
	load    119($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    118($sp), $i1
	store   $i1, 0($i2)
	load    117($sp), $i1
	store   $ra, 119($sp)
	add     $sp, 120, $sp
	jal     min_caml_create_array
	sub     $sp, 120, $sp
	load    119($sp), $ra
	load    38($sp), $i2
	store   $i1, 4($i2)
	load    4($i2), $i1
	store   $i1, 119($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 120($sp)
	add     $sp, 121, $sp
	jal     min_caml_create_float_array
	sub     $sp, 121, $sp
	load    120($sp), $ra
	mov     $i1, $i2
	store   $i2, 120($sp)
	load    9($sp), $i1
	load    0($i1), $i1
	store   $ra, 121($sp)
	add     $sp, 122, $sp
	jal     min_caml_create_array
	sub     $sp, 122, $sp
	load    121($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    120($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    119($sp), $i2
	store   $i1, 118($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 121($sp)
	add     $sp, 122, $sp
	jal     min_caml_create_float_array
	sub     $sp, 122, $sp
	load    121($sp), $ra
	mov     $i1, $i2
	store   $i2, 121($sp)
	load    9($sp), $i1
	load    0($i1), $i1
	store   $ra, 122($sp)
	add     $sp, 123, $sp
	jal     min_caml_create_array
	sub     $sp, 123, $sp
	load    122($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    121($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    119($sp), $i2
	store   $i1, 117($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 122($sp)
	add     $sp, 123, $sp
	jal     min_caml_create_float_array
	sub     $sp, 123, $sp
	load    122($sp), $ra
	mov     $i1, $i2
	store   $i2, 122($sp)
	load    9($sp), $i1
	load    0($i1), $i1
	store   $ra, 123($sp)
	add     $sp, 124, $sp
	jal     min_caml_create_array
	sub     $sp, 124, $sp
	load    123($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    122($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    119($sp), $i2
	store   $i1, 116($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 123($sp)
	add     $sp, 124, $sp
	jal     min_caml_create_float_array
	sub     $sp, 124, $sp
	load    123($sp), $ra
	mov     $i1, $i2
	store   $i2, 123($sp)
	load    9($sp), $i1
	load    0($i1), $i1
	store   $ra, 124($sp)
	add     $sp, 125, $sp
	jal     min_caml_create_array
	sub     $sp, 125, $sp
	load    124($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    123($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    119($sp), $i2
	store   $i1, 115($i2)
	li      114, $i1
	load    75($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 124($sp)
	load    0($i11), $i10
	li      cls.58647, $ra
	add     $sp, 125, $sp
	jr      $i10
cls.58647:
	sub     $sp, 125, $sp
	load    124($sp), $ra
	li      3, $i1
	load    76($sp), $i11
	store   $ra, 124($sp)
	load    0($i11), $i10
	li      cls.58648, $ra
	add     $sp, 125, $sp
	jr      $i10
cls.58648:
	sub     $sp, 125, $sp
	load    124($sp), $ra
	li      9, $i1
	li      0, $i2
	store   $i2, 124($sp)
	li      0, $i2
	store   $i2, 125($sp)
	store   $ra, 126($sp)
	add     $sp, 127, $sp
	jal     min_caml_float_of_int
	sub     $sp, 127, $sp
	load    126($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26356, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	li      4, $i1
	load    124($sp), $i2
	load    125($sp), $i3
	load    73($sp), $i11
	store   $ra, 126($sp)
	load    0($i11), $i10
	li      cls.58649, $ra
	add     $sp, 127, $sp
	jr      $i10
cls.58649:
	sub     $sp, 127, $sp
	load    126($sp), $ra
	li      8, $i1
	li      2, $i2
	li      4, $i3
	load    74($sp), $i11
	store   $ra, 126($sp)
	load    0($i11), $i10
	li      cls.58650, $ra
	add     $sp, 127, $sp
	jr      $i10
cls.58650:
	sub     $sp, 127, $sp
	load    126($sp), $ra
	load    38($sp), $i1
	load    4($i1), $i1
	li      119, $i2
	load    77($sp), $i11
	store   $ra, 126($sp)
	load    0($i11), $i10
	li      cls.58651, $ra
	add     $sp, 127, $sp
	jr      $i10
cls.58651:
	sub     $sp, 127, $sp
	load    126($sp), $ra
	li      3, $i1
	load    78($sp), $i11
	store   $ra, 126($sp)
	load    0($i11), $i10
	li      cls.58652, $ra
	add     $sp, 127, $sp
	jr      $i10
cls.58652:
	sub     $sp, 127, $sp
	load    126($sp), $ra
	load    13($sp), $i1
	load    0($i1), $f1
	load    40($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    9($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58653
	load    10($sp), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i3
	load    1($i3), $i4
	li      1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.58655
	store   $i1, 126($sp)
	mov     $i2, $i1
	mov     $i3, $i2
	store   $ra, 127($sp)
	add     $sp, 128, $sp
	jal     setup_rect_table.3000
	sub     $sp, 128, $sp
	load    127($sp), $ra
	load    126($sp), $i2
	load    41($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.58656
be_else.58655:
	li      2, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.58657
	store   $i1, 126($sp)
	mov     $i2, $i1
	mov     $i3, $i2
	store   $ra, 127($sp)
	add     $sp, 128, $sp
	jal     setup_surface_table.3003
	sub     $sp, 128, $sp
	load    127($sp), $ra
	load    126($sp), $i2
	load    41($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.58658
be_else.58657:
	store   $i1, 126($sp)
	mov     $i2, $i1
	mov     $i3, $i2
	store   $ra, 127($sp)
	add     $sp, 128, $sp
	jal     setup_second_table.3006
	sub     $sp, 128, $sp
	load    127($sp), $ra
	load    126($sp), $i2
	load    41($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.58658:
be_cont.58656:
	sub     $i2, 1, $i2
	load    42($sp), $i1
	load    54($sp), $i11
	store   $ra, 127($sp)
	load    0($i11), $i10
	li      cls.58659, $ra
	add     $sp, 128, $sp
	jr      $i10
cls.58659:
	sub     $sp, 128, $sp
	load    127($sp), $ra
	b       bge_cont.58654
bge_else.58653:
bge_cont.58654:
	load    9($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    79($sp), $i11
	store   $ra, 127($sp)
	load    0($i11), $i10
	li      cls.58660, $ra
	add     $sp, 128, $sp
	jr      $i10
cls.58660:
	sub     $sp, 128, $sp
	load    127($sp), $ra
	li      0, $i2
	li      0, $i3
	load    104($sp), $i1
	load    71($sp), $i11
	store   $ra, 127($sp)
	load    0($i11), $i10
	li      cls.58661, $ra
	add     $sp, 128, $sp
	jr      $i10
cls.58661:
	sub     $sp, 128, $sp
	load    127($sp), $ra
	li      0, $i1
	li      2, $i5
	load    92($sp), $i2
	load    104($sp), $i3
	load    116($sp), $i4
	load    72($sp), $i11
	store   $ra, 127($sp)
	load    0($i11), $i10
	li      cls.58662, $ra
	add     $sp, 128, $sp
	jr      $i10
cls.58662:
	sub     $sp, 128, $sp
	load    127($sp), $ra
	li      0, $i12
	halt
cordic_rec.6601:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.58663
	mov     $f2, $f1
	ret
be_else.58663:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.58664
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58665
	ret
be_else.58665:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58666
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58666:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58664:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58667
	ret
be_else.58667:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58668
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58668:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_sin.2715:
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6601, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.58669
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25710, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58669:
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25705, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
cordic_rec.6569:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.58670
	ret
be_else.58670:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.58671
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58672
	mov     $f6, $f1
	ret
be_else.58672:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58673
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58673:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58671:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58674
	mov     $f6, $f1
	ret
be_else.58674:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58675
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58675:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_cos.2717:
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6569, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.58676
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25710, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58676:
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25705, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
cordic_rec.6536:
	load    1($i11), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.58677
	mov     $f3, $f1
	ret
be_else.58677:
	li      l.25703, $i3
	load    0($i3), $f5
	fcmp    $f2, $f5, $i12
	bg      $i12, ble_else.58678
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f5
	fsub    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58679
	mov     $f2, $f1
	ret
be_else.58679:
	li      l.25703, $i1
	load    0($i1), $f4
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.58680
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58680:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58678:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f5
	fadd    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58681
	mov     $f2, $f1
	ret
be_else.58681:
	li      l.25703, $i1
	load    0($i1), $f4
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.58682
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58682:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_atan.2719:
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 2, $hp
	li      cordic_rec.6536, $i2
	store   $i2, 0($i11)
	store   $i1, 1($i11)
	li      l.25743, $i1
	load    0($i1), $f2
	li      l.25703, $i1
	load    0($i1), $f3
	li      l.25743, $i1
	load    0($i1), $f4
	li      l.25703, $i1
	load    0($i1), $f5
	fcmp    $f1, $f5, $i12
	bg      $i12, ble_else.58683
	li      1, $i1
	fmul    $f4, $f1, $f4
	fsub    $f2, $f4, $f2
	li      l.25743, $i2
	load    0($i2), $f4
	fadd    $f1, $f4, $f1
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f3, $f4, $f3
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58683:
	li      1, $i1
	fmul    $f4, $f1, $f4
	fadd    $f2, $f4, $f2
	li      l.25743, $i2
	load    0($i2), $f4
	fsub    $f1, $f4, $f1
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f3, $f4, $f3
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_rec.6601.12200:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.58684
	mov     $f2, $f1
	ret
be_else.58684:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.58685
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58686
	ret
be_else.58686:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58687
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58687:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58685:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58688
	ret
be_else.58688:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58689
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58689:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_rec.6601.12232:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.58690
	mov     $f2, $f1
	ret
be_else.58690:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.58691
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58692
	ret
be_else.58692:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58693
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58693:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58691:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58694
	ret
be_else.58694:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58695
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58695:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
sin.2721:
	load    5($i11), $f2
	load    4($i11), $f3
	load    3($i11), $f4
	load    2($i11), $i1
	load    1($i11), $i2
	li      l.25703, $i3
	load    0($i3), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58696
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58697
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58698
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58699
	fsub    $f1, $f3, $f1
	li      l.25703, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58700
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58701
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58702
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58703
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58703:
	fsub    $f3, $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58704, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58704:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.58702:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.58701:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.58700:
	fneg    $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58705, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58705:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.58699:
	fsub    $f3, $f1, $f1
	li      l.25703, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58706
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58708
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58710
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58712
	fsub    $f1, $f3, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58714, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58714:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       ble_cont.58713
ble_else.58712:
	fsub    $f3, $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58715, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58715:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.58713:
	b       ble_cont.58711
ble_else.58710:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58716, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58716:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.58711:
	b       ble_cont.58709
ble_else.58708:
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58717, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58717:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.58709:
	b       ble_cont.58707
ble_else.58706:
	fneg    $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58718, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58718:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.58707:
	fneg    $f1, $f1
	ret
ble_else.58698:
	fsub    $f4, $f1, $f1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6601.12232, $i1
	store   $i1, 0($i11)
	store   $i2, 2($i11)
	store   $f1, 1($i11)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.58719
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25710, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58719:
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25705, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58697:
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6601.12200, $i1
	store   $i1, 0($i11)
	store   $i2, 2($i11)
	store   $f1, 1($i11)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.58720
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25710, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58720:
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25705, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58696:
	fneg    $f1, $f1
	li      l.25703, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58721
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58723
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58725
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58727
	fsub    $f1, $f3, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58729, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58729:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       ble_cont.58728
ble_else.58727:
	fsub    $f3, $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58730, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58730:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.58728:
	b       ble_cont.58726
ble_else.58725:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58731, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58731:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.58726:
	b       ble_cont.58724
ble_else.58723:
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58732, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58732:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.58724:
	b       ble_cont.58722
ble_else.58721:
	fneg    $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58733, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58733:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
ble_cont.58722:
	fneg    $f1, $f1
	ret
cordic_rec.6569.12117:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.58734
	ret
be_else.58734:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.58735
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58736
	mov     $f6, $f1
	ret
be_else.58736:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58737
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58737:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58735:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58738
	mov     $f6, $f1
	ret
be_else.58738:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58739
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58739:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_rec.6569.12149:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.58740
	ret
be_else.58740:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.58741
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fadd    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58742
	mov     $f6, $f1
	ret
be_else.58742:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58743
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58743:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58741:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f6
	fsub    $f1, $f6, $f6
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.58744
	mov     $f6, $f1
	ret
be_else.58744:
	fcmp    $f5, $f2, $i12
	bg      $i12, ble_else.58745
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58745:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f6, $f4, $f4
	fmul    $f3, $f6, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cos.2723:
	load    5($i11), $f2
	load    4($i11), $f3
	load    3($i11), $f4
	load    2($i11), $i1
	load    1($i11), $i2
	li      l.25703, $i3
	load    0($i3), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58746
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58747
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58748
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58749
	fsub    $f1, $f3, $f1
	li      l.25703, $i1
	load    0($i1), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58750
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58751
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58752
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58753
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58753:
	fsub    $f3, $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58752:
	fsub    $f4, $f1, $f1
	mov     $i2, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58754, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58754:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.58751:
	mov     $i2, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.58750:
	fneg    $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58749:
	fsub    $f3, $f1, $f1
	li      l.25703, $i1
	load    0($i1), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58755
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58756
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58757
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58758
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58758:
	fsub    $f3, $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58757:
	fsub    $f4, $f1, $f1
	mov     $i2, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58759, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58759:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.58756:
	mov     $i2, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.58755:
	fneg    $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58748:
	fsub    $f4, $f1, $f1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6569.12149, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.58760
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25710, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58762, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58762:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       ble_cont.58761
ble_else.58760:
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25705, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58763, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58763:
	sub     $sp, 1, $sp
	load    0($sp), $ra
ble_cont.58761:
	fneg    $f1, $f1
	ret
ble_else.58747:
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6569.12117, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.58764
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25710, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58764:
	li      1, $i1
	li      l.25705, $i2
	load    0($i2), $f1
	li      l.25705, $i2
	load    0($i2), $f3
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f2, $f4, $f2
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f3, $f14
	mov     $f2, $f3
	mov     $f14, $f2
	load    0($i11), $i10
	jr      $i10
ble_else.58746:
	fneg    $f1, $f1
	li      l.25703, $i1
	load    0($i1), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.58765
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58766
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.58767
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.58768
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58768:
	fsub    $f3, $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.58767:
	fsub    $f4, $f1, $f1
	mov     $i2, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.58769, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.58769:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.58766:
	mov     $i2, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.58765:
	fneg    $f1, $f1
	load    0($i11), $i10
	jr      $i10
get_sqrt_init_rec.6510.12047:
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58770
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58770:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58771
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58772
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58772:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58773
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58774
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58774:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58775
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58776
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58776:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58777
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58778
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58778:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58779
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58780
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58780:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58781
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58782
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58782:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58783
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58784
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.58784:
	li      l.25831, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58785
	li      l.25831, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	b       get_sqrt_init_rec.6510.12047
ble_else.58785:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.58783:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.58781:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.58779:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.58777:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.58775:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.58773:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
ble_else.58771:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
sqrt.2729:
	li      l.25743, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58786
	store   $f1, 0($sp)
	li      l.25831, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58787
	li      l.25831, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.25831, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58789
	li      l.25831, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.25831, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58791
	li      l.25831, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.25831, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58793
	li      l.25831, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.25831, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58795
	li      l.25831, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.25831, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58797
	li      l.25831, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      l.25831, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.58799
	li      l.25831, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	li      7, $i1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     get_sqrt_init_rec.6510.12047
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       ble_cont.58800
ble_else.58799:
	li      min_caml_rsqrt_table, $i1
	load    6($i1), $f1
ble_cont.58800:
	b       ble_cont.58798
ble_else.58797:
	li      min_caml_rsqrt_table, $i1
	load    5($i1), $f1
ble_cont.58798:
	b       ble_cont.58796
ble_else.58795:
	li      min_caml_rsqrt_table, $i1
	load    4($i1), $f1
ble_cont.58796:
	b       ble_cont.58794
ble_else.58793:
	li      min_caml_rsqrt_table, $i1
	load    3($i1), $f1
ble_cont.58794:
	b       ble_cont.58792
ble_else.58791:
	li      min_caml_rsqrt_table, $i1
	load    2($i1), $f1
ble_cont.58792:
	b       ble_cont.58790
ble_else.58789:
	li      min_caml_rsqrt_table, $i1
	load    1($i1), $f1
ble_cont.58790:
	b       ble_cont.58788
ble_else.58787:
	li      min_caml_rsqrt_table, $i1
	load    0($i1), $f1
ble_cont.58788:
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	load    0($sp), $f4
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.25696, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.25874, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	fmul    $f1, $f4, $f1
	ret
ble_else.58786:
	li      l.25696, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f1, $f15, $f3
	fadd    $f1, $f3, $f3
	fmul    $f2, $f3, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	fadd    $f2, $f1, $f1
	fmul    $f3, $f1, $f1
	ret
skip.6367:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58801
	ret
be_else.58801:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58802
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58803
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58804
	ret
be_else.58804:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58805
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58806
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58807
	ret
be_else.58807:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58808
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58809
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58810
	ret
be_else.58810:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58811
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58812
	b       skip.6367
bge_else.58812:
	ret
bge_else.58811:
	b       skip.6367
bge_else.58809:
	ret
bge_else.58808:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58813
	ret
be_else.58813:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58814
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58815
	b       skip.6367
bge_else.58815:
	ret
bge_else.58814:
	b       skip.6367
bge_else.58806:
	ret
bge_else.58805:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58816
	ret
be_else.58816:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58817
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58818
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58819
	ret
be_else.58819:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58820
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58821
	b       skip.6367
bge_else.58821:
	ret
bge_else.58820:
	b       skip.6367
bge_else.58818:
	ret
bge_else.58817:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58822
	ret
be_else.58822:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58823
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58824
	b       skip.6367
bge_else.58824:
	ret
bge_else.58823:
	b       skip.6367
bge_else.58803:
	ret
bge_else.58802:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58825
	ret
be_else.58825:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58826
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58827
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58828
	ret
be_else.58828:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58829
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58830
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58831
	ret
be_else.58831:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58832
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58833
	b       skip.6367
bge_else.58833:
	ret
bge_else.58832:
	b       skip.6367
bge_else.58830:
	ret
bge_else.58829:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58834
	ret
be_else.58834:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58835
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58836
	b       skip.6367
bge_else.58836:
	ret
bge_else.58835:
	b       skip.6367
bge_else.58827:
	ret
bge_else.58826:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58837
	ret
be_else.58837:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58838
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58839
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58840
	ret
be_else.58840:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58841
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58842
	b       skip.6367
bge_else.58842:
	ret
bge_else.58841:
	b       skip.6367
bge_else.58839:
	ret
bge_else.58838:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58843
	ret
be_else.58843:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58844
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58845
	b       skip.6367
bge_else.58845:
	ret
bge_else.58844:
	b       skip.6367
read_rec.6369:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58846
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58847
	load    0($sp), $i1
	ret
bge_else.58847:
	load    0($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58848
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58849
	load    1($sp), $i1
	ret
bge_else.58849:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58850
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58851
	load    2($sp), $i1
	ret
bge_else.58851:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58852
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58853
	load    3($sp), $i1
	ret
bge_else.58853:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	b       read_rec.6369
bge_else.58852:
	load    3($sp), $i1
	ret
bge_else.58850:
	load    2($sp), $i1
	ret
bge_else.58848:
	load    1($sp), $i1
	ret
bge_else.58846:
	load    0($sp), $i1
	ret
read_int.2731:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58854
	b       be_cont.58855
be_else.58854:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58856
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58858
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58860
	b       be_cont.58861
be_else.58860:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58862
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58864
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58866
	b       be_cont.58867
be_else.58866:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58868
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58870
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.58871
bge_else.58870:
bge_cont.58871:
	b       bge_cont.58869
bge_else.58868:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.58869:
be_cont.58867:
	b       bge_cont.58865
bge_else.58864:
bge_cont.58865:
	b       bge_cont.58863
bge_else.58862:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58872
	b       be_cont.58873
be_else.58872:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58874
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58876
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.58877
bge_else.58876:
bge_cont.58877:
	b       bge_cont.58875
bge_else.58874:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.58875:
be_cont.58873:
bge_cont.58863:
be_cont.58861:
	b       bge_cont.58859
bge_else.58858:
bge_cont.58859:
	b       bge_cont.58857
bge_else.58856:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58878
	b       be_cont.58879
be_else.58878:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58880
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58882
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58884
	b       be_cont.58885
be_else.58884:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58886
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58888
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.58889
bge_else.58888:
bge_cont.58889:
	b       bge_cont.58887
bge_else.58886:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.58887:
be_cont.58885:
	b       bge_cont.58883
bge_else.58882:
bge_cont.58883:
	b       bge_cont.58881
bge_else.58880:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58890
	b       be_cont.58891
be_else.58890:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58892
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58894
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.58895
bge_else.58894:
bge_cont.58895:
	b       bge_cont.58893
bge_else.58892:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.58893:
be_cont.58891:
bge_cont.58881:
be_cont.58879:
bge_cont.58857:
be_cont.58855:
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58896
	li      0, $i1
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58897
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58899
	li      0, $i1
	b       bge_cont.58900
bge_else.58899:
	load    0($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58901
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58903
	load    1($sp), $i1
	b       bge_cont.58904
bge_else.58903:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58905
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58907
	load    2($sp), $i1
	b       bge_cont.58908
bge_else.58907:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     read_rec.6369
	sub     $sp, 4, $sp
	load    3($sp), $ra
bge_cont.58908:
	b       bge_cont.58906
bge_else.58905:
	load    2($sp), $i1
bge_cont.58906:
bge_cont.58904:
	b       bge_cont.58902
bge_else.58901:
	load    1($sp), $i1
bge_cont.58902:
bge_cont.58900:
	b       bge_cont.58898
bge_else.58897:
	li      0, $i1
bge_cont.58898:
	neg     $i1, $i1
	ret
be_else.58896:
	sub     $i1, 48, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58909
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58910
	load    3($sp), $i1
	ret
bge_else.58910:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_read
	sub     $sp, 6, $sp
	load    5($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58911
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58912
	load    4($sp), $i1
	ret
bge_else.58912:
	load    4($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_read
	sub     $sp, 7, $sp
	load    6($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58913
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58914
	load    5($sp), $i1
	ret
bge_else.58914:
	load    5($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	b       read_rec.6369
bge_else.58913:
	load    5($sp), $i1
	ret
bge_else.58911:
	load    4($sp), $i1
	ret
bge_else.58909:
	load    3($sp), $i1
	ret
skip.6319:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58915
	ret
be_else.58915:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58916
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58917
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58918
	ret
be_else.58918:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58919
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58920
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58921
	ret
be_else.58921:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58922
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58923
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58924
	ret
be_else.58924:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58925
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58926
	b       skip.6319
bge_else.58926:
	ret
bge_else.58925:
	b       skip.6319
bge_else.58923:
	ret
bge_else.58922:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58927
	ret
be_else.58927:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58928
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58929
	b       skip.6319
bge_else.58929:
	ret
bge_else.58928:
	b       skip.6319
bge_else.58920:
	ret
bge_else.58919:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58930
	ret
be_else.58930:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58931
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58932
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58933
	ret
be_else.58933:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58934
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58935
	b       skip.6319
bge_else.58935:
	ret
bge_else.58934:
	b       skip.6319
bge_else.58932:
	ret
bge_else.58931:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58936
	ret
be_else.58936:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58937
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58938
	b       skip.6319
bge_else.58938:
	ret
bge_else.58937:
	b       skip.6319
bge_else.58917:
	ret
bge_else.58916:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58939
	ret
be_else.58939:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58940
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58941
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58942
	ret
be_else.58942:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58943
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58944
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58945
	ret
be_else.58945:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58946
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58947
	b       skip.6319
bge_else.58947:
	ret
bge_else.58946:
	b       skip.6319
bge_else.58944:
	ret
bge_else.58943:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58948
	ret
be_else.58948:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58949
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58950
	b       skip.6319
bge_else.58950:
	ret
bge_else.58949:
	b       skip.6319
bge_else.58941:
	ret
bge_else.58940:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58951
	ret
be_else.58951:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58952
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58953
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58954
	ret
be_else.58954:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58955
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58956
	b       skip.6319
bge_else.58956:
	ret
bge_else.58955:
	b       skip.6319
bge_else.58953:
	ret
bge_else.58952:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58957
	ret
be_else.58957:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58958
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58959
	b       skip.6319
bge_else.58959:
	ret
bge_else.58958:
	b       skip.6319
read_rec2.6321:
	store   $f1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58960
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58961
	li      l.25703, $i1
	load    0($i1), $f1
	ret
bge_else.58961:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_float_of_int
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 1($sp)
	li      l.25895, $i1
	load    0($i1), $f1
	fmul    $f2, $f1, $f1
	store   $f1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58962
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58964
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58965
bge_else.58964:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_float_of_int
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 3($sp)
	li      l.25895, $i1
	load    0($i1), $f1
	fmul    $f2, $f1, $f1
	store   $f1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_read
	sub     $sp, 6, $sp
	load    5($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58966
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58968
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58969
bge_else.58968:
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_float_of_int
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 5($sp)
	li      l.25895, $i1
	load    0($i1), $f1
	fmul    $f2, $f1, $f1
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_read
	sub     $sp, 8, $sp
	load    7($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58970
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58972
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58973
bge_else.58972:
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_float_of_int
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 7($sp)
	li      l.25895, $i1
	load    0($i1), $f1
	fmul    $f2, $f1, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     read_rec2.6321
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58973:
	b       bge_cont.58971
bge_else.58970:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58971:
	load    5($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58969:
	b       bge_cont.58967
bge_else.58966:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58967:
	load    3($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58965:
	b       bge_cont.58963
bge_else.58962:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58963:
	load    1($sp), $f2
	fadd    $f2, $f1, $f1
	ret
bge_else.58960:
	li      l.25703, $i1
	load    0($i1), $f1
	ret
read_rec1.6323:
	store   $f1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58974
	li      l.25895, $i1
	load    0($i1), $f1
	store   $f1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58975
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58977
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58978
bge_else.58977:
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_float_of_int
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 2($sp)
	li      l.25915, $i1
	load    0($i1), $f1
	store   $f1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58979
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58981
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58982
bge_else.58981:
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_float_of_int
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 4($sp)
	li      l.25922, $i1
	load    0($i1), $f1
	store   $f1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_read
	sub     $sp, 7, $sp
	load    6($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58983
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58985
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58986
bge_else.58985:
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_float_of_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 6($sp)
	li      l.25932, $i1
	load    0($i1), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_rec2.6321
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58986:
	b       bge_cont.58984
bge_else.58983:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58984:
	load    4($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58982:
	b       bge_cont.58980
bge_else.58979:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58980:
	load    2($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58978:
	b       bge_cont.58976
bge_else.58975:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58976:
	load    0($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.58974:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58987
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58988
	load    0($sp), $f1
	ret
bge_else.58988:
	li      l.25907, $i2
	load    0($i2), $f1
	load    0($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_float_of_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read
	sub     $sp, 10, $sp
	load    9($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.58989
	li      l.25895, $i1
	load    0($i1), $f1
	store   $f1, 9($sp)
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58990
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58992
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58993
bge_else.58992:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_float_of_int
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 10($sp)
	li      l.25915, $i1
	load    0($i1), $f1
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read
	sub     $sp, 13, $sp
	load    12($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58994
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58996
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.58997
bge_else.58996:
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_float_of_int
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 12($sp)
	li      l.25922, $i1
	load    0($i1), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     read_rec2.6321
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58997:
	b       bge_cont.58995
bge_else.58994:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58995:
	load    10($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.58993:
	b       bge_cont.58991
bge_else.58990:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.58991:
	load    8($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.58989:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58998
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.58999
	load    8($sp), $f1
	ret
bge_else.58999:
	li      l.25907, $i2
	load    0($i2), $f1
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 13($sp)
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_float_of_int
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_read
	sub     $sp, 16, $sp
	load    15($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59000
	li      l.25895, $i1
	load    0($i1), $f1
	store   $f1, 15($sp)
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_read
	sub     $sp, 17, $sp
	load    16($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59001
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59003
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.59004
bge_else.59003:
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_float_of_int
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 16($sp)
	li      l.25915, $i1
	load    0($i1), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     read_rec2.6321
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.59004:
	b       bge_cont.59002
bge_else.59001:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.59002:
	load    14($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.59000:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59005
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59006
	load    14($sp), $f1
	ret
bge_else.59006:
	li      l.25907, $i2
	load    0($i2), $f1
	load    14($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 17($sp)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_float_of_int
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 18($sp)
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_read
	sub     $sp, 20, $sp
	load    19($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59007
	li      l.25895, $i1
	load    0($i1), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     read_rec2.6321
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.59007:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59008
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59009
	load    18($sp), $f1
	ret
bge_else.59009:
	li      l.25907, $i2
	load    0($i2), $f1
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_float_of_int
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $f2
	fadd    $f2, $f1, $f1
	b       read_rec1.6323
bge_else.59008:
	load    18($sp), $f1
	ret
bge_else.59005:
	load    14($sp), $f1
	ret
bge_else.58998:
	load    8($sp), $f1
	ret
bge_else.58987:
	load    0($sp), $f1
	ret
read_float.2733:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59010
	b       be_cont.59011
be_else.59010:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59012
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59014
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59016
	b       be_cont.59017
be_else.59016:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59018
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59020
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59022
	b       be_cont.59023
be_else.59022:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59024
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59026
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.59027
bge_else.59026:
bge_cont.59027:
	b       bge_cont.59025
bge_else.59024:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.59025:
be_cont.59023:
	b       bge_cont.59021
bge_else.59020:
bge_cont.59021:
	b       bge_cont.59019
bge_else.59018:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59028
	b       be_cont.59029
be_else.59028:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59030
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59032
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.59033
bge_else.59032:
bge_cont.59033:
	b       bge_cont.59031
bge_else.59030:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.59031:
be_cont.59029:
bge_cont.59019:
be_cont.59017:
	b       bge_cont.59015
bge_else.59014:
bge_cont.59015:
	b       bge_cont.59013
bge_else.59012:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59034
	b       be_cont.59035
be_else.59034:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59036
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59038
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59040
	b       be_cont.59041
be_else.59040:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59042
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59044
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.59045
bge_else.59044:
bge_cont.59045:
	b       bge_cont.59043
bge_else.59042:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.59043:
be_cont.59041:
	b       bge_cont.59039
bge_else.59038:
bge_cont.59039:
	b       bge_cont.59037
bge_else.59036:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59046
	b       be_cont.59047
be_else.59046:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59048
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59050
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       bge_cont.59051
bge_else.59050:
bge_cont.59051:
	b       bge_cont.59049
bge_else.59048:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
bge_cont.59049:
be_cont.59047:
bge_cont.59037:
be_cont.59035:
bge_cont.59013:
be_cont.59011:
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59052
	li      l.25703, $i1
	load    0($i1), $f1
	store   $f1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59053
	li      l.25895, $i1
	load    0($i1), $f1
	store   $f1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59055
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59057
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.59058
bge_else.59057:
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_float_of_int
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 2($sp)
	li      l.25915, $i1
	load    0($i1), $f1
	store   $f1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59059
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59061
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.59062
bge_else.59061:
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_float_of_int
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 4($sp)
	li      l.25922, $i1
	load    0($i1), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     read_rec2.6321
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.59062:
	b       bge_cont.59060
bge_else.59059:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.59060:
	load    2($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.59058:
	b       bge_cont.59056
bge_else.59055:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.59056:
	load    0($sp), $f2
	fadd    $f2, $f1, $f1
	b       be_cont.59054
be_else.59053:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59063
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59065
	load    0($sp), $f1
	b       bge_cont.59066
bge_else.59065:
	li      l.25703, $i2
	load    0($i2), $f1
	store   $f1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_float_of_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_read
	sub     $sp, 8, $sp
	load    7($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59067
	li      l.25895, $i1
	load    0($i1), $f1
	store   $f1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_read
	sub     $sp, 9, $sp
	load    8($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59069
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59071
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.59072
bge_else.59071:
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_float_of_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 8($sp)
	li      l.25915, $i1
	load    0($i1), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_rec2.6321
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.59072:
	b       bge_cont.59070
bge_else.59069:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.59070:
	load    6($sp), $f2
	fadd    $f2, $f1, $f1
	b       be_cont.59068
be_else.59067:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59073
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59075
	load    6($sp), $f1
	b       bge_cont.59076
bge_else.59075:
	li      l.25907, $i2
	load    0($i2), $f1
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 9($sp)
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_float_of_int
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_read
	sub     $sp, 12, $sp
	load    11($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59077
	li      l.25895, $i1
	load    0($i1), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     read_rec2.6321
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	fadd    $f2, $f1, $f1
	b       be_cont.59078
be_else.59077:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59079
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59081
	load    10($sp), $f1
	b       bge_cont.59082
bge_else.59081:
	li      l.25907, $i2
	load    0($i2), $f1
	load    10($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_float_of_int
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     read_rec1.6323
	sub     $sp, 13, $sp
	load    12($sp), $ra
bge_cont.59082:
	b       bge_cont.59080
bge_else.59079:
	load    10($sp), $f1
bge_cont.59080:
be_cont.59078:
bge_cont.59076:
	b       bge_cont.59074
bge_else.59073:
	load    6($sp), $f1
bge_cont.59074:
be_cont.59068:
bge_cont.59066:
	b       bge_cont.59064
bge_else.59063:
	load    0($sp), $f1
bge_cont.59064:
be_cont.59054:
	fneg    $f1, $f1
	ret
be_else.59052:
	sub     $i1, 48, $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_float_of_int
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $f1, 12($sp)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_read
	sub     $sp, 14, $sp
	load    13($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59083
	li      l.25895, $i1
	load    0($i1), $f1
	store   $f1, 13($sp)
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_read
	sub     $sp, 15, $sp
	load    14($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59084
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59086
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.59087
bge_else.59086:
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_float_of_int
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 14($sp)
	li      l.25915, $i1
	load    0($i1), $f1
	store   $f1, 15($sp)
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_read
	sub     $sp, 17, $sp
	load    16($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59088
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59090
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.59091
bge_else.59090:
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_float_of_int
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 16($sp)
	li      l.25922, $i1
	load    0($i1), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     read_rec2.6321
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.59091:
	b       bge_cont.59089
bge_else.59088:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.59089:
	load    14($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.59087:
	b       bge_cont.59085
bge_else.59084:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.59085:
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.59083:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59092
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59093
	load    12($sp), $f1
	ret
bge_else.59093:
	li      l.25907, $i2
	load    0($i2), $f1
	load    12($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 17($sp)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_float_of_int
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 18($sp)
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_read
	sub     $sp, 20, $sp
	load    19($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59094
	li      l.25895, $i1
	load    0($i1), $f1
	store   $f1, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_read
	sub     $sp, 21, $sp
	load    20($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59095
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59097
	li      l.25703, $i1
	load    0($i1), $f1
	b       bge_cont.59098
bge_else.59097:
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_float_of_int
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 20($sp)
	li      l.25915, $i1
	load    0($i1), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     read_rec2.6321
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    20($sp), $f2
	fadd    $f2, $f1, $f1
bge_cont.59098:
	b       bge_cont.59096
bge_else.59095:
	li      l.25703, $i1
	load    0($i1), $f1
bge_cont.59096:
	load    18($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.59094:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59099
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59100
	load    18($sp), $f1
	ret
bge_else.59100:
	li      l.25907, $i2
	load    0($i2), $f1
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 21($sp)
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_float_of_int
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 22($sp)
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_read
	sub     $sp, 24, $sp
	load    23($sp), $ra
	sub     $i1, 48, $i1
	li      -2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59101
	li      l.25895, $i1
	load    0($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     read_rec2.6321
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    22($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.59101:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59102
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59103
	load    22($sp), $f1
	ret
bge_else.59103:
	li      l.25907, $i2
	load    0($i2), $f1
	load    22($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 23($sp)
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_float_of_int
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    23($sp), $f2
	fadd    $f2, $f1, $f1
	b       read_rec1.6323
bge_else.59102:
	load    22($sp), $f1
	ret
bge_else.59099:
	load    18($sp), $f1
	ret
bge_else.59092:
	load    12($sp), $f1
	ret
read_screen_settings.2895:
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
	jal     read_float.2733
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    5($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     read_float.2733
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    5($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     read_float.2733
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    5($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     read_float.2733
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      l.25968, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 12($sp)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59104
	load    6($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59106
	load    8($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59108
	load    7($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59110
	fsub    $f1, $f2, $f1
	load    9($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59112, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59112:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	b       ble_cont.59111
ble_else.59110:
	fsub    $f2, $f1, $f1
	load    9($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59113, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59113:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.59111:
	b       ble_cont.59109
ble_else.59108:
	fsub    $f2, $f1, $f1
	load    11($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59114, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59114:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	fneg    $f1, $f1
ble_cont.59109:
	b       ble_cont.59107
ble_else.59106:
	load    11($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59115, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59115:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.59107:
	b       ble_cont.59105
ble_else.59104:
	fneg    $f1, $f1
	load    9($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59116, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59116:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.59105:
	store   $f1, 13($sp)
	li      l.25703, $i1
	load    0($i1), $f1
	load    12($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59117
	load    6($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59119
	load    8($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59121
	load    7($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59123
	fsub    $f2, $f1, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59125, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59125:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       ble_cont.59124
ble_else.59123:
	fsub    $f1, $f2, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59126, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59126:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.59124:
	b       ble_cont.59122
ble_else.59121:
	fsub    $f1, $f2, $f1
	load    10($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59127, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59127:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.59122:
	b       ble_cont.59120
ble_else.59119:
	load    10($sp), $i11
	mov     $f2, $f1
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59128, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59128:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.59120:
	b       ble_cont.59118
ble_else.59117:
	fneg    $f2, $f1
	load    1($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59129, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59129:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.59118:
	store   $f1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     read_float.2733
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      l.25968, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 15($sp)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59130
	load    6($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59132
	load    8($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59134
	load    7($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59136
	fsub    $f1, $f2, $f1
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.59138, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.59138:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	b       ble_cont.59137
ble_else.59136:
	fsub    $f2, $f1, $f1
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.59139, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.59139:
	sub     $sp, 17, $sp
	load    16($sp), $ra
ble_cont.59137:
	b       ble_cont.59135
ble_else.59134:
	fsub    $f2, $f1, $f1
	load    11($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.59140, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.59140:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	fneg    $f1, $f1
ble_cont.59135:
	b       ble_cont.59133
ble_else.59132:
	load    11($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.59141, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.59141:
	sub     $sp, 17, $sp
	load    16($sp), $ra
ble_cont.59133:
	b       ble_cont.59131
ble_else.59130:
	fneg    $f1, $f1
	load    9($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.59142, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.59142:
	sub     $sp, 17, $sp
	load    16($sp), $ra
ble_cont.59131:
	store   $f1, 16($sp)
	li      l.25703, $i1
	load    0($i1), $f1
	load    15($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59143
	load    6($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59145
	load    8($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59147
	load    7($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.59149
	fsub    $f2, $f1, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.59151, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.59151:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       ble_cont.59150
ble_else.59149:
	fsub    $f1, $f2, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.59152, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.59152:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	fneg    $f1, $f1
ble_cont.59150:
	b       ble_cont.59148
ble_else.59147:
	fsub    $f1, $f2, $f1
	load    10($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.59153, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.59153:
	sub     $sp, 18, $sp
	load    17($sp), $ra
ble_cont.59148:
	b       ble_cont.59146
ble_else.59145:
	load    10($sp), $i11
	mov     $f2, $f1
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.59154, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.59154:
	sub     $sp, 18, $sp
	load    17($sp), $ra
ble_cont.59146:
	b       ble_cont.59144
ble_else.59143:
	fneg    $f2, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.59155, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.59155:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	fneg    $f1, $f1
ble_cont.59144:
	store   $f1, 17($sp)
	load    13($sp), $f2
	fmul    $f2, $f1, $f3
	li      l.25975, $i1
	load    0($i1), $f4
	fmul    $f3, $f4, $f3
	load    2($sp), $i1
	store   $f3, 0($i1)
	li      l.25977, $i2
	load    0($i2), $f3
	load    14($sp), $f4
	fmul    $f4, $f3, $f3
	store   $f3, 1($i1)
	load    16($sp), $f3
	fmul    $f2, $f3, $f2
	li      l.25975, $i2
	load    0($i2), $f4
	fmul    $f2, $f4, $f2
	store   $f2, 2($i1)
	load    4($sp), $i1
	store   $f3, 0($i1)
	li      l.25703, $i2
	load    0($i2), $f2
	store   $f2, 1($i1)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fneg
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    4($sp), $i1
	store   $f1, 2($i1)
	load    14($sp), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fneg
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $i1
	store   $f1, 0($i1)
	load    13($sp), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fneg
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    3($sp), $i1
	store   $f1, 1($i1)
	load    14($sp), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fneg
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    16($sp), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $i1
	store   $f1, 2($i1)
	load    5($sp), $i1
	load    0($i1), $f1
	load    2($sp), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	load    0($sp), $i3
	store   $f1, 0($i3)
	load    1($i1), $f1
	load    1($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 1($i3)
	load    2($i1), $f1
	load    2($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 2($i3)
	ret
rotate_quadratic_matrix.2899:
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
	li      l.25703, $i2
	load    0($i2), $f5
	fcmp    $f5, $f4, $i12
	bg      $i12, ble_else.59157
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.59159
	fcmp    $f3, $f4, $i12
	bg      $i12, ble_else.59161
	fcmp    $f2, $f4, $i12
	bg      $i12, ble_else.59163
	fsub    $f4, $f2, $f1
	mov     $i1, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.59165, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.59165:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	b       ble_cont.59164
ble_else.59163:
	fsub    $f2, $f4, $f1
	mov     $i1, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.59166, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.59166:
	sub     $sp, 10, $sp
	load    9($sp), $ra
ble_cont.59164:
	b       ble_cont.59162
ble_else.59161:
	fsub    $f3, $f4, $f1
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.59167, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.59167:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	fneg    $f1, $f1
ble_cont.59162:
	b       ble_cont.59160
ble_else.59159:
	mov     $f4, $f1
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.59168, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.59168:
	sub     $sp, 10, $sp
	load    9($sp), $ra
ble_cont.59160:
	b       ble_cont.59158
ble_else.59157:
	fneg    $f4, $f1
	mov     $i1, $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.59169, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.59169:
	sub     $sp, 10, $sp
	load    9($sp), $ra
ble_cont.59158:
	store   $f1, 9($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59170
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59172
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59174
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59176
	fsub    $f1, $f2, $f1
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.59178, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.59178:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       ble_cont.59177
ble_else.59176:
	fsub    $f2, $f1, $f1
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.59179, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.59179:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	fneg    $f1, $f1
ble_cont.59177:
	b       ble_cont.59175
ble_else.59174:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.59180, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.59180:
	sub     $sp, 11, $sp
	load    10($sp), $ra
ble_cont.59175:
	b       ble_cont.59173
ble_else.59172:
	load    7($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.59181, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.59181:
	sub     $sp, 11, $sp
	load    10($sp), $ra
ble_cont.59173:
	b       ble_cont.59171
ble_else.59170:
	fneg    $f1, $f1
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.59182, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.59182:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	fneg    $f1, $f1
ble_cont.59171:
	store   $f1, 10($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59183
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59185
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59187
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59189
	fsub    $f1, $f2, $f1
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.59191, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.59191:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       ble_cont.59190
ble_else.59189:
	fsub    $f2, $f1, $f1
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.59192, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.59192:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.59190:
	b       ble_cont.59188
ble_else.59187:
	fsub    $f2, $f1, $f1
	load    8($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.59193, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.59193:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	fneg    $f1, $f1
ble_cont.59188:
	b       ble_cont.59186
ble_else.59185:
	load    8($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.59194, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.59194:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.59186:
	b       ble_cont.59184
ble_else.59183:
	fneg    $f1, $f1
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.59195, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.59195:
	sub     $sp, 12, $sp
	load    11($sp), $ra
ble_cont.59184:
	store   $f1, 11($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59196
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59198
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59200
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59202
	fsub    $f1, $f2, $f1
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.59204, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.59204:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	b       ble_cont.59203
ble_else.59202:
	fsub    $f2, $f1, $f1
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.59205, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.59205:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.59203:
	b       ble_cont.59201
ble_else.59200:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.59206, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.59206:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.59201:
	b       ble_cont.59199
ble_else.59198:
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.59207, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.59207:
	sub     $sp, 13, $sp
	load    12($sp), $ra
ble_cont.59199:
	b       ble_cont.59197
ble_else.59196:
	fneg    $f1, $f1
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.59208, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.59208:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	fneg    $f1, $f1
ble_cont.59197:
	store   $f1, 12($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59209
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59211
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59213
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59215
	fsub    $f1, $f2, $f1
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59217, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59217:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	b       ble_cont.59216
ble_else.59215:
	fsub    $f2, $f1, $f1
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59218, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59218:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.59216:
	b       ble_cont.59214
ble_else.59213:
	fsub    $f2, $f1, $f1
	load    8($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59219, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59219:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	fneg    $f1, $f1
ble_cont.59214:
	b       ble_cont.59212
ble_else.59211:
	load    8($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59220, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59220:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.59212:
	b       ble_cont.59210
ble_else.59209:
	fneg    $f1, $f1
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59221, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59221:
	sub     $sp, 14, $sp
	load    13($sp), $ra
ble_cont.59210:
	store   $f1, 13($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59222
	load    3($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59224
	load    5($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59226
	load    4($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.59228
	fsub    $f1, $f2, $f1
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59230, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59230:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       ble_cont.59229
ble_else.59228:
	fsub    $f2, $f1, $f1
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59231, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59231:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.59229:
	b       ble_cont.59227
ble_else.59226:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59232, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59232:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.59227:
	b       ble_cont.59225
ble_else.59224:
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59233, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59233:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.59225:
	b       ble_cont.59223
ble_else.59222:
	fneg    $f1, $f1
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59234, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59234:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.59223:
	load    13($sp), $f2
	load    11($sp), $f3
	fmul    $f3, $f2, $f4
	store   $f4, 14($sp)
	load    12($sp), $f4
	load    10($sp), $f5
	fmul    $f5, $f4, $f6
	fmul    $f6, $f2, $f6
	load    9($sp), $f7
	fmul    $f7, $f1, $f8
	fsub    $f6, $f8, $f6
	store   $f6, 15($sp)
	fmul    $f7, $f4, $f6
	fmul    $f6, $f2, $f6
	fmul    $f5, $f1, $f8
	fadd    $f6, $f8, $f6
	store   $f6, 16($sp)
	fmul    $f3, $f1, $f3
	store   $f3, 17($sp)
	fmul    $f5, $f4, $f3
	fmul    $f3, $f1, $f3
	fmul    $f7, $f2, $f6
	fadd    $f3, $f6, $f3
	store   $f3, 18($sp)
	fmul    $f7, $f4, $f3
	fmul    $f3, $f1, $f1
	fmul    $f5, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 19($sp)
	mov     $f4, $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fneg
	sub     $sp, 21, $sp
	load    20($sp), $ra
	store   $f1, 20($sp)
	load    11($sp), $f1
	load    10($sp), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 21($sp)
	load    9($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 22($sp)
	load    0($sp), $i1
	load    0($i1), $f1
	store   $f1, 23($sp)
	load    1($i1), $f1
	store   $f1, 24($sp)
	load    2($i1), $f1
	store   $f1, 25($sp)
	load    14($sp), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fsqr
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    23($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 26($sp)
	load    17($sp), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fsqr
	sub     $sp, 28, $sp
	load    27($sp), $ra
	load    24($sp), $f2
	fmul    $f2, $f1, $f1
	load    26($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 27($sp)
	load    20($sp), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fsqr
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    25($sp), $f2
	fmul    $f2, $f1, $f1
	load    27($sp), $f2
	fadd    $f2, $f1, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	load    15($sp), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fsqr
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    23($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 28($sp)
	load    18($sp), $f1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_fsqr
	sub     $sp, 30, $sp
	load    29($sp), $ra
	load    24($sp), $f2
	fmul    $f2, $f1, $f1
	load    28($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 29($sp)
	load    21($sp), $f1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_fsqr
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    25($sp), $f2
	fmul    $f2, $f1, $f1
	load    29($sp), $f2
	fadd    $f2, $f1, $f1
	load    0($sp), $i1
	store   $f1, 1($i1)
	load    16($sp), $f1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_fsqr
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    23($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 30($sp)
	load    19($sp), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fsqr
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    24($sp), $f2
	fmul    $f2, $f1, $f1
	load    30($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 31($sp)
	load    22($sp), $f1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_fsqr
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    25($sp), $f2
	fmul    $f2, $f1, $f1
	load    31($sp), $f3
	fadd    $f3, $f1, $f1
	load    0($sp), $i1
	store   $f1, 2($i1)
	li      l.25831, $i1
	load    0($i1), $f1
	load    15($sp), $f3
	load    23($sp), $f4
	fmul    $f4, $f3, $f5
	load    16($sp), $f6
	fmul    $f5, $f6, $f5
	load    18($sp), $f7
	load    24($sp), $f8
	fmul    $f8, $f7, $f9
	load    19($sp), $f10
	fmul    $f9, $f10, $f9
	fadd    $f5, $f9, $f5
	load    21($sp), $f9
	fmul    $f2, $f9, $f11
	load    22($sp), $f12
	fmul    $f11, $f12, $f11
	fadd    $f5, $f11, $f5
	fmul    $f1, $f5, $f1
	load    1($sp), $i1
	store   $f1, 0($i1)
	li      l.25831, $i2
	load    0($i2), $f1
	load    14($sp), $f5
	fmul    $f4, $f5, $f11
	fmul    $f11, $f6, $f6
	load    17($sp), $f11
	fmul    $f8, $f11, $f13
	fmul    $f13, $f10, $f10
	fadd    $f6, $f10, $f6
	load    20($sp), $f10
	fmul    $f2, $f10, $f13
	fmul    $f13, $f12, $f12
	fadd    $f6, $f12, $f6
	fmul    $f1, $f6, $f1
	store   $f1, 1($i1)
	li      l.25831, $i2
	load    0($i2), $f1
	fmul    $f4, $f5, $f4
	fmul    $f4, $f3, $f3
	fmul    $f8, $f11, $f4
	fmul    $f4, $f7, $f4
	fadd    $f3, $f4, $f3
	fmul    $f2, $f10, $f2
	fmul    $f2, $f9, $f2
	fadd    $f3, $f2, $f2
	fmul    $f1, $f2, $f1
	store   $f1, 2($i1)
	ret
skip.6367.11751:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59236
	ret
be_else.59236:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59237
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59238
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59239
	ret
be_else.59239:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59240
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59241
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59242
	ret
be_else.59242:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59243
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59244
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59245
	ret
be_else.59245:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59246
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59247
	b       skip.6367.11751
bge_else.59247:
	ret
bge_else.59246:
	b       skip.6367.11751
bge_else.59244:
	ret
bge_else.59243:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59248
	ret
be_else.59248:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59249
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59250
	b       skip.6367.11751
bge_else.59250:
	ret
bge_else.59249:
	b       skip.6367.11751
bge_else.59241:
	ret
bge_else.59240:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59251
	ret
be_else.59251:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59252
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59253
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59254
	ret
be_else.59254:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59255
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59256
	b       skip.6367.11751
bge_else.59256:
	ret
bge_else.59255:
	b       skip.6367.11751
bge_else.59253:
	ret
bge_else.59252:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59257
	ret
be_else.59257:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59258
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59259
	b       skip.6367.11751
bge_else.59259:
	ret
bge_else.59258:
	b       skip.6367.11751
bge_else.59238:
	ret
bge_else.59237:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59260
	ret
be_else.59260:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59261
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59262
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59263
	ret
be_else.59263:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59264
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59265
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59266
	ret
be_else.59266:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59267
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59268
	b       skip.6367.11751
bge_else.59268:
	ret
bge_else.59267:
	b       skip.6367.11751
bge_else.59265:
	ret
bge_else.59264:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59269
	ret
be_else.59269:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59270
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59271
	b       skip.6367.11751
bge_else.59271:
	ret
bge_else.59270:
	b       skip.6367.11751
bge_else.59262:
	ret
bge_else.59261:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59272
	ret
be_else.59272:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59273
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59274
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59275
	ret
be_else.59275:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59276
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59277
	b       skip.6367.11751
bge_else.59277:
	ret
bge_else.59276:
	b       skip.6367.11751
bge_else.59274:
	ret
bge_else.59273:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59278
	ret
be_else.59278:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59279
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59280
	b       skip.6367.11751
bge_else.59280:
	ret
bge_else.59279:
	b       skip.6367.11751
read_rec.6369.11753:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59281
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59282
	load    0($sp), $i1
	ret
bge_else.59282:
	load    0($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59283
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59284
	load    1($sp), $i1
	ret
bge_else.59284:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59285
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59286
	load    2($sp), $i1
	ret
bge_else.59286:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59287
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59288
	load    3($sp), $i1
	ret
bge_else.59288:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	b       read_rec.6369.11753
bge_else.59287:
	load    3($sp), $i1
	ret
bge_else.59285:
	load    2($sp), $i1
	ret
bge_else.59283:
	load    1($sp), $i1
	ret
bge_else.59281:
	load    0($sp), $i1
	ret
skip.6367.11719:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59289
	ret
be_else.59289:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59290
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59291
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59292
	ret
be_else.59292:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59293
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59294
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59295
	ret
be_else.59295:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59296
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59297
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59298
	ret
be_else.59298:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59299
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59300
	b       skip.6367.11719
bge_else.59300:
	ret
bge_else.59299:
	b       skip.6367.11719
bge_else.59297:
	ret
bge_else.59296:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59301
	ret
be_else.59301:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59302
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59303
	b       skip.6367.11719
bge_else.59303:
	ret
bge_else.59302:
	b       skip.6367.11719
bge_else.59294:
	ret
bge_else.59293:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59304
	ret
be_else.59304:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59305
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59306
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59307
	ret
be_else.59307:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59308
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59309
	b       skip.6367.11719
bge_else.59309:
	ret
bge_else.59308:
	b       skip.6367.11719
bge_else.59306:
	ret
bge_else.59305:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59310
	ret
be_else.59310:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59311
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59312
	b       skip.6367.11719
bge_else.59312:
	ret
bge_else.59311:
	b       skip.6367.11719
bge_else.59291:
	ret
bge_else.59290:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59313
	ret
be_else.59313:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59314
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59315
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59316
	ret
be_else.59316:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59317
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59318
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59319
	ret
be_else.59319:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59320
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59321
	b       skip.6367.11719
bge_else.59321:
	ret
bge_else.59320:
	b       skip.6367.11719
bge_else.59318:
	ret
bge_else.59317:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59322
	ret
be_else.59322:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59323
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59324
	b       skip.6367.11719
bge_else.59324:
	ret
bge_else.59323:
	b       skip.6367.11719
bge_else.59315:
	ret
bge_else.59314:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59325
	ret
be_else.59325:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59326
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59327
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59328
	ret
be_else.59328:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59329
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59330
	b       skip.6367.11719
bge_else.59330:
	ret
bge_else.59329:
	b       skip.6367.11719
bge_else.59327:
	ret
bge_else.59326:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59331
	ret
be_else.59331:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59332
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59333
	b       skip.6367.11719
bge_else.59333:
	ret
bge_else.59332:
	b       skip.6367.11719
read_rec.6369.11721:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59334
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59335
	load    0($sp), $i1
	ret
bge_else.59335:
	load    0($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59336
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59337
	load    1($sp), $i1
	ret
bge_else.59337:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59338
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59339
	load    2($sp), $i1
	ret
bge_else.59339:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59340
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59341
	load    3($sp), $i1
	ret
bge_else.59341:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	b       read_rec.6369.11721
bge_else.59340:
	load    3($sp), $i1
	ret
bge_else.59338:
	load    2($sp), $i1
	ret
bge_else.59336:
	load    1($sp), $i1
	ret
bge_else.59334:
	load    0($sp), $i1
	ret
skip.6367.11687:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59342
	ret
be_else.59342:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59343
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59344
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59345
	ret
be_else.59345:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59346
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59347
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59348
	ret
be_else.59348:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59349
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59350
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59351
	ret
be_else.59351:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59352
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59353
	b       skip.6367.11687
bge_else.59353:
	ret
bge_else.59352:
	b       skip.6367.11687
bge_else.59350:
	ret
bge_else.59349:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59354
	ret
be_else.59354:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59355
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59356
	b       skip.6367.11687
bge_else.59356:
	ret
bge_else.59355:
	b       skip.6367.11687
bge_else.59347:
	ret
bge_else.59346:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59357
	ret
be_else.59357:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59358
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59359
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59360
	ret
be_else.59360:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59361
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59362
	b       skip.6367.11687
bge_else.59362:
	ret
bge_else.59361:
	b       skip.6367.11687
bge_else.59359:
	ret
bge_else.59358:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59363
	ret
be_else.59363:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59364
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59365
	b       skip.6367.11687
bge_else.59365:
	ret
bge_else.59364:
	b       skip.6367.11687
bge_else.59344:
	ret
bge_else.59343:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59366
	ret
be_else.59366:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59367
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59368
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59369
	ret
be_else.59369:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59370
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59371
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59372
	ret
be_else.59372:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59373
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59374
	b       skip.6367.11687
bge_else.59374:
	ret
bge_else.59373:
	b       skip.6367.11687
bge_else.59371:
	ret
bge_else.59370:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59375
	ret
be_else.59375:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59376
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59377
	b       skip.6367.11687
bge_else.59377:
	ret
bge_else.59376:
	b       skip.6367.11687
bge_else.59368:
	ret
bge_else.59367:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59378
	ret
be_else.59378:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59379
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59380
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59381
	ret
be_else.59381:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59382
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59383
	b       skip.6367.11687
bge_else.59383:
	ret
bge_else.59382:
	b       skip.6367.11687
bge_else.59380:
	ret
bge_else.59379:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59384
	ret
be_else.59384:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59385
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59386
	b       skip.6367.11687
bge_else.59386:
	ret
bge_else.59385:
	b       skip.6367.11687
read_rec.6369.11689:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59387
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59388
	load    0($sp), $i1
	ret
bge_else.59388:
	load    0($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59389
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59390
	load    1($sp), $i1
	ret
bge_else.59390:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59391
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59392
	load    2($sp), $i1
	ret
bge_else.59392:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59393
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59394
	load    3($sp), $i1
	ret
bge_else.59394:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	b       read_rec.6369.11689
bge_else.59393:
	load    3($sp), $i1
	ret
bge_else.59391:
	load    2($sp), $i1
	ret
bge_else.59389:
	load    1($sp), $i1
	ret
bge_else.59387:
	load    0($sp), $i1
	ret
skip.6367.11655:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59395
	ret
be_else.59395:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59396
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59397
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59398
	ret
be_else.59398:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59399
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59400
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59401
	ret
be_else.59401:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59402
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59403
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59404
	ret
be_else.59404:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59405
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59406
	b       skip.6367.11655
bge_else.59406:
	ret
bge_else.59405:
	b       skip.6367.11655
bge_else.59403:
	ret
bge_else.59402:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59407
	ret
be_else.59407:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59408
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59409
	b       skip.6367.11655
bge_else.59409:
	ret
bge_else.59408:
	b       skip.6367.11655
bge_else.59400:
	ret
bge_else.59399:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59410
	ret
be_else.59410:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59411
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59412
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59413
	ret
be_else.59413:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59414
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59415
	b       skip.6367.11655
bge_else.59415:
	ret
bge_else.59414:
	b       skip.6367.11655
bge_else.59412:
	ret
bge_else.59411:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59416
	ret
be_else.59416:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59417
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59418
	b       skip.6367.11655
bge_else.59418:
	ret
bge_else.59417:
	b       skip.6367.11655
bge_else.59397:
	ret
bge_else.59396:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59419
	ret
be_else.59419:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59420
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59421
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59422
	ret
be_else.59422:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59423
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59424
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59425
	ret
be_else.59425:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59426
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59427
	b       skip.6367.11655
bge_else.59427:
	ret
bge_else.59426:
	b       skip.6367.11655
bge_else.59424:
	ret
bge_else.59423:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59428
	ret
be_else.59428:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59429
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59430
	b       skip.6367.11655
bge_else.59430:
	ret
bge_else.59429:
	b       skip.6367.11655
bge_else.59421:
	ret
bge_else.59420:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59431
	ret
be_else.59431:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59432
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59433
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59434
	ret
be_else.59434:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59435
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59436
	b       skip.6367.11655
bge_else.59436:
	ret
bge_else.59435:
	b       skip.6367.11655
bge_else.59433:
	ret
bge_else.59432:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59437
	ret
be_else.59437:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59438
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59439
	b       skip.6367.11655
bge_else.59439:
	ret
bge_else.59438:
	b       skip.6367.11655
read_rec.6369.11657:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59440
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59441
	load    0($sp), $i1
	ret
bge_else.59441:
	load    0($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59442
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59443
	load    1($sp), $i1
	ret
bge_else.59443:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59444
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59445
	load    2($sp), $i1
	ret
bge_else.59445:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59446
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59447
	load    3($sp), $i1
	ret
bge_else.59447:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	b       read_rec.6369.11657
bge_else.59446:
	load    3($sp), $i1
	ret
bge_else.59444:
	load    2($sp), $i1
	ret
bge_else.59442:
	load    1($sp), $i1
	ret
bge_else.59440:
	load    0($sp), $i1
	ret
read_nth_object.2902:
	store   $i1, 0($sp)
	load    2($i11), $i1
	store   $i1, 1($sp)
	load    1($i11), $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59448
	b       be_cont.59449
be_else.59448:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59450
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59452
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59454
	b       be_cont.59455
be_else.59454:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59456
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59458
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59460
	b       be_cont.59461
be_else.59460:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59462
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59464
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       bge_cont.59465
bge_else.59464:
bge_cont.59465:
	b       bge_cont.59463
bge_else.59462:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
bge_cont.59463:
be_cont.59461:
	b       bge_cont.59459
bge_else.59458:
bge_cont.59459:
	b       bge_cont.59457
bge_else.59456:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59466
	b       be_cont.59467
be_else.59466:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59468
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59470
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       bge_cont.59471
bge_else.59470:
bge_cont.59471:
	b       bge_cont.59469
bge_else.59468:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
bge_cont.59469:
be_cont.59467:
bge_cont.59457:
be_cont.59455:
	b       bge_cont.59453
bge_else.59452:
bge_cont.59453:
	b       bge_cont.59451
bge_else.59450:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59472
	b       be_cont.59473
be_else.59472:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59474
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59476
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59478
	b       be_cont.59479
be_else.59478:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59480
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59482
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       bge_cont.59483
bge_else.59482:
bge_cont.59483:
	b       bge_cont.59481
bge_else.59480:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
bge_cont.59481:
be_cont.59479:
	b       bge_cont.59477
bge_else.59476:
bge_cont.59477:
	b       bge_cont.59475
bge_else.59474:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59484
	b       be_cont.59485
be_else.59484:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59486
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59488
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       bge_cont.59489
bge_else.59488:
bge_cont.59489:
	b       bge_cont.59487
bge_else.59486:
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     skip.6367.11751
	sub     $sp, 4, $sp
	load    3($sp), $ra
bge_cont.59487:
be_cont.59485:
bge_cont.59475:
be_cont.59473:
bge_cont.59451:
be_cont.59449:
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59490
	li      0, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59492
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59494
	li      0, $i1
	b       bge_cont.59495
bge_else.59494:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_read
	sub     $sp, 6, $sp
	load    5($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59496
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59498
	load    4($sp), $i1
	b       bge_cont.59499
bge_else.59498:
	load    4($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_read
	sub     $sp, 7, $sp
	load    6($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59500
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59502
	load    5($sp), $i1
	b       bge_cont.59503
bge_else.59502:
	load    5($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     read_rec.6369.11753
	sub     $sp, 7, $sp
	load    6($sp), $ra
bge_cont.59503:
	b       bge_cont.59501
bge_else.59500:
	load    5($sp), $i1
bge_cont.59501:
bge_cont.59499:
	b       bge_cont.59497
bge_else.59496:
	load    4($sp), $i1
bge_cont.59497:
bge_cont.59495:
	b       bge_cont.59493
bge_else.59492:
	li      0, $i1
bge_cont.59493:
	neg     $i1, $i1
	b       be_cont.59491
be_else.59490:
	sub     $i1, 48, $i1
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_read
	sub     $sp, 8, $sp
	load    7($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59504
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59506
	load    6($sp), $i1
	b       bge_cont.59507
bge_else.59506:
	load    6($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_read
	sub     $sp, 9, $sp
	load    8($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59508
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59510
	load    7($sp), $i1
	b       bge_cont.59511
bge_else.59510:
	load    7($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_read
	sub     $sp, 10, $sp
	load    9($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59512
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59514
	load    8($sp), $i1
	b       bge_cont.59515
bge_else.59514:
	load    8($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_rec.6369.11753
	sub     $sp, 10, $sp
	load    9($sp), $ra
bge_cont.59515:
	b       bge_cont.59513
bge_else.59512:
	load    8($sp), $i1
bge_cont.59513:
bge_cont.59511:
	b       bge_cont.59509
bge_else.59508:
	load    7($sp), $i1
bge_cont.59509:
bge_cont.59507:
	b       bge_cont.59505
bge_else.59504:
	load    6($sp), $i1
bge_cont.59505:
be_cont.59491:
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59516
	li      0, $i1
	ret
be_else.59516:
	store   $i1, 9($sp)
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59517
	b       be_cont.59518
be_else.59517:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59519
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59521
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59523
	b       be_cont.59524
be_else.59523:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59525
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59527
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59529
	b       be_cont.59530
be_else.59529:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59531
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59533
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       bge_cont.59534
bge_else.59533:
bge_cont.59534:
	b       bge_cont.59532
bge_else.59531:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
bge_cont.59532:
be_cont.59530:
	b       bge_cont.59528
bge_else.59527:
bge_cont.59528:
	b       bge_cont.59526
bge_else.59525:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59535
	b       be_cont.59536
be_else.59535:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59537
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59539
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       bge_cont.59540
bge_else.59539:
bge_cont.59540:
	b       bge_cont.59538
bge_else.59537:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
bge_cont.59538:
be_cont.59536:
bge_cont.59526:
be_cont.59524:
	b       bge_cont.59522
bge_else.59521:
bge_cont.59522:
	b       bge_cont.59520
bge_else.59519:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59541
	b       be_cont.59542
be_else.59541:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59543
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59545
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59547
	b       be_cont.59548
be_else.59547:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59549
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59551
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       bge_cont.59552
bge_else.59551:
bge_cont.59552:
	b       bge_cont.59550
bge_else.59549:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
bge_cont.59550:
be_cont.59548:
	b       bge_cont.59546
bge_else.59545:
bge_cont.59546:
	b       bge_cont.59544
bge_else.59543:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_read
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59553
	b       be_cont.59554
be_else.59553:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59555
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59557
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       bge_cont.59558
bge_else.59557:
bge_cont.59558:
	b       bge_cont.59556
bge_else.59555:
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     skip.6367.11719
	sub     $sp, 11, $sp
	load    10($sp), $ra
bge_cont.59556:
be_cont.59554:
bge_cont.59544:
be_cont.59542:
bge_cont.59520:
be_cont.59518:
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59559
	li      0, $i1
	store   $i1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_read
	sub     $sp, 12, $sp
	load    11($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59561
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59563
	li      0, $i1
	b       bge_cont.59564
bge_else.59563:
	load    10($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_read
	sub     $sp, 13, $sp
	load    12($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59565
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59567
	load    11($sp), $i1
	b       bge_cont.59568
bge_else.59567:
	load    11($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 12($sp)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_read
	sub     $sp, 14, $sp
	load    13($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59569
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59571
	load    12($sp), $i1
	b       bge_cont.59572
bge_else.59571:
	load    12($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     read_rec.6369.11721
	sub     $sp, 14, $sp
	load    13($sp), $ra
bge_cont.59572:
	b       bge_cont.59570
bge_else.59569:
	load    12($sp), $i1
bge_cont.59570:
bge_cont.59568:
	b       bge_cont.59566
bge_else.59565:
	load    11($sp), $i1
bge_cont.59566:
bge_cont.59564:
	b       bge_cont.59562
bge_else.59561:
	li      0, $i1
bge_cont.59562:
	neg     $i1, $i1
	b       be_cont.59560
be_else.59559:
	sub     $i1, 48, $i1
	store   $i1, 13($sp)
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_read
	sub     $sp, 15, $sp
	load    14($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59573
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59575
	load    13($sp), $i1
	b       bge_cont.59576
bge_else.59575:
	load    13($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_read
	sub     $sp, 16, $sp
	load    15($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59577
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59579
	load    14($sp), $i1
	b       bge_cont.59580
bge_else.59579:
	load    14($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 15($sp)
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_read
	sub     $sp, 17, $sp
	load    16($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59581
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59583
	load    15($sp), $i1
	b       bge_cont.59584
bge_else.59583:
	load    15($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     read_rec.6369.11721
	sub     $sp, 17, $sp
	load    16($sp), $ra
bge_cont.59584:
	b       bge_cont.59582
bge_else.59581:
	load    15($sp), $i1
bge_cont.59582:
bge_cont.59580:
	b       bge_cont.59578
bge_else.59577:
	load    14($sp), $i1
bge_cont.59578:
bge_cont.59576:
	b       bge_cont.59574
bge_else.59573:
	load    13($sp), $i1
bge_cont.59574:
be_cont.59560:
	store   $i1, 16($sp)
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_read
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59585
	b       be_cont.59586
be_else.59585:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59587
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59589
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_read
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59591
	b       be_cont.59592
be_else.59591:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59593
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59595
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_read
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59597
	b       be_cont.59598
be_else.59597:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59599
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59601
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       bge_cont.59602
bge_else.59601:
bge_cont.59602:
	b       bge_cont.59600
bge_else.59599:
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
bge_cont.59600:
be_cont.59598:
	b       bge_cont.59596
bge_else.59595:
bge_cont.59596:
	b       bge_cont.59594
bge_else.59593:
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_read
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59603
	b       be_cont.59604
be_else.59603:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59605
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59607
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       bge_cont.59608
bge_else.59607:
bge_cont.59608:
	b       bge_cont.59606
bge_else.59605:
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
bge_cont.59606:
be_cont.59604:
bge_cont.59594:
be_cont.59592:
	b       bge_cont.59590
bge_else.59589:
bge_cont.59590:
	b       bge_cont.59588
bge_else.59587:
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_read
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59609
	b       be_cont.59610
be_else.59609:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59611
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59613
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_read
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59615
	b       be_cont.59616
be_else.59615:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59617
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59619
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       bge_cont.59620
bge_else.59619:
bge_cont.59620:
	b       bge_cont.59618
bge_else.59617:
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
bge_cont.59618:
be_cont.59616:
	b       bge_cont.59614
bge_else.59613:
bge_cont.59614:
	b       bge_cont.59612
bge_else.59611:
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_read
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59621
	b       be_cont.59622
be_else.59621:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59623
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59625
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       bge_cont.59626
bge_else.59625:
bge_cont.59626:
	b       bge_cont.59624
bge_else.59623:
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     skip.6367.11687
	sub     $sp, 18, $sp
	load    17($sp), $ra
bge_cont.59624:
be_cont.59622:
bge_cont.59612:
be_cont.59610:
bge_cont.59588:
be_cont.59586:
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59627
	li      0, $i1
	store   $i1, 17($sp)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_read
	sub     $sp, 19, $sp
	load    18($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59629
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59631
	li      0, $i1
	b       bge_cont.59632
bge_else.59631:
	load    17($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 18($sp)
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_read
	sub     $sp, 20, $sp
	load    19($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59633
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59635
	load    18($sp), $i1
	b       bge_cont.59636
bge_else.59635:
	load    18($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_read
	sub     $sp, 21, $sp
	load    20($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59637
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59639
	load    19($sp), $i1
	b       bge_cont.59640
bge_else.59639:
	load    19($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     read_rec.6369.11689
	sub     $sp, 21, $sp
	load    20($sp), $ra
bge_cont.59640:
	b       bge_cont.59638
bge_else.59637:
	load    19($sp), $i1
bge_cont.59638:
bge_cont.59636:
	b       bge_cont.59634
bge_else.59633:
	load    18($sp), $i1
bge_cont.59634:
bge_cont.59632:
	b       bge_cont.59630
bge_else.59629:
	li      0, $i1
bge_cont.59630:
	neg     $i1, $i1
	b       be_cont.59628
be_else.59627:
	sub     $i1, 48, $i1
	store   $i1, 20($sp)
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_read
	sub     $sp, 22, $sp
	load    21($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59641
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59643
	load    20($sp), $i1
	b       bge_cont.59644
bge_else.59643:
	load    20($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 21($sp)
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_read
	sub     $sp, 23, $sp
	load    22($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59645
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59647
	load    21($sp), $i1
	b       bge_cont.59648
bge_else.59647:
	load    21($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 22($sp)
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_read
	sub     $sp, 24, $sp
	load    23($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59649
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59651
	load    22($sp), $i1
	b       bge_cont.59652
bge_else.59651:
	load    22($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     read_rec.6369.11689
	sub     $sp, 24, $sp
	load    23($sp), $ra
bge_cont.59652:
	b       bge_cont.59650
bge_else.59649:
	load    22($sp), $i1
bge_cont.59650:
bge_cont.59648:
	b       bge_cont.59646
bge_else.59645:
	load    21($sp), $i1
bge_cont.59646:
bge_cont.59644:
	b       bge_cont.59642
bge_else.59641:
	load    20($sp), $i1
bge_cont.59642:
be_cont.59628:
	store   $i1, 23($sp)
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_read
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59653
	b       be_cont.59654
be_else.59653:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59655
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59657
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_read
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59659
	b       be_cont.59660
be_else.59659:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59661
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59663
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_read
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59665
	b       be_cont.59666
be_else.59665:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59667
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59669
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       bge_cont.59670
bge_else.59669:
bge_cont.59670:
	b       bge_cont.59668
bge_else.59667:
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
bge_cont.59668:
be_cont.59666:
	b       bge_cont.59664
bge_else.59663:
bge_cont.59664:
	b       bge_cont.59662
bge_else.59661:
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_read
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59671
	b       be_cont.59672
be_else.59671:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59673
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59675
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       bge_cont.59676
bge_else.59675:
bge_cont.59676:
	b       bge_cont.59674
bge_else.59673:
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
bge_cont.59674:
be_cont.59672:
bge_cont.59662:
be_cont.59660:
	b       bge_cont.59658
bge_else.59657:
bge_cont.59658:
	b       bge_cont.59656
bge_else.59655:
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_read
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59677
	b       be_cont.59678
be_else.59677:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59679
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59681
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_read
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59683
	b       be_cont.59684
be_else.59683:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59685
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59687
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       bge_cont.59688
bge_else.59687:
bge_cont.59688:
	b       bge_cont.59686
bge_else.59685:
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
bge_cont.59686:
be_cont.59684:
	b       bge_cont.59682
bge_else.59681:
bge_cont.59682:
	b       bge_cont.59680
bge_else.59679:
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_read
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59689
	b       be_cont.59690
be_else.59689:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59691
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59693
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       bge_cont.59694
bge_else.59693:
bge_cont.59694:
	b       bge_cont.59692
bge_else.59691:
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     skip.6367.11655
	sub     $sp, 25, $sp
	load    24($sp), $ra
bge_cont.59692:
be_cont.59690:
bge_cont.59680:
be_cont.59678:
bge_cont.59656:
be_cont.59654:
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59695
	li      0, $i1
	store   $i1, 24($sp)
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_read
	sub     $sp, 26, $sp
	load    25($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59697
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59699
	li      0, $i1
	b       bge_cont.59700
bge_else.59699:
	load    24($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 25($sp)
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_read
	sub     $sp, 27, $sp
	load    26($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59701
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59703
	load    25($sp), $i1
	b       bge_cont.59704
bge_else.59703:
	load    25($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 26($sp)
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_read
	sub     $sp, 28, $sp
	load    27($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59705
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59707
	load    26($sp), $i1
	b       bge_cont.59708
bge_else.59707:
	load    26($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     read_rec.6369.11657
	sub     $sp, 28, $sp
	load    27($sp), $ra
bge_cont.59708:
	b       bge_cont.59706
bge_else.59705:
	load    26($sp), $i1
bge_cont.59706:
bge_cont.59704:
	b       bge_cont.59702
bge_else.59701:
	load    25($sp), $i1
bge_cont.59702:
bge_cont.59700:
	b       bge_cont.59698
bge_else.59697:
	li      0, $i1
bge_cont.59698:
	neg     $i1, $i1
	b       be_cont.59696
be_else.59695:
	sub     $i1, 48, $i1
	store   $i1, 27($sp)
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_read
	sub     $sp, 29, $sp
	load    28($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59709
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59711
	load    27($sp), $i1
	b       bge_cont.59712
bge_else.59711:
	load    27($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 28($sp)
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_read
	sub     $sp, 30, $sp
	load    29($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59713
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59715
	load    28($sp), $i1
	b       bge_cont.59716
bge_else.59715:
	load    28($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 29($sp)
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_read
	sub     $sp, 31, $sp
	load    30($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59717
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59719
	load    29($sp), $i1
	b       bge_cont.59720
bge_else.59719:
	load    29($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     read_rec.6369.11657
	sub     $sp, 31, $sp
	load    30($sp), $ra
bge_cont.59720:
	b       bge_cont.59718
bge_else.59717:
	load    29($sp), $i1
bge_cont.59718:
bge_cont.59716:
	b       bge_cont.59714
bge_else.59713:
	load    28($sp), $i1
bge_cont.59714:
bge_cont.59712:
	b       bge_cont.59710
bge_else.59709:
	load    27($sp), $i1
bge_cont.59710:
be_cont.59696:
	store   $i1, 30($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_create_float_array
	sub     $sp, 32, $sp
	load    31($sp), $ra
	store   $i1, 31($sp)
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     read_float.2733
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    31($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     read_float.2733
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    31($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     read_float.2733
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    31($sp), $i1
	store   $f1, 2($i1)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_float_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	store   $i1, 32($sp)
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     read_float.2733
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    32($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     read_float.2733
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    32($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     read_float.2733
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    32($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     read_float.2733
	sub     $sp, 34, $sp
	load    33($sp), $ra
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fisneg
	sub     $sp, 34, $sp
	load    33($sp), $ra
	store   $i1, 33($sp)
	li      2, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_create_float_array
	sub     $sp, 35, $sp
	load    34($sp), $ra
	store   $i1, 34($sp)
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     read_float.2733
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    34($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     read_float.2733
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    34($sp), $i1
	store   $f1, 1($i1)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_create_float_array
	sub     $sp, 36, $sp
	load    35($sp), $ra
	store   $i1, 35($sp)
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     read_float.2733
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     read_float.2733
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     read_float.2733
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	store   $f1, 2($i1)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_create_float_array
	sub     $sp, 37, $sp
	load    36($sp), $ra
	store   $i1, 36($sp)
	load    30($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59721
	b       be_cont.59722
be_else.59721:
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     read_float.2733
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      l.25968, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    36($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     read_float.2733
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      l.25968, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    36($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     read_float.2733
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      l.25968, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    36($sp), $i1
	store   $f1, 2($i1)
be_cont.59722:
	load    16($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59723
	li      1, $i1
	b       be_cont.59724
be_else.59723:
	load    33($sp), $i1
be_cont.59724:
	store   $i1, 37($sp)
	li      4, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_float_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	mov     $hp, $i2
	add     $hp, 11, $hp
	store   $i1, 10($i2)
	load    36($sp), $i1
	store   $i1, 9($i2)
	load    35($sp), $i1
	store   $i1, 8($i2)
	load    34($sp), $i1
	store   $i1, 7($i2)
	load    37($sp), $i1
	store   $i1, 6($i2)
	load    32($sp), $i1
	store   $i1, 5($i2)
	load    31($sp), $i1
	store   $i1, 4($i2)
	load    30($sp), $i3
	store   $i3, 3($i2)
	load    23($sp), $i3
	store   $i3, 2($i2)
	load    16($sp), $i3
	store   $i3, 1($i2)
	load    9($sp), $i4
	store   $i4, 0($i2)
	load    0($sp), $i4
	load    2($sp), $i5
	add     $i5, $i4, $i12
	store   $i2, 0($i12)
	li      3, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.59725
	load    0($i1), $f1
	store   $f1, 38($sp)
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fiszero
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59727
	load    38($sp), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fiszero
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59729
	load    38($sp), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fispos
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59731
	li      l.26012, $i1
	load    0($i1), $f1
	b       be_cont.59732
be_else.59731:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.59732:
	b       be_cont.59730
be_else.59729:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.59730:
	store   $f1, 39($sp)
	load    38($sp), $f1
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_fsqr
	sub     $sp, 41, $sp
	load    40($sp), $ra
	load    39($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.59728
be_else.59727:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.59728:
	load    31($sp), $i1
	store   $f1, 0($i1)
	load    1($i1), $f1
	store   $f1, 40($sp)
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_fiszero
	sub     $sp, 42, $sp
	load    41($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59733
	load    40($sp), $f1
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_fiszero
	sub     $sp, 42, $sp
	load    41($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59735
	load    40($sp), $f1
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_fispos
	sub     $sp, 42, $sp
	load    41($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59737
	li      l.26012, $i1
	load    0($i1), $f1
	b       be_cont.59738
be_else.59737:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.59738:
	b       be_cont.59736
be_else.59735:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.59736:
	store   $f1, 41($sp)
	load    40($sp), $f1
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     min_caml_fsqr
	sub     $sp, 43, $sp
	load    42($sp), $ra
	load    41($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.59734
be_else.59733:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.59734:
	load    31($sp), $i1
	store   $f1, 1($i1)
	load    2($i1), $f1
	store   $f1, 42($sp)
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fiszero
	sub     $sp, 44, $sp
	load    43($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59739
	load    42($sp), $f1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fiszero
	sub     $sp, 44, $sp
	load    43($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59741
	load    42($sp), $f1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fispos
	sub     $sp, 44, $sp
	load    43($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59743
	li      l.26012, $i1
	load    0($i1), $f1
	b       be_cont.59744
be_else.59743:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.59744:
	b       be_cont.59742
be_else.59741:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.59742:
	store   $f1, 43($sp)
	load    42($sp), $f1
	store   $ra, 44($sp)
	add     $sp, 45, $sp
	jal     min_caml_fsqr
	sub     $sp, 45, $sp
	load    44($sp), $ra
	load    43($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.59740
be_else.59739:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.59740:
	load    31($sp), $i1
	store   $f1, 2($i1)
	b       be_cont.59726
be_else.59725:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.59745
	load    33($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59747
	li      1, $i2
	b       be_cont.59748
be_else.59747:
	li      0, $i2
be_cont.59748:
	store   $i2, 44($sp)
	load    0($i1), $f1
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fsqr
	sub     $sp, 46, $sp
	load    45($sp), $ra
	store   $f1, 45($sp)
	load    31($sp), $i1
	load    1($i1), $f1
	store   $ra, 46($sp)
	add     $sp, 47, $sp
	jal     min_caml_fsqr
	sub     $sp, 47, $sp
	load    46($sp), $ra
	load    45($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 46($sp)
	load    31($sp), $i1
	load    2($i1), $f1
	store   $ra, 47($sp)
	add     $sp, 48, $sp
	jal     min_caml_fsqr
	sub     $sp, 48, $sp
	load    47($sp), $ra
	load    46($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 47($sp)
	add     $sp, 48, $sp
	jal     sqrt.2729
	sub     $sp, 48, $sp
	load    47($sp), $ra
	store   $f1, 47($sp)
	store   $ra, 48($sp)
	add     $sp, 49, $sp
	jal     min_caml_fiszero
	sub     $sp, 49, $sp
	load    48($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59749
	load    44($sp), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59751
	li      l.25743, $i1
	load    0($i1), $f1
	load    47($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.59752
be_else.59751:
	li      l.26012, $i1
	load    0($i1), $f1
	load    47($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
be_cont.59752:
	b       be_cont.59750
be_else.59749:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.59750:
	load    31($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 2($i1)
	b       be_cont.59746
be_else.59745:
be_cont.59746:
be_cont.59726:
	load    30($sp), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59753
	b       be_cont.59754
be_else.59753:
	load    31($sp), $i1
	load    36($sp), $i2
	load    1($sp), $i11
	store   $ra, 48($sp)
	load    0($i11), $i10
	li      cls.59755, $ra
	add     $sp, 49, $sp
	jr      $i10
cls.59755:
	sub     $sp, 49, $sp
	load    48($sp), $ra
be_cont.59754:
	li      1, $i1
	ret
read_object.2904:
	load    2($i11), $i2
	load    1($i11), $i3
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59756
	ret
bge_else.59756:
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	store   $i3, 2($sp)
	store   $i1, 3($sp)
	mov     $i2, $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.59758, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.59758:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59759
	load    2($sp), $i1
	load    3($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59759:
	load    3($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59761
	ret
bge_else.59761:
	store   $i1, 4($sp)
	load    1($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.59763, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.59763:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59764
	load    2($sp), $i1
	load    4($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59764:
	load    4($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59766
	ret
bge_else.59766:
	store   $i1, 5($sp)
	load    1($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.59768, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.59768:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59769
	load    2($sp), $i1
	load    5($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59769:
	load    5($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59771
	ret
bge_else.59771:
	store   $i1, 6($sp)
	load    1($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.59773, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.59773:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59774
	load    2($sp), $i1
	load    6($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59774:
	load    6($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59776
	ret
bge_else.59776:
	store   $i1, 7($sp)
	load    1($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.59778, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.59778:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59779
	load    2($sp), $i1
	load    7($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59779:
	load    7($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59781
	ret
bge_else.59781:
	store   $i1, 8($sp)
	load    1($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.59783, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.59783:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59784
	load    2($sp), $i1
	load    8($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59784:
	load    8($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59786
	ret
bge_else.59786:
	store   $i1, 9($sp)
	load    1($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.59788, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.59788:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59789
	load    2($sp), $i1
	load    9($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59789:
	load    9($sp), $i1
	add     $i1, 1, $i1
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59791
	ret
bge_else.59791:
	store   $i1, 10($sp)
	load    1($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.59793, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.59793:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59794
	load    2($sp), $i1
	load    10($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.59794:
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
skip.6367.11564:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59796
	ret
be_else.59796:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59797
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59798
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59799
	ret
be_else.59799:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59800
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59801
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59802
	ret
be_else.59802:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59803
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59804
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59805
	ret
be_else.59805:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59806
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59807
	b       skip.6367.11564
bge_else.59807:
	ret
bge_else.59806:
	b       skip.6367.11564
bge_else.59804:
	ret
bge_else.59803:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59808
	ret
be_else.59808:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59809
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59810
	b       skip.6367.11564
bge_else.59810:
	ret
bge_else.59809:
	b       skip.6367.11564
bge_else.59801:
	ret
bge_else.59800:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59811
	ret
be_else.59811:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59812
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59813
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59814
	ret
be_else.59814:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59815
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59816
	b       skip.6367.11564
bge_else.59816:
	ret
bge_else.59815:
	b       skip.6367.11564
bge_else.59813:
	ret
bge_else.59812:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59817
	ret
be_else.59817:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59818
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59819
	b       skip.6367.11564
bge_else.59819:
	ret
bge_else.59818:
	b       skip.6367.11564
bge_else.59798:
	ret
bge_else.59797:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59820
	ret
be_else.59820:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59821
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59822
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59823
	ret
be_else.59823:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59824
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59825
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59826
	ret
be_else.59826:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59827
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59828
	b       skip.6367.11564
bge_else.59828:
	ret
bge_else.59827:
	b       skip.6367.11564
bge_else.59825:
	ret
bge_else.59824:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59829
	ret
be_else.59829:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59830
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59831
	b       skip.6367.11564
bge_else.59831:
	ret
bge_else.59830:
	b       skip.6367.11564
bge_else.59822:
	ret
bge_else.59821:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59832
	ret
be_else.59832:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59833
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59834
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59835
	ret
be_else.59835:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59836
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59837
	b       skip.6367.11564
bge_else.59837:
	ret
bge_else.59836:
	b       skip.6367.11564
bge_else.59834:
	ret
bge_else.59833:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59838
	ret
be_else.59838:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59839
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59840
	b       skip.6367.11564
bge_else.59840:
	ret
bge_else.59839:
	b       skip.6367.11564
read_rec.6369.11566:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59841
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59842
	load    0($sp), $i1
	ret
bge_else.59842:
	load    0($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59843
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59844
	load    1($sp), $i1
	ret
bge_else.59844:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59845
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59846
	load    2($sp), $i1
	ret
bge_else.59846:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59847
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59848
	load    3($sp), $i1
	ret
bge_else.59848:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	b       read_rec.6369.11566
bge_else.59847:
	load    3($sp), $i1
	ret
bge_else.59845:
	load    2($sp), $i1
	ret
bge_else.59843:
	load    1($sp), $i1
	ret
bge_else.59841:
	load    0($sp), $i1
	ret
read_net_item.2908:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59849
	b       be_cont.59850
be_else.59849:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59851
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59853
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59855
	b       be_cont.59856
be_else.59855:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59857
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59859
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59861
	b       be_cont.59862
be_else.59861:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59863
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59865
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       bge_cont.59866
bge_else.59865:
bge_cont.59866:
	b       bge_cont.59864
bge_else.59863:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
bge_cont.59864:
be_cont.59862:
	b       bge_cont.59860
bge_else.59859:
bge_cont.59860:
	b       bge_cont.59858
bge_else.59857:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59867
	b       be_cont.59868
be_else.59867:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59869
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59871
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       bge_cont.59872
bge_else.59871:
bge_cont.59872:
	b       bge_cont.59870
bge_else.59869:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
bge_cont.59870:
be_cont.59868:
bge_cont.59858:
be_cont.59856:
	b       bge_cont.59854
bge_else.59853:
bge_cont.59854:
	b       bge_cont.59852
bge_else.59851:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59873
	b       be_cont.59874
be_else.59873:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59875
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59877
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59879
	b       be_cont.59880
be_else.59879:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59881
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59883
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       bge_cont.59884
bge_else.59883:
bge_cont.59884:
	b       bge_cont.59882
bge_else.59881:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
bge_cont.59882:
be_cont.59880:
	b       bge_cont.59878
bge_else.59877:
bge_cont.59878:
	b       bge_cont.59876
bge_else.59875:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_read
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59885
	b       be_cont.59886
be_else.59885:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59887
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59889
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       bge_cont.59890
bge_else.59889:
bge_cont.59890:
	b       bge_cont.59888
bge_else.59887:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     skip.6367.11564
	sub     $sp, 2, $sp
	load    1($sp), $ra
bge_cont.59888:
be_cont.59886:
bge_cont.59876:
be_cont.59874:
bge_cont.59852:
be_cont.59850:
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59891
	li      0, $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_read
	sub     $sp, 3, $sp
	load    2($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59893
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59895
	li      0, $i1
	b       bge_cont.59896
bge_else.59895:
	load    1($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_read
	sub     $sp, 4, $sp
	load    3($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59897
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59899
	load    2($sp), $i1
	b       bge_cont.59900
bge_else.59899:
	load    2($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_read
	sub     $sp, 5, $sp
	load    4($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59901
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59903
	load    3($sp), $i1
	b       bge_cont.59904
bge_else.59903:
	load    3($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_rec.6369.11566
	sub     $sp, 5, $sp
	load    4($sp), $ra
bge_cont.59904:
	b       bge_cont.59902
bge_else.59901:
	load    3($sp), $i1
bge_cont.59902:
bge_cont.59900:
	b       bge_cont.59898
bge_else.59897:
	load    2($sp), $i1
bge_cont.59898:
bge_cont.59896:
	b       bge_cont.59894
bge_else.59893:
	li      0, $i1
bge_cont.59894:
	neg     $i1, $i1
	b       be_cont.59892
be_else.59891:
	sub     $i1, 48, $i1
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_read
	sub     $sp, 6, $sp
	load    5($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59905
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59907
	load    4($sp), $i1
	b       bge_cont.59908
bge_else.59907:
	load    4($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_read
	sub     $sp, 7, $sp
	load    6($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59909
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59911
	load    5($sp), $i1
	b       bge_cont.59912
bge_else.59911:
	load    5($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_read
	sub     $sp, 8, $sp
	load    7($sp), $ra
	sub     $i1, 48, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59913
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.59915
	load    6($sp), $i1
	b       bge_cont.59916
bge_else.59915:
	load    6($sp), $i2
	sll     $i2, 3, $i3
	sll     $i2, 1, $i2
	add     $i3, $i2, $i2
	add     $i2, $i1, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_rec.6369.11566
	sub     $sp, 8, $sp
	load    7($sp), $ra
bge_cont.59916:
	b       bge_cont.59914
bge_else.59913:
	load    6($sp), $i1
bge_cont.59914:
bge_cont.59912:
	b       bge_cont.59910
bge_else.59909:
	load    5($sp), $i1
bge_cont.59910:
bge_cont.59908:
	b       bge_cont.59906
bge_else.59905:
	load    4($sp), $i1
bge_cont.59906:
be_cont.59892:
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59917
	load    0($sp), $i1
	add     $i1, 1, $i1
	li      -1, $i2
	b       min_caml_create_array
be_else.59917:
	store   $i1, 7($sp)
	load    0($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_int.2731
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59918
	load    8($sp), $i1
	add     $i1, 1, $i1
	li      -1, $i2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	b       be_cont.59919
be_else.59918:
	store   $i1, 9($sp)
	load    8($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     read_net_item.2908
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.59919:
	load    0($sp), $i2
	load    7($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
	ret
read_or_network.2910:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     read_int.2731
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59920
	li      1, $i1
	li      -1, $i2
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	b       be_cont.59921
be_else.59920:
	store   $i1, 1($sp)
	li      1, $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     read_net_item.2908
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	store   $i2, 0($i1)
be_cont.59921:
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59922
	load    0($sp), $i1
	add     $i1, 1, $i1
	b       min_caml_create_array
be_else.59922:
	store   $i2, 2($sp)
	load    0($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 3($sp)
	li      0, $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_net_item.2908
	sub     $sp, 5, $sp
	load    4($sp), $ra
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59923
	load    3($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	b       be_cont.59924
be_else.59923:
	store   $i2, 4($sp)
	load    3($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     read_int.2731
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59925
	li      1, $i1
	li      -1, $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	b       be_cont.59926
be_else.59925:
	store   $i1, 6($sp)
	li      1, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_net_item.2908
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i2
	store   $i2, 0($i1)
be_cont.59926:
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59927
	load    5($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	b       be_cont.59928
be_else.59927:
	store   $i2, 7($sp)
	load    5($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 8($sp)
	li      0, $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_net_item.2908
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59929
	load    8($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	b       be_cont.59930
be_else.59929:
	store   $i2, 9($sp)
	load    8($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     read_or_network.2910
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.59930:
	load    5($sp), $i2
	load    7($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.59928:
	load    3($sp), $i2
	load    4($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
be_cont.59924:
	load    0($sp), $i2
	load    2($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
	ret
read_and_network.2912:
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	load    1($i11), $i1
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     read_int.2731
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59931
	li      1, $i1
	li      -1, $i2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	b       be_cont.59932
be_else.59931:
	store   $i1, 3($sp)
	li      1, $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_net_item.2908
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	store   $i2, 0($i1)
be_cont.59932:
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59933
	ret
be_else.59933:
	load    1($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	store   $i1, 4($sp)
	li      0, $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     read_net_item.2908
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59935
	ret
be_else.59935:
	load    4($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     read_int.2731
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59937
	li      1, $i1
	li      -1, $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	b       be_cont.59938
be_else.59937:
	store   $i1, 6($sp)
	li      1, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_net_item.2908
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i2
	store   $i2, 0($i1)
be_cont.59938:
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59939
	ret
be_else.59939:
	load    5($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	store   $i1, 7($sp)
	li      0, $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     read_net_item.2908
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59941
	ret
be_else.59941:
	load    7($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
read_parameter.2914:
	load    11($i11), $i1
	store   $i1, 0($sp)
	load    10($i11), $i1
	load    9($i11), $i2
	store   $i2, 1($sp)
	load    8($i11), $i2
	store   $i2, 2($sp)
	load    7($i11), $i2
	store   $i2, 3($sp)
	load    6($i11), $i2
	store   $i2, 4($sp)
	load    5($i11), $i2
	store   $i2, 5($sp)
	load    4($i11), $i2
	store   $i2, 6($sp)
	load    3($i11), $i2
	store   $i2, 7($sp)
	load    2($i11), $i2
	store   $i2, 8($sp)
	load    1($i11), $i2
	store   $i2, 9($sp)
	mov     $i1, $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.59943, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.59943:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     read_int.2731
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     read_float.2733
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      l.25968, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 10($sp)
	load    0($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.59944, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.59944:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    6($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     read_float.2733
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      l.25968, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 11($sp)
	load    10($sp), $f1
	load    7($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.59945, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.59945:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $f1, 12($sp)
	load    11($sp), $f1
	load    0($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59946, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59946:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fmul    $f2, $f1, $f1
	load    6($sp), $i1
	store   $f1, 0($i1)
	load    11($sp), $f1
	load    7($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.59947, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.59947:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fmul    $f2, $f1, $f1
	load    6($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     read_float.2733
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    8($sp), $i1
	store   $f1, 0($i1)
	li      0, $i1
	store   $i1, 13($sp)
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.59948, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.59948:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59949
	load    5($sp), $i1
	load    13($sp), $i2
	store   $i2, 0($i1)
	b       be_cont.59950
be_else.59949:
	li      1, $i1
	store   $i1, 14($sp)
	load    2($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.59951, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.59951:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59952
	load    5($sp), $i1
	load    14($sp), $i2
	store   $i2, 0($i1)
	b       be_cont.59953
be_else.59952:
	li      2, $i1
	store   $i1, 15($sp)
	load    2($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.59954, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.59954:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59955
	load    5($sp), $i1
	load    15($sp), $i2
	store   $i2, 0($i1)
	b       be_cont.59956
be_else.59955:
	li      3, $i1
	store   $i1, 16($sp)
	load    2($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.59957, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.59957:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59958
	load    5($sp), $i1
	load    16($sp), $i2
	store   $i2, 0($i1)
	b       be_cont.59959
be_else.59958:
	li      4, $i1
	store   $i1, 17($sp)
	load    2($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.59960, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.59960:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59961
	load    5($sp), $i1
	load    17($sp), $i2
	store   $i2, 0($i1)
	b       be_cont.59962
be_else.59961:
	li      5, $i1
	store   $i1, 18($sp)
	load    2($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.59963, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.59963:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59964
	load    5($sp), $i1
	load    18($sp), $i2
	store   $i2, 0($i1)
	b       be_cont.59965
be_else.59964:
	li      6, $i1
	load    1($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.59966, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.59966:
	sub     $sp, 20, $sp
	load    19($sp), $ra
be_cont.59965:
be_cont.59962:
be_cont.59959:
be_cont.59956:
be_cont.59953:
be_cont.59950:
	li      0, $i1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     read_net_item.2908
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59967
	b       be_cont.59968
be_else.59967:
	load    9($sp), $i2
	store   $i1, 0($i2)
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     read_int.2731
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59969
	li      1, $i1
	li      -1, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	b       be_cont.59970
be_else.59969:
	store   $i1, 19($sp)
	li      1, $i1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     read_net_item.2908
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i2
	store   $i2, 0($i1)
be_cont.59970:
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59971
	b       be_cont.59972
be_else.59971:
	load    9($sp), $i2
	store   $i1, 1($i2)
	li      0, $i1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     read_net_item.2908
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59973
	b       be_cont.59974
be_else.59973:
	load    9($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	load    3($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.59975, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.59975:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.59974:
be_cont.59972:
be_cont.59968:
	li      0, $i1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     read_net_item.2908
	sub     $sp, 21, $sp
	load    20($sp), $ra
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59976
	li      1, $i1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	b       be_cont.59977
be_else.59976:
	store   $i2, 20($sp)
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     read_int.2731
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59978
	li      1, $i1
	li      -1, $i2
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	b       be_cont.59979
be_else.59978:
	store   $i1, 21($sp)
	li      1, $i1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     read_net_item.2908
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i2
	store   $i2, 0($i1)
be_cont.59979:
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59980
	li      2, $i1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_create_array
	sub     $sp, 23, $sp
	load    22($sp), $ra
	b       be_cont.59981
be_else.59980:
	store   $i2, 22($sp)
	li      0, $i1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     read_net_item.2908
	sub     $sp, 24, $sp
	load    23($sp), $ra
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59982
	li      3, $i1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_create_array
	sub     $sp, 24, $sp
	load    23($sp), $ra
	b       be_cont.59983
be_else.59982:
	store   $i2, 23($sp)
	li      3, $i1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     read_or_network.2910
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    23($sp), $i2
	store   $i2, 2($i1)
be_cont.59983:
	load    22($sp), $i2
	store   $i2, 1($i1)
be_cont.59981:
	load    20($sp), $i2
	store   $i2, 0($i1)
be_cont.59977:
	load    4($sp), $i2
	store   $i1, 0($i2)
	ret
solver_rect.2925:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $f1, 2($sp)
	store   $i2, 3($sp)
	store   $i1, 4($sp)
	load    1($i11), $i1
	store   $i1, 5($sp)
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fiszero
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59985
	load    4($sp), $i1
	load    4($i1), $i2
	store   $i2, 6($sp)
	load    6($i1), $i1
	store   $i1, 7($sp)
	load    3($sp), $i1
	load    0($i1), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fisneg
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.59987
	b       be_cont.59988
be_else.59987:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59989
	li      1, $i1
	b       be_cont.59990
be_else.59989:
	li      0, $i1
be_cont.59990:
be_cont.59988:
	load    6($sp), $i2
	load    0($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59991
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fneg
	sub     $sp, 9, $sp
	load    8($sp), $ra
	b       be_cont.59992
be_else.59991:
be_cont.59992:
	load    2($sp), $f2
	fsub    $f1, $f2, $f1
	load    3($sp), $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 8($sp)
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fabs
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    6($sp), $i1
	load    1($i1), $f2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59993
	li      0, $i1
	b       be_cont.59994
be_else.59993:
	load    3($sp), $i1
	load    2($i1), $f1
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fabs
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    6($sp), $i1
	load    2($i1), $f2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59995
	li      0, $i1
	b       be_cont.59996
be_else.59995:
	load    5($sp), $i1
	load    8($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.59996:
be_cont.59994:
	b       be_cont.59986
be_else.59985:
	li      0, $i1
be_cont.59986:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59997
	load    3($sp), $i1
	load    1($i1), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fiszero
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.59998
	load    4($sp), $i1
	load    4($i1), $i2
	store   $i2, 9($sp)
	load    6($i1), $i1
	store   $i1, 10($sp)
	load    3($sp), $i1
	load    1($i1), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fisneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60000
	b       be_cont.60001
be_else.60000:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60002
	li      1, $i1
	b       be_cont.60003
be_else.60002:
	li      0, $i1
be_cont.60003:
be_cont.60001:
	load    9($sp), $i2
	load    1($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60004
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       be_cont.60005
be_else.60004:
be_cont.60005:
	load    1($sp), $f2
	fsub    $f1, $f2, $f1
	load    3($sp), $i1
	load    1($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 11($sp)
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fabs
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    9($sp), $i1
	load    2($i1), $f2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60006
	li      0, $i1
	b       be_cont.60007
be_else.60006:
	load    3($sp), $i1
	load    0($i1), $f1
	load    11($sp), $f2
	fmul    $f2, $f1, $f1
	load    2($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fabs
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    9($sp), $i1
	load    0($i1), $f2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60008
	li      0, $i1
	b       be_cont.60009
be_else.60008:
	load    5($sp), $i1
	load    11($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60009:
be_cont.60007:
	b       be_cont.59999
be_else.59998:
	li      0, $i1
be_cont.59999:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60010
	load    3($sp), $i1
	load    2($i1), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fiszero
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60011
	load    4($sp), $i1
	load    4($i1), $i2
	store   $i2, 12($sp)
	load    6($i1), $i1
	store   $i1, 13($sp)
	load    3($sp), $i1
	load    2($i1), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fisneg
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60013
	b       be_cont.60014
be_else.60013:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60015
	li      1, $i1
	b       be_cont.60016
be_else.60015:
	li      0, $i1
be_cont.60016:
be_cont.60014:
	load    12($sp), $i2
	load    2($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60017
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fneg
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       be_cont.60018
be_else.60017:
be_cont.60018:
	load    0($sp), $f2
	fsub    $f1, $f2, $f1
	load    3($sp), $i1
	load    2($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 14($sp)
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    2($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fabs
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    12($sp), $i1
	load    0($i1), $f2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fless
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60019
	li      0, $i1
	b       be_cont.60020
be_else.60019:
	load    3($sp), $i1
	load    1($i1), $f1
	load    14($sp), $f2
	fmul    $f2, $f1, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fabs
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    12($sp), $i1
	load    1($i1), $f2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fless
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60021
	li      0, $i1
	b       be_cont.60022
be_else.60021:
	load    5($sp), $i1
	load    14($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60022:
be_cont.60020:
	b       be_cont.60012
be_else.60011:
	li      0, $i1
be_cont.60012:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60023
	li      0, $i1
	ret
be_else.60023:
	li      3, $i1
	ret
be_else.60010:
	li      2, $i1
	ret
be_else.59997:
	li      1, $i1
	ret
solver_second.2950:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $f1, 2($sp)
	store   $i2, 3($sp)
	store   $i1, 4($sp)
	load    1($i11), $i1
	store   $i1, 5($sp)
	load    0($i2), $f1
	store   $f1, 6($sp)
	load    1($i2), $f2
	store   $f2, 7($sp)
	load    2($i2), $f2
	store   $f2, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fsqr
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    4($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 9($sp)
	load    7($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    4($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 10($sp)
	load    8($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fsqr
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    4($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    10($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60024
	b       be_cont.60025
be_else.60024:
	load    8($sp), $f2
	load    7($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    6($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60025:
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fiszero
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60026
	load    3($sp), $i1
	load    0($i1), $f1
	load    1($i1), $f2
	load    2($i1), $f3
	load    2($sp), $f4
	fmul    $f1, $f4, $f5
	load    4($sp), $i1
	load    4($i1), $i2
	load    0($i2), $f6
	fmul    $f5, $f6, $f5
	load    1($sp), $f6
	fmul    $f2, $f6, $f7
	load    4($i1), $i2
	load    1($i2), $f8
	fmul    $f7, $f8, $f7
	fadd    $f5, $f7, $f5
	load    0($sp), $f7
	fmul    $f3, $f7, $f8
	load    4($i1), $i2
	load    2($i2), $f9
	fmul    $f8, $f9, $f8
	fadd    $f5, $f8, $f5
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60027
	mov     $f5, $f1
	b       be_cont.60028
be_else.60027:
	store   $f5, 12($sp)
	fmul    $f3, $f6, $f5
	fmul    $f2, $f7, $f8
	fadd    $f5, $f8, $f5
	load    9($i1), $i2
	load    0($i2), $f8
	fmul    $f5, $f8, $f5
	fmul    $f1, $f7, $f7
	fmul    $f3, $f4, $f3
	fadd    $f7, $f3, $f3
	load    9($i1), $i2
	load    1($i2), $f7
	fmul    $f3, $f7, $f3
	fadd    $f5, $f3, $f3
	fmul    $f1, $f6, $f1
	fmul    $f2, $f4, $f2
	fadd    $f1, $f2, $f1
	load    9($i1), $i1
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	fadd    $f3, $f1, $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fhalf
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
be_cont.60028:
	store   $f1, 13($sp)
	load    2($sp), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fsqr
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    4($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 14($sp)
	load    1($sp), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fsqr
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    4($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    14($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 15($sp)
	load    0($sp), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fsqr
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    4($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    15($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60029
	b       be_cont.60030
be_else.60029:
	load    0($sp), $f2
	load    1($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    2($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60030:
	load    1($i1), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60031
	li      l.25743, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60032
be_else.60031:
be_cont.60032:
	store   $f1, 16($sp)
	load    13($sp), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fsqr
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $f2
	load    11($sp), $f3
	fmul    $f3, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 17($sp)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fispos
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60033
	li      0, $i1
	ret
be_else.60033:
	load    17($sp), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     sqrt.2729
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    4($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60034
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fneg
	sub     $sp, 19, $sp
	load    18($sp), $ra
	b       be_cont.60035
be_else.60034:
be_cont.60035:
	load    13($sp), $f2
	fsub    $f1, $f2, $f1
	load    11($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.60026:
	li      0, $i1
	ret
solver.2956:
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i5, $i1, $i12
	load    0($i12), $i1
	load    0($i3), $f1
	load    5($i1), $i5
	load    0($i5), $f2
	fsub    $f1, $f2, $f1
	load    1($i3), $f2
	load    5($i1), $i5
	load    1($i5), $f3
	fsub    $f2, $f3, $f2
	load    2($i3), $f3
	load    5($i1), $i3
	load    2($i3), $f4
	fsub    $f3, $f4, $f3
	load    1($i1), $i3
	li      1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60036
	store   $i4, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	store   $i2, 4($sp)
	store   $i1, 5($sp)
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fiszero
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60037
	load    5($sp), $i1
	load    4($i1), $i2
	store   $i2, 6($sp)
	load    6($i1), $i1
	store   $i1, 7($sp)
	load    4($sp), $i1
	load    0($i1), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fisneg
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60039
	b       be_cont.60040
be_else.60039:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60041
	li      1, $i1
	b       be_cont.60042
be_else.60041:
	li      0, $i1
be_cont.60042:
be_cont.60040:
	load    6($sp), $i2
	load    0($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60043
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fneg
	sub     $sp, 9, $sp
	load    8($sp), $ra
	b       be_cont.60044
be_else.60043:
be_cont.60044:
	load    3($sp), $f2
	fsub    $f1, $f2, $f1
	load    4($sp), $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 8($sp)
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    2($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fabs
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    6($sp), $i1
	load    1($i1), $f2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60045
	li      0, $i1
	b       be_cont.60046
be_else.60045:
	load    4($sp), $i1
	load    2($i1), $f1
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fabs
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    6($sp), $i1
	load    2($i1), $f2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60047
	li      0, $i1
	b       be_cont.60048
be_else.60047:
	load    0($sp), $i1
	load    8($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60048:
be_cont.60046:
	b       be_cont.60038
be_else.60037:
	li      0, $i1
be_cont.60038:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60049
	load    4($sp), $i1
	load    1($i1), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fiszero
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60050
	load    5($sp), $i1
	load    4($i1), $i2
	store   $i2, 9($sp)
	load    6($i1), $i1
	store   $i1, 10($sp)
	load    4($sp), $i1
	load    1($i1), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fisneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60052
	b       be_cont.60053
be_else.60052:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60054
	li      1, $i1
	b       be_cont.60055
be_else.60054:
	li      0, $i1
be_cont.60055:
be_cont.60053:
	load    9($sp), $i2
	load    1($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60056
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       be_cont.60057
be_else.60056:
be_cont.60057:
	load    2($sp), $f2
	fsub    $f1, $f2, $f1
	load    4($sp), $i1
	load    1($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 11($sp)
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fabs
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    9($sp), $i1
	load    2($i1), $f2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60058
	li      0, $i1
	b       be_cont.60059
be_else.60058:
	load    4($sp), $i1
	load    0($i1), $f1
	load    11($sp), $f2
	fmul    $f2, $f1, $f1
	load    3($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fabs
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    9($sp), $i1
	load    0($i1), $f2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60060
	li      0, $i1
	b       be_cont.60061
be_else.60060:
	load    0($sp), $i1
	load    11($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60061:
be_cont.60059:
	b       be_cont.60051
be_else.60050:
	li      0, $i1
be_cont.60051:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60062
	load    4($sp), $i1
	load    2($i1), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fiszero
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60063
	load    5($sp), $i1
	load    4($i1), $i2
	store   $i2, 12($sp)
	load    6($i1), $i1
	store   $i1, 13($sp)
	load    4($sp), $i1
	load    2($i1), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fisneg
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60065
	b       be_cont.60066
be_else.60065:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60067
	li      1, $i1
	b       be_cont.60068
be_else.60067:
	li      0, $i1
be_cont.60068:
be_cont.60066:
	load    12($sp), $i2
	load    2($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60069
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fneg
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       be_cont.60070
be_else.60069:
be_cont.60070:
	load    1($sp), $f2
	fsub    $f1, $f2, $f1
	load    4($sp), $i1
	load    2($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 14($sp)
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fabs
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    12($sp), $i1
	load    0($i1), $f2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fless
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60071
	li      0, $i1
	b       be_cont.60072
be_else.60071:
	load    4($sp), $i1
	load    1($i1), $f1
	load    14($sp), $f2
	fmul    $f2, $f1, $f1
	load    2($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fabs
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    12($sp), $i1
	load    1($i1), $f2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fless
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60073
	li      0, $i1
	b       be_cont.60074
be_else.60073:
	load    0($sp), $i1
	load    14($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60074:
be_cont.60072:
	b       be_cont.60064
be_else.60063:
	li      0, $i1
be_cont.60064:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60075
	li      0, $i1
	ret
be_else.60075:
	li      3, $i1
	ret
be_else.60062:
	li      2, $i1
	ret
be_else.60049:
	li      1, $i1
	ret
be_else.60036:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60076
	store   $i4, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	load    4($i1), $i1
	store   $i1, 15($sp)
	load    0($i2), $f1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($i2), $f2
	load    1($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i2), $f2
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 16($sp)
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fispos
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60077
	li      0, $i1
	ret
be_else.60077:
	load    15($sp), $i1
	load    0($i1), $f1
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    2($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    1($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fneg
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.60076:
	store   $i4, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	store   $i2, 4($sp)
	store   $i1, 5($sp)
	load    0($i2), $f1
	store   $f1, 17($sp)
	load    1($i2), $f2
	store   $f2, 18($sp)
	load    2($i2), $f2
	store   $f2, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fsqr
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 20($sp)
	load    18($sp), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fsqr
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    20($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 21($sp)
	load    19($sp), $f1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fsqr
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    21($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60078
	b       be_cont.60079
be_else.60078:
	load    19($sp), $f2
	load    18($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    17($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60079:
	store   $f1, 22($sp)
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fiszero
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60080
	load    4($sp), $i1
	load    0($i1), $f1
	load    1($i1), $f2
	load    2($i1), $f3
	load    3($sp), $f4
	fmul    $f1, $f4, $f5
	load    5($sp), $i1
	load    4($i1), $i2
	load    0($i2), $f6
	fmul    $f5, $f6, $f5
	load    2($sp), $f6
	fmul    $f2, $f6, $f7
	load    4($i1), $i2
	load    1($i2), $f8
	fmul    $f7, $f8, $f7
	fadd    $f5, $f7, $f5
	load    1($sp), $f7
	fmul    $f3, $f7, $f8
	load    4($i1), $i2
	load    2($i2), $f9
	fmul    $f8, $f9, $f8
	fadd    $f5, $f8, $f5
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60081
	mov     $f5, $f1
	b       be_cont.60082
be_else.60081:
	store   $f5, 23($sp)
	fmul    $f3, $f6, $f5
	fmul    $f2, $f7, $f8
	fadd    $f5, $f8, $f5
	load    9($i1), $i2
	load    0($i2), $f8
	fmul    $f5, $f8, $f5
	fmul    $f1, $f7, $f7
	fmul    $f3, $f4, $f3
	fadd    $f7, $f3, $f3
	load    9($i1), $i2
	load    1($i2), $f7
	fmul    $f3, $f7, $f3
	fadd    $f5, $f3, $f3
	fmul    $f1, $f6, $f1
	fmul    $f2, $f4, $f2
	fadd    $f1, $f2, $f1
	load    9($i1), $i1
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	fadd    $f3, $f1, $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fhalf
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    23($sp), $f2
	fadd    $f2, $f1, $f1
be_cont.60082:
	store   $f1, 24($sp)
	load    3($sp), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fsqr
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 25($sp)
	load    2($sp), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fsqr
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    25($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 26($sp)
	load    1($sp), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fsqr
	sub     $sp, 28, $sp
	load    27($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    26($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60083
	b       be_cont.60084
be_else.60083:
	load    1($sp), $f2
	load    2($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    3($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60084:
	load    1($i1), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60085
	li      l.25743, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60086
be_else.60085:
be_cont.60086:
	store   $f1, 27($sp)
	load    24($sp), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fsqr
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    27($sp), $f2
	load    22($sp), $f3
	fmul    $f3, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 28($sp)
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_fispos
	sub     $sp, 30, $sp
	load    29($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60087
	li      0, $i1
	ret
be_else.60087:
	load    28($sp), $f1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     sqrt.2729
	sub     $sp, 30, $sp
	load    29($sp), $ra
	load    5($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60088
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_fneg
	sub     $sp, 30, $sp
	load    29($sp), $ra
	b       be_cont.60089
be_else.60088:
be_cont.60089:
	load    24($sp), $f2
	fsub    $f1, $f2, $f1
	load    22($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.60080:
	li      0, $i1
	ret
solver_rect_fast.2960:
	store   $f3, 0($sp)
	store   $f1, 1($sp)
	store   $i2, 2($sp)
	store   $f2, 3($sp)
	store   $i3, 4($sp)
	store   $i1, 5($sp)
	load    1($i11), $i1
	store   $i1, 6($sp)
	load    0($i3), $f3
	fsub    $f3, $f1, $f1
	load    1($i3), $f3
	fmul    $f1, $f3, $f1
	store   $f1, 7($sp)
	load    1($i2), $f3
	fmul    $f1, $f3, $f1
	fadd    $f1, $f2, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fabs
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fless
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60090
	li      0, $i1
	b       be_cont.60091
be_else.60090:
	load    2($sp), $i1
	load    2($i1), $f1
	load    7($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fabs
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fless
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60092
	li      0, $i1
	b       be_cont.60093
be_else.60092:
	load    4($sp), $i1
	load    1($i1), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fiszero
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60094
	li      1, $i1
	b       be_cont.60095
be_else.60094:
	li      0, $i1
be_cont.60095:
be_cont.60093:
be_cont.60091:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60096
	load    4($sp), $i1
	load    2($i1), $f1
	load    3($sp), $f2
	fsub    $f1, $f2, $f1
	load    3($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 8($sp)
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fabs
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60097
	li      0, $i1
	b       be_cont.60098
be_else.60097:
	load    2($sp), $i1
	load    2($i1), $f1
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fabs
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60099
	li      0, $i1
	b       be_cont.60100
be_else.60099:
	load    4($sp), $i1
	load    3($i1), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fiszero
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60101
	li      1, $i1
	b       be_cont.60102
be_else.60101:
	li      0, $i1
be_cont.60102:
be_cont.60100:
be_cont.60098:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60103
	load    4($sp), $i1
	load    4($i1), $f1
	load    0($sp), $f2
	fsub    $f1, $f2, $f1
	load    5($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 9($sp)
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fabs
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fless
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60104
	li      0, $i1
	b       be_cont.60105
be_else.60104:
	load    2($sp), $i1
	load    1($i1), $f1
	load    9($sp), $f2
	fmul    $f2, $f1, $f1
	load    3($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fabs
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fless
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60106
	li      0, $i1
	b       be_cont.60107
be_else.60106:
	load    4($sp), $i1
	load    5($i1), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fiszero
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60108
	li      1, $i1
	b       be_cont.60109
be_else.60108:
	li      0, $i1
be_cont.60109:
be_cont.60107:
be_cont.60105:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60110
	li      0, $i1
	ret
be_else.60110:
	load    6($sp), $i1
	load    9($sp), $f1
	store   $f1, 0($i1)
	li      3, $i1
	ret
be_else.60103:
	load    6($sp), $i1
	load    8($sp), $f1
	store   $f1, 0($i1)
	li      2, $i1
	ret
be_else.60096:
	load    6($sp), $i1
	load    7($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
	ret
solver_second_fast.2973:
	store   $i1, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	store   $i2, 4($sp)
	load    1($i11), $i1
	store   $i1, 5($sp)
	load    0($i2), $f1
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fiszero
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60111
	load    4($sp), $i1
	load    1($i1), $f1
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f3
	load    2($sp), $f4
	fmul    $f3, $f4, $f3
	fadd    $f1, $f3, $f1
	load    3($i1), $f3
	load    1($sp), $f4
	fmul    $f3, $f4, $f3
	fadd    $f1, $f3, $f1
	store   $f1, 7($sp)
	mov     $f2, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fsqr
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    0($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 8($sp)
	load    2($sp), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fsqr
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    0($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    8($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 9($sp)
	load    1($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    0($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60112
	b       be_cont.60113
be_else.60112:
	load    1($sp), $f2
	load    2($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    3($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60113:
	load    1($i1), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60114
	li      l.25743, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60115
be_else.60114:
be_cont.60115:
	store   $f1, 10($sp)
	load    7($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fsqr
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	load    6($sp), $f3
	fmul    $f3, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fispos
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60116
	li      0, $i1
	ret
be_else.60116:
	load    0($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60117
	load    11($sp), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     sqrt.2729
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	load    4($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.60118
be_else.60117:
	load    11($sp), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     sqrt.2729
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
	load    4($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
be_cont.60118:
	li      1, $i1
	ret
be_else.60111:
	li      0, $i1
	ret
solver_fast.2979:
	load    3($i11), $i4
	load    2($i11), $i5
	load    1($i11), $i6
	add     $i6, $i1, $i12
	load    0($i12), $i6
	load    0($i3), $f1
	load    5($i6), $i7
	load    0($i7), $f2
	fsub    $f1, $f2, $f1
	load    1($i3), $f2
	load    5($i6), $i7
	load    1($i7), $f3
	fsub    $f2, $f3, $f2
	load    2($i3), $f3
	load    5($i6), $i3
	load    2($i3), $f4
	fsub    $f3, $f4, $f3
	load    1($i2), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i3
	load    1($i6), $i1
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60119
	load    0($i2), $i2
	mov     $i6, $i1
	mov     $i4, $i11
	load    0($i11), $i10
	jr      $i10
be_else.60119:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60120
	store   $i5, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	store   $i3, 4($sp)
	load    0($i3), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fisneg
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60121
	li      0, $i1
	ret
be_else.60121:
	load    4($sp), $i1
	load    1($i1), $f1
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    2($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    1($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.60120:
	store   $i5, 0($sp)
	store   $i6, 5($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	store   $i3, 4($sp)
	load    0($i3), $f1
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fiszero
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60122
	load    4($sp), $i1
	load    1($i1), $f1
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f3
	load    2($sp), $f4
	fmul    $f3, $f4, $f3
	fadd    $f1, $f3, $f1
	load    3($i1), $f3
	load    1($sp), $f4
	fmul    $f3, $f4, $f3
	fadd    $f1, $f3, $f1
	store   $f1, 7($sp)
	mov     $f2, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fsqr
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 8($sp)
	load    2($sp), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fsqr
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    8($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 9($sp)
	load    1($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60123
	b       be_cont.60124
be_else.60123:
	load    1($sp), $f2
	load    2($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    3($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60124:
	load    1($i1), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60125
	li      l.25743, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60126
be_else.60125:
be_cont.60126:
	store   $f1, 10($sp)
	load    7($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fsqr
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	load    6($sp), $f3
	fmul    $f3, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fispos
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60127
	li      0, $i1
	ret
be_else.60127:
	load    5($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60128
	load    11($sp), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     sqrt.2729
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	load    4($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.60129
be_else.60128:
	load    11($sp), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     sqrt.2729
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
	load    4($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
be_cont.60129:
	li      1, $i1
	ret
be_else.60122:
	li      0, $i1
	ret
solver_fast2.2997:
	load    3($i11), $i3
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i5, $i1, $i12
	load    0($i12), $i5
	load    10($i5), $i6
	load    0($i6), $f1
	load    1($i6), $f2
	load    2($i6), $f3
	load    1($i2), $i7
	add     $i7, $i1, $i12
	load    0($i12), $i1
	load    1($i5), $i7
	li      1, $i12
	cmp     $i7, $i12, $i12
	bne     $i12, be_else.60130
	load    0($i2), $i2
	mov     $i3, $i11
	mov     $i1, $i3
	mov     $i5, $i1
	load    0($i11), $i10
	jr      $i10
be_else.60130:
	li      2, $i12
	cmp     $i7, $i12, $i12
	bne     $i12, be_else.60131
	store   $i4, 0($sp)
	store   $i6, 1($sp)
	store   $i1, 2($sp)
	load    0($i1), $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fisneg
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60132
	li      0, $i1
	ret
be_else.60132:
	load    2($sp), $i1
	load    0($i1), $f1
	load    1($sp), $i1
	load    3($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.60131:
	store   $i4, 0($sp)
	store   $i5, 3($sp)
	store   $i6, 1($sp)
	store   $f3, 4($sp)
	store   $f2, 5($sp)
	store   $f1, 6($sp)
	store   $i1, 2($sp)
	load    0($i1), $f1
	store   $f1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fiszero
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60133
	load    2($sp), $i1
	load    1($i1), $f1
	load    6($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    5($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    4($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 8($sp)
	load    1($sp), $i1
	load    3($i1), $f2
	store   $f2, 9($sp)
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	load    7($sp), $f3
	fmul    $f3, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fispos
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60134
	li      0, $i1
	ret
be_else.60134:
	load    3($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60135
	load    10($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $f2
	fsub    $f2, $f1, $f1
	load    2($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.60136
be_else.60135:
	load    10($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $f2
	fadd    $f2, $f1, $f1
	load    2($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
be_cont.60136:
	li      1, $i1
	ret
be_else.60133:
	li      0, $i1
	ret
setup_rect_table.3000:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      6, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $i1, 2($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fiszero
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60137
	load    0($sp), $i1
	load    6($i1), $i1
	store   $i1, 3($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fisneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60139
	b       be_cont.60140
be_else.60139:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60141
	li      1, $i1
	b       be_cont.60142
be_else.60141:
	li      0, $i1
be_cont.60142:
be_cont.60140:
	load    0($sp), $i2
	load    4($i2), $i2
	load    0($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60143
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	b       be_cont.60144
be_else.60143:
be_cont.60144:
	load    2($sp), $i1
	store   $f1, 0($i1)
	li      l.25743, $i2
	load    0($i2), $f1
	load    1($sp), $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 1($i1)
	b       be_cont.60138
be_else.60137:
	li      l.25703, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 1($i1)
be_cont.60138:
	load    1($sp), $i1
	load    1($i1), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fiszero
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60145
	load    0($sp), $i1
	load    6($i1), $i1
	store   $i1, 4($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fisneg
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60147
	b       be_cont.60148
be_else.60147:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60149
	li      1, $i1
	b       be_cont.60150
be_else.60149:
	li      0, $i1
be_cont.60150:
be_cont.60148:
	load    0($sp), $i2
	load    4($i2), $i2
	load    1($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60151
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fneg
	sub     $sp, 6, $sp
	load    5($sp), $ra
	b       be_cont.60152
be_else.60151:
be_cont.60152:
	load    2($sp), $i1
	store   $f1, 2($i1)
	li      l.25743, $i2
	load    0($i2), $f1
	load    1($sp), $i2
	load    1($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 3($i1)
	b       be_cont.60146
be_else.60145:
	li      l.25703, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 3($i1)
be_cont.60146:
	load    1($sp), $i1
	load    2($i1), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fiszero
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60153
	load    0($sp), $i1
	load    6($i1), $i1
	store   $i1, 5($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fisneg
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60155
	b       be_cont.60156
be_else.60155:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60157
	li      1, $i1
	b       be_cont.60158
be_else.60157:
	li      0, $i1
be_cont.60158:
be_cont.60156:
	load    0($sp), $i2
	load    4($i2), $i2
	load    2($i2), $f1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60159
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fneg
	sub     $sp, 7, $sp
	load    6($sp), $ra
	b       be_cont.60160
be_else.60159:
be_cont.60160:
	load    2($sp), $i1
	store   $f1, 4($i1)
	li      l.25743, $i2
	load    0($i2), $f1
	load    1($sp), $i2
	load    2($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 5($i1)
	b       be_cont.60154
be_else.60153:
	li      l.25703, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 5($i1)
be_cont.60154:
	ret
setup_surface_table.3003:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      4, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $i1, 2($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i2
	load    4($i2), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    4($i2), $i3
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    4($i2), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fispos
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60161
	li      l.25703, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.60162
be_else.60161:
	li      l.26012, $i1
	load    0($i1), $f1
	load    3($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    2($sp), $i1
	store   $f1, 0($i1)
	load    0($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f1
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    2($sp), $i1
	store   $f1, 1($i1)
	load    0($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f1
	load    3($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    2($sp), $i1
	store   $f1, 2($i1)
	load    0($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f1
	load    3($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    2($sp), $i1
	store   $f1, 3($i1)
be_cont.60162:
	ret
setup_second_table.3006:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      5, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $i1, 2($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $f1, 3($sp)
	load    1($i1), $f2
	store   $f2, 4($sp)
	load    2($i1), $f2
	store   $f2, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fsqr
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    0($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 6($sp)
	load    4($sp), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fsqr
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    0($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    6($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 7($sp)
	load    5($sp), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fsqr
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    0($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60163
	b       be_cont.60164
be_else.60163:
	load    5($sp), $f2
	load    4($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    3($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60164:
	store   $f1, 8($sp)
	load    1($sp), $i2
	load    0($i2), $f1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $f1, 9($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	load    0($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fneg
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $f1, 10($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	load    0($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    2($sp), $i1
	load    8($sp), $f2
	store   $f2, 0($i1)
	load    0($sp), $i2
	load    3($i2), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60165
	load    9($sp), $f2
	store   $f2, 1($i1)
	load    10($sp), $f2
	store   $f2, 2($i1)
	store   $f1, 3($i1)
	b       be_cont.60166
be_else.60165:
	store   $f1, 11($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	load    9($i2), $i3
	load    1($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    9($i2), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fhalf
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    9($sp), $f2
	fsub    $f2, $f1, $f1
	load    2($sp), $i1
	store   $f1, 1($i1)
	load    1($sp), $i1
	load    2($i1), $f1
	load    0($sp), $i2
	load    9($i2), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    0($i1), $f2
	load    9($i2), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fhalf
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    10($sp), $f2
	fsub    $f2, $f1, $f1
	load    2($sp), $i1
	store   $f1, 2($i1)
	load    1($sp), $i1
	load    1($i1), $f1
	load    0($sp), $i2
	load    9($i2), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    0($i1), $f2
	load    9($i2), $i1
	load    1($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fhalf
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	fsub    $f2, $f1, $f1
	load    2($sp), $i1
	store   $f1, 3($i1)
be_cont.60166:
	load    8($sp), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fiszero
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60167
	li      l.25743, $i1
	load    0($i1), $f1
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    2($sp), $i1
	store   $f1, 4($i1)
	b       be_cont.60168
be_else.60167:
be_cont.60168:
	load    2($sp), $i1
	ret
iter_setup_dirvec_constants.3009:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.60169
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
	bne     $i12, be_else.60170
	store   $i2, 3($sp)
	store   $i4, 4($sp)
	mov     $i3, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     setup_rect_table.3000
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    3($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.60171
be_else.60170:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.60172
	store   $i2, 3($sp)
	store   $i4, 4($sp)
	store   $i3, 5($sp)
	store   $i1, 6($sp)
	li      4, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	load    6($sp), $i1
	load    0($i1), $f1
	load    5($sp), $i2
	load    4($i2), $i3
	load    0($i3), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    4($i2), $i3
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    4($i2), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fispos
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60174
	li      l.25703, $i1
	load    0($i1), $f1
	load    7($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.60175
be_else.60174:
	li      l.26012, $i1
	load    0($i1), $f1
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    7($sp), $i1
	store   $f1, 0($i1)
	load    5($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f1
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    7($sp), $i1
	store   $f1, 1($i1)
	load    5($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f1
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    7($sp), $i1
	store   $f1, 2($i1)
	load    5($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f1
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    7($sp), $i1
	store   $f1, 3($i1)
be_cont.60175:
	load    3($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.60173
be_else.60172:
	store   $i2, 3($sp)
	store   $i4, 4($sp)
	mov     $i3, $i2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     setup_second_table.3006
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    3($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.60173:
be_cont.60171:
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.60176
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    1($sp), $i3
	load    1($i3), $i4
	load    0($i3), $i3
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.60177
	store   $i1, 9($sp)
	store   $i4, 10($sp)
	mov     $i3, $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_rect_table.3000
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.60178
be_else.60177:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.60179
	store   $i1, 9($sp)
	store   $i4, 10($sp)
	mov     $i3, $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_surface_table.3003
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.60180
be_else.60179:
	store   $i1, 9($sp)
	store   $i4, 10($sp)
	mov     $i3, $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_second_table.3006
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.60180:
be_cont.60178:
	sub     $i2, 1, $i2
	load    1($sp), $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.60176:
	ret
bge_else.60169:
	ret
setup_startp_constants.3014:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.60183
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
	bne     $i12, be_else.60184
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
	b       be_cont.60185
be_else.60184:
	li      2, $i12
	cmp     $i4, $i12, $i12
	bg      $i12, ble_else.60186
	b       ble_cont.60187
ble_else.60186:
	store   $i3, 3($sp)
	store   $i4, 4($sp)
	store   $i2, 5($sp)
	load    0($i3), $f1
	store   $f1, 6($sp)
	load    1($i3), $f2
	store   $f2, 7($sp)
	load    2($i3), $f2
	store   $f2, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fsqr
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 9($sp)
	load    7($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 10($sp)
	load    8($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fsqr
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    5($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    10($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60188
	b       be_cont.60189
be_else.60188:
	load    8($sp), $f2
	load    7($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    6($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60189:
	load    4($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60190
	li      l.25743, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60191
be_else.60190:
be_cont.60191:
	load    3($sp), $i1
	store   $f1, 3($i1)
ble_cont.60187:
be_cont.60185:
	load    2($sp), $i1
	sub     $i1, 1, $i2
	load    0($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.60183:
	ret
is_outside.3034:
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
	bne     $i12, be_else.60193
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fabs
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fless
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60194
	li      0, $i1
	b       be_cont.60195
be_else.60194:
	load    1($sp), $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fabs
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fless
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60196
	li      0, $i1
	b       be_cont.60197
be_else.60196:
	load    0($sp), $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fabs
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fless
	sub     $sp, 4, $sp
	load    3($sp), $ra
be_cont.60197:
be_cont.60195:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60198
	load    2($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60199
	li      1, $i1
	ret
be_else.60199:
	li      0, $i1
	ret
be_else.60198:
	load    2($sp), $i1
	load    6($i1), $i1
	ret
be_else.60193:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60200
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
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fisneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60201
	b       be_cont.60202
be_else.60201:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60203
	li      1, $i1
	b       be_cont.60204
be_else.60203:
	li      0, $i1
be_cont.60204:
be_cont.60202:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60205
	li      1, $i1
	ret
be_else.60205:
	li      0, $i1
	ret
be_else.60200:
	store   $f1, 4($sp)
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $i1, 2($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fsqr
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    2($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 5($sp)
	load    1($sp), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fsqr
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    2($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    5($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 6($sp)
	load    0($sp), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fsqr
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    2($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    6($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60206
	b       be_cont.60207
be_else.60206:
	load    0($sp), $f2
	load    1($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    4($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60207:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60208
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60209
be_else.60208:
be_cont.60209:
	load    6($i1), $i1
	store   $i1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fisneg
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60210
	b       be_cont.60211
be_else.60210:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60212
	li      1, $i1
	b       be_cont.60213
be_else.60212:
	li      0, $i1
be_cont.60213:
be_cont.60211:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60214
	li      1, $i1
	ret
be_else.60214:
	li      0, $i1
	ret
check_all_inside.3039:
	load    1($i11), $i3
	add     $i2, $i1, $i12
	load    0($i12), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60215
	li      1, $i1
	ret
be_else.60215:
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
	bne     $i12, be_else.60216
	store   $f3, 7($sp)
	store   $f2, 8($sp)
	store   $i1, 9($sp)
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fabs
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fless
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60218
	li      0, $i1
	b       be_cont.60219
be_else.60218:
	load    8($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fabs
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fless
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60220
	li      0, $i1
	b       be_cont.60221
be_else.60220:
	load    7($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fabs
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fless
	sub     $sp, 11, $sp
	load    10($sp), $ra
be_cont.60221:
be_cont.60219:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60222
	load    9($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60224
	li      1, $i1
	b       be_cont.60225
be_else.60224:
	li      0, $i1
be_cont.60225:
	b       be_cont.60223
be_else.60222:
	load    9($sp), $i1
	load    6($i1), $i1
be_cont.60223:
	b       be_cont.60217
be_else.60216:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60226
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
	store   $i1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fisneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60228
	b       be_cont.60229
be_else.60228:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60230
	li      1, $i1
	b       be_cont.60231
be_else.60230:
	li      0, $i1
be_cont.60231:
be_cont.60229:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60232
	li      1, $i1
	b       be_cont.60233
be_else.60232:
	li      0, $i1
be_cont.60233:
	b       be_cont.60227
be_else.60226:
	store   $f1, 11($sp)
	store   $f3, 7($sp)
	store   $f2, 8($sp)
	store   $i1, 9($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fsqr
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    9($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 12($sp)
	load    8($sp), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fsqr
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    9($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 13($sp)
	load    7($sp), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fsqr
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    9($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    13($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60234
	b       be_cont.60235
be_else.60234:
	load    7($sp), $f2
	load    8($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    11($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60235:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60236
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60237
be_else.60236:
be_cont.60237:
	load    6($i1), $i1
	store   $i1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fisneg
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60238
	b       be_cont.60239
be_else.60238:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60240
	li      1, $i1
	b       be_cont.60241
be_else.60240:
	li      0, $i1
be_cont.60241:
be_cont.60239:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60242
	li      1, $i1
	b       be_cont.60243
be_else.60242:
	li      0, $i1
be_cont.60243:
be_cont.60227:
be_cont.60217:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60244
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60245
	li      1, $i1
	ret
be_else.60245:
	store   $i1, 15($sp)
	load    4($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i1
	load    3($sp), $f1
	load    2($sp), $f2
	load    1($sp), $f3
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     is_outside.3034
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60246
	load    15($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60247
	li      1, $i1
	ret
be_else.60247:
	store   $i1, 16($sp)
	load    4($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f1
	load    3($sp), $f2
	fsub    $f2, $f1, $f1
	load    5($i1), $i2
	load    1($i2), $f2
	load    2($sp), $f3
	fsub    $f3, $f2, $f2
	load    5($i1), $i2
	load    2($i2), $f3
	load    1($sp), $f4
	fsub    $f4, $f3, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60248
	store   $f3, 17($sp)
	store   $f2, 18($sp)
	store   $i1, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fabs
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60250
	li      0, $i1
	b       be_cont.60251
be_else.60250:
	load    18($sp), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fabs
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60252
	li      0, $i1
	b       be_cont.60253
be_else.60252:
	load    17($sp), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fabs
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.60253:
be_cont.60251:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60254
	load    19($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60256
	li      1, $i1
	b       be_cont.60257
be_else.60256:
	li      0, $i1
be_cont.60257:
	b       be_cont.60255
be_else.60254:
	load    19($sp), $i1
	load    6($i1), $i1
be_cont.60255:
	b       be_cont.60249
be_else.60248:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60258
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
	store   $i1, 20($sp)
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fisneg
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    20($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60260
	b       be_cont.60261
be_else.60260:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60262
	li      1, $i1
	b       be_cont.60263
be_else.60262:
	li      0, $i1
be_cont.60263:
be_cont.60261:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60264
	li      1, $i1
	b       be_cont.60265
be_else.60264:
	li      0, $i1
be_cont.60265:
	b       be_cont.60259
be_else.60258:
	store   $f1, 21($sp)
	store   $f3, 17($sp)
	store   $f2, 18($sp)
	store   $i1, 19($sp)
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fsqr
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    19($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 22($sp)
	load    18($sp), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fsqr
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    19($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    22($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 23($sp)
	load    17($sp), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fsqr
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    19($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    23($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60266
	b       be_cont.60267
be_else.60266:
	load    17($sp), $f2
	load    18($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    21($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60267:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60268
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60269
be_else.60268:
be_cont.60269:
	load    6($i1), $i1
	store   $i1, 24($sp)
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fisneg
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60270
	b       be_cont.60271
be_else.60270:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60272
	li      1, $i1
	b       be_cont.60273
be_else.60272:
	li      0, $i1
be_cont.60273:
be_cont.60271:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60274
	li      1, $i1
	b       be_cont.60275
be_else.60274:
	li      0, $i1
be_cont.60275:
be_cont.60259:
be_cont.60249:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60276
	load    16($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60277
	li      1, $i1
	ret
be_else.60277:
	store   $i1, 25($sp)
	load    4($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i1
	load    3($sp), $f1
	load    2($sp), $f2
	load    1($sp), $f3
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     is_outside.3034
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60278
	load    25($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $f1
	load    2($sp), $f2
	load    1($sp), $f3
	load    5($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60278:
	li      0, $i1
	ret
be_else.60276:
	li      0, $i1
	ret
be_else.60246:
	li      0, $i1
	ret
be_else.60244:
	li      0, $i1
	ret
shadow_check_and_group.3045:
	store   $i11, 0($sp)
	load    11($i11), $i3
	load    10($i11), $i4
	store   $i4, 1($sp)
	load    9($i11), $i4
	load    8($i11), $i5
	load    7($i11), $i6
	load    6($i11), $i7
	load    5($i11), $i8
	load    4($i11), $i9
	store   $i9, 2($sp)
	load    3($i11), $i9
	load    2($i11), $i10
	load    1($i11), $i11
	store   $i11, 3($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i11
	li      -1, $i12
	cmp     $i11, $i12, $i12
	bne     $i12, be_else.60279
	li      0, $i1
	ret
be_else.60279:
	store   $i9, 4($sp)
	store   $i2, 5($sp)
	store   $i1, 6($sp)
	store   $i7, 7($sp)
	store   $i6, 8($sp)
	store   $i5, 9($sp)
	store   $i8, 10($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 11($sp)
	add     $i7, $i1, $i12
	load    0($i12), $i2
	load    0($i9), $f1
	load    5($i2), $i5
	load    0($i5), $f2
	fsub    $f1, $f2, $f1
	load    1($i9), $f2
	load    5($i2), $i5
	load    1($i5), $f3
	fsub    $f2, $f3, $f2
	load    2($i9), $f3
	load    5($i2), $i5
	load    2($i5), $f4
	fsub    $f3, $f4, $f3
	add     $i10, $i1, $i12
	load    0($i12), $i1
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.60280
	mov     $i4, $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i2, $i1
	mov     $i10, $i2
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.60282, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.60282:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	b       be_cont.60281
be_else.60280:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.60283
	store   $f3, 12($sp)
	store   $f2, 13($sp)
	store   $f1, 14($sp)
	store   $i1, 15($sp)
	load    0($i1), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fisneg
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60285
	li      0, $i1
	b       be_cont.60286
be_else.60285:
	load    15($sp), $i1
	load    1($i1), $f1
	load    14($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    13($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    12($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    8($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60286:
	b       be_cont.60284
be_else.60283:
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.60287, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.60287:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.60284:
be_cont.60281:
	load    8($sp), $i2
	load    0($i2), $f1
	store   $f1, 16($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60288
	li      0, $i1
	b       be_cont.60289
be_else.60288:
	li      l.26052, $i1
	load    0($i1), $f2
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fless
	sub     $sp, 18, $sp
	load    17($sp), $ra
be_cont.60289:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60290
	load    11($sp), $i1
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60291
	li      0, $i1
	ret
be_else.60291:
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60292
	li      0, $i1
	ret
be_else.60292:
	store   $i1, 17($sp)
	add     $i3, $i1, $i12
	load    0($i12), $i1
	store   $i1, 18($sp)
	load    10($sp), $i2
	load    4($sp), $i3
	load    9($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.60293, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.60293:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    8($sp), $i2
	load    0($i2), $f1
	store   $f1, 19($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60294
	li      0, $i1
	b       be_cont.60295
be_else.60294:
	li      l.26052, $i1
	load    0($i1), $f2
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.60295:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60296
	load    18($sp), $i1
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60297
	li      0, $i1
	ret
be_else.60297:
	load    17($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60296:
	li      l.26054, $i1
	load    0($i1), $f1
	load    19($sp), $f2
	fadd    $f2, $f1, $f1
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    4($sp), $i2
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
	load    5($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60298
	li      1, $i1
	b       be_cont.60299
be_else.60298:
	store   $f1, 20($sp)
	store   $f3, 21($sp)
	store   $f2, 22($sp)
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	load    5($i1), $i2
	load    1($i2), $f4
	fsub    $f3, $f4, $f3
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f1, $f4, $f1
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60300
	store   $f1, 23($sp)
	store   $f3, 24($sp)
	store   $i1, 25($sp)
	mov     $f2, $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fabs
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    25($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fless
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60302
	li      0, $i1
	b       be_cont.60303
be_else.60302:
	load    24($sp), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fabs
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    25($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fless
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60304
	li      0, $i1
	b       be_cont.60305
be_else.60304:
	load    23($sp), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fabs
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    25($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fless
	sub     $sp, 27, $sp
	load    26($sp), $ra
be_cont.60305:
be_cont.60303:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60306
	load    25($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60308
	li      1, $i1
	b       be_cont.60309
be_else.60308:
	li      0, $i1
be_cont.60309:
	b       be_cont.60307
be_else.60306:
	load    25($sp), $i1
	load    6($i1), $i1
be_cont.60307:
	b       be_cont.60301
be_else.60300:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60310
	load    4($i1), $i2
	load    0($i2), $f4
	fmul    $f4, $f2, $f2
	load    1($i2), $f4
	fmul    $f4, $f3, $f3
	fadd    $f2, $f3, $f2
	load    2($i2), $f3
	fmul    $f3, $f1, $f1
	fadd    $f2, $f1, $f1
	load    6($i1), $i1
	store   $i1, 26($sp)
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fisneg
	sub     $sp, 28, $sp
	load    27($sp), $ra
	load    26($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60312
	b       be_cont.60313
be_else.60312:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60314
	li      1, $i1
	b       be_cont.60315
be_else.60314:
	li      0, $i1
be_cont.60315:
be_cont.60313:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60316
	li      1, $i1
	b       be_cont.60317
be_else.60316:
	li      0, $i1
be_cont.60317:
	b       be_cont.60311
be_else.60310:
	store   $f2, 27($sp)
	store   $f1, 23($sp)
	store   $f3, 24($sp)
	store   $i1, 25($sp)
	mov     $f2, $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fsqr
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    25($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 28($sp)
	load    24($sp), $f1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_fsqr
	sub     $sp, 30, $sp
	load    29($sp), $ra
	load    25($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    28($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 29($sp)
	load    23($sp), $f1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_fsqr
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    25($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    29($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60318
	b       be_cont.60319
be_else.60318:
	load    23($sp), $f2
	load    24($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    27($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60319:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60320
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60321
be_else.60320:
be_cont.60321:
	load    6($i1), $i1
	store   $i1, 30($sp)
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fisneg
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    30($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60322
	b       be_cont.60323
be_else.60322:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60324
	li      1, $i1
	b       be_cont.60325
be_else.60324:
	li      0, $i1
be_cont.60325:
be_cont.60323:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60326
	li      1, $i1
	b       be_cont.60327
be_else.60326:
	li      0, $i1
be_cont.60327:
be_cont.60311:
be_cont.60301:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60328
	load    5($sp), $i2
	load    1($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60330
	li      1, $i1
	b       be_cont.60331
be_else.60330:
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    22($sp), $f1
	load    21($sp), $f2
	load    20($sp), $f3
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     is_outside.3034
	sub     $sp, 32, $sp
	load    31($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60332
	li      2, $i1
	load    22($sp), $f1
	load    21($sp), $f2
	load    20($sp), $f3
	load    5($sp), $i2
	load    3($sp), $i11
	store   $ra, 31($sp)
	load    0($i11), $i10
	li      cls.60334, $ra
	add     $sp, 32, $sp
	jr      $i10
cls.60334:
	sub     $sp, 32, $sp
	load    31($sp), $ra
	b       be_cont.60333
be_else.60332:
	li      0, $i1
be_cont.60333:
be_cont.60331:
	b       be_cont.60329
be_else.60328:
	li      0, $i1
be_cont.60329:
be_cont.60299:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60335
	load    17($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60335:
	li      1, $i1
	ret
be_else.60290:
	li      l.26054, $i1
	load    0($i1), $f1
	load    16($sp), $f2
	fadd    $f2, $f1, $f1
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    4($sp), $i3
	load    0($i3), $f3
	fadd    $f2, $f3, $f2
	load    1($i1), $f3
	fmul    $f3, $f1, $f3
	load    1($i3), $f4
	fadd    $f3, $f4, $f3
	load    2($i1), $f4
	fmul    $f4, $f1, $f1
	load    2($i3), $f4
	fadd    $f1, $f4, $f1
	load    5($sp), $i1
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60336
	li      1, $i1
	b       be_cont.60337
be_else.60336:
	store   $f1, 31($sp)
	store   $f3, 32($sp)
	store   $f2, 33($sp)
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i1
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     is_outside.3034
	sub     $sp, 35, $sp
	load    34($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60338
	load    5($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60340
	li      1, $i1
	b       be_cont.60341
be_else.60340:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f1
	load    33($sp), $f2
	fsub    $f2, $f1, $f1
	load    5($i1), $i2
	load    1($i2), $f2
	load    32($sp), $f3
	fsub    $f3, $f2, $f2
	load    5($i1), $i2
	load    2($i2), $f3
	load    31($sp), $f4
	fsub    $f4, $f3, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60342
	store   $f3, 34($sp)
	store   $f2, 35($sp)
	store   $i1, 36($sp)
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fabs
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    36($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fless
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60344
	li      0, $i1
	b       be_cont.60345
be_else.60344:
	load    35($sp), $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fabs
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    36($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fless
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60346
	li      0, $i1
	b       be_cont.60347
be_else.60346:
	load    34($sp), $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fabs
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    36($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fless
	sub     $sp, 38, $sp
	load    37($sp), $ra
be_cont.60347:
be_cont.60345:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60348
	load    36($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60350
	li      1, $i1
	b       be_cont.60351
be_else.60350:
	li      0, $i1
be_cont.60351:
	b       be_cont.60349
be_else.60348:
	load    36($sp), $i1
	load    6($i1), $i1
be_cont.60349:
	b       be_cont.60343
be_else.60342:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60352
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
	store   $i1, 37($sp)
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_fisneg
	sub     $sp, 39, $sp
	load    38($sp), $ra
	load    37($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60354
	b       be_cont.60355
be_else.60354:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60356
	li      1, $i1
	b       be_cont.60357
be_else.60356:
	li      0, $i1
be_cont.60357:
be_cont.60355:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60358
	li      1, $i1
	b       be_cont.60359
be_else.60358:
	li      0, $i1
be_cont.60359:
	b       be_cont.60353
be_else.60352:
	store   $f1, 38($sp)
	store   $f3, 34($sp)
	store   $f2, 35($sp)
	store   $i1, 36($sp)
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fsqr
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    36($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 39($sp)
	load    35($sp), $f1
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_fsqr
	sub     $sp, 41, $sp
	load    40($sp), $ra
	load    36($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    39($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 40($sp)
	load    34($sp), $f1
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_fsqr
	sub     $sp, 42, $sp
	load    41($sp), $ra
	load    36($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    40($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60360
	b       be_cont.60361
be_else.60360:
	load    34($sp), $f2
	load    35($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    38($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60361:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60362
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60363
be_else.60362:
be_cont.60363:
	load    6($i1), $i1
	store   $i1, 41($sp)
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     min_caml_fisneg
	sub     $sp, 43, $sp
	load    42($sp), $ra
	load    41($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60364
	b       be_cont.60365
be_else.60364:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60366
	li      1, $i1
	b       be_cont.60367
be_else.60366:
	li      0, $i1
be_cont.60367:
be_cont.60365:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60368
	li      1, $i1
	b       be_cont.60369
be_else.60368:
	li      0, $i1
be_cont.60369:
be_cont.60353:
be_cont.60343:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60370
	load    5($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60372
	li      1, $i1
	b       be_cont.60373
be_else.60372:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    33($sp), $f1
	load    32($sp), $f2
	load    31($sp), $f3
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     is_outside.3034
	sub     $sp, 43, $sp
	load    42($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60374
	li      3, $i1
	load    33($sp), $f1
	load    32($sp), $f2
	load    31($sp), $f3
	load    5($sp), $i2
	load    3($sp), $i11
	store   $ra, 42($sp)
	load    0($i11), $i10
	li      cls.60376, $ra
	add     $sp, 43, $sp
	jr      $i10
cls.60376:
	sub     $sp, 43, $sp
	load    42($sp), $ra
	b       be_cont.60375
be_else.60374:
	li      0, $i1
be_cont.60375:
be_cont.60373:
	b       be_cont.60371
be_else.60370:
	li      0, $i1
be_cont.60371:
be_cont.60341:
	b       be_cont.60339
be_else.60338:
	li      0, $i1
be_cont.60339:
be_cont.60337:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60377
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60378
	li      0, $i1
	ret
be_else.60378:
	store   $i1, 42($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 43($sp)
	load    10($sp), $i2
	load    4($sp), $i3
	load    9($sp), $i11
	store   $ra, 44($sp)
	load    0($i11), $i10
	li      cls.60379, $ra
	add     $sp, 45, $sp
	jr      $i10
cls.60379:
	sub     $sp, 45, $sp
	load    44($sp), $ra
	load    8($sp), $i2
	load    0($i2), $f1
	store   $f1, 44($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60380
	li      0, $i1
	b       be_cont.60381
be_else.60380:
	li      l.26052, $i1
	load    0($i1), $f2
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fless
	sub     $sp, 46, $sp
	load    45($sp), $ra
be_cont.60381:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60382
	load    43($sp), $i1
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60383
	li      0, $i1
	ret
be_else.60383:
	load    42($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60382:
	li      l.26054, $i1
	load    0($i1), $f1
	load    44($sp), $f2
	fadd    $f2, $f1, $f1
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    4($sp), $i2
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
	load    5($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60384
	li      1, $i1
	b       be_cont.60385
be_else.60384:
	store   $f1, 45($sp)
	store   $f3, 46($sp)
	store   $f2, 47($sp)
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	load    5($i1), $i2
	load    1($i2), $f4
	fsub    $f3, $f4, $f3
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f1, $f4, $f1
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60386
	store   $f1, 48($sp)
	store   $f3, 49($sp)
	store   $i1, 50($sp)
	mov     $f2, $f1
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fabs
	sub     $sp, 52, $sp
	load    51($sp), $ra
	load    50($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fless
	sub     $sp, 52, $sp
	load    51($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60388
	li      0, $i1
	b       be_cont.60389
be_else.60388:
	load    49($sp), $f1
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fabs
	sub     $sp, 52, $sp
	load    51($sp), $ra
	load    50($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fless
	sub     $sp, 52, $sp
	load    51($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60390
	li      0, $i1
	b       be_cont.60391
be_else.60390:
	load    48($sp), $f1
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fabs
	sub     $sp, 52, $sp
	load    51($sp), $ra
	load    50($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fless
	sub     $sp, 52, $sp
	load    51($sp), $ra
be_cont.60391:
be_cont.60389:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60392
	load    50($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60394
	li      1, $i1
	b       be_cont.60395
be_else.60394:
	li      0, $i1
be_cont.60395:
	b       be_cont.60393
be_else.60392:
	load    50($sp), $i1
	load    6($i1), $i1
be_cont.60393:
	b       be_cont.60387
be_else.60386:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60396
	load    4($i1), $i2
	load    0($i2), $f4
	fmul    $f4, $f2, $f2
	load    1($i2), $f4
	fmul    $f4, $f3, $f3
	fadd    $f2, $f3, $f2
	load    2($i2), $f3
	fmul    $f3, $f1, $f1
	fadd    $f2, $f1, $f1
	load    6($i1), $i1
	store   $i1, 51($sp)
	store   $ra, 52($sp)
	add     $sp, 53, $sp
	jal     min_caml_fisneg
	sub     $sp, 53, $sp
	load    52($sp), $ra
	load    51($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60398
	b       be_cont.60399
be_else.60398:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60400
	li      1, $i1
	b       be_cont.60401
be_else.60400:
	li      0, $i1
be_cont.60401:
be_cont.60399:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60402
	li      1, $i1
	b       be_cont.60403
be_else.60402:
	li      0, $i1
be_cont.60403:
	b       be_cont.60397
be_else.60396:
	store   $f2, 52($sp)
	store   $f1, 48($sp)
	store   $f3, 49($sp)
	store   $i1, 50($sp)
	mov     $f2, $f1
	store   $ra, 53($sp)
	add     $sp, 54, $sp
	jal     min_caml_fsqr
	sub     $sp, 54, $sp
	load    53($sp), $ra
	load    50($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 53($sp)
	load    49($sp), $f1
	store   $ra, 54($sp)
	add     $sp, 55, $sp
	jal     min_caml_fsqr
	sub     $sp, 55, $sp
	load    54($sp), $ra
	load    50($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    53($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 54($sp)
	load    48($sp), $f1
	store   $ra, 55($sp)
	add     $sp, 56, $sp
	jal     min_caml_fsqr
	sub     $sp, 56, $sp
	load    55($sp), $ra
	load    50($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    54($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60404
	b       be_cont.60405
be_else.60404:
	load    48($sp), $f2
	load    49($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    52($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60405:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60406
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60407
be_else.60406:
be_cont.60407:
	load    6($i1), $i1
	store   $i1, 55($sp)
	store   $ra, 56($sp)
	add     $sp, 57, $sp
	jal     min_caml_fisneg
	sub     $sp, 57, $sp
	load    56($sp), $ra
	load    55($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60408
	b       be_cont.60409
be_else.60408:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60410
	li      1, $i1
	b       be_cont.60411
be_else.60410:
	li      0, $i1
be_cont.60411:
be_cont.60409:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60412
	li      1, $i1
	b       be_cont.60413
be_else.60412:
	li      0, $i1
be_cont.60413:
be_cont.60397:
be_cont.60387:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60414
	load    5($sp), $i2
	load    1($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60416
	li      1, $i1
	b       be_cont.60417
be_else.60416:
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    47($sp), $f1
	load    46($sp), $f2
	load    45($sp), $f3
	store   $ra, 56($sp)
	add     $sp, 57, $sp
	jal     is_outside.3034
	sub     $sp, 57, $sp
	load    56($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60418
	li      2, $i1
	load    47($sp), $f1
	load    46($sp), $f2
	load    45($sp), $f3
	load    5($sp), $i2
	load    3($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.60420, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.60420:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	b       be_cont.60419
be_else.60418:
	li      0, $i1
be_cont.60419:
be_cont.60417:
	b       be_cont.60415
be_else.60414:
	li      0, $i1
be_cont.60415:
be_cont.60385:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60421
	load    42($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60421:
	li      1, $i1
	ret
be_else.60377:
	li      1, $i1
	ret
shadow_check_one_or_group.3048:
	load    9($i11), $i3
	load    8($i11), $i4
	load    7($i11), $i5
	load    6($i11), $i6
	load    5($i11), $i7
	load    4($i11), $i8
	store   $i8, 0($sp)
	load    3($i11), $i8
	load    2($i11), $i9
	store   $i9, 1($sp)
	load    1($i11), $i9
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60422
	li      0, $i1
	ret
be_else.60422:
	store   $i11, 2($sp)
	store   $i5, 3($sp)
	store   $i9, 4($sp)
	store   $i2, 5($sp)
	store   $i1, 6($sp)
	store   $i6, 7($sp)
	add     $i9, $i10, $i12
	load    0($i12), $i1
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60423
	li      0, $i1
	b       be_cont.60424
be_else.60423:
	store   $i8, 8($sp)
	store   $i1, 9($sp)
	store   $i4, 10($sp)
	load    0($i1), $i1
	store   $i1, 11($sp)
	mov     $i7, $i2
	mov     $i3, $i11
	mov     $i8, $i3
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.60425, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.60425:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    10($sp), $i2
	load    0($i2), $f1
	store   $f1, 12($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60426
	li      0, $i1
	b       be_cont.60427
be_else.60426:
	li      l.26052, $i1
	load    0($i1), $f2
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fless
	sub     $sp, 14, $sp
	load    13($sp), $ra
be_cont.60427:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60428
	load    11($sp), $i1
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60430
	li      0, $i1
	b       be_cont.60431
be_else.60430:
	li      1, $i1
	load    9($sp), $i2
	load    3($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60432, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60432:
	sub     $sp, 14, $sp
	load    13($sp), $ra
be_cont.60431:
	b       be_cont.60429
be_else.60428:
	li      l.26054, $i1
	load    0($i1), $f1
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
	load    0($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    8($sp), $i2
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
	load    9($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60433
	li      1, $i1
	b       be_cont.60434
be_else.60433:
	store   $f1, 13($sp)
	store   $f3, 14($sp)
	store   $f2, 15($sp)
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f4
	fsub    $f2, $f4, $f2
	load    5($i1), $i2
	load    1($i2), $f4
	fsub    $f3, $f4, $f3
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f1, $f4, $f1
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60435
	store   $f1, 16($sp)
	store   $f3, 17($sp)
	store   $i1, 18($sp)
	mov     $f2, $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fabs
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fless
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60437
	li      0, $i1
	b       be_cont.60438
be_else.60437:
	load    17($sp), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fabs
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fless
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60439
	li      0, $i1
	b       be_cont.60440
be_else.60439:
	load    16($sp), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fabs
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fless
	sub     $sp, 20, $sp
	load    19($sp), $ra
be_cont.60440:
be_cont.60438:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60441
	load    18($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60443
	li      1, $i1
	b       be_cont.60444
be_else.60443:
	li      0, $i1
be_cont.60444:
	b       be_cont.60442
be_else.60441:
	load    18($sp), $i1
	load    6($i1), $i1
be_cont.60442:
	b       be_cont.60436
be_else.60435:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60445
	load    4($i1), $i2
	load    0($i2), $f4
	fmul    $f4, $f2, $f2
	load    1($i2), $f4
	fmul    $f4, $f3, $f3
	fadd    $f2, $f3, $f2
	load    2($i2), $f3
	fmul    $f3, $f1, $f1
	fadd    $f2, $f1, $f1
	load    6($i1), $i1
	store   $i1, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fisneg
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60447
	b       be_cont.60448
be_else.60447:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60449
	li      1, $i1
	b       be_cont.60450
be_else.60449:
	li      0, $i1
be_cont.60450:
be_cont.60448:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60451
	li      1, $i1
	b       be_cont.60452
be_else.60451:
	li      0, $i1
be_cont.60452:
	b       be_cont.60446
be_else.60445:
	store   $f2, 20($sp)
	store   $f1, 16($sp)
	store   $f3, 17($sp)
	store   $i1, 18($sp)
	mov     $f2, $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fsqr
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    18($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 21($sp)
	load    17($sp), $f1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fsqr
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    18($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    21($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 22($sp)
	load    16($sp), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fsqr
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    18($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    22($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60453
	b       be_cont.60454
be_else.60453:
	load    16($sp), $f2
	load    17($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    20($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60454:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60455
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60456
be_else.60455:
be_cont.60456:
	load    6($i1), $i1
	store   $i1, 23($sp)
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fisneg
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    23($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60457
	b       be_cont.60458
be_else.60457:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60459
	li      1, $i1
	b       be_cont.60460
be_else.60459:
	li      0, $i1
be_cont.60460:
be_cont.60458:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60461
	li      1, $i1
	b       be_cont.60462
be_else.60461:
	li      0, $i1
be_cont.60462:
be_cont.60446:
be_cont.60436:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60463
	load    9($sp), $i2
	load    1($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60465
	li      1, $i1
	b       be_cont.60466
be_else.60465:
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    15($sp), $f1
	load    14($sp), $f2
	load    13($sp), $f3
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     is_outside.3034
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60467
	li      2, $i1
	load    15($sp), $f1
	load    14($sp), $f2
	load    13($sp), $f3
	load    9($sp), $i2
	load    1($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.60469, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.60469:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       be_cont.60468
be_else.60467:
	li      0, $i1
be_cont.60468:
be_cont.60466:
	b       be_cont.60464
be_else.60463:
	li      0, $i1
be_cont.60464:
be_cont.60434:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60470
	li      1, $i1
	load    9($sp), $i2
	load    3($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.60472, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.60472:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       be_cont.60471
be_else.60470:
	li      1, $i1
be_cont.60471:
be_cont.60429:
be_cont.60424:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60473
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60474
	li      0, $i1
	ret
be_else.60474:
	store   $i1, 24($sp)
	load    4($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    3($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60475, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60475:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60476
	load    24($sp), $i1
	add     $i1, 1, $i1
	load    5($sp), $i2
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60476:
	li      1, $i1
	ret
be_else.60473:
	li      1, $i1
	ret
shadow_check_one_or_matrix.3051:
	load    12($i11), $i3
	store   $i3, 0($sp)
	load    11($i11), $i3
	store   $i3, 1($sp)
	load    10($i11), $i3
	store   $i3, 2($sp)
	load    9($i11), $i3
	load    8($i11), $i4
	load    7($i11), $i5
	load    6($i11), $i6
	store   $i6, 3($sp)
	load    5($i11), $i6
	store   $i6, 4($sp)
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
	bne     $i12, be_else.60477
	li      0, $i1
	ret
be_else.60477:
	store   $i8, 6($sp)
	store   $i9, 7($sp)
	store   $i4, 8($sp)
	store   $i7, 9($sp)
	store   $i6, 10($sp)
	store   $i3, 11($sp)
	store   $i5, 12($sp)
	store   $i11, 13($sp)
	store   $i2, 14($sp)
	store   $i1, 15($sp)
	li      99, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60478
	li      1, $i1
	b       be_cont.60479
be_else.60478:
	load    4($sp), $i1
	add     $i1, $i10, $i12
	load    0($i12), $i1
	load    0($i7), $f1
	load    5($i1), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	load    1($i7), $f2
	load    5($i1), $i2
	load    1($i2), $f3
	fsub    $f2, $f3, $f2
	load    2($i7), $f3
	load    5($i1), $i2
	load    2($i2), $f4
	fsub    $f3, $f4, $f3
	load    5($sp), $i2
	add     $i2, $i10, $i12
	load    0($i12), $i3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60480
	load    0($sp), $i2
	load    2($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.60482, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.60482:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	b       be_cont.60481
be_else.60480:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60483
	store   $f3, 16($sp)
	store   $f2, 17($sp)
	store   $f1, 18($sp)
	store   $i3, 19($sp)
	load    0($i3), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fisneg
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60485
	li      0, $i1
	b       be_cont.60486
be_else.60485:
	load    19($sp), $i1
	load    1($i1), $f1
	load    18($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    17($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    16($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    8($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60486:
	b       be_cont.60484
be_else.60483:
	load    1($sp), $i11
	mov     $i3, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60487, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60487:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.60484:
be_cont.60481:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60488
	li      0, $i1
	b       be_cont.60489
be_else.60488:
	load    8($sp), $i1
	load    0($i1), $f1
	li      l.26066, $i1
	load    0($i1), $f2
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60490
	li      0, $i1
	b       be_cont.60491
be_else.60490:
	load    7($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60492
	li      0, $i1
	b       be_cont.60493
be_else.60492:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    3($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60494, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60494:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60495
	li      2, $i1
	load    7($sp), $i2
	load    12($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60497, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60497:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	b       be_cont.60496
be_else.60495:
	li      1, $i1
be_cont.60496:
be_cont.60493:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60498
	li      0, $i1
	b       be_cont.60499
be_else.60498:
	li      1, $i1
be_cont.60499:
be_cont.60491:
be_cont.60489:
be_cont.60479:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60500
	load    15($sp), $i1
	add     $i1, 1, $i1
	load    14($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60501
	li      0, $i1
	ret
be_else.60501:
	store   $i3, 20($sp)
	store   $i1, 21($sp)
	li      99, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60502
	li      1, $i1
	b       be_cont.60503
be_else.60502:
	load    10($sp), $i2
	load    9($sp), $i3
	load    11($sp), $i11
	mov     $i4, $i1
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60504, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60504:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60505
	li      0, $i1
	b       be_cont.60506
be_else.60505:
	load    8($sp), $i1
	load    0($i1), $f1
	li      l.26066, $i1
	load    0($i1), $f2
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fless
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60507
	li      0, $i1
	b       be_cont.60508
be_else.60507:
	li      1, $i1
	load    20($sp), $i2
	load    12($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60509, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60509:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60510
	li      0, $i1
	b       be_cont.60511
be_else.60510:
	li      1, $i1
be_cont.60511:
be_cont.60508:
be_cont.60506:
be_cont.60503:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60512
	load    21($sp), $i1
	add     $i1, 1, $i1
	load    14($sp), $i2
	load    13($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60512:
	li      1, $i1
	load    20($sp), $i2
	load    12($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60513, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60513:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60514
	load    21($sp), $i1
	add     $i1, 1, $i1
	load    14($sp), $i2
	load    13($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60514:
	li      1, $i1
	ret
be_else.60500:
	load    7($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60515
	li      0, $i1
	b       be_cont.60516
be_else.60515:
	load    6($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    3($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60517, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60517:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60518
	li      2, $i1
	load    7($sp), $i2
	load    12($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60520, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60520:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	b       be_cont.60519
be_else.60518:
	li      1, $i1
be_cont.60519:
be_cont.60516:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60521
	load    15($sp), $i1
	add     $i1, 1, $i1
	load    14($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60522
	li      0, $i1
	ret
be_else.60522:
	store   $i3, 22($sp)
	store   $i1, 23($sp)
	li      99, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60523
	li      1, $i1
	b       be_cont.60524
be_else.60523:
	load    10($sp), $i2
	load    9($sp), $i3
	load    11($sp), $i11
	mov     $i4, $i1
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.60525, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.60525:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60526
	li      0, $i1
	b       be_cont.60527
be_else.60526:
	load    8($sp), $i1
	load    0($i1), $f1
	li      l.26066, $i1
	load    0($i1), $f2
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fless
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60528
	li      0, $i1
	b       be_cont.60529
be_else.60528:
	li      1, $i1
	load    22($sp), $i2
	load    12($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.60530, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.60530:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60531
	li      0, $i1
	b       be_cont.60532
be_else.60531:
	li      1, $i1
be_cont.60532:
be_cont.60529:
be_cont.60527:
be_cont.60524:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60533
	load    23($sp), $i1
	add     $i1, 1, $i1
	load    14($sp), $i2
	load    13($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60533:
	li      1, $i1
	load    22($sp), $i2
	load    12($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.60534, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.60534:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60535
	load    23($sp), $i1
	add     $i1, 1, $i1
	load    14($sp), $i2
	load    13($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60535:
	li      1, $i1
	ret
be_else.60521:
	li      1, $i1
	ret
solve_each_element.3054:
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
	load    2($i11), $i10
	store   $i10, 2($sp)
	load    1($i11), $i10
	store   $i10, 3($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60536
	ret
be_else.60536:
	store   $i5, 4($sp)
	store   $i7, 5($sp)
	store   $i3, 6($sp)
	store   $i2, 7($sp)
	store   $i11, 8($sp)
	store   $i1, 9($sp)
	store   $i10, 10($sp)
	store   $i8, 11($sp)
	store   $i4, 12($sp)
	store   $i9, 13($sp)
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
	bne     $i12, be_else.60538
	mov     $i3, $i2
	mov     $i6, $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.60540, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.60540:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       be_cont.60539
be_else.60538:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60541
	store   $f3, 14($sp)
	store   $f2, 15($sp)
	store   $f1, 16($sp)
	load    4($i1), $i1
	store   $i1, 17($sp)
	load    0($i3), $f1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($i3), $f2
	load    1($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i3), $f2
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 18($sp)
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fispos
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60543
	li      0, $i1
	b       be_cont.60544
be_else.60543:
	load    17($sp), $i1
	load    0($i1), $f1
	load    16($sp), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    15($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    14($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fneg
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60544:
	b       be_cont.60542
be_else.60541:
	load    0($sp), $i11
	mov     $i3, $i2
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.60545, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.60545:
	sub     $sp, 20, $sp
	load    19($sp), $ra
be_cont.60542:
be_cont.60539:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60546
	load    10($sp), $i1
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60547
	ret
be_else.60547:
	load    9($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    6($sp), $i3
	load    8($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60546:
	store   $i1, 19($sp)
	load    5($sp), $i1
	load    0($i1), $f2
	store   $f2, 20($sp)
	li      l.25703, $i1
	load    0($i1), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fless
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60549
	b       be_cont.60550
be_else.60549:
	load    12($sp), $i1
	load    0($i1), $f2
	load    20($sp), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fless
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60551
	b       be_cont.60552
be_else.60551:
	li      l.26054, $i1
	load    0($i1), $f1
	load    20($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 21($sp)
	load    6($sp), $i3
	load    0($i3), $f2
	fmul    $f2, $f1, $f2
	load    4($sp), $i1
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
	load    7($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60553
	li      1, $i1
	b       be_cont.60554
be_else.60553:
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     is_outside.3034
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60555
	load    7($sp), $i2
	load    1($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60557
	li      1, $i1
	b       be_cont.60558
be_else.60557:
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f1
	load    22($sp), $f2
	fsub    $f2, $f1, $f1
	load    5($i1), $i2
	load    1($i2), $f2
	load    23($sp), $f3
	fsub    $f3, $f2, $f2
	load    5($i1), $i2
	load    2($i2), $f3
	load    24($sp), $f4
	fsub    $f4, $f3, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60559
	store   $f3, 25($sp)
	store   $f2, 26($sp)
	store   $i1, 27($sp)
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fabs
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    27($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fless
	sub     $sp, 29, $sp
	load    28($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60561
	li      0, $i1
	b       be_cont.60562
be_else.60561:
	load    26($sp), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fabs
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    27($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fless
	sub     $sp, 29, $sp
	load    28($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60563
	li      0, $i1
	b       be_cont.60564
be_else.60563:
	load    25($sp), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fabs
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    27($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fless
	sub     $sp, 29, $sp
	load    28($sp), $ra
be_cont.60564:
be_cont.60562:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60565
	load    27($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60567
	li      1, $i1
	b       be_cont.60568
be_else.60567:
	li      0, $i1
be_cont.60568:
	b       be_cont.60566
be_else.60565:
	load    27($sp), $i1
	load    6($i1), $i1
be_cont.60566:
	b       be_cont.60560
be_else.60559:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60569
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
	store   $i1, 28($sp)
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_fisneg
	sub     $sp, 30, $sp
	load    29($sp), $ra
	load    28($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60571
	b       be_cont.60572
be_else.60571:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60573
	li      1, $i1
	b       be_cont.60574
be_else.60573:
	li      0, $i1
be_cont.60574:
be_cont.60572:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60575
	li      1, $i1
	b       be_cont.60576
be_else.60575:
	li      0, $i1
be_cont.60576:
	b       be_cont.60570
be_else.60569:
	store   $f1, 29($sp)
	store   $f3, 25($sp)
	store   $f2, 26($sp)
	store   $i1, 27($sp)
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_fsqr
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    27($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 30($sp)
	load    26($sp), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fsqr
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    27($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    30($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 31($sp)
	load    25($sp), $f1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_fsqr
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    27($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    31($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60577
	b       be_cont.60578
be_else.60577:
	load    25($sp), $f2
	load    26($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    29($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60578:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60579
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60580
be_else.60579:
be_cont.60580:
	load    6($i1), $i1
	store   $i1, 32($sp)
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fisneg
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    32($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60581
	b       be_cont.60582
be_else.60581:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60583
	li      1, $i1
	b       be_cont.60584
be_else.60583:
	li      0, $i1
be_cont.60584:
be_cont.60582:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60585
	li      1, $i1
	b       be_cont.60586
be_else.60585:
	li      0, $i1
be_cont.60586:
be_cont.60570:
be_cont.60560:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60587
	load    7($sp), $i2
	load    2($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60589
	li      1, $i1
	b       be_cont.60590
be_else.60589:
	load    11($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    22($sp), $f1
	load    23($sp), $f2
	load    24($sp), $f3
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     is_outside.3034
	sub     $sp, 34, $sp
	load    33($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60591
	li      3, $i1
	load    22($sp), $f1
	load    23($sp), $f2
	load    24($sp), $f3
	load    7($sp), $i2
	load    3($sp), $i11
	store   $ra, 33($sp)
	load    0($i11), $i10
	li      cls.60593, $ra
	add     $sp, 34, $sp
	jr      $i10
cls.60593:
	sub     $sp, 34, $sp
	load    33($sp), $ra
	b       be_cont.60592
be_else.60591:
	li      0, $i1
be_cont.60592:
be_cont.60590:
	b       be_cont.60588
be_else.60587:
	li      0, $i1
be_cont.60588:
be_cont.60558:
	b       be_cont.60556
be_else.60555:
	li      0, $i1
be_cont.60556:
be_cont.60554:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60594
	b       be_cont.60595
be_else.60594:
	load    12($sp), $i1
	load    21($sp), $f1
	store   $f1, 0($i1)
	load    13($sp), $i1
	load    22($sp), $f1
	store   $f1, 0($i1)
	load    23($sp), $f1
	store   $f1, 1($i1)
	load    24($sp), $f1
	store   $f1, 2($i1)
	load    2($sp), $i1
	load    10($sp), $i2
	store   $i2, 0($i1)
	load    1($sp), $i1
	load    19($sp), $i2
	store   $i2, 0($i1)
be_cont.60595:
be_cont.60552:
be_cont.60550:
	load    9($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    6($sp), $i3
	load    8($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_one_or_network.3058:
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i2, $i1, $i12
	load    0($i12), $i6
	li      -1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.60596
	ret
be_else.60596:
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
	li      cls.60598, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.60598:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60599
	ret
be_else.60599:
	store   $i1, 6($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.60601, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.60601:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60602
	ret
be_else.60602:
	store   $i1, 7($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.60604, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.60604:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60605
	ret
be_else.60605:
	store   $i1, 8($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.60607, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.60607:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60608
	ret
be_else.60608:
	store   $i1, 9($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.60610, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.60610:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60611
	ret
be_else.60611:
	store   $i1, 10($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.60613, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.60613:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60614
	ret
be_else.60614:
	store   $i1, 11($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.60616, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.60616:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60617
	ret
be_else.60617:
	store   $i1, 12($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60619, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60619:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	load    1($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
trace_or_matrix.3062:
	load    10($i11), $i4
	store   $i4, 0($sp)
	load    9($i11), $i4
	load    8($i11), $i5
	store   $i5, 1($sp)
	load    7($i11), $i5
	store   $i5, 2($sp)
	load    6($i11), $i5
	store   $i5, 3($sp)
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	store   $i8, 4($sp)
	load    1($i11), $i8
	add     $i2, $i1, $i12
	load    0($i12), $i9
	load    0($i9), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60620
	ret
be_else.60620:
	store   $i4, 5($sp)
	store   $i5, 6($sp)
	store   $i6, 7($sp)
	store   $i7, 8($sp)
	store   $i8, 9($sp)
	store   $i3, 10($sp)
	store   $i11, 11($sp)
	store   $i2, 12($sp)
	store   $i1, 13($sp)
	li      99, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60622
	load    1($i9), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60624
	b       be_cont.60625
be_else.60624:
	store   $i9, 14($sp)
	add     $i8, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i7, $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60626, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60626:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60627
	b       be_cont.60628
be_else.60627:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60629, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60629:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60630
	b       be_cont.60631
be_else.60630:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60632, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60632:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60633
	b       be_cont.60634
be_else.60633:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60635, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60635:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60636
	b       be_cont.60637
be_else.60636:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60638, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60638:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60639
	b       be_cont.60640
be_else.60639:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60641, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60641:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i1
	load    7($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60642
	b       be_cont.60643
be_else.60642:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60644, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60644:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      8, $i1
	load    14($sp), $i2
	load    10($sp), $i3
	load    7($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60645, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60645:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.60643:
be_cont.60640:
be_cont.60637:
be_cont.60634:
be_cont.60631:
be_cont.60628:
be_cont.60625:
	b       be_cont.60623
be_else.60622:
	store   $i9, 14($sp)
	load    4($sp), $i1
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
	bne     $i12, be_else.60646
	load    2($sp), $i11
	mov     $i3, $i2
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60648, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60648:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       be_cont.60647
be_else.60646:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60649
	store   $f3, 15($sp)
	store   $f2, 16($sp)
	store   $f1, 17($sp)
	load    4($i1), $i1
	store   $i1, 18($sp)
	load    0($i3), $f1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($i3), $f2
	load    1($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i3), $f2
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fispos
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60651
	li      0, $i1
	b       be_cont.60652
be_else.60651:
	load    18($sp), $i1
	load    0($i1), $f1
	load    17($sp), $f2
	fmul    $f1, $f2, $f1
	load    1($i1), $f2
	load    16($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	load    15($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fneg
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    3($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60652:
	b       be_cont.60650
be_else.60649:
	load    1($sp), $i11
	mov     $i3, $i2
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60653, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60653:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.60650:
be_cont.60647:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60654
	b       be_cont.60655
be_else.60654:
	load    3($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60656
	b       be_cont.60657
be_else.60656:
	load    14($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60658
	b       be_cont.60659
be_else.60658:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60660, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60660:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    14($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60661
	b       be_cont.60662
be_else.60661:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60663, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60663:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    14($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60664
	b       be_cont.60665
be_else.60664:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60666, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60666:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    14($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60667
	b       be_cont.60668
be_else.60667:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60669, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60669:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    14($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60670
	b       be_cont.60671
be_else.60670:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60672, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60672:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    14($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60673
	b       be_cont.60674
be_else.60673:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60675, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60675:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    14($sp), $i1
	load    7($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60676
	b       be_cont.60677
be_else.60676:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60678, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60678:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      8, $i1
	load    14($sp), $i2
	load    10($sp), $i3
	load    7($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.60679, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.60679:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.60677:
be_cont.60674:
be_cont.60671:
be_cont.60668:
be_cont.60665:
be_cont.60662:
be_cont.60659:
be_cont.60657:
be_cont.60655:
be_cont.60623:
	load    13($sp), $i1
	add     $i1, 1, $i1
	load    12($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60680
	ret
be_else.60680:
	store   $i1, 20($sp)
	li      99, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60682
	load    1($i3), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60684
	b       be_cont.60685
be_else.60684:
	store   $i3, 21($sp)
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60686, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60686:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60687
	b       be_cont.60688
be_else.60687:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60689, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60689:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60690
	b       be_cont.60691
be_else.60690:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60692, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60692:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60693
	b       be_cont.60694
be_else.60693:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60695, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60695:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60696
	b       be_cont.60697
be_else.60696:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60698, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60698:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60699
	b       be_cont.60700
be_else.60699:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60701, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60701:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      7, $i1
	load    21($sp), $i2
	load    10($sp), $i3
	load    7($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60702, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60702:
	sub     $sp, 23, $sp
	load    22($sp), $ra
be_cont.60700:
be_cont.60697:
be_cont.60694:
be_cont.60691:
be_cont.60688:
be_cont.60685:
	b       be_cont.60683
be_else.60682:
	store   $i3, 21($sp)
	load    10($sp), $i2
	load    5($sp), $i3
	load    6($sp), $i11
	mov     $i4, $i1
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60703, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60703:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60704
	b       be_cont.60705
be_else.60704:
	load    3($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fless
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60706
	b       be_cont.60707
be_else.60706:
	load    21($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60708
	b       be_cont.60709
be_else.60708:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60710, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60710:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60711
	b       be_cont.60712
be_else.60711:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60713, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60713:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60714
	b       be_cont.60715
be_else.60714:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60716, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60716:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60717
	b       be_cont.60718
be_else.60717:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60719, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60719:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60720
	b       be_cont.60721
be_else.60720:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60722, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60722:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60723
	b       be_cont.60724
be_else.60723:
	load    9($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    10($sp), $i3
	load    8($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60725, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60725:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	li      7, $i1
	load    21($sp), $i2
	load    10($sp), $i3
	load    7($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.60726, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.60726:
	sub     $sp, 23, $sp
	load    22($sp), $ra
be_cont.60724:
be_cont.60721:
be_cont.60718:
be_cont.60715:
be_cont.60712:
be_cont.60709:
be_cont.60707:
be_cont.60705:
be_cont.60683:
	load    20($sp), $i1
	add     $i1, 1, $i1
	load    12($sp), $i2
	load    10($sp), $i3
	load    11($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_each_element_fast.3068:
	load    9($i11), $i4
	load    8($i11), $i5
	load    7($i11), $i6
	load    6($i11), $i7
	load    5($i11), $i8
	load    4($i11), $i9
	store   $i9, 0($sp)
	load    3($i11), $i9
	store   $i9, 1($sp)
	load    2($i11), $i9
	store   $i9, 2($sp)
	load    1($i11), $i9
	store   $i9, 3($sp)
	load    0($i3), $i9
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60727
	ret
be_else.60727:
	store   $i7, 4($sp)
	store   $i3, 5($sp)
	store   $i2, 6($sp)
	store   $i11, 7($sp)
	store   $i1, 8($sp)
	store   $i10, 9($sp)
	store   $i8, 10($sp)
	store   $i4, 11($sp)
	store   $i9, 12($sp)
	store   $i5, 13($sp)
	add     $i8, $i10, $i12
	load    0($i12), $i1
	load    10($i1), $i2
	store   $i2, 14($sp)
	load    0($i2), $f1
	load    1($i2), $f2
	load    2($i2), $f3
	load    1($i3), $i2
	add     $i2, $i10, $i12
	load    0($i12), $i2
	load    1($i1), $i4
	li      1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60729
	load    0($i3), $i3
	mov     $i6, $i11
	mov     $i3, $i10
	mov     $i2, $i3
	mov     $i10, $i2
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.60731, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.60731:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       be_cont.60730
be_else.60729:
	li      2, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60732
	store   $i2, 15($sp)
	load    0($i2), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fisneg
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60734
	li      0, $i1
	b       be_cont.60735
be_else.60734:
	load    15($sp), $i1
	load    0($i1), $f1
	load    14($sp), $i1
	load    3($i1), $f2
	fmul    $f1, $f2, $f1
	load    4($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60735:
	b       be_cont.60733
be_else.60732:
	store   $i1, 16($sp)
	store   $f3, 17($sp)
	store   $f2, 18($sp)
	store   $f1, 19($sp)
	store   $i2, 15($sp)
	load    0($i2), $f1
	store   $f1, 20($sp)
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fiszero
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60736
	load    15($sp), $i1
	load    1($i1), $f1
	load    19($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    18($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    17($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 21($sp)
	load    14($sp), $i1
	load    3($i1), $f2
	store   $f2, 22($sp)
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fsqr
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    22($sp), $f2
	load    20($sp), $f3
	fmul    $f3, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 23($sp)
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fispos
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60738
	li      0, $i1
	b       be_cont.60739
be_else.60738:
	load    16($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60740
	load    23($sp), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     sqrt.2729
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    21($sp), $f2
	fsub    $f2, $f1, $f1
	load    15($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    4($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.60741
be_else.60740:
	load    23($sp), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     sqrt.2729
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    21($sp), $f2
	fadd    $f2, $f1, $f1
	load    15($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    4($sp), $i1
	store   $f1, 0($i1)
be_cont.60741:
	li      1, $i1
be_cont.60739:
	b       be_cont.60737
be_else.60736:
	li      0, $i1
be_cont.60737:
be_cont.60733:
be_cont.60730:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60742
	load    9($sp), $i1
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60743
	ret
be_else.60743:
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    6($sp), $i2
	load    5($sp), $i3
	load    7($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.60742:
	store   $i1, 24($sp)
	load    4($sp), $i1
	load    0($i1), $f2
	store   $f2, 25($sp)
	li      l.25703, $i1
	load    0($i1), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fless
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60745
	b       be_cont.60746
be_else.60745:
	load    11($sp), $i1
	load    0($i1), $f2
	load    25($sp), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fless
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60747
	b       be_cont.60748
be_else.60747:
	li      l.26054, $i1
	load    0($i1), $f1
	load    25($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 26($sp)
	load    12($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    13($sp), $i2
	load    0($i2), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 27($sp)
	load    1($i1), $f3
	fmul    $f3, $f1, $f3
	load    1($i2), $f4
	fadd    $f3, $f4, $f3
	store   $f3, 28($sp)
	load    2($i1), $f4
	fmul    $f4, $f1, $f1
	load    2($i2), $f4
	fadd    $f1, $f4, $f1
	store   $f1, 29($sp)
	load    6($sp), $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60749
	li      1, $i1
	b       be_cont.60750
be_else.60749:
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     is_outside.3034
	sub     $sp, 31, $sp
	load    30($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60751
	load    6($sp), $i2
	load    1($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60753
	li      1, $i1
	b       be_cont.60754
be_else.60753:
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    5($i1), $i2
	load    0($i2), $f1
	load    27($sp), $f2
	fsub    $f2, $f1, $f1
	load    5($i1), $i2
	load    1($i2), $f2
	load    28($sp), $f3
	fsub    $f3, $f2, $f2
	load    5($i1), $i2
	load    2($i2), $f3
	load    29($sp), $f4
	fsub    $f4, $f3, $f3
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60755
	store   $f3, 30($sp)
	store   $f2, 31($sp)
	store   $i1, 32($sp)
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fabs
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    32($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fless
	sub     $sp, 34, $sp
	load    33($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60757
	li      0, $i1
	b       be_cont.60758
be_else.60757:
	load    31($sp), $f1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fabs
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    32($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fless
	sub     $sp, 34, $sp
	load    33($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60759
	li      0, $i1
	b       be_cont.60760
be_else.60759:
	load    30($sp), $f1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fabs
	sub     $sp, 34, $sp
	load    33($sp), $ra
	load    32($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f2
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fless
	sub     $sp, 34, $sp
	load    33($sp), $ra
be_cont.60760:
be_cont.60758:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60761
	load    32($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60763
	li      1, $i1
	b       be_cont.60764
be_else.60763:
	li      0, $i1
be_cont.60764:
	b       be_cont.60762
be_else.60761:
	load    32($sp), $i1
	load    6($i1), $i1
be_cont.60762:
	b       be_cont.60756
be_else.60755:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60765
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
	store   $i1, 33($sp)
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fisneg
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    33($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60767
	b       be_cont.60768
be_else.60767:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60769
	li      1, $i1
	b       be_cont.60770
be_else.60769:
	li      0, $i1
be_cont.60770:
be_cont.60768:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60771
	li      1, $i1
	b       be_cont.60772
be_else.60771:
	li      0, $i1
be_cont.60772:
	b       be_cont.60766
be_else.60765:
	store   $f1, 34($sp)
	store   $f3, 30($sp)
	store   $f2, 31($sp)
	store   $i1, 32($sp)
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_fsqr
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    32($sp), $i1
	load    4($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 35($sp)
	load    31($sp), $f1
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_fsqr
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    32($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f2
	fmul    $f1, $f2, $f1
	load    35($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 36($sp)
	load    30($sp), $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fsqr
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    32($sp), $i1
	load    4($i1), $i2
	load    2($i2), $f2
	fmul    $f1, $f2, $f1
	load    36($sp), $f2
	fadd    $f2, $f1, $f1
	load    3($i1), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60773
	b       be_cont.60774
be_else.60773:
	load    30($sp), $f2
	load    31($sp), $f3
	fmul    $f3, $f2, $f4
	load    9($i1), $i2
	load    0($i2), $f5
	fmul    $f4, $f5, $f4
	fadd    $f1, $f4, $f1
	load    34($sp), $f4
	fmul    $f2, $f4, $f2
	load    9($i1), $i2
	load    1($i2), $f5
	fmul    $f2, $f5, $f2
	fadd    $f1, $f2, $f1
	fmul    $f4, $f3, $f2
	load    9($i1), $i2
	load    2($i2), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
be_cont.60774:
	load    1($i1), $i2
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60775
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.60776
be_else.60775:
be_cont.60776:
	load    6($i1), $i1
	store   $i1, 37($sp)
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_fisneg
	sub     $sp, 39, $sp
	load    38($sp), $ra
	load    37($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60777
	b       be_cont.60778
be_else.60777:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60779
	li      1, $i1
	b       be_cont.60780
be_else.60779:
	li      0, $i1
be_cont.60780:
be_cont.60778:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60781
	li      1, $i1
	b       be_cont.60782
be_else.60781:
	li      0, $i1
be_cont.60782:
be_cont.60766:
be_cont.60756:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60783
	load    6($sp), $i2
	load    2($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60785
	li      1, $i1
	b       be_cont.60786
be_else.60785:
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    27($sp), $f1
	load    28($sp), $f2
	load    29($sp), $f3
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     is_outside.3034
	sub     $sp, 39, $sp
	load    38($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60787
	li      3, $i1
	load    27($sp), $f1
	load    28($sp), $f2
	load    29($sp), $f3
	load    6($sp), $i2
	load    3($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.60789, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.60789:
	sub     $sp, 39, $sp
	load    38($sp), $ra
	b       be_cont.60788
be_else.60787:
	li      0, $i1
be_cont.60788:
be_cont.60786:
	b       be_cont.60784
be_else.60783:
	li      0, $i1
be_cont.60784:
be_cont.60754:
	b       be_cont.60752
be_else.60751:
	li      0, $i1
be_cont.60752:
be_cont.60750:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60790
	b       be_cont.60791
be_else.60790:
	load    11($sp), $i1
	load    26($sp), $f1
	store   $f1, 0($i1)
	load    1($sp), $i1
	load    27($sp), $f1
	store   $f1, 0($i1)
	load    28($sp), $f1
	store   $f1, 1($i1)
	load    29($sp), $f1
	store   $f1, 2($i1)
	load    2($sp), $i1
	load    9($sp), $i2
	store   $i2, 0($i1)
	load    0($sp), $i1
	load    24($sp), $i2
	store   $i2, 0($i1)
be_cont.60791:
be_cont.60748:
be_cont.60746:
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    6($sp), $i2
	load    5($sp), $i3
	load    7($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_one_or_network_fast.3072:
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i2, $i1, $i12
	load    0($i12), $i6
	li      -1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.60792
	ret
be_else.60792:
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
	li      cls.60794, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.60794:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60795
	ret
be_else.60795:
	store   $i1, 6($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.60797, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.60797:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60798
	ret
be_else.60798:
	store   $i1, 7($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.60800, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.60800:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60801
	ret
be_else.60801:
	store   $i1, 8($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.60803, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.60803:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60804
	ret
be_else.60804:
	store   $i1, 9($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.60806, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.60806:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60807
	ret
be_else.60807:
	store   $i1, 10($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.60809, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.60809:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60810
	ret
be_else.60810:
	store   $i1, 11($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.60812, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.60812:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60813
	ret
be_else.60813:
	store   $i1, 12($sp)
	load    3($sp), $i1
	add     $i1, $i3, $i12
	load    0($i12), $i2
	li      0, $i1
	load    1($sp), $i3
	load    2($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60815, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60815:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	load    1($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
trace_or_matrix_fast.3076:
	load    8($i11), $i4
	store   $i4, 0($sp)
	load    7($i11), $i4
	store   $i4, 1($sp)
	load    6($i11), $i4
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	store   $i8, 2($sp)
	load    1($i11), $i8
	add     $i2, $i1, $i12
	load    0($i12), $i9
	load    0($i9), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60816
	ret
be_else.60816:
	store   $i5, 3($sp)
	store   $i4, 4($sp)
	store   $i6, 5($sp)
	store   $i7, 6($sp)
	store   $i8, 7($sp)
	store   $i3, 8($sp)
	store   $i11, 9($sp)
	store   $i2, 10($sp)
	store   $i1, 11($sp)
	li      99, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.60818
	load    1($i9), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60820
	b       be_cont.60821
be_else.60820:
	store   $i9, 12($sp)
	add     $i8, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i7, $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60822, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60822:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60823
	b       be_cont.60824
be_else.60823:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60825, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60825:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60826
	b       be_cont.60827
be_else.60826:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60828, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60828:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60829
	b       be_cont.60830
be_else.60829:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60831, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60831:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60832
	b       be_cont.60833
be_else.60832:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60834, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60834:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60835
	b       be_cont.60836
be_else.60835:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60837, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60837:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	load    7($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60838
	b       be_cont.60839
be_else.60838:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60840, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60840:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      8, $i1
	load    12($sp), $i2
	load    8($sp), $i3
	load    5($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60841, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60841:
	sub     $sp, 14, $sp
	load    13($sp), $ra
be_cont.60839:
be_cont.60836:
be_cont.60833:
be_cont.60830:
be_cont.60827:
be_cont.60824:
be_cont.60821:
	b       be_cont.60819
be_else.60818:
	store   $i9, 12($sp)
	load    2($sp), $i1
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
	bne     $i12, be_else.60842
	load    0($i3), $i2
	load    1($sp), $i11
	mov     $i4, $i3
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.60844, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.60844:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	b       be_cont.60843
be_else.60842:
	li      2, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.60845
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	load    0($i4), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fisneg
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60847
	li      0, $i1
	b       be_cont.60848
be_else.60847:
	load    14($sp), $i1
	load    0($i1), $f1
	load    13($sp), $i1
	load    3($i1), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
be_cont.60848:
	b       be_cont.60846
be_else.60845:
	store   $i1, 15($sp)
	store   $i2, 13($sp)
	store   $f3, 16($sp)
	store   $f2, 17($sp)
	store   $f1, 18($sp)
	store   $i4, 14($sp)
	load    0($i4), $f1
	store   $f1, 19($sp)
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fiszero
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60849
	load    14($sp), $i1
	load    1($i1), $f1
	load    18($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    17($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    16($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 20($sp)
	load    13($sp), $i1
	load    3($i1), $f2
	store   $f2, 21($sp)
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fsqr
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $f2
	load    19($sp), $f3
	fmul    $f3, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 22($sp)
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fispos
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60851
	li      0, $i1
	b       be_cont.60852
be_else.60851:
	load    15($sp), $i1
	load    6($i1), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60853
	load    22($sp), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     sqrt.2729
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    20($sp), $f2
	fsub    $f2, $f1, $f1
	load    14($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.60854
be_else.60853:
	load    22($sp), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     sqrt.2729
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    20($sp), $f2
	fadd    $f2, $f1, $f1
	load    14($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $i1
	store   $f1, 0($i1)
be_cont.60854:
	li      1, $i1
be_cont.60852:
	b       be_cont.60850
be_else.60849:
	li      0, $i1
be_cont.60850:
be_cont.60846:
be_cont.60843:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60855
	b       be_cont.60856
be_else.60855:
	load    3($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fless
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60857
	b       be_cont.60858
be_else.60857:
	load    12($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60859
	b       be_cont.60860
be_else.60859:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60861, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60861:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    12($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60862
	b       be_cont.60863
be_else.60862:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60864, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60864:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    12($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60865
	b       be_cont.60866
be_else.60865:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60867, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60867:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    12($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60868
	b       be_cont.60869
be_else.60868:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60870, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60870:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    12($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60871
	b       be_cont.60872
be_else.60871:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60873, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60873:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    12($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60874
	b       be_cont.60875
be_else.60874:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60876, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60876:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    12($sp), $i1
	load    7($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60877
	b       be_cont.60878
be_else.60877:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60879, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60879:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      8, $i1
	load    12($sp), $i2
	load    8($sp), $i3
	load    5($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.60880, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.60880:
	sub     $sp, 24, $sp
	load    23($sp), $ra
be_cont.60878:
be_cont.60875:
be_cont.60872:
be_cont.60869:
be_cont.60866:
be_cont.60863:
be_cont.60860:
be_cont.60858:
be_cont.60856:
be_cont.60819:
	load    11($sp), $i1
	add     $i1, 1, $i1
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60881
	ret
be_else.60881:
	store   $i1, 23($sp)
	li      99, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.60883
	load    1($i3), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60885
	b       be_cont.60886
be_else.60885:
	store   $i3, 24($sp)
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60887, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60887:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60888
	b       be_cont.60889
be_else.60888:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60890, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60890:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60891
	b       be_cont.60892
be_else.60891:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60893, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60893:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60894
	b       be_cont.60895
be_else.60894:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60896, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60896:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60897
	b       be_cont.60898
be_else.60897:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60899, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60899:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60900
	b       be_cont.60901
be_else.60900:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60902, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60902:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      7, $i1
	load    24($sp), $i2
	load    8($sp), $i3
	load    5($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60903, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60903:
	sub     $sp, 26, $sp
	load    25($sp), $ra
be_cont.60901:
be_cont.60898:
be_cont.60895:
be_cont.60892:
be_cont.60889:
be_cont.60886:
	b       be_cont.60884
be_else.60883:
	store   $i3, 24($sp)
	load    8($sp), $i2
	load    4($sp), $i11
	mov     $i4, $i1
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60904, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60904:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60905
	b       be_cont.60906
be_else.60905:
	load    3($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    0($i1), $f2
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fless
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60907
	b       be_cont.60908
be_else.60907:
	load    24($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60909
	b       be_cont.60910
be_else.60909:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60911, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60911:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60912
	b       be_cont.60913
be_else.60912:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60914, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60914:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60915
	b       be_cont.60916
be_else.60915:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60917, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60917:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60918
	b       be_cont.60919
be_else.60918:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60920, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60920:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    5($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60921
	b       be_cont.60922
be_else.60921:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60923, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60923:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	load    6($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60924
	b       be_cont.60925
be_else.60924:
	load    7($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    8($sp), $i3
	load    6($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60926, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60926:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      7, $i1
	load    24($sp), $i2
	load    8($sp), $i3
	load    5($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60927, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60927:
	sub     $sp, 26, $sp
	load    25($sp), $ra
be_cont.60925:
be_cont.60922:
be_cont.60919:
be_cont.60916:
be_cont.60913:
be_cont.60910:
be_cont.60908:
be_cont.60906:
be_cont.60884:
	load    23($sp), $i1
	add     $i1, 1, $i1
	load    10($sp), $i2
	load    8($sp), $i3
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
get_nvector_second.3086:
	store   $i1, 0($sp)
	load    2($i11), $i2
	store   $i2, 1($sp)
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
	bne     $i12, be_else.60928
	store   $f4, 0($i2)
	store   $f5, 1($i2)
	store   $f6, 2($i2)
	b       be_cont.60929
be_else.60928:
	store   $f6, 2($sp)
	store   $f2, 3($sp)
	store   $f5, 4($sp)
	store   $f3, 5($sp)
	store   $f1, 6($sp)
	store   $f4, 7($sp)
	load    9($i1), $i2
	load    2($i2), $f1
	fmul    $f2, $f1, $f1
	load    9($i1), $i1
	load    1($i1), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fhalf
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 0($i1)
	load    0($sp), $i1
	load    9($i1), $i2
	load    2($i2), $f1
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	load    9($i1), $i1
	load    0($i1), $f2
	load    5($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fhalf
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    4($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 1($i1)
	load    0($sp), $i1
	load    9($i1), $i2
	load    1($i2), $f1
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	load    9($i1), $i1
	load    0($i1), $f2
	load    3($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fhalf
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    2($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 2($i1)
be_cont.60929:
	load    0($sp), $i1
	load    6($i1), $i1
	store   $i1, 8($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fsqr
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $f1, 9($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 10($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fsqr
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fiszero
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60930
	load    8($sp), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60932
	li      l.25743, $i1
	load    0($i1), $f1
	load    11($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.60933
be_else.60932:
	li      l.26012, $i1
	load    0($i1), $f1
	load    11($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
be_cont.60933:
	b       be_cont.60931
be_else.60930:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.60931:
	load    1($sp), $i1
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
utexture.3091:
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
	bne     $i12, be_else.60935
	store   $i3, 0($sp)
	store   $i1, 1($sp)
	store   $i2, 2($sp)
	load    0($i2), $f1
	load    5($i1), $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 3($sp)
	li      l.26112, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_floor
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      l.26114, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.25907, $i1
	load    0($i1), $f2
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fless
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	load    2($sp), $i1
	load    2($i1), $f1
	load    1($sp), $i1
	load    5($i1), $i1
	load    2($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 5($sp)
	li      l.26112, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_floor
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.26114, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    5($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.25907, $i1
	load    0($i1), $f2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fless
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    4($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.60936
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60938
	li      l.26096, $i1
	load    0($i1), $f1
	b       be_cont.60939
be_else.60938:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.60939:
	b       be_cont.60937
be_else.60936:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60940
	li      l.25703, $i1
	load    0($i1), $f1
	b       be_cont.60941
be_else.60940:
	li      l.26096, $i1
	load    0($i1), $f1
be_cont.60941:
be_cont.60937:
	load    0($sp), $i1
	store   $f1, 1($i1)
	ret
be_else.60935:
	li      2, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.60943
	store   $i3, 0($sp)
	load    1($i2), $f4
	li      l.26106, $i1
	load    0($i1), $f5
	fmul    $f4, $f5, $f4
	li      l.25703, $i1
	load    0($i1), $f5
	fcmp    $f5, $f4, $i12
	bg      $i12, ble_else.60944
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.60946
	fcmp    $f3, $f4, $i12
	bg      $i12, ble_else.60948
	fcmp    $f2, $f4, $i12
	bg      $i12, ble_else.60950
	fsub    $f4, $f2, $f1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.60952, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.60952:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	b       ble_cont.60951
ble_else.60950:
	fsub    $f2, $f4, $f1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.60953, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.60953:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	fneg    $f1, $f1
ble_cont.60951:
	b       ble_cont.60949
ble_else.60948:
	fsub    $f3, $f4, $f1
	mov     $i6, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.60954, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.60954:
	sub     $sp, 7, $sp
	load    6($sp), $ra
ble_cont.60949:
	b       ble_cont.60947
ble_else.60946:
	mov     $i6, $i11
	mov     $f4, $f1
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.60955, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.60955:
	sub     $sp, 7, $sp
	load    6($sp), $ra
ble_cont.60947:
	b       ble_cont.60945
ble_else.60944:
	fneg    $f4, $f1
	mov     $i4, $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.60956, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.60956:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	fneg    $f1, $f1
ble_cont.60945:
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fsqr
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.26096, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    0($sp), $i1
	store   $f2, 0($i1)
	li      l.26096, $i2
	load    0($i2), $f2
	li      l.25743, $i2
	load    0($i2), $f3
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	store   $f1, 1($i1)
	ret
be_else.60943:
	li      3, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.60958
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
	store   $f2, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fsqr
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $f1, 12($sp)
	load    11($sp), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fsqr
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     sqrt.2729
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      l.25907, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 13($sp)
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_floor
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.26085, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.60959
	load    10($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.60961
	load    9($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.60963
	load    8($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.60965
	fsub    $f1, $f2, $f1
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.60967, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.60967:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       ble_cont.60966
ble_else.60965:
	fsub    $f2, $f1, $f1
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.60968, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.60968:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.60966:
	b       ble_cont.60964
ble_else.60963:
	fsub    $f2, $f1, $f1
	load    6($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.60969, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.60969:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	fneg    $f1, $f1
ble_cont.60964:
	b       ble_cont.60962
ble_else.60961:
	load    6($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.60970, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.60970:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.60962:
	b       ble_cont.60960
ble_else.60959:
	fneg    $f1, $f1
	load    7($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.60971, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.60971:
	sub     $sp, 15, $sp
	load    14($sp), $ra
ble_cont.60960:
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fsqr
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      l.26096, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    0($sp), $i1
	store   $f2, 1($i1)
	li      l.25743, $i2
	load    0($i2), $f2
	fsub    $f2, $f1, $f1
	li      l.26096, $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 2($i1)
	ret
be_else.60958:
	li      4, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.60973
	store   $i3, 0($sp)
	store   $i8, 14($sp)
	store   $i1, 1($sp)
	store   $i2, 2($sp)
	load    0($i2), $f1
	load    5($i1), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 15($sp)
	load    4($i1), $i1
	load    0($i1), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     sqrt.2729
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 16($sp)
	load    2($sp), $i1
	load    2($i1), $f1
	load    1($sp), $i1
	load    5($i1), $i2
	load    2($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 17($sp)
	load    4($i1), $i1
	load    2($i1), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     sqrt.2729
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 18($sp)
	load    16($sp), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fsqr
	sub     $sp, 20, $sp
	load    19($sp), $ra
	store   $f1, 19($sp)
	load    18($sp), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fsqr
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 20($sp)
	load    16($sp), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fabs
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      l.26079, $i1
	load    0($i1), $f2
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fless
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60974
	load    16($sp), $f1
	load    18($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fabs
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    14($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.60976, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.60976:
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      l.26083, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26085, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.60975
be_else.60974:
	li      l.26081, $i1
	load    0($i1), $f1
be_cont.60975:
	store   $f1, 21($sp)
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_floor
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 22($sp)
	load    2($sp), $i1
	load    1($i1), $f1
	load    1($sp), $i1
	load    5($i1), $i2
	load    1($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 23($sp)
	load    4($i1), $i1
	load    1($i1), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     sqrt.2729
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    23($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 24($sp)
	load    20($sp), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fabs
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      l.26079, $i1
	load    0($i1), $f2
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fless
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60977
	load    20($sp), $f1
	load    24($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fabs
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    14($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.60979, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.60979:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      l.26083, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26085, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.60978
be_else.60977:
	li      l.26081, $i1
	load    0($i1), $f1
be_cont.60978:
	store   $f1, 25($sp)
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_floor
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    25($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 26($sp)
	li      l.26091, $i1
	load    0($i1), $f1
	store   $f1, 27($sp)
	li      l.25696, $i1
	load    0($i1), $f1
	load    22($sp), $f2
	fsub    $f1, $f2, $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fsqr
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    27($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 28($sp)
	li      l.25696, $i1
	load    0($i1), $f1
	load    26($sp), $f2
	fsub    $f1, $f2, $f1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_fsqr
	sub     $sp, 30, $sp
	load    29($sp), $ra
	load    28($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 29($sp)
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_fisneg
	sub     $sp, 31, $sp
	load    30($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60980
	load    29($sp), $f1
	b       be_cont.60981
be_else.60980:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.60981:
	li      l.26096, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f1
	li      l.26098, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    0($sp), $i1
	store   $f1, 2($i1)
	ret
be_else.60973:
	ret
trace_reflections.3098:
	load    19($i11), $i3
	load    18($i11), $i4
	load    17($i11), $i5
	store   $i5, 0($sp)
	load    16($i11), $i5
	store   $i5, 1($sp)
	load    15($i11), $i5
	store   $i5, 2($sp)
	load    14($i11), $i5
	store   $i5, 3($sp)
	load    13($i11), $i5
	store   $i5, 4($sp)
	load    12($i11), $i5
	store   $i5, 5($sp)
	load    11($i11), $i5
	load    10($i11), $i6
	store   $i6, 6($sp)
	load    9($i11), $i6
	store   $i6, 7($sp)
	load    8($i11), $i6
	load    7($i11), $i7
	load    6($i11), $i8
	store   $i8, 8($sp)
	load    5($i11), $i8
	store   $i8, 9($sp)
	load    4($i11), $i8
	load    3($i11), $i9
	store   $i9, 10($sp)
	load    2($i11), $i9
	load    1($i11), $i10
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.60984
	store   $i3, 11($sp)
	store   $i9, 12($sp)
	store   $f2, 13($sp)
	store   $f1, 14($sp)
	store   $i2, 15($sp)
	store   $i11, 16($sp)
	store   $i7, 17($sp)
	store   $i6, 18($sp)
	store   $i1, 19($sp)
	store   $i4, 20($sp)
	store   $i8, 21($sp)
	store   $i5, 22($sp)
	store   $i10, 23($sp)
	add     $i6, $i1, $i12
	load    0($i12), $i1
	store   $i1, 24($sp)
	load    1($i1), $i1
	store   $i1, 25($sp)
	li      l.26124, $i2
	load    0($i2), $f1
	store   $f1, 0($i4)
	li      0, $i2
	load    0($i7), $i4
	mov     $i3, $i11
	mov     $i1, $i3
	mov     $i2, $i1
	mov     $i4, $i2
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.60985, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.60985:
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    20($sp), $i1
	load    0($i1), $f2
	store   $f2, 26($sp)
	li      l.26066, $i1
	load    0($i1), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fless
	sub     $sp, 28, $sp
	load    27($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60986
	li      0, $i1
	b       be_cont.60987
be_else.60986:
	li      l.26127, $i1
	load    0($i1), $f2
	load    26($sp), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fless
	sub     $sp, 28, $sp
	load    27($sp), $ra
be_cont.60987:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60988
	b       be_cont.60989
be_else.60988:
	load    12($sp), $i1
	load    0($i1), $i1
	sll     $i1, 2, $i1
	load    21($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	load    24($sp), $i2
	load    0($i2), $i3
	cmp     $i1, $i3, $i12
	bne     $i12, be_else.60990
	load    17($sp), $i1
	load    0($i1), $i2
	load    0($i2), $i1
	load    0($i1), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60992
	li      0, $i1
	b       be_cont.60993
be_else.60992:
	store   $i1, 27($sp)
	store   $i2, 28($sp)
	li      99, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.60994
	li      1, $i1
	b       be_cont.60995
be_else.60994:
	load    9($sp), $i2
	load    10($sp), $i1
	load    2($sp), $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 29($sp)
	load    0($i11), $i10
	li      cls.60996, $ra
	add     $sp, 30, $sp
	jr      $i10
cls.60996:
	sub     $sp, 30, $sp
	load    29($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60997
	li      0, $i1
	b       be_cont.60998
be_else.60997:
	load    3($sp), $i1
	load    0($i1), $f1
	li      l.26066, $i1
	load    0($i1), $f2
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_fless
	sub     $sp, 30, $sp
	load    29($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.60999
	li      0, $i1
	b       be_cont.61000
be_else.60999:
	li      1, $i1
	load    27($sp), $i2
	load    6($sp), $i11
	store   $ra, 29($sp)
	load    0($i11), $i10
	li      cls.61001, $ra
	add     $sp, 30, $sp
	jr      $i10
cls.61001:
	sub     $sp, 30, $sp
	load    29($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61002
	li      0, $i1
	b       be_cont.61003
be_else.61002:
	li      1, $i1
be_cont.61003:
be_cont.61000:
be_cont.60998:
be_cont.60995:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61004
	li      1, $i1
	load    28($sp), $i2
	load    22($sp), $i11
	store   $ra, 29($sp)
	load    0($i11), $i10
	li      cls.61006, $ra
	add     $sp, 30, $sp
	jr      $i10
cls.61006:
	sub     $sp, 30, $sp
	load    29($sp), $ra
	b       be_cont.61005
be_else.61004:
	li      1, $i1
	load    27($sp), $i2
	load    6($sp), $i11
	store   $ra, 29($sp)
	load    0($i11), $i10
	li      cls.61007, $ra
	add     $sp, 30, $sp
	jr      $i10
cls.61007:
	sub     $sp, 30, $sp
	load    29($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61008
	li      1, $i1
	load    28($sp), $i2
	load    22($sp), $i11
	store   $ra, 29($sp)
	load    0($i11), $i10
	li      cls.61010, $ra
	add     $sp, 30, $sp
	jr      $i10
cls.61010:
	sub     $sp, 30, $sp
	load    29($sp), $ra
	b       be_cont.61009
be_else.61008:
	li      1, $i1
be_cont.61009:
be_cont.61005:
be_cont.60993:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61011
	load    25($sp), $i1
	load    0($i1), $i2
	load    8($sp), $i3
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
	load    24($sp), $i2
	load    2($i2), $f2
	load    14($sp), $f3
	fmul    $f2, $f3, $f3
	fmul    $f3, $f1, $f1
	store   $f1, 29($sp)
	load    0($i1), $i1
	load    15($sp), $i2
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
	store   $f2, 30($sp)
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fispos
	sub     $sp, 32, $sp
	load    31($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61013
	b       be_cont.61014
be_else.61013:
	load    7($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i2
	load    0($i2), $f2
	load    29($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i1)
	load    1($i1), $f1
	load    1($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i1)
	load    2($i1), $f1
	load    2($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i1)
be_cont.61014:
	load    30($sp), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fispos
	sub     $sp, 32, $sp
	load    31($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61015
	b       be_cont.61016
be_else.61015:
	load    30($sp), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fsqr
	sub     $sp, 32, $sp
	load    31($sp), $ra
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fsqr
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    13($sp), $f2
	fmul    $f1, $f2, $f1
	load    7($sp), $i1
	load    0($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
be_cont.61016:
	b       be_cont.61012
be_else.61011:
be_cont.61012:
	b       be_cont.60991
be_else.60990:
be_cont.60991:
be_cont.60989:
	load    19($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61017
	store   $i1, 31($sp)
	load    18($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 32($sp)
	load    1($i1), $i3
	store   $i3, 33($sp)
	li      l.26124, $i1
	load    0($i1), $f1
	load    20($sp), $i1
	store   $f1, 0($i1)
	load    17($sp), $i2
	load    0($i2), $i2
	load    0($i2), $i4
	load    0($i4), $i5
	li      -1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61018
	b       be_cont.61019
be_else.61018:
	store   $i2, 34($sp)
	li      99, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61020
	load    1($i4), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61022
	b       be_cont.61023
be_else.61022:
	store   $i4, 35($sp)
	load    23($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61024, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61024:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61025
	b       be_cont.61026
be_else.61025:
	load    23($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    33($sp), $i3
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61027, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61027:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61028
	b       be_cont.61029
be_else.61028:
	load    23($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    33($sp), $i3
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61030, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61030:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61031
	b       be_cont.61032
be_else.61031:
	load    23($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    33($sp), $i3
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61033, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61033:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	li      5, $i1
	load    35($sp), $i2
	load    33($sp), $i3
	load    4($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61034, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61034:
	sub     $sp, 37, $sp
	load    36($sp), $ra
be_cont.61032:
be_cont.61029:
be_cont.61026:
be_cont.61023:
	b       be_cont.61021
be_else.61020:
	store   $i4, 35($sp)
	load    1($sp), $i11
	mov     $i3, $i2
	mov     $i5, $i1
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61035, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61035:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61036
	b       be_cont.61037
be_else.61036:
	load    3($sp), $i1
	load    0($i1), $f1
	load    20($sp), $i1
	load    0($i1), $f2
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_fless
	sub     $sp, 37, $sp
	load    36($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61038
	b       be_cont.61039
be_else.61038:
	load    35($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61040
	b       be_cont.61041
be_else.61040:
	load    23($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    33($sp), $i3
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61042, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61042:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61043
	b       be_cont.61044
be_else.61043:
	load    23($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    33($sp), $i3
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61045, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61045:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61046
	b       be_cont.61047
be_else.61046:
	load    23($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    33($sp), $i3
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61048, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61048:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61049
	b       be_cont.61050
be_else.61049:
	load    23($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    33($sp), $i3
	load    5($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61051, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61051:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	li      5, $i1
	load    35($sp), $i2
	load    33($sp), $i3
	load    4($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61052, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61052:
	sub     $sp, 37, $sp
	load    36($sp), $ra
be_cont.61050:
be_cont.61047:
be_cont.61044:
be_cont.61041:
be_cont.61039:
be_cont.61037:
be_cont.61021:
	li      1, $i1
	load    34($sp), $i2
	load    33($sp), $i3
	load    11($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.61053, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.61053:
	sub     $sp, 37, $sp
	load    36($sp), $ra
be_cont.61019:
	load    20($sp), $i1
	load    0($i1), $f2
	store   $f2, 36($sp)
	li      l.26066, $i1
	load    0($i1), $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fless
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61054
	li      0, $i1
	b       be_cont.61055
be_else.61054:
	li      l.26127, $i1
	load    0($i1), $f2
	load    36($sp), $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fless
	sub     $sp, 38, $sp
	load    37($sp), $ra
be_cont.61055:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61056
	b       be_cont.61057
be_else.61056:
	load    12($sp), $i1
	load    0($i1), $i1
	sll     $i1, 2, $i1
	load    21($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	load    32($sp), $i2
	load    0($i2), $i3
	cmp     $i1, $i3, $i12
	bne     $i12, be_else.61058
	li      0, $i1
	load    17($sp), $i2
	load    0($i2), $i2
	load    22($sp), $i11
	store   $ra, 37($sp)
	load    0($i11), $i10
	li      cls.61060, $ra
	add     $sp, 38, $sp
	jr      $i10
cls.61060:
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61061
	load    33($sp), $i1
	load    0($i1), $i2
	load    8($sp), $i3
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
	load    32($sp), $i2
	load    2($i2), $f2
	load    14($sp), $f3
	fmul    $f2, $f3, $f3
	fmul    $f3, $f1, $f1
	store   $f1, 37($sp)
	load    0($i1), $i1
	load    15($sp), $i2
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
	store   $f2, 38($sp)
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fispos
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61063
	b       be_cont.61064
be_else.61063:
	load    7($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i2
	load    0($i2), $f2
	load    37($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i1)
	load    1($i1), $f1
	load    1($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i1)
	load    2($i1), $f1
	load    2($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i1)
be_cont.61064:
	load    38($sp), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fispos
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61065
	b       be_cont.61066
be_else.61065:
	load    38($sp), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fsqr
	sub     $sp, 40, $sp
	load    39($sp), $ra
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fsqr
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    13($sp), $f2
	fmul    $f1, $f2, $f1
	load    7($sp), $i1
	load    0($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
be_cont.61066:
	b       be_cont.61062
be_else.61061:
be_cont.61062:
	b       be_cont.61059
be_else.61058:
be_cont.61059:
be_cont.61057:
	load    31($sp), $i1
	sub     $i1, 1, $i1
	load    14($sp), $f1
	load    13($sp), $f2
	load    15($sp), $i2
	load    16($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61017:
	ret
bge_else.60984:
	ret
trace_ray.3103:
	store   $i11, 0($sp)
	load    31($i11), $i4
	store   $i4, 1($sp)
	load    30($i11), $i4
	store   $i4, 2($sp)
	load    29($i11), $i4
	store   $i4, 3($sp)
	load    28($i11), $i4
	load    27($i11), $i5
	load    26($i11), $i6
	store   $i6, 4($sp)
	load    25($i11), $i6
	store   $i6, 5($sp)
	load    24($i11), $i6
	store   $i6, 6($sp)
	load    23($i11), $i6
	store   $i6, 7($sp)
	load    22($i11), $i6
	store   $i6, 8($sp)
	load    21($i11), $i6
	store   $i6, 9($sp)
	load    20($i11), $i6
	store   $i6, 10($sp)
	load    19($i11), $i6
	store   $i6, 11($sp)
	load    18($i11), $i6
	store   $i6, 12($sp)
	load    17($i11), $i6
	store   $i6, 13($sp)
	load    16($i11), $i6
	store   $i6, 14($sp)
	load    15($i11), $i6
	load    14($i11), $i7
	store   $i7, 15($sp)
	load    13($i11), $i7
	load    12($i11), $i8
	store   $i8, 16($sp)
	load    11($i11), $i8
	store   $i8, 17($sp)
	load    10($i11), $i8
	store   $i8, 18($sp)
	load    9($i11), $i8
	store   $i8, 19($sp)
	load    8($i11), $i8
	store   $i8, 20($sp)
	load    7($i11), $i8
	load    6($i11), $i9
	store   $i9, 21($sp)
	load    5($i11), $i9
	store   $i9, 22($sp)
	load    4($i11), $i9
	load    3($i11), $i10
	store   $i10, 23($sp)
	load    2($i11), $i10
	load    1($i11), $i11
	li      4, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61069
	store   $f2, 24($sp)
	store   $i9, 25($sp)
	store   $i6, 26($sp)
	store   $i10, 27($sp)
	store   $f1, 28($sp)
	store   $i8, 29($sp)
	store   $i2, 30($sp)
	store   $i1, 31($sp)
	store   $i5, 32($sp)
	store   $i7, 33($sp)
	store   $i3, 34($sp)
	store   $i11, 35($sp)
	load    2($i3), $i1
	store   $i1, 36($sp)
	li      l.26124, $i1
	load    0($i1), $f1
	store   $f1, 0($i5)
	li      0, $i1
	load    0($i7), $i3
	mov     $i4, $i11
	mov     $i3, $i10
	mov     $i2, $i3
	mov     $i10, $i2
	store   $ra, 37($sp)
	load    0($i11), $i10
	li      cls.61070, $ra
	add     $sp, 38, $sp
	jr      $i10
cls.61070:
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    32($sp), $i1
	load    0($i1), $f2
	store   $f2, 37($sp)
	li      l.26066, $i1
	load    0($i1), $f1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_fless
	sub     $sp, 39, $sp
	load    38($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61071
	li      0, $i1
	b       be_cont.61072
be_else.61071:
	li      l.26127, $i1
	load    0($i1), $f2
	load    37($sp), $f1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_fless
	sub     $sp, 39, $sp
	load    38($sp), $ra
be_cont.61072:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61073
	li      -1, $i1
	load    31($sp), $i2
	load    36($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61074
	ret
be_else.61074:
	load    30($sp), $i1
	load    0($i1), $f1
	load    29($sp), $i2
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
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_fneg
	sub     $sp, 39, $sp
	load    38($sp), $ra
	store   $f1, 38($sp)
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fispos
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61076
	ret
be_else.61076:
	load    38($sp), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fsqr
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    38($sp), $f2
	fmul    $f1, $f2, $f1
	load    28($sp), $f2
	fmul    $f1, $f2, $f1
	load    27($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    26($sp), $i1
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
be_else.61073:
	load    25($sp), $i1
	load    0($i1), $i1
	store   $i1, 39($sp)
	load    16($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 40($sp)
	load    2($i1), $i2
	store   $i2, 41($sp)
	load    7($i1), $i2
	load    0($i2), $f1
	load    28($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 42($sp)
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61079
	load    21($sp), $i1
	load    0($i1), $i1
	li      l.25703, $i2
	load    0($i2), $f1
	load    17($sp), $i2
	store   $f1, 0($i2)
	store   $f1, 1($i2)
	store   $f1, 2($i2)
	sub     $i1, 1, $i2
	store   $i2, 43($sp)
	sub     $i1, 1, $i1
	load    30($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	store   $f1, 44($sp)
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fiszero
	sub     $sp, 46, $sp
	load    45($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61081
	load    44($sp), $f1
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fispos
	sub     $sp, 46, $sp
	load    45($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61083
	li      l.26012, $i1
	load    0($i1), $f1
	b       be_cont.61084
be_else.61083:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.61084:
	b       be_cont.61082
be_else.61081:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.61082:
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fneg
	sub     $sp, 46, $sp
	load    45($sp), $ra
	load    43($sp), $i1
	load    17($sp), $i2
	add     $i2, $i1, $i12
	store   $f1, 0($i12)
	b       be_cont.61080
be_else.61079:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61085
	load    4($i1), $i1
	load    0($i1), $f1
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fneg
	sub     $sp, 46, $sp
	load    45($sp), $ra
	load    17($sp), $i1
	store   $f1, 0($i1)
	load    40($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f1
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fneg
	sub     $sp, 46, $sp
	load    45($sp), $ra
	load    17($sp), $i1
	store   $f1, 1($i1)
	load    40($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f1
	store   $ra, 45($sp)
	add     $sp, 46, $sp
	jal     min_caml_fneg
	sub     $sp, 46, $sp
	load    45($sp), $ra
	load    17($sp), $i1
	store   $f1, 2($i1)
	b       be_cont.61086
be_else.61085:
	load    23($sp), $i11
	store   $ra, 45($sp)
	load    0($i11), $i10
	li      cls.61087, $ra
	add     $sp, 46, $sp
	jr      $i10
cls.61087:
	sub     $sp, 46, $sp
	load    45($sp), $ra
be_cont.61086:
be_cont.61080:
	load    22($sp), $i2
	load    0($i2), $f1
	load    6($sp), $i1
	store   $f1, 0($i1)
	load    1($i2), $f1
	store   $f1, 1($i1)
	load    2($i2), $f1
	store   $f1, 2($i1)
	load    40($sp), $i1
	load    1($sp), $i11
	store   $ra, 45($sp)
	load    0($i11), $i10
	li      cls.61088, $ra
	add     $sp, 46, $sp
	jr      $i10
cls.61088:
	sub     $sp, 46, $sp
	load    45($sp), $ra
	load    39($sp), $i1
	sll     $i1, 2, $i1
	load    21($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	load    31($sp), $i2
	load    36($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    34($sp), $i1
	load    1($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i2
	load    22($sp), $i3
	load    0($i3), $f1
	store   $f1, 0($i2)
	load    1($i3), $f1
	store   $f1, 1($i2)
	load    2($i3), $f1
	store   $f1, 2($i2)
	load    3($i1), $i1
	store   $i1, 45($sp)
	load    40($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f1
	li      l.25696, $i1
	load    0($i1), $f2
	store   $ra, 46($sp)
	add     $sp, 47, $sp
	jal     min_caml_fless
	sub     $sp, 47, $sp
	load    46($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61089
	li      1, $i1
	load    31($sp), $i2
	load    45($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    34($sp), $i1
	load    4($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i4
	load    4($sp), $i5
	load    0($i5), $f1
	store   $f1, 0($i4)
	load    1($i5), $f1
	store   $f1, 1($i4)
	load    2($i5), $f1
	store   $f1, 2($i4)
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      l.26141, $i4
	load    0($i4), $f1
	load    42($sp), $f2
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
	load    17($sp), $i2
	load    0($i2), $f1
	store   $f1, 0($i1)
	load    1($i2), $f1
	store   $f1, 1($i1)
	load    2($i2), $f1
	store   $f1, 2($i1)
	b       be_cont.61090
be_else.61089:
	li      0, $i1
	load    31($sp), $i2
	load    45($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.61090:
	li      l.26143, $i1
	load    0($i1), $f1
	load    30($sp), $i1
	load    0($i1), $f2
	load    17($sp), $i2
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
	load    40($sp), $i1
	load    7($i1), $i1
	load    1($i1), $f1
	load    28($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 46($sp)
	load    33($sp), $i1
	load    0($i1), $i2
	load    0($i2), $i1
	load    0($i1), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61091
	li      0, $i1
	b       be_cont.61092
be_else.61091:
	store   $i1, 47($sp)
	store   $i2, 48($sp)
	li      99, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61093
	li      1, $i1
	b       be_cont.61094
be_else.61093:
	load    20($sp), $i2
	load    22($sp), $i1
	load    8($sp), $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 49($sp)
	load    0($i11), $i10
	li      cls.61095, $ra
	add     $sp, 50, $sp
	jr      $i10
cls.61095:
	sub     $sp, 50, $sp
	load    49($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61096
	li      0, $i1
	b       be_cont.61097
be_else.61096:
	load    9($sp), $i1
	load    0($i1), $f1
	li      l.26066, $i1
	load    0($i1), $f2
	store   $ra, 49($sp)
	add     $sp, 50, $sp
	jal     min_caml_fless
	sub     $sp, 50, $sp
	load    49($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61098
	li      0, $i1
	b       be_cont.61099
be_else.61098:
	li      1, $i1
	load    47($sp), $i2
	load    13($sp), $i11
	store   $ra, 49($sp)
	load    0($i11), $i10
	li      cls.61100, $ra
	add     $sp, 50, $sp
	jr      $i10
cls.61100:
	sub     $sp, 50, $sp
	load    49($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61101
	li      0, $i1
	b       be_cont.61102
be_else.61101:
	li      1, $i1
be_cont.61102:
be_cont.61099:
be_cont.61097:
be_cont.61094:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61103
	li      1, $i1
	load    48($sp), $i2
	load    12($sp), $i11
	store   $ra, 49($sp)
	load    0($i11), $i10
	li      cls.61105, $ra
	add     $sp, 50, $sp
	jr      $i10
cls.61105:
	sub     $sp, 50, $sp
	load    49($sp), $ra
	b       be_cont.61104
be_else.61103:
	li      1, $i1
	load    47($sp), $i2
	load    13($sp), $i11
	store   $ra, 49($sp)
	load    0($i11), $i10
	li      cls.61106, $ra
	add     $sp, 50, $sp
	jr      $i10
cls.61106:
	sub     $sp, 50, $sp
	load    49($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61107
	li      1, $i1
	load    48($sp), $i2
	load    12($sp), $i11
	store   $ra, 49($sp)
	load    0($i11), $i10
	li      cls.61109, $ra
	add     $sp, 50, $sp
	jr      $i10
cls.61109:
	sub     $sp, 50, $sp
	load    49($sp), $ra
	b       be_cont.61108
be_else.61107:
	li      1, $i1
be_cont.61108:
be_cont.61104:
be_cont.61092:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61110
	load    17($sp), $i1
	load    0($i1), $f1
	load    29($sp), $i2
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
	store   $ra, 49($sp)
	add     $sp, 50, $sp
	jal     min_caml_fneg
	sub     $sp, 50, $sp
	load    49($sp), $ra
	load    42($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 49($sp)
	load    30($sp), $i1
	load    0($i1), $f1
	load    29($sp), $i2
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
	store   $ra, 50($sp)
	add     $sp, 51, $sp
	jal     min_caml_fneg
	sub     $sp, 51, $sp
	load    50($sp), $ra
	store   $f1, 50($sp)
	load    49($sp), $f1
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fispos
	sub     $sp, 52, $sp
	load    51($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61112
	b       be_cont.61113
be_else.61112:
	load    26($sp), $i1
	load    0($i1), $f1
	load    4($sp), $i2
	load    0($i2), $f2
	load    49($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i1)
	load    1($i1), $f1
	load    1($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i1)
	load    2($i1), $f1
	load    2($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i1)
be_cont.61113:
	load    50($sp), $f1
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fispos
	sub     $sp, 52, $sp
	load    51($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61114
	b       be_cont.61115
be_else.61114:
	load    50($sp), $f1
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fsqr
	sub     $sp, 52, $sp
	load    51($sp), $ra
	store   $ra, 51($sp)
	add     $sp, 52, $sp
	jal     min_caml_fsqr
	sub     $sp, 52, $sp
	load    51($sp), $ra
	load    46($sp), $f2
	fmul    $f1, $f2, $f1
	load    26($sp), $i1
	load    0($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
be_cont.61115:
	b       be_cont.61111
be_else.61110:
be_cont.61111:
	load    22($sp), $i1
	load    0($i1), $f1
	load    5($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    19($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    14($sp), $i11
	store   $ra, 51($sp)
	load    0($i11), $i10
	li      cls.61116, $ra
	add     $sp, 52, $sp
	jr      $i10
cls.61116:
	sub     $sp, 52, $sp
	load    51($sp), $ra
	load    18($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61117
	store   $i1, 51($sp)
	load    15($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 52($sp)
	load    1($i1), $i3
	store   $i3, 53($sp)
	li      l.26124, $i1
	load    0($i1), $f1
	load    32($sp), $i1
	store   $f1, 0($i1)
	load    33($sp), $i2
	load    0($i2), $i2
	load    0($i2), $i4
	load    0($i4), $i5
	li      -1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61119
	b       be_cont.61120
be_else.61119:
	store   $i2, 54($sp)
	li      99, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61121
	load    1($i4), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61123
	b       be_cont.61124
be_else.61123:
	store   $i4, 55($sp)
	load    35($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61125, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61125:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	load    55($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61126
	b       be_cont.61127
be_else.61126:
	load    35($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    53($sp), $i3
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61128, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61128:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	load    55($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61129
	b       be_cont.61130
be_else.61129:
	load    35($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    53($sp), $i3
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61131, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61131:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	load    55($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61132
	b       be_cont.61133
be_else.61132:
	load    35($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    53($sp), $i3
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61134, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61134:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	li      5, $i1
	load    55($sp), $i2
	load    53($sp), $i3
	load    10($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61135, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61135:
	sub     $sp, 57, $sp
	load    56($sp), $ra
be_cont.61133:
be_cont.61130:
be_cont.61127:
be_cont.61124:
	b       be_cont.61122
be_else.61121:
	store   $i4, 55($sp)
	load    7($sp), $i11
	mov     $i3, $i2
	mov     $i5, $i1
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61136, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61136:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61137
	b       be_cont.61138
be_else.61137:
	load    9($sp), $i1
	load    0($i1), $f1
	load    32($sp), $i1
	load    0($i1), $f2
	store   $ra, 56($sp)
	add     $sp, 57, $sp
	jal     min_caml_fless
	sub     $sp, 57, $sp
	load    56($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61139
	b       be_cont.61140
be_else.61139:
	load    55($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61141
	b       be_cont.61142
be_else.61141:
	load    35($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    53($sp), $i3
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61143, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61143:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	load    55($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61144
	b       be_cont.61145
be_else.61144:
	load    35($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    53($sp), $i3
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61146, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61146:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	load    55($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61147
	b       be_cont.61148
be_else.61147:
	load    35($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    53($sp), $i3
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61149, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61149:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	load    55($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61150
	b       be_cont.61151
be_else.61150:
	load    35($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    53($sp), $i3
	load    11($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61152, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61152:
	sub     $sp, 57, $sp
	load    56($sp), $ra
	li      5, $i1
	load    55($sp), $i2
	load    53($sp), $i3
	load    10($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61153, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61153:
	sub     $sp, 57, $sp
	load    56($sp), $ra
be_cont.61151:
be_cont.61148:
be_cont.61145:
be_cont.61142:
be_cont.61140:
be_cont.61138:
be_cont.61122:
	li      1, $i1
	load    54($sp), $i2
	load    53($sp), $i3
	load    3($sp), $i11
	store   $ra, 56($sp)
	load    0($i11), $i10
	li      cls.61154, $ra
	add     $sp, 57, $sp
	jr      $i10
cls.61154:
	sub     $sp, 57, $sp
	load    56($sp), $ra
be_cont.61120:
	load    32($sp), $i1
	load    0($i1), $f2
	store   $f2, 56($sp)
	li      l.26066, $i1
	load    0($i1), $f1
	store   $ra, 57($sp)
	add     $sp, 58, $sp
	jal     min_caml_fless
	sub     $sp, 58, $sp
	load    57($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61155
	li      0, $i1
	b       be_cont.61156
be_else.61155:
	li      l.26127, $i1
	load    0($i1), $f2
	load    56($sp), $f1
	store   $ra, 57($sp)
	add     $sp, 58, $sp
	jal     min_caml_fless
	sub     $sp, 58, $sp
	load    57($sp), $ra
be_cont.61156:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61157
	b       be_cont.61158
be_else.61157:
	load    25($sp), $i1
	load    0($i1), $i1
	sll     $i1, 2, $i1
	load    21($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	load    52($sp), $i2
	load    0($i2), $i3
	cmp     $i1, $i3, $i12
	bne     $i12, be_else.61159
	li      0, $i1
	load    33($sp), $i2
	load    0($i2), $i2
	load    12($sp), $i11
	store   $ra, 57($sp)
	load    0($i11), $i10
	li      cls.61161, $ra
	add     $sp, 58, $sp
	jr      $i10
cls.61161:
	sub     $sp, 58, $sp
	load    57($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61162
	load    53($sp), $i1
	load    0($i1), $i2
	load    17($sp), $i3
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
	load    52($sp), $i2
	load    2($i2), $f2
	load    42($sp), $f3
	fmul    $f2, $f3, $f3
	fmul    $f3, $f1, $f1
	store   $f1, 57($sp)
	load    0($i1), $i1
	load    30($sp), $i2
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
	store   $f2, 58($sp)
	store   $ra, 59($sp)
	add     $sp, 60, $sp
	jal     min_caml_fispos
	sub     $sp, 60, $sp
	load    59($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61164
	b       be_cont.61165
be_else.61164:
	load    26($sp), $i1
	load    0($i1), $f1
	load    4($sp), $i2
	load    0($i2), $f2
	load    57($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i1)
	load    1($i1), $f1
	load    1($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i1)
	load    2($i1), $f1
	load    2($i2), $f2
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i1)
be_cont.61165:
	load    58($sp), $f1
	store   $ra, 59($sp)
	add     $sp, 60, $sp
	jal     min_caml_fispos
	sub     $sp, 60, $sp
	load    59($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61166
	b       be_cont.61167
be_else.61166:
	load    58($sp), $f1
	store   $ra, 59($sp)
	add     $sp, 60, $sp
	jal     min_caml_fsqr
	sub     $sp, 60, $sp
	load    59($sp), $ra
	store   $ra, 59($sp)
	add     $sp, 60, $sp
	jal     min_caml_fsqr
	sub     $sp, 60, $sp
	load    59($sp), $ra
	load    46($sp), $f2
	fmul    $f1, $f2, $f1
	load    26($sp), $i1
	load    0($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 0($i1)
	load    1($i1), $f2
	fadd    $f2, $f1, $f2
	store   $f2, 1($i1)
	load    2($i1), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 2($i1)
be_cont.61167:
	b       be_cont.61163
be_else.61162:
be_cont.61163:
	b       be_cont.61160
be_else.61159:
be_cont.61160:
be_cont.61158:
	load    51($sp), $i1
	sub     $i1, 1, $i1
	load    42($sp), $f1
	load    46($sp), $f2
	load    30($sp), $i2
	load    2($sp), $i11
	store   $ra, 59($sp)
	load    0($i11), $i10
	li      cls.61168, $ra
	add     $sp, 60, $sp
	jr      $i10
cls.61168:
	sub     $sp, 60, $sp
	load    59($sp), $ra
	b       bge_cont.61118
bge_else.61117:
bge_cont.61118:
	li      l.25895, $i1
	load    0($i1), $f1
	load    28($sp), $f2
	store   $ra, 59($sp)
	add     $sp, 60, $sp
	jal     min_caml_fless
	sub     $sp, 60, $sp
	load    59($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61169
	ret
be_else.61169:
	load    31($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61171
	b       bge_cont.61172
bge_else.61171:
	add     $i1, 1, $i1
	li      -1, $i2
	load    36($sp), $i3
	add     $i3, $i1, $i12
	store   $i2, 0($i12)
bge_cont.61172:
	load    41($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61173
	li      l.25743, $i1
	load    0($i1), $f1
	load    40($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	load    28($sp), $f2
	fmul    $f2, $f1, $f1
	load    31($sp), $i1
	add     $i1, 1, $i1
	load    32($sp), $i2
	load    0($i2), $f2
	load    24($sp), $f3
	fadd    $f3, $f2, $f2
	load    30($sp), $i2
	load    34($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.61173:
	ret
ble_else.61069:
	ret
trace_diffuse_ray.3109:
	store   $f1, 0($sp)
	store   $i1, 1($sp)
	load    18($i11), $i2
	store   $i2, 2($sp)
	load    17($i11), $i2
	load    16($i11), $i3
	store   $i3, 3($sp)
	load    15($i11), $i4
	store   $i4, 4($sp)
	load    14($i11), $i4
	store   $i4, 5($sp)
	load    13($i11), $i4
	store   $i4, 6($sp)
	load    12($i11), $i4
	store   $i4, 7($sp)
	load    11($i11), $i4
	store   $i4, 8($sp)
	load    10($i11), $i4
	store   $i4, 9($sp)
	load    9($i11), $i5
	store   $i5, 10($sp)
	load    8($i11), $i5
	store   $i5, 11($sp)
	load    7($i11), $i5
	store   $i5, 12($sp)
	load    6($i11), $i5
	store   $i5, 13($sp)
	load    5($i11), $i5
	store   $i5, 14($sp)
	load    4($i11), $i5
	store   $i5, 15($sp)
	load    3($i11), $i5
	store   $i5, 16($sp)
	load    2($i11), $i5
	store   $i5, 17($sp)
	load    1($i11), $i5
	store   $i5, 18($sp)
	li      l.26124, $i5
	load    0($i5), $f1
	store   $f1, 0($i3)
	li      0, $i3
	load    0($i4), $i4
	mov     $i2, $i11
	mov     $i4, $i2
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61176, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61176:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    3($sp), $i1
	load    0($i1), $f2
	store   $f2, 19($sp)
	li      l.26066, $i1
	load    0($i1), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61177
	li      0, $i1
	b       be_cont.61178
be_else.61177:
	li      l.26127, $i1
	load    0($i1), $f2
	load    19($sp), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_fless
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.61178:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61179
	ret
be_else.61179:
	load    16($sp), $i1
	load    0($i1), $i1
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 20($sp)
	load    1($sp), $i2
	load    0($i2), $i2
	load    1($i1), $i3
	li      1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61181
	load    14($sp), $i1
	load    0($i1), $i1
	li      l.25703, $i3
	load    0($i3), $f1
	load    11($sp), $i3
	store   $f1, 0($i3)
	store   $f1, 1($i3)
	store   $f1, 2($i3)
	sub     $i1, 1, $i3
	store   $i3, 21($sp)
	sub     $i1, 1, $i1
	add     $i2, $i1, $i12
	load    0($i12), $f1
	store   $f1, 22($sp)
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fiszero
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61183
	load    22($sp), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fispos
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61185
	li      l.26012, $i1
	load    0($i1), $f1
	b       be_cont.61186
be_else.61185:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.61186:
	b       be_cont.61184
be_else.61183:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.61184:
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fneg
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    21($sp), $i1
	load    11($sp), $i2
	add     $i2, $i1, $i12
	store   $f1, 0($i12)
	b       be_cont.61182
be_else.61181:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61187
	load    4($i1), $i1
	load    0($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fneg
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    11($sp), $i1
	store   $f1, 0($i1)
	load    20($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fneg
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    11($sp), $i1
	store   $f1, 1($i1)
	load    20($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fneg
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    11($sp), $i1
	store   $f1, 2($i1)
	b       be_cont.61188
be_else.61187:
	load    17($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61189, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61189:
	sub     $sp, 24, $sp
	load    23($sp), $ra
be_cont.61188:
be_cont.61182:
	load    20($sp), $i1
	load    15($sp), $i2
	load    2($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61190, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61190:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    9($sp), $i1
	load    0($i1), $i2
	load    0($i2), $i1
	load    0($i1), $i3
	li      -1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61191
	li      0, $i1
	b       be_cont.61192
be_else.61191:
	store   $i1, 23($sp)
	store   $i2, 24($sp)
	li      99, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61193
	li      1, $i1
	b       be_cont.61194
be_else.61193:
	load    12($sp), $i2
	load    15($sp), $i1
	load    5($sp), $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61195, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61195:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61196
	li      0, $i1
	b       be_cont.61197
be_else.61196:
	load    6($sp), $i1
	load    0($i1), $f1
	li      l.26066, $i1
	load    0($i1), $f2
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fless
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61198
	li      0, $i1
	b       be_cont.61199
be_else.61198:
	li      1, $i1
	load    23($sp), $i2
	load    8($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61200, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61200:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61201
	li      0, $i1
	b       be_cont.61202
be_else.61201:
	li      1, $i1
be_cont.61202:
be_cont.61199:
be_cont.61197:
be_cont.61194:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61203
	li      1, $i1
	load    24($sp), $i2
	load    7($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61205, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61205:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	b       be_cont.61204
be_else.61203:
	li      1, $i1
	load    23($sp), $i2
	load    8($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61206, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61206:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61207
	li      1, $i1
	load    24($sp), $i2
	load    7($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61209, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61209:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	b       be_cont.61208
be_else.61207:
	li      1, $i1
be_cont.61208:
be_cont.61204:
be_cont.61192:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61210
	load    11($sp), $i1
	load    0($i1), $f1
	load    13($sp), $i2
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
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fneg
	sub     $sp, 26, $sp
	load    25($sp), $ra
	store   $f1, 25($sp)
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fispos
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61211
	li      l.25703, $i1
	load    0($i1), $f1
	b       be_cont.61212
be_else.61211:
	load    25($sp), $f1
be_cont.61212:
	load    0($sp), $f2
	fmul    $f2, $f1, $f1
	load    20($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    18($sp), $i1
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
be_else.61210:
	ret
iter_trace_diffuse_rays.3112:
	load    20($i11), $i5
	store   $i5, 0($sp)
	load    19($i11), $i5
	store   $i5, 1($sp)
	load    18($i11), $i5
	load    17($i11), $i6
	load    16($i11), $i7
	store   $i7, 2($sp)
	load    15($i11), $i7
	store   $i7, 3($sp)
	load    14($i11), $i7
	store   $i7, 4($sp)
	load    13($i11), $i7
	store   $i7, 5($sp)
	load    12($i11), $i7
	store   $i7, 6($sp)
	load    11($i11), $i7
	store   $i7, 7($sp)
	load    10($i11), $i7
	load    9($i11), $i8
	load    8($i11), $i9
	store   $i9, 8($sp)
	load    7($i11), $i9
	store   $i9, 9($sp)
	load    6($i11), $i9
	store   $i9, 10($sp)
	load    5($i11), $i9
	store   $i9, 11($sp)
	load    4($i11), $i9
	load    3($i11), $i10
	store   $i10, 12($sp)
	load    2($i11), $i10
	store   $i10, 13($sp)
	load    1($i11), $i10
	li      0, $i12
	cmp     $i4, $i12, $i12
	bl      $i12, bge_else.61215
	store   $i8, 14($sp)
	store   $i9, 15($sp)
	store   $i3, 16($sp)
	store   $i11, 17($sp)
	store   $i5, 18($sp)
	store   $i2, 19($sp)
	store   $i7, 20($sp)
	store   $i6, 21($sp)
	store   $i4, 22($sp)
	store   $i1, 23($sp)
	store   $i10, 24($sp)
	add     $i1, $i4, $i12
	load    0($i12), $i1
	load    0($i1), $i1
	load    0($i1), $f1
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
	store   $f1, 25($sp)
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fisneg
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61216
	load    22($sp), $i1
	load    23($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	store   $i3, 26($sp)
	li      l.26170, $i1
	load    0($i1), $f1
	load    25($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $f1, 27($sp)
	li      l.26124, $i1
	load    0($i1), $f1
	load    21($sp), $i1
	store   $f1, 0($i1)
	load    20($sp), $i2
	load    0($i2), $i2
	load    0($i2), $i4
	load    0($i4), $i5
	li      -1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61218
	b       be_cont.61219
be_else.61218:
	store   $i2, 28($sp)
	li      99, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61220
	load    1($i4), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61222
	b       be_cont.61223
be_else.61222:
	store   $i4, 29($sp)
	load    24($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61224, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61224:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    29($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61225
	b       be_cont.61226
be_else.61225:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    26($sp), $i3
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61227, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61227:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    29($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61228
	b       be_cont.61229
be_else.61228:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    26($sp), $i3
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61230, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61230:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    29($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61231
	b       be_cont.61232
be_else.61231:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    26($sp), $i3
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61233, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61233:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	li      5, $i1
	load    29($sp), $i2
	load    26($sp), $i3
	load    5($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61234, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61234:
	sub     $sp, 31, $sp
	load    30($sp), $ra
be_cont.61232:
be_cont.61229:
be_cont.61226:
be_cont.61223:
	b       be_cont.61221
be_else.61220:
	store   $i4, 29($sp)
	load    3($sp), $i11
	mov     $i3, $i2
	mov     $i5, $i1
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61235, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61235:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61236
	b       be_cont.61237
be_else.61236:
	load    4($sp), $i1
	load    0($i1), $f1
	load    21($sp), $i1
	load    0($i1), $f2
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_fless
	sub     $sp, 31, $sp
	load    30($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61238
	b       be_cont.61239
be_else.61238:
	load    29($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61240
	b       be_cont.61241
be_else.61240:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    26($sp), $i3
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61242, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61242:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    29($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61243
	b       be_cont.61244
be_else.61243:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    26($sp), $i3
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61245, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61245:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    29($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61246
	b       be_cont.61247
be_else.61246:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    26($sp), $i3
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61248, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61248:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    29($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61249
	b       be_cont.61250
be_else.61249:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    26($sp), $i3
	load    6($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61251, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61251:
	sub     $sp, 31, $sp
	load    30($sp), $ra
	li      5, $i1
	load    29($sp), $i2
	load    26($sp), $i3
	load    5($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61252, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61252:
	sub     $sp, 31, $sp
	load    30($sp), $ra
be_cont.61250:
be_cont.61247:
be_cont.61244:
be_cont.61241:
be_cont.61239:
be_cont.61237:
be_cont.61221:
	li      1, $i1
	load    28($sp), $i2
	load    26($sp), $i3
	load    1($sp), $i11
	store   $ra, 30($sp)
	load    0($i11), $i10
	li      cls.61253, $ra
	add     $sp, 31, $sp
	jr      $i10
cls.61253:
	sub     $sp, 31, $sp
	load    30($sp), $ra
be_cont.61219:
	load    21($sp), $i1
	load    0($i1), $f2
	store   $f2, 30($sp)
	li      l.26066, $i1
	load    0($i1), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fless
	sub     $sp, 32, $sp
	load    31($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61254
	li      0, $i1
	b       be_cont.61255
be_else.61254:
	li      l.26127, $i1
	load    0($i1), $f2
	load    30($sp), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fless
	sub     $sp, 32, $sp
	load    31($sp), $ra
be_cont.61255:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61256
	b       be_cont.61257
be_else.61256:
	load    15($sp), $i1
	load    0($i1), $i1
	load    14($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 31($sp)
	load    26($sp), $i2
	load    0($i2), $i2
	load    1($i1), $i3
	li      1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61258
	load    10($sp), $i1
	load    0($i1), $i1
	li      l.25703, $i3
	load    0($i3), $f1
	load    8($sp), $i3
	store   $f1, 0($i3)
	store   $f1, 1($i3)
	store   $f1, 2($i3)
	sub     $i1, 1, $i3
	store   $i3, 32($sp)
	sub     $i1, 1, $i1
	add     $i2, $i1, $i12
	load    0($i12), $f1
	store   $f1, 33($sp)
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fiszero
	sub     $sp, 35, $sp
	load    34($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61260
	load    33($sp), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fispos
	sub     $sp, 35, $sp
	load    34($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61262
	li      l.26012, $i1
	load    0($i1), $f1
	b       be_cont.61263
be_else.61262:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.61263:
	b       be_cont.61261
be_else.61260:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.61261:
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fneg
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    32($sp), $i1
	load    8($sp), $i2
	add     $i2, $i1, $i12
	store   $f1, 0($i12)
	b       be_cont.61259
be_else.61258:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61264
	load    4($i1), $i1
	load    0($i1), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fneg
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    8($sp), $i1
	store   $f1, 0($i1)
	load    31($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fneg
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    8($sp), $i1
	store   $f1, 1($i1)
	load    31($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fneg
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    8($sp), $i1
	store   $f1, 2($i1)
	b       be_cont.61265
be_else.61264:
	load    12($sp), $i11
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61266, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61266:
	sub     $sp, 35, $sp
	load    34($sp), $ra
be_cont.61265:
be_cont.61259:
	load    31($sp), $i1
	load    11($sp), $i2
	load    0($sp), $i11
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61267, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61267:
	sub     $sp, 35, $sp
	load    34($sp), $ra
	li      0, $i1
	load    20($sp), $i2
	load    0($i2), $i2
	load    7($sp), $i11
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61268, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61268:
	sub     $sp, 35, $sp
	load    34($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61269
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
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fneg
	sub     $sp, 35, $sp
	load    34($sp), $ra
	store   $f1, 34($sp)
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_fispos
	sub     $sp, 36, $sp
	load    35($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61271
	li      l.25703, $i1
	load    0($i1), $f1
	b       be_cont.61272
be_else.61271:
	load    34($sp), $f1
be_cont.61272:
	load    27($sp), $f2
	fmul    $f2, $f1, $f1
	load    31($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    13($sp), $i1
	load    0($i1), $f2
	load    2($sp), $i2
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
	b       be_cont.61270
be_else.61269:
be_cont.61270:
be_cont.61257:
	b       be_cont.61217
be_else.61216:
	load    22($sp), $i1
	add     $i1, 1, $i1
	load    23($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	store   $i3, 35($sp)
	li      l.26160, $i1
	load    0($i1), $f1
	load    25($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $f1, 36($sp)
	li      l.26124, $i1
	load    0($i1), $f1
	load    21($sp), $i1
	store   $f1, 0($i1)
	load    20($sp), $i2
	load    0($i2), $i2
	load    0($i2), $i4
	load    0($i4), $i5
	li      -1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61273
	b       be_cont.61274
be_else.61273:
	store   $i2, 37($sp)
	li      99, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61275
	load    1($i4), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61277
	b       be_cont.61278
be_else.61277:
	store   $i4, 38($sp)
	load    24($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	li      0, $i1
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61279, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61279:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    38($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61280
	b       be_cont.61281
be_else.61280:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    35($sp), $i3
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61282, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61282:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    38($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61283
	b       be_cont.61284
be_else.61283:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    35($sp), $i3
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61285, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61285:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    38($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61286
	b       be_cont.61287
be_else.61286:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    35($sp), $i3
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61288, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61288:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      5, $i1
	load    38($sp), $i2
	load    35($sp), $i3
	load    5($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61289, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61289:
	sub     $sp, 40, $sp
	load    39($sp), $ra
be_cont.61287:
be_cont.61284:
be_cont.61281:
be_cont.61278:
	b       be_cont.61276
be_else.61275:
	store   $i4, 38($sp)
	load    3($sp), $i11
	mov     $i3, $i2
	mov     $i5, $i1
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61290, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61290:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61291
	b       be_cont.61292
be_else.61291:
	load    4($sp), $i1
	load    0($i1), $f1
	load    21($sp), $i1
	load    0($i1), $f2
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_fless
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61293
	b       be_cont.61294
be_else.61293:
	load    38($sp), $i1
	load    1($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61295
	b       be_cont.61296
be_else.61295:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    35($sp), $i3
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61297, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61297:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    38($sp), $i1
	load    2($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61298
	b       be_cont.61299
be_else.61298:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    35($sp), $i3
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61300, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61300:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    38($sp), $i1
	load    3($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61301
	b       be_cont.61302
be_else.61301:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    35($sp), $i3
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61303, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61303:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	load    38($sp), $i1
	load    4($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61304
	b       be_cont.61305
be_else.61304:
	load    24($sp), $i1
	add     $i1, $i2, $i12
	load    0($i12), $i2
	li      0, $i1
	load    35($sp), $i3
	load    6($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61306, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61306:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	li      5, $i1
	load    38($sp), $i2
	load    35($sp), $i3
	load    5($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61307, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61307:
	sub     $sp, 40, $sp
	load    39($sp), $ra
be_cont.61305:
be_cont.61302:
be_cont.61299:
be_cont.61296:
be_cont.61294:
be_cont.61292:
be_cont.61276:
	li      1, $i1
	load    37($sp), $i2
	load    35($sp), $i3
	load    1($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61308, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61308:
	sub     $sp, 40, $sp
	load    39($sp), $ra
be_cont.61274:
	load    21($sp), $i1
	load    0($i1), $f2
	store   $f2, 39($sp)
	li      l.26066, $i1
	load    0($i1), $f1
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_fless
	sub     $sp, 41, $sp
	load    40($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61309
	li      0, $i1
	b       be_cont.61310
be_else.61309:
	li      l.26127, $i1
	load    0($i1), $f2
	load    39($sp), $f1
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_fless
	sub     $sp, 41, $sp
	load    40($sp), $ra
be_cont.61310:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61311
	b       be_cont.61312
be_else.61311:
	load    15($sp), $i1
	load    0($i1), $i1
	load    14($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 40($sp)
	load    35($sp), $i2
	load    0($i2), $i2
	load    1($i1), $i3
	li      1, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61313
	load    10($sp), $i1
	load    0($i1), $i1
	li      l.25703, $i3
	load    0($i3), $f1
	load    8($sp), $i3
	store   $f1, 0($i3)
	store   $f1, 1($i3)
	store   $f1, 2($i3)
	sub     $i1, 1, $i3
	store   $i3, 41($sp)
	sub     $i1, 1, $i1
	add     $i2, $i1, $i12
	load    0($i12), $f1
	store   $f1, 42($sp)
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fiszero
	sub     $sp, 44, $sp
	load    43($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61315
	load    42($sp), $f1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fispos
	sub     $sp, 44, $sp
	load    43($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61317
	li      l.26012, $i1
	load    0($i1), $f1
	b       be_cont.61318
be_else.61317:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.61318:
	b       be_cont.61316
be_else.61315:
	li      l.25703, $i1
	load    0($i1), $f1
be_cont.61316:
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fneg
	sub     $sp, 44, $sp
	load    43($sp), $ra
	load    41($sp), $i1
	load    8($sp), $i2
	add     $i2, $i1, $i12
	store   $f1, 0($i12)
	b       be_cont.61314
be_else.61313:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61319
	load    4($i1), $i1
	load    0($i1), $f1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fneg
	sub     $sp, 44, $sp
	load    43($sp), $ra
	load    8($sp), $i1
	store   $f1, 0($i1)
	load    40($sp), $i1
	load    4($i1), $i1
	load    1($i1), $f1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fneg
	sub     $sp, 44, $sp
	load    43($sp), $ra
	load    8($sp), $i1
	store   $f1, 1($i1)
	load    40($sp), $i1
	load    4($i1), $i1
	load    2($i1), $f1
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fneg
	sub     $sp, 44, $sp
	load    43($sp), $ra
	load    8($sp), $i1
	store   $f1, 2($i1)
	b       be_cont.61320
be_else.61319:
	load    12($sp), $i11
	store   $ra, 43($sp)
	load    0($i11), $i10
	li      cls.61321, $ra
	add     $sp, 44, $sp
	jr      $i10
cls.61321:
	sub     $sp, 44, $sp
	load    43($sp), $ra
be_cont.61320:
be_cont.61314:
	load    40($sp), $i1
	load    11($sp), $i2
	load    0($sp), $i11
	store   $ra, 43($sp)
	load    0($i11), $i10
	li      cls.61322, $ra
	add     $sp, 44, $sp
	jr      $i10
cls.61322:
	sub     $sp, 44, $sp
	load    43($sp), $ra
	li      0, $i1
	load    20($sp), $i2
	load    0($i2), $i2
	load    7($sp), $i11
	store   $ra, 43($sp)
	load    0($i11), $i10
	li      cls.61323, $ra
	add     $sp, 44, $sp
	jr      $i10
cls.61323:
	sub     $sp, 44, $sp
	load    43($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61324
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
	store   $ra, 43($sp)
	add     $sp, 44, $sp
	jal     min_caml_fneg
	sub     $sp, 44, $sp
	load    43($sp), $ra
	store   $f1, 43($sp)
	store   $ra, 44($sp)
	add     $sp, 45, $sp
	jal     min_caml_fispos
	sub     $sp, 45, $sp
	load    44($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61326
	li      l.25703, $i1
	load    0($i1), $f1
	b       be_cont.61327
be_else.61326:
	load    43($sp), $f1
be_cont.61327:
	load    36($sp), $f2
	fmul    $f2, $f1, $f1
	load    40($sp), $i1
	load    7($i1), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    13($sp), $i1
	load    0($i1), $f2
	load    2($sp), $i2
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
	b       be_cont.61325
be_else.61324:
be_cont.61325:
be_cont.61312:
be_cont.61217:
	load    22($sp), $i1
	sub     $i1, 2, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61328
	store   $i1, 44($sp)
	load    23($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    0($i1), $i1
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
	store   $f1, 45($sp)
	store   $ra, 46($sp)
	add     $sp, 47, $sp
	jal     min_caml_fisneg
	sub     $sp, 47, $sp
	load    46($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61329
	load    44($sp), $i1
	load    23($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    45($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    18($sp), $i11
	store   $ra, 46($sp)
	load    0($i11), $i10
	li      cls.61331, $ra
	add     $sp, 47, $sp
	jr      $i10
cls.61331:
	sub     $sp, 47, $sp
	load    46($sp), $ra
	b       be_cont.61330
be_else.61329:
	load    44($sp), $i1
	add     $i1, 1, $i1
	load    23($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    45($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    18($sp), $i11
	store   $ra, 46($sp)
	load    0($i11), $i10
	li      cls.61332, $ra
	add     $sp, 47, $sp
	jr      $i10
cls.61332:
	sub     $sp, 47, $sp
	load    46($sp), $ra
be_cont.61330:
	load    44($sp), $i1
	sub     $i1, 2, $i4
	load    23($sp), $i1
	load    19($sp), $i2
	load    16($sp), $i3
	load    17($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61328:
	ret
bge_else.61215:
	ret
trace_diffuse_ray_80percent.3121:
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
	bne     $i12, be_else.61335
	b       be_cont.61336
be_else.61335:
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
	li      cls.61337, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.61337:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      118, $i4
	load    8($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.61338, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.61338:
	sub     $sp, 10, $sp
	load    9($sp), $ra
be_cont.61336:
	load    2($sp), $i1
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61339
	b       be_cont.61340
be_else.61339:
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
	li      cls.61341, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.61341:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      118, $i4
	load    9($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.61342, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.61342:
	sub     $sp, 11, $sp
	load    10($sp), $ra
be_cont.61340:
	load    2($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61343
	b       be_cont.61344
be_else.61343:
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
	li      cls.61345, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.61345:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      118, $i4
	load    10($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.61346, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.61346:
	sub     $sp, 12, $sp
	load    11($sp), $ra
be_cont.61344:
	load    2($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61347
	b       be_cont.61348
be_else.61347:
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
	li      cls.61349, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.61349:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      118, $i4
	load    11($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.61350, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.61350:
	sub     $sp, 13, $sp
	load    12($sp), $ra
be_cont.61348:
	load    2($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61351
	ret
be_else.61351:
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
	li      cls.61353, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.61353:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      118, $i4
	load    12($sp), $i1
	load    0($sp), $i2
	load    1($sp), $i3
	load    6($sp), $i11
	load    0($i11), $i10
	jr      $i10
calc_diffuse_using_1point.3125:
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
	bne     $i12, be_else.61354
	b       be_cont.61355
be_else.61354:
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
	li      cls.61356, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.61356:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i1
	load    118($i1), $i1
	load    0($i1), $i1
	load    0($i1), $f1
	load    11($sp), $i2
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
	store   $f1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fisneg
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61357
	load    13($sp), $i1
	load    118($i1), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    14($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.61359, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.61359:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       be_cont.61358
be_else.61357:
	load    13($sp), $i1
	load    119($i1), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    14($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.61360, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.61360:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.61358:
	li      116, $i4
	load    13($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.61361, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.61361:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.61355:
	load    10($sp), $i1
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61362
	b       be_cont.61363
be_else.61362:
	load    7($sp), $i1
	load    1($i1), $i1
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
	li      cls.61364, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.61364:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    118($i1), $i1
	load    0($i1), $i1
	load    0($i1), $f1
	load    11($sp), $i2
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
	store   $f1, 16($sp)
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fisneg
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61365
	load    15($sp), $i1
	load    118($i1), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    16($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.61367, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.61367:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	b       be_cont.61366
be_else.61365:
	load    15($sp), $i1
	load    119($i1), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    16($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.61368, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.61368:
	sub     $sp, 18, $sp
	load    17($sp), $ra
be_cont.61366:
	li      116, $i4
	load    15($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.61369, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.61369:
	sub     $sp, 18, $sp
	load    17($sp), $ra
be_cont.61363:
	load    10($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61370
	b       be_cont.61371
be_else.61370:
	load    7($sp), $i1
	load    2($i1), $i1
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
	li      cls.61372, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61372:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $i1
	load    118($i1), $i1
	load    0($i1), $i1
	load    0($i1), $f1
	load    11($sp), $i2
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
	store   $f1, 18($sp)
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fisneg
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61373
	load    17($sp), $i1
	load    118($i1), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    18($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61375, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61375:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	b       be_cont.61374
be_else.61373:
	load    17($sp), $i1
	load    119($i1), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    18($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61376, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61376:
	sub     $sp, 20, $sp
	load    19($sp), $ra
be_cont.61374:
	li      116, $i4
	load    17($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61377, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61377:
	sub     $sp, 20, $sp
	load    19($sp), $ra
be_cont.61371:
	load    10($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61378
	b       be_cont.61379
be_else.61378:
	load    7($sp), $i1
	load    3($i1), $i1
	store   $i1, 19($sp)
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
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.61380, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.61380:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i1
	load    118($i1), $i1
	load    0($i1), $i1
	load    0($i1), $f1
	load    11($sp), $i2
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
	store   $f1, 20($sp)
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fisneg
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61381
	load    19($sp), $i1
	load    118($i1), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    20($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61383, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61383:
	sub     $sp, 22, $sp
	load    21($sp), $ra
	b       be_cont.61382
be_else.61381:
	load    19($sp), $i1
	load    119($i1), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    20($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61384, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61384:
	sub     $sp, 22, $sp
	load    21($sp), $ra
be_cont.61382:
	li      116, $i4
	load    19($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61385, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61385:
	sub     $sp, 22, $sp
	load    21($sp), $ra
be_cont.61379:
	load    10($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61386
	b       be_cont.61387
be_else.61386:
	load    7($sp), $i1
	load    4($i1), $i1
	store   $i1, 21($sp)
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
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.61388, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.61388:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $i1
	load    118($i1), $i1
	load    0($i1), $i1
	load    0($i1), $f1
	load    11($sp), $i2
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
	store   $f1, 22($sp)
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fisneg
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61389
	load    21($sp), $i1
	load    118($i1), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    22($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61391, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61391:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	b       be_cont.61390
be_else.61389:
	load    21($sp), $i1
	load    119($i1), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    22($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61392, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61392:
	sub     $sp, 24, $sp
	load    23($sp), $ra
be_cont.61390:
	li      116, $i4
	load    21($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    6($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61393, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61393:
	sub     $sp, 24, $sp
	load    23($sp), $ra
be_cont.61387:
	load    0($sp), $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    4($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	load    8($sp), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i2)
	load    1($i2), $f1
	load    1($i1), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i2)
	load    2($i2), $f1
	load    2($i1), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
	ret
calc_diffuse_using_5points.3128:
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
	load    0($i12), $i1
	load    0($i6), $f1
	load    0($i1), $f2
	load    0($i7), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i6)
	load    1($i6), $f1
	load    1($i1), $f2
	load    1($i7), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i6)
	load    2($i6), $f1
	load    2($i1), $f2
	load    2($i7), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i6)
	ret
do_without_neighbors.3134:
	load    9($i11), $i3
	load    8($i11), $i4
	load    7($i11), $i5
	load    6($i11), $i6
	load    5($i11), $i7
	load    4($i11), $i8
	store   $i8, 0($sp)
	load    3($i11), $i8
	load    2($i11), $i9
	load    1($i11), $i10
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61396
	store   $i5, 1($sp)
	load    2($i1), $i5
	add     $i5, $i2, $i12
	load    0($i12), $i5
	li      0, $i12
	cmp     $i5, $i12, $i12
	bl      $i12, bge_else.61397
	store   $i6, 2($sp)
	store   $i3, 3($sp)
	store   $i9, 4($sp)
	store   $i10, 5($sp)
	store   $i11, 6($sp)
	store   $i1, 7($sp)
	store   $i2, 8($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61398
	b       be_cont.61399
be_else.61398:
	store   $i7, 9($sp)
	store   $i4, 10($sp)
	store   $i8, 11($sp)
	load    5($i1), $i3
	load    7($i1), $i5
	load    1($i1), $i6
	load    4($i1), $i10
	store   $i10, 12($sp)
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    0($i3), $f1
	store   $f1, 0($i9)
	load    1($i3), $f1
	store   $f1, 1($i9)
	load    2($i3), $f1
	store   $f1, 2($i9)
	load    6($i1), $i1
	load    0($i1), $i1
	store   $i1, 13($sp)
	add     $i5, $i2, $i12
	load    0($i12), $i3
	store   $i3, 14($sp)
	add     $i6, $i2, $i12
	load    0($i12), $i2
	store   $i2, 15($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61400
	b       be_cont.61401
be_else.61400:
	load    0($i8), $i1
	store   $i1, 16($sp)
	load    0($i2), $f1
	store   $f1, 0($i4)
	load    1($i2), $f1
	store   $f1, 1($i4)
	load    2($i2), $f1
	store   $f1, 2($i4)
	load    0($i7), $i1
	sub     $i1, 1, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.61402, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.61402:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      118, $i4
	load    16($sp), $i1
	load    14($sp), $i2
	load    15($sp), $i3
	load    0($sp), $i11
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.61403, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.61403:
	sub     $sp, 18, $sp
	load    17($sp), $ra
be_cont.61401:
	load    13($sp), $i1
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61404
	b       be_cont.61405
be_else.61404:
	load    11($sp), $i1
	load    1($i1), $i1
	store   $i1, 17($sp)
	load    15($sp), $i1
	load    0($i1), $f1
	load    10($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    9($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    1($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61406, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61406:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      118, $i4
	load    17($sp), $i1
	load    14($sp), $i2
	load    15($sp), $i3
	load    0($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61407, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61407:
	sub     $sp, 19, $sp
	load    18($sp), $ra
be_cont.61405:
	load    13($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61408
	b       be_cont.61409
be_else.61408:
	load    11($sp), $i1
	load    2($i1), $i1
	store   $i1, 18($sp)
	load    15($sp), $i1
	load    0($i1), $f1
	load    10($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    9($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    1($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61410, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61410:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      118, $i4
	load    18($sp), $i1
	load    14($sp), $i2
	load    15($sp), $i3
	load    0($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61411, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61411:
	sub     $sp, 20, $sp
	load    19($sp), $ra
be_cont.61409:
	load    13($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61412
	b       be_cont.61413
be_else.61412:
	load    11($sp), $i1
	load    3($i1), $i1
	store   $i1, 19($sp)
	load    15($sp), $i1
	load    0($i1), $f1
	load    10($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    9($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    1($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.61414, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.61414:
	sub     $sp, 21, $sp
	load    20($sp), $ra
	li      118, $i4
	load    19($sp), $i1
	load    14($sp), $i2
	load    15($sp), $i3
	load    0($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.61415, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.61415:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.61413:
	load    13($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61416
	b       be_cont.61417
be_else.61416:
	load    11($sp), $i1
	load    4($i1), $i1
	store   $i1, 20($sp)
	load    15($sp), $i1
	load    0($i1), $f1
	load    10($sp), $i2
	store   $f1, 0($i2)
	load    1($i1), $f1
	store   $f1, 1($i2)
	load    2($i1), $f1
	store   $f1, 2($i2)
	load    9($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    1($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61418, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61418:
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      118, $i4
	load    20($sp), $i1
	load    14($sp), $i2
	load    15($sp), $i3
	load    0($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61419, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61419:
	sub     $sp, 22, $sp
	load    21($sp), $ra
be_cont.61417:
	load    8($sp), $i1
	load    12($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    2($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	load    4($sp), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i2)
	load    1($i2), $f1
	load    1($i1), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i2)
	load    2($i2), $f1
	load    2($i1), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
be_cont.61399:
	load    8($sp), $i1
	add     $i1, 1, $i2
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61420
	load    7($sp), $i1
	load    2($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61421
	store   $i2, 21($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61422
	b       be_cont.61423
be_else.61422:
	load    5($sp), $i11
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.61424, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.61424:
	sub     $sp, 23, $sp
	load    22($sp), $ra
be_cont.61423:
	load    21($sp), $i1
	add     $i1, 1, $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61425
	load    7($sp), $i2
	load    2($i2), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61426
	load    3($i2), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61427
	b       be_cont.61428
be_else.61427:
	store   $i1, 22($sp)
	load    5($i2), $i3
	load    7($i2), $i4
	load    1($i2), $i5
	load    4($i2), $i6
	store   $i6, 23($sp)
	add     $i3, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $f1
	load    4($sp), $i6
	store   $f1, 0($i6)
	load    1($i3), $f1
	store   $f1, 1($i6)
	load    2($i3), $f1
	store   $f1, 2($i6)
	load    6($i2), $i2
	load    0($i2), $i2
	add     $i4, $i1, $i12
	load    0($i12), $i3
	add     $i5, $i1, $i12
	load    0($i12), $i1
	load    3($sp), $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i2, $i1
	mov     $i10, $i2
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.61429, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.61429:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    22($sp), $i1
	load    23($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    2($sp), $i3
	load    0($i3), $f1
	load    0($i2), $f2
	load    4($sp), $i4
	load    0($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i3)
	load    1($i3), $f1
	load    1($i2), $f2
	load    1($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i3)
	load    2($i3), $f1
	load    2($i2), $f2
	load    2($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i3)
be_cont.61428:
	add     $i1, 1, $i2
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61430
	load    7($sp), $i1
	load    2($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61431
	store   $i2, 24($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61432
	b       be_cont.61433
be_else.61432:
	load    5($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61434, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61434:
	sub     $sp, 26, $sp
	load    25($sp), $ra
be_cont.61433:
	load    24($sp), $i1
	add     $i1, 1, $i2
	load    7($sp), $i1
	load    6($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61431:
	ret
ble_else.61430:
	ret
bge_else.61426:
	ret
ble_else.61425:
	ret
bge_else.61421:
	ret
ble_else.61420:
	ret
bge_else.61397:
	ret
ble_else.61396:
	ret
try_exploit_neighbors.3150:
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	load    6($i11), $i2
	load    5($i11), $i7
	load    4($i11), $i8
	load    3($i11), $i9
	load    2($i11), $i10
	store   $i10, 2($sp)
	load    1($i11), $i11
	add     $i4, $i1, $i12
	load    0($i12), $i10
	li      4, $i12
	cmp     $i6, $i12, $i12
	bg      $i12, ble_else.61443
	store   $i10, 3($sp)
	load    2($i10), $i10
	add     $i10, $i6, $i12
	load    0($i12), $i10
	li      0, $i12
	cmp     $i10, $i12, $i12
	bl      $i12, bge_else.61444
	store   $i3, 4($sp)
	add     $i4, $i1, $i12
	load    0($i12), $i10
	load    2($i10), $i10
	add     $i10, $i6, $i12
	load    0($i12), $i10
	add     $i3, $i1, $i12
	load    0($i12), $i3
	load    2($i3), $i3
	add     $i3, $i6, $i12
	load    0($i12), $i3
	cmp     $i3, $i10, $i12
	bne     $i12, be_else.61445
	add     $i5, $i1, $i12
	load    0($i12), $i3
	load    2($i3), $i3
	add     $i3, $i6, $i12
	load    0($i12), $i3
	cmp     $i3, $i10, $i12
	bne     $i12, be_else.61447
	sub     $i1, 1, $i3
	add     $i4, $i3, $i12
	load    0($i12), $i3
	load    2($i3), $i3
	add     $i3, $i6, $i12
	load    0($i12), $i3
	cmp     $i3, $i10, $i12
	bne     $i12, be_else.61449
	add     $i1, 1, $i3
	add     $i4, $i3, $i12
	load    0($i12), $i3
	load    2($i3), $i3
	add     $i3, $i6, $i12
	load    0($i12), $i3
	cmp     $i3, $i10, $i12
	bne     $i12, be_else.61451
	li      1, $i3
	b       be_cont.61452
be_else.61451:
	li      0, $i3
be_cont.61452:
	b       be_cont.61450
be_else.61449:
	li      0, $i3
be_cont.61450:
	b       be_cont.61448
be_else.61447:
	li      0, $i3
be_cont.61448:
	b       be_cont.61446
be_else.61445:
	li      0, $i3
be_cont.61446:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61453
	add     $i4, $i1, $i12
	load    0($i12), $i1
	li      4, $i12
	cmp     $i6, $i12, $i12
	bg      $i12, ble_else.61454
	load    2($i1), $i3
	add     $i3, $i6, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61455
	store   $i7, 5($sp)
	store   $i2, 6($sp)
	store   $i9, 7($sp)
	store   $i11, 8($sp)
	store   $i8, 9($sp)
	store   $i1, 10($sp)
	store   $i6, 11($sp)
	load    3($i1), $i2
	add     $i2, $i6, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61456
	b       be_cont.61457
be_else.61456:
	mov     $i6, $i2
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.61458, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.61458:
	sub     $sp, 13, $sp
	load    12($sp), $ra
be_cont.61457:
	load    11($sp), $i1
	add     $i1, 1, $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61459
	load    10($sp), $i2
	load    2($i2), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61460
	load    3($i2), $i3
	add     $i3, $i1, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61461
	b       be_cont.61462
be_else.61461:
	store   $i1, 12($sp)
	load    5($i2), $i3
	load    7($i2), $i4
	load    1($i2), $i5
	load    4($i2), $i6
	store   $i6, 13($sp)
	add     $i3, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $f1
	load    7($sp), $i6
	store   $f1, 0($i6)
	load    1($i3), $f1
	store   $f1, 1($i6)
	load    2($i3), $f1
	store   $f1, 2($i6)
	load    6($i2), $i2
	load    0($i2), $i2
	add     $i4, $i1, $i12
	load    0($i12), $i3
	add     $i5, $i1, $i12
	load    0($i12), $i1
	load    6($sp), $i11
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i2, $i1
	mov     $i10, $i2
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.61463, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.61463:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    12($sp), $i1
	load    13($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($sp), $i3
	load    0($i3), $f1
	load    0($i2), $f2
	load    7($sp), $i4
	load    0($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i3)
	load    1($i3), $f1
	load    1($i2), $f2
	load    1($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i3)
	load    2($i3), $f1
	load    2($i2), $f2
	load    2($i4), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i3)
be_cont.61462:
	add     $i1, 1, $i2
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61464
	load    10($sp), $i1
	load    2($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61465
	store   $i2, 14($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61466
	b       be_cont.61467
be_else.61466:
	load    8($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.61468, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.61468:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.61467:
	load    14($sp), $i1
	add     $i1, 1, $i2
	load    10($sp), $i1
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61465:
	ret
ble_else.61464:
	ret
bge_else.61460:
	ret
ble_else.61459:
	ret
bge_else.61455:
	ret
ble_else.61454:
	ret
be_else.61453:
	store   $i2, 6($sp)
	store   $i11, 8($sp)
	store   $i8, 9($sp)
	store   $i5, 15($sp)
	load    3($sp), $i2
	load    3($i2), $i2
	add     $i2, $i6, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61475
	b       be_cont.61476
be_else.61475:
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($i2), $i2
	sub     $i1, 1, $i3
	add     $i4, $i3, $i12
	load    0($i12), $i3
	load    5($i3), $i3
	add     $i4, $i1, $i12
	load    0($i12), $i8
	load    5($i8), $i8
	add     $i1, 1, $i10
	add     $i4, $i10, $i12
	load    0($i12), $i10
	load    5($i10), $i10
	add     $i5, $i1, $i12
	load    0($i12), $i5
	load    5($i5), $i5
	add     $i2, $i6, $i12
	load    0($i12), $i2
	load    0($i2), $f1
	store   $f1, 0($i9)
	load    1($i2), $f1
	store   $f1, 1($i9)
	load    2($i2), $f1
	store   $f1, 2($i9)
	add     $i3, $i6, $i12
	load    0($i12), $i2
	load    0($i9), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i9)
	load    1($i9), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i9)
	load    2($i9), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i9)
	add     $i8, $i6, $i12
	load    0($i12), $i2
	load    0($i9), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i9)
	load    1($i9), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i9)
	load    2($i9), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i9)
	add     $i10, $i6, $i12
	load    0($i12), $i2
	load    0($i9), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i9)
	load    1($i9), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i9)
	load    2($i9), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i9)
	add     $i5, $i6, $i12
	load    0($i12), $i2
	load    0($i9), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i9)
	load    1($i9), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i9)
	load    2($i9), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i9)
	add     $i4, $i1, $i12
	load    0($i12), $i2
	load    4($i2), $i2
	add     $i2, $i6, $i12
	load    0($i12), $i2
	load    0($i7), $f1
	load    0($i2), $f2
	load    0($i9), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i7)
	load    1($i7), $f1
	load    1($i2), $f2
	load    1($i9), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i7)
	load    2($i7), $f1
	load    2($i2), $f2
	load    2($i9), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i7)
be_cont.61476:
	add     $i6, 1, $i5
	add     $i4, $i1, $i12
	load    0($i12), $i2
	li      4, $i12
	cmp     $i5, $i12, $i12
	bg      $i12, ble_else.61477
	load    2($i2), $i3
	add     $i3, $i5, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61478
	add     $i4, $i1, $i12
	load    0($i12), $i3
	load    2($i3), $i3
	add     $i3, $i5, $i12
	load    0($i12), $i3
	load    4($sp), $i6
	add     $i6, $i1, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i5, $i12
	load    0($i12), $i8
	cmp     $i8, $i3, $i12
	bne     $i12, be_else.61479
	load    15($sp), $i8
	add     $i8, $i1, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i5, $i12
	load    0($i12), $i8
	cmp     $i8, $i3, $i12
	bne     $i12, be_else.61481
	sub     $i1, 1, $i8
	add     $i4, $i8, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i5, $i12
	load    0($i12), $i8
	cmp     $i8, $i3, $i12
	bne     $i12, be_else.61483
	add     $i1, 1, $i8
	add     $i4, $i8, $i12
	load    0($i12), $i8
	load    2($i8), $i8
	add     $i8, $i5, $i12
	load    0($i12), $i8
	cmp     $i8, $i3, $i12
	bne     $i12, be_else.61485
	li      1, $i3
	b       be_cont.61486
be_else.61485:
	li      0, $i3
be_cont.61486:
	b       be_cont.61484
be_else.61483:
	li      0, $i3
be_cont.61484:
	b       be_cont.61482
be_else.61481:
	li      0, $i3
be_cont.61482:
	b       be_cont.61480
be_else.61479:
	li      0, $i3
be_cont.61480:
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61487
	add     $i4, $i1, $i12
	load    0($i12), $i1
	li      4, $i12
	cmp     $i5, $i12, $i12
	bg      $i12, ble_else.61488
	load    2($i1), $i2
	add     $i2, $i5, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61489
	store   $i1, 16($sp)
	store   $i5, 17($sp)
	load    3($i1), $i2
	add     $i2, $i5, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61490
	b       be_cont.61491
be_else.61490:
	store   $i9, 7($sp)
	store   $i7, 5($sp)
	load    5($i1), $i2
	load    7($i1), $i3
	load    1($i1), $i4
	load    4($i1), $i6
	store   $i6, 18($sp)
	add     $i2, $i5, $i12
	load    0($i12), $i2
	load    0($i2), $f1
	store   $f1, 0($i9)
	load    1($i2), $f1
	store   $f1, 1($i9)
	load    2($i2), $f1
	store   $f1, 2($i9)
	load    6($i1), $i1
	load    0($i1), $i1
	add     $i3, $i5, $i12
	load    0($i12), $i2
	add     $i4, $i5, $i12
	load    0($i12), $i3
	load    6($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61492, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61492:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    17($sp), $i1
	load    18($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    5($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	load    7($sp), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i2)
	load    1($i2), $f1
	load    1($i1), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i2)
	load    2($i2), $f1
	load    2($i1), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
be_cont.61491:
	load    17($sp), $i1
	add     $i1, 1, $i2
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61493
	load    16($sp), $i1
	load    2($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61494
	store   $i2, 19($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61495
	b       be_cont.61496
be_else.61495:
	load    8($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.61497, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.61497:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.61496:
	load    19($sp), $i1
	add     $i1, 1, $i2
	load    16($sp), $i1
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61494:
	ret
ble_else.61493:
	ret
bge_else.61489:
	ret
ble_else.61488:
	ret
be_else.61487:
	store   $i4, 20($sp)
	store   $i1, 21($sp)
	store   $i5, 17($sp)
	load    3($i2), $i2
	add     $i2, $i5, $i12
	load    0($i12), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61502
	b       be_cont.61503
be_else.61502:
	load    15($sp), $i2
	load    2($sp), $i11
	mov     $i4, $i3
	mov     $i2, $i4
	mov     $i6, $i2
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.61504, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.61504:
	sub     $sp, 23, $sp
	load    22($sp), $ra
be_cont.61503:
	load    17($sp), $i1
	add     $i1, 1, $i6
	load    21($sp), $i1
	load    1($sp), $i2
	load    4($sp), $i3
	load    20($sp), $i4
	load    15($sp), $i5
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61478:
	ret
ble_else.61477:
	ret
bge_else.61444:
	ret
ble_else.61443:
	ret
pretrace_diffuse_rays.3163:
	load    7($i11), $i3
	load    6($i11), $i4
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	load    1($i11), $i9
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61509
	load    2($i1), $i10
	add     $i10, $i2, $i12
	load    0($i12), $i10
	li      0, $i12
	cmp     $i10, $i12, $i12
	bl      $i12, bge_else.61510
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
	bne     $i12, be_else.61511
	b       be_cont.61512
be_else.61511:
	store   $i1, 9($sp)
	load    6($i1), $i3
	load    0($i3), $i3
	li      l.25703, $i7
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
	li      cls.61513, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.61513:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      118, $i4
	load    10($sp), $i1
	load    11($sp), $i2
	load    12($sp), $i3
	load    0($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.61514, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.61514:
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
be_cont.61512:
	load    8($sp), $i2
	add     $i2, 1, $i2
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61515
	load    2($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61516
	store   $i2, 13($sp)
	load    3($i1), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61517
	b       be_cont.61518
be_else.61517:
	store   $i1, 9($sp)
	load    6($i1), $i3
	load    0($i3), $i3
	li      l.25703, $i4
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
	li      cls.61519, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.61519:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    14($sp), $i1
	load    118($i1), $i1
	load    0($i1), $i1
	load    0($i1), $f1
	load    15($sp), $i2
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
	store   $f1, 17($sp)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fisneg
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61520
	load    14($sp), $i1
	load    118($i1), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    17($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61522, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61522:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	b       be_cont.61521
be_else.61520:
	load    14($sp), $i1
	load    119($i1), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    17($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    1($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61523, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61523:
	sub     $sp, 19, $sp
	load    18($sp), $ra
be_cont.61521:
	li      116, $i4
	load    14($sp), $i1
	load    15($sp), $i2
	load    16($sp), $i3
	load    0($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61524, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61524:
	sub     $sp, 19, $sp
	load    18($sp), $ra
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
be_cont.61518:
	load    13($sp), $i2
	add     $i2, 1, $i2
	load    7($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61516:
	ret
ble_else.61515:
	ret
bge_else.61510:
	ret
ble_else.61509:
	ret
pretrace_pixels.3166:
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
	bl      $i12, bge_else.61529
	store   $i11, 9($sp)
	store   $i9, 10($sp)
	store   $i6, 11($sp)
	store   $i2, 12($sp)
	store   $i1, 13($sp)
	store   $i4, 14($sp)
	store   $i3, 15($sp)
	store   $i7, 16($sp)
	store   $f3, 17($sp)
	store   $f2, 18($sp)
	store   $i8, 19($sp)
	store   $f1, 20($sp)
	store   $i5, 21($sp)
	store   $i10, 22($sp)
	load    0($i6), $f1
	store   $f1, 23($sp)
	load    0($i9), $i1
	sub     $i2, $i1, $i1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_float_of_int
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    23($sp), $f2
	fmul    $f2, $f1, $f1
	load    21($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    20($sp), $f3
	fadd    $f2, $f3, $f2
	load    19($sp), $i2
	store   $f2, 0($i2)
	load    1($i1), $f2
	fmul    $f1, $f2, $f2
	load    18($sp), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i2)
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	load    17($sp), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
	load    0($i2), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fsqr
	sub     $sp, 25, $sp
	load    24($sp), $ra
	store   $f1, 24($sp)
	load    19($sp), $i1
	load    1($i1), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fsqr
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 25($sp)
	load    19($sp), $i1
	load    2($i1), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fsqr
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    25($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     sqrt.2729
	sub     $sp, 27, $sp
	load    26($sp), $ra
	store   $f1, 26($sp)
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fiszero
	sub     $sp, 28, $sp
	load    27($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61530
	li      l.25743, $i1
	load    0($i1), $f1
	load    26($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.61531
be_else.61530:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.61531:
	load    19($sp), $i2
	load    0($i2), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 0($i2)
	load    1($i2), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 1($i2)
	load    2($i2), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 2($i2)
	li      l.25703, $i1
	load    0($i1), $f1
	load    16($sp), $i1
	store   $f1, 0($i1)
	store   $f1, 1($i1)
	store   $f1, 2($i1)
	load    15($sp), $i1
	load    0($i1), $f1
	load    14($sp), $i3
	store   $f1, 0($i3)
	load    1($i1), $f1
	store   $f1, 1($i3)
	load    2($i1), $f1
	store   $f1, 2($i3)
	li      0, $i1
	li      l.25743, $i3
	load    0($i3), $f1
	load    12($sp), $i3
	load    13($sp), $i4
	add     $i4, $i3, $i12
	load    0($i12), $i3
	li      l.25703, $i4
	load    0($i4), $f2
	load    2($sp), $i11
	store   $ra, 27($sp)
	load    0($i11), $i10
	li      cls.61532, $ra
	add     $sp, 28, $sp
	jr      $i10
cls.61532:
	sub     $sp, 28, $sp
	load    27($sp), $ra
	load    12($sp), $i1
	load    13($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    16($sp), $i4
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
	bl      $i12, bge_else.61533
	load    3($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61535
	b       be_cont.61536
be_else.61535:
	store   $i1, 27($sp)
	load    6($i1), $i2
	load    0($i2), $i2
	li      l.25703, $i3
	load    0($i3), $f1
	load    9($sp), $i3
	store   $f1, 0($i3)
	store   $f1, 1($i3)
	store   $f1, 2($i3)
	load    7($i1), $i3
	load    1($i1), $i1
	load    22($sp), $i4
	add     $i4, $i2, $i12
	load    0($i12), $i2
	store   $i2, 28($sp)
	load    0($i3), $i2
	store   $i2, 29($sp)
	load    0($i1), $i1
	store   $i1, 30($sp)
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
	store   $ra, 31($sp)
	load    0($i11), $i10
	li      cls.61537, $ra
	add     $sp, 32, $sp
	jr      $i10
cls.61537:
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    28($sp), $i1
	load    118($i1), $i1
	load    0($i1), $i1
	load    0($i1), $f1
	load    29($sp), $i2
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
	store   $f1, 31($sp)
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_fisneg
	sub     $sp, 33, $sp
	load    32($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61538
	load    28($sp), $i1
	load    118($i1), $i1
	li      l.26170, $i2
	load    0($i2), $f1
	load    31($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    3($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.61540, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.61540:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	b       be_cont.61539
be_else.61538:
	load    28($sp), $i1
	load    119($i1), $i1
	li      l.26160, $i2
	load    0($i2), $f1
	load    31($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    3($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.61541, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.61541:
	sub     $sp, 33, $sp
	load    32($sp), $ra
be_cont.61539:
	li      116, $i4
	load    28($sp), $i1
	load    29($sp), $i2
	load    30($sp), $i3
	load    8($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.61542, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.61542:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    27($sp), $i1
	load    5($i1), $i2
	load    0($i2), $i2
	load    9($sp), $i3
	load    0($i3), $f1
	store   $f1, 0($i2)
	load    1($i3), $f1
	store   $f1, 1($i2)
	load    2($i3), $f1
	store   $f1, 2($i2)
be_cont.61536:
	li      1, $i2
	load    6($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.61543, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.61543:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	b       bge_cont.61534
bge_else.61533:
bge_cont.61534:
	load    12($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i2
	add     $i2, 1, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61544
	sub     $i2, 5, $i2
	b       bge_cont.61545
bge_else.61544:
bge_cont.61545:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61546
	store   $i2, 32($sp)
	store   $i1, 33($sp)
	load    11($sp), $i2
	load    0($i2), $f1
	store   $f1, 34($sp)
	load    10($sp), $i2
	load    0($i2), $i2
	sub     $i1, $i2, $i1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_float_of_int
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    34($sp), $f2
	fmul    $f2, $f1, $f1
	load    21($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    20($sp), $f3
	fadd    $f2, $f3, $f2
	load    19($sp), $i2
	store   $f2, 0($i2)
	load    1($i1), $f2
	fmul    $f1, $f2, $f2
	load    18($sp), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i2)
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	load    17($sp), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
	load    0($i2), $f1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_fsqr
	sub     $sp, 36, $sp
	load    35($sp), $ra
	store   $f1, 35($sp)
	load    19($sp), $i1
	load    1($i1), $f1
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_fsqr
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    35($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 36($sp)
	load    19($sp), $i1
	load    2($i1), $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fsqr
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    36($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     sqrt.2729
	sub     $sp, 38, $sp
	load    37($sp), $ra
	store   $f1, 37($sp)
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_fiszero
	sub     $sp, 39, $sp
	load    38($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61547
	li      l.25743, $i1
	load    0($i1), $f1
	load    37($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.61548
be_else.61547:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.61548:
	load    19($sp), $i2
	load    0($i2), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 0($i2)
	load    1($i2), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 1($i2)
	load    2($i2), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 2($i2)
	li      l.25703, $i1
	load    0($i1), $f1
	load    16($sp), $i1
	store   $f1, 0($i1)
	store   $f1, 1($i1)
	store   $f1, 2($i1)
	load    15($sp), $i1
	load    0($i1), $f1
	load    14($sp), $i3
	store   $f1, 0($i3)
	load    1($i1), $f1
	store   $f1, 1($i3)
	load    2($i1), $f1
	store   $f1, 2($i3)
	li      0, $i1
	li      l.25743, $i3
	load    0($i3), $f1
	load    33($sp), $i3
	load    13($sp), $i4
	add     $i4, $i3, $i12
	load    0($i12), $i3
	li      l.25703, $i4
	load    0($i4), $f2
	load    2($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.61549, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.61549:
	sub     $sp, 39, $sp
	load    38($sp), $ra
	load    33($sp), $i1
	load    13($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    16($sp), $i4
	load    0($i4), $f1
	store   $f1, 0($i3)
	load    1($i4), $f1
	store   $f1, 1($i3)
	load    2($i4), $f1
	store   $f1, 2($i3)
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    6($i3), $i3
	load    32($sp), $i4
	store   $i4, 0($i3)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      0, $i2
	load    6($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.61550, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.61550:
	sub     $sp, 39, $sp
	load    38($sp), $ra
	load    33($sp), $i1
	sub     $i1, 1, $i2
	load    32($sp), $i1
	add     $i1, 1, $i1
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61551
	sub     $i1, 5, $i1
	b       bge_cont.61552
bge_else.61551:
bge_cont.61552:
	mov     $i1, $i3
	load    20($sp), $f1
	load    18($sp), $f2
	load    17($sp), $f3
	load    13($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61546:
	ret
bge_else.61529:
	ret
pretrace_line.3173:
	store   $i1, 0($sp)
	store   $i3, 1($sp)
	load    13($i11), $i1
	store   $i1, 2($sp)
	load    12($i11), $i1
	store   $i1, 3($sp)
	load    11($i11), $i1
	store   $i1, 4($sp)
	load    10($i11), $i1
	store   $i1, 5($sp)
	load    9($i11), $i1
	store   $i1, 6($sp)
	load    8($i11), $i1
	store   $i1, 7($sp)
	load    7($i11), $i1
	store   $i1, 8($sp)
	load    6($i11), $i3
	store   $i3, 9($sp)
	load    5($i11), $i3
	store   $i3, 10($sp)
	load    4($i11), $i3
	store   $i3, 11($sp)
	load    3($i11), $i3
	store   $i3, 12($sp)
	load    2($i11), $i3
	store   $i3, 13($sp)
	load    1($i11), $i3
	store   $i3, 14($sp)
	load    0($i1), $f1
	store   $f1, 15($sp)
	load    1($i3), $i1
	sub     $i2, $i1, $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_float_of_int
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f2, $f1, $f1
	load    6($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    5($sp), $i2
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
	load    13($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61555
	store   $i1, 16($sp)
	store   $f1, 17($sp)
	store   $f3, 18($sp)
	store   $f2, 19($sp)
	load    8($sp), $i2
	load    0($i2), $f1
	store   $f1, 20($sp)
	load    14($sp), $i2
	load    0($i2), $i2
	sub     $i1, $i2, $i1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_float_of_int
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    20($sp), $f2
	fmul    $f2, $f1, $f1
	load    7($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    19($sp), $f3
	fadd    $f2, $f3, $f2
	load    10($sp), $i2
	store   $f2, 0($i2)
	load    1($i1), $f2
	fmul    $f1, $f2, $f2
	load    18($sp), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i2)
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	load    17($sp), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
	load    0($i2), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fsqr
	sub     $sp, 22, $sp
	load    21($sp), $ra
	store   $f1, 21($sp)
	load    10($sp), $i1
	load    1($i1), $f1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fsqr
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 22($sp)
	load    10($sp), $i1
	load    2($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fsqr
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    22($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     sqrt.2729
	sub     $sp, 24, $sp
	load    23($sp), $ra
	store   $f1, 23($sp)
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fiszero
	sub     $sp, 25, $sp
	load    24($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61556
	li      l.25743, $i1
	load    0($i1), $f1
	load    23($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.61557
be_else.61556:
	li      l.25743, $i1
	load    0($i1), $f1
be_cont.61557:
	load    10($sp), $i2
	load    0($i2), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 0($i2)
	load    1($i2), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 1($i2)
	load    2($i2), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 2($i2)
	li      l.25703, $i1
	load    0($i1), $f1
	load    9($sp), $i1
	store   $f1, 0($i1)
	store   $f1, 1($i1)
	store   $f1, 2($i1)
	load    2($sp), $i1
	load    0($i1), $f1
	load    4($sp), $i3
	store   $f1, 0($i3)
	load    1($i1), $f1
	store   $f1, 1($i3)
	load    2($i1), $f1
	store   $f1, 2($i3)
	li      0, $i1
	li      l.25743, $i3
	load    0($i3), $f1
	load    16($sp), $i3
	load    0($sp), $i4
	add     $i4, $i3, $i12
	load    0($i12), $i3
	li      l.25703, $i4
	load    0($i4), $f2
	load    3($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.61558, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.61558:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    16($sp), $i1
	load    0($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    9($sp), $i4
	load    0($i4), $f1
	store   $f1, 0($i3)
	load    1($i4), $f1
	store   $f1, 1($i3)
	load    2($i4), $f1
	store   $f1, 2($i3)
	add     $i2, $i1, $i12
	load    0($i12), $i3
	load    6($i3), $i3
	load    1($sp), $i4
	store   $i4, 0($i3)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      0, $i2
	load    12($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.61559, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.61559:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    16($sp), $i1
	sub     $i1, 1, $i2
	load    1($sp), $i1
	add     $i1, 1, $i1
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61560
	sub     $i1, 5, $i1
	b       bge_cont.61561
bge_else.61560:
bge_cont.61561:
	mov     $i1, $i3
	load    19($sp), $f1
	load    18($sp), $f2
	load    17($sp), $f3
	load    0($sp), $i1
	load    11($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61555:
	ret
scan_pixel.3177:
	load    8($i11), $i6
	store   $i6, 0($sp)
	load    7($i11), $i6
	store   $i6, 1($sp)
	load    6($i11), $i6
	load    5($i11), $i7
	load    4($i11), $i8
	load    3($i11), $i9
	store   $i9, 2($sp)
	load    2($i11), $i9
	store   $i9, 3($sp)
	load    1($i11), $i9
	load    0($i7), $i10
	cmp     $i10, $i1, $i12
	bg      $i12, ble_else.61563
	ret
ble_else.61563:
	store   $i5, 4($sp)
	store   $i3, 5($sp)
	store   $i11, 6($sp)
	store   $i8, 7($sp)
	store   $i2, 8($sp)
	store   $i4, 9($sp)
	store   $i7, 10($sp)
	store   $i1, 11($sp)
	store   $i6, 12($sp)
	store   $i9, 13($sp)
	add     $i4, $i1, $i12
	load    0($i12), $i9
	load    0($i9), $i9
	load    0($i9), $f1
	store   $f1, 0($i6)
	load    1($i9), $f1
	store   $f1, 1($i6)
	load    2($i9), $f1
	store   $f1, 2($i6)
	load    1($i7), $i9
	add     $i2, 1, $i10
	cmp     $i9, $i10, $i12
	bg      $i12, ble_else.61565
	li      0, $i7
	b       ble_cont.61566
ble_else.61565:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61567
	li      0, $i7
	b       ble_cont.61568
ble_else.61567:
	load    0($i7), $i7
	add     $i1, 1, $i9
	cmp     $i7, $i9, $i12
	bg      $i12, ble_else.61569
	li      0, $i7
	b       ble_cont.61570
ble_else.61569:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61571
	li      0, $i7
	b       ble_cont.61572
ble_else.61571:
	li      1, $i7
ble_cont.61572:
ble_cont.61570:
ble_cont.61568:
ble_cont.61566:
	li      0, $i12
	cmp     $i7, $i12, $i12
	bne     $i12, be_else.61573
	add     $i4, $i1, $i12
	load    0($i12), $i1
	li      0, $i2
	load    2($i1), $i3
	load    0($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61575
	store   $i1, 14($sp)
	load    3($i1), $i3
	load    0($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61577
	b       be_cont.61578
be_else.61577:
	load    13($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.61579, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.61579:
	sub     $sp, 16, $sp
	load    15($sp), $ra
be_cont.61578:
	load    14($sp), $i1
	load    2($i1), $i2
	load    1($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61580
	load    3($i1), $i2
	load    1($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61582
	b       be_cont.61583
be_else.61582:
	load    5($i1), $i2
	load    7($i1), $i3
	load    1($i1), $i4
	load    4($i1), $i5
	store   $i5, 15($sp)
	load    1($i2), $i2
	load    0($i2), $f1
	load    2($sp), $i5
	store   $f1, 0($i5)
	load    1($i2), $f1
	store   $f1, 1($i5)
	load    2($i2), $f1
	store   $f1, 2($i5)
	load    6($i1), $i1
	load    0($i1), $i1
	load    1($i3), $i2
	load    1($i4), $i3
	load    1($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.61584, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.61584:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    1($i1), $i1
	load    12($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	load    2($sp), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i2)
	load    1($i2), $f1
	load    1($i1), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i2)
	load    2($i2), $f1
	load    2($i1), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
be_cont.61583:
	li      2, $i2
	load    14($sp), $i1
	load    2($i1), $i3
	load    2($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61585
	load    3($i1), $i3
	load    2($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61587
	b       be_cont.61588
be_else.61587:
	load    13($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.61589, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.61589:
	sub     $sp, 17, $sp
	load    16($sp), $ra
be_cont.61588:
	li      3, $i2
	load    14($sp), $i1
	load    7($sp), $i11
	store   $ra, 16($sp)
	load    0($i11), $i10
	li      cls.61590, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.61590:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	b       bge_cont.61586
bge_else.61585:
bge_cont.61586:
	b       bge_cont.61581
bge_else.61580:
bge_cont.61581:
	b       bge_cont.61576
bge_else.61575:
bge_cont.61576:
	b       be_cont.61574
be_else.61573:
	li      0, $i7
	add     $i4, $i1, $i12
	load    0($i12), $i9
	load    2($i9), $i10
	load    0($i10), $i10
	li      0, $i12
	cmp     $i10, $i12, $i12
	bl      $i12, bge_else.61591
	add     $i4, $i1, $i12
	load    0($i12), $i10
	load    2($i10), $i10
	load    0($i10), $i10
	add     $i3, $i1, $i12
	load    0($i12), $i11
	load    2($i11), $i11
	load    0($i11), $i11
	cmp     $i11, $i10, $i12
	bne     $i12, be_else.61593
	add     $i5, $i1, $i12
	load    0($i12), $i11
	load    2($i11), $i11
	load    0($i11), $i11
	cmp     $i11, $i10, $i12
	bne     $i12, be_else.61595
	sub     $i1, 1, $i11
	add     $i4, $i11, $i12
	load    0($i12), $i11
	load    2($i11), $i11
	load    0($i11), $i11
	cmp     $i11, $i10, $i12
	bne     $i12, be_else.61597
	add     $i1, 1, $i11
	add     $i4, $i11, $i12
	load    0($i12), $i11
	load    2($i11), $i11
	load    0($i11), $i11
	cmp     $i11, $i10, $i12
	bne     $i12, be_else.61599
	li      1, $i10
	b       be_cont.61600
be_else.61599:
	li      0, $i10
be_cont.61600:
	b       be_cont.61598
be_else.61597:
	li      0, $i10
be_cont.61598:
	b       be_cont.61596
be_else.61595:
	li      0, $i10
be_cont.61596:
	b       be_cont.61594
be_else.61593:
	li      0, $i10
be_cont.61594:
	li      0, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.61601
	add     $i4, $i1, $i12
	load    0($i12), $i1
	load    2($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61603
	store   $i1, 16($sp)
	load    3($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61605
	b       be_cont.61606
be_else.61605:
	load    5($i1), $i2
	load    7($i1), $i3
	load    1($i1), $i4
	load    4($i1), $i5
	store   $i5, 17($sp)
	load    0($i2), $i2
	load    0($i2), $f1
	load    2($sp), $i5
	store   $f1, 0($i5)
	load    1($i2), $f1
	store   $f1, 1($i5)
	load    2($i2), $f1
	store   $f1, 2($i5)
	load    6($i1), $i1
	load    0($i1), $i1
	load    0($i3), $i2
	load    0($i4), $i3
	load    1($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61607, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61607:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $i1
	load    0($i1), $i1
	load    12($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	load    2($sp), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i2)
	load    1($i2), $f1
	load    1($i1), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i2)
	load    2($i2), $f1
	load    2($i1), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
be_cont.61606:
	li      1, $i2
	load    16($sp), $i1
	load    2($i1), $i3
	load    1($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61608
	load    3($i1), $i3
	load    1($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61610
	b       be_cont.61611
be_else.61610:
	load    13($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61612, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61612:
	sub     $sp, 19, $sp
	load    18($sp), $ra
be_cont.61611:
	li      2, $i2
	load    16($sp), $i1
	load    7($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61613, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61613:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	b       bge_cont.61609
bge_else.61608:
bge_cont.61609:
	b       bge_cont.61604
bge_else.61603:
bge_cont.61604:
	b       be_cont.61602
be_else.61601:
	load    3($i9), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61614
	b       be_cont.61615
be_else.61614:
	load    3($sp), $i11
	mov     $i3, $i2
	mov     $i4, $i3
	mov     $i5, $i4
	mov     $i7, $i5
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61616, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61616:
	sub     $sp, 19, $sp
	load    18($sp), $ra
be_cont.61615:
	li      1, $i6
	load    11($sp), $i1
	load    8($sp), $i2
	load    5($sp), $i3
	load    9($sp), $i4
	load    4($sp), $i5
	load    0($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.61617, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.61617:
	sub     $sp, 19, $sp
	load    18($sp), $ra
be_cont.61602:
	b       bge_cont.61592
bge_else.61591:
bge_cont.61592:
be_cont.61574:
	load    12($sp), $i1
	load    0($i1), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_int_of_float
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61618
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61620
	b       bge_cont.61621
bge_else.61620:
	li      0, $i1
bge_cont.61621:
	b       ble_cont.61619
ble_else.61618:
	li      255, $i1
ble_cont.61619:
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_write
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    12($sp), $i1
	load    1($i1), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_int_of_float
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61622
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61624
	b       bge_cont.61625
bge_else.61624:
	li      0, $i1
bge_cont.61625:
	b       ble_cont.61623
ble_else.61622:
	li      255, $i1
ble_cont.61623:
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_write
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    12($sp), $i1
	load    2($i1), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_int_of_float
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61626
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61628
	b       bge_cont.61629
bge_else.61628:
	li      0, $i1
bge_cont.61629:
	b       ble_cont.61627
ble_else.61626:
	li      255, $i1
ble_cont.61627:
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_write
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    11($sp), $i1
	add     $i1, 1, $i1
	load    10($sp), $i2
	load    0($i2), $i3
	cmp     $i3, $i1, $i12
	bg      $i12, ble_else.61630
	ret
ble_else.61630:
	store   $i1, 18($sp)
	load    9($sp), $i4
	add     $i4, $i1, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	load    0($i3), $f1
	load    12($sp), $i5
	store   $f1, 0($i5)
	load    1($i3), $f1
	store   $f1, 1($i5)
	load    2($i3), $f1
	store   $f1, 2($i5)
	load    1($i2), $i3
	load    8($sp), $i6
	add     $i6, 1, $i7
	cmp     $i3, $i7, $i12
	bg      $i12, ble_else.61632
	li      0, $i2
	b       ble_cont.61633
ble_else.61632:
	li      0, $i12
	cmp     $i6, $i12, $i12
	bg      $i12, ble_else.61634
	li      0, $i2
	b       ble_cont.61635
ble_else.61634:
	load    0($i2), $i2
	add     $i1, 1, $i3
	cmp     $i2, $i3, $i12
	bg      $i12, ble_else.61636
	li      0, $i2
	b       ble_cont.61637
ble_else.61636:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61638
	li      0, $i2
	b       ble_cont.61639
ble_else.61638:
	li      1, $i2
ble_cont.61639:
ble_cont.61637:
ble_cont.61635:
ble_cont.61633:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61640
	add     $i4, $i1, $i12
	load    0($i12), $i1
	load    2($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61642
	store   $i1, 19($sp)
	load    3($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61644
	b       be_cont.61645
be_else.61644:
	load    5($i1), $i2
	load    7($i1), $i3
	load    1($i1), $i4
	load    4($i1), $i5
	store   $i5, 20($sp)
	load    0($i2), $i2
	load    0($i2), $f1
	load    2($sp), $i5
	store   $f1, 0($i5)
	load    1($i2), $f1
	store   $f1, 1($i5)
	load    2($i2), $f1
	store   $f1, 2($i5)
	load    6($i1), $i1
	load    0($i1), $i1
	load    0($i3), $i2
	load    0($i4), $i3
	load    1($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61646, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61646:
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    20($sp), $i1
	load    0($i1), $i1
	load    12($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	load    2($sp), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i2)
	load    1($i2), $f1
	load    1($i1), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i2)
	load    2($i2), $f1
	load    2($i1), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
be_cont.61645:
	li      1, $i2
	load    19($sp), $i1
	load    2($i1), $i3
	load    1($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61647
	load    3($i1), $i3
	load    1($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61649
	b       be_cont.61650
be_else.61649:
	load    13($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61651, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61651:
	sub     $sp, 22, $sp
	load    21($sp), $ra
be_cont.61650:
	li      2, $i2
	load    19($sp), $i1
	load    7($sp), $i11
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61652, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61652:
	sub     $sp, 22, $sp
	load    21($sp), $ra
	b       bge_cont.61648
bge_else.61647:
bge_cont.61648:
	b       bge_cont.61643
bge_else.61642:
bge_cont.61643:
	b       be_cont.61641
be_else.61640:
	li      0, $i2
	load    5($sp), $i3
	load    4($sp), $i5
	load    0($sp), $i11
	mov     $i6, $i10
	mov     $i2, $i6
	mov     $i10, $i2
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61653, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61653:
	sub     $sp, 22, $sp
	load    21($sp), $ra
be_cont.61641:
	load    12($sp), $i1
	load    0($i1), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_int_of_float
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61654
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61656
	b       bge_cont.61657
bge_else.61656:
	li      0, $i1
bge_cont.61657:
	b       ble_cont.61655
ble_else.61654:
	li      255, $i1
ble_cont.61655:
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_write
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    12($sp), $i1
	load    1($i1), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_int_of_float
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61658
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61660
	b       bge_cont.61661
bge_else.61660:
	li      0, $i1
bge_cont.61661:
	b       ble_cont.61659
ble_else.61658:
	li      255, $i1
ble_cont.61659:
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_write
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    12($sp), $i1
	load    2($i1), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_int_of_float
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61662
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61664
	b       bge_cont.61665
bge_else.61664:
	li      0, $i1
bge_cont.61665:
	b       ble_cont.61663
ble_else.61662:
	li      255, $i1
ble_cont.61663:
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_write
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    18($sp), $i1
	add     $i1, 1, $i1
	load    8($sp), $i2
	load    5($sp), $i3
	load    9($sp), $i4
	load    4($sp), $i5
	load    6($sp), $i11
	load    0($i11), $i10
	jr      $i10
scan_line.3183:
	load    14($i11), $i6
	store   $i6, 0($sp)
	load    13($i11), $i6
	store   $i6, 1($sp)
	load    12($i11), $i6
	store   $i6, 2($sp)
	load    11($i11), $i6
	store   $i6, 3($sp)
	load    10($i11), $i6
	load    9($i11), $i7
	store   $i7, 4($sp)
	load    8($i11), $i7
	load    7($i11), $i8
	store   $i8, 5($sp)
	load    6($i11), $i8
	load    5($i11), $i9
	load    4($i11), $i10
	store   $i10, 6($sp)
	load    3($i11), $i10
	store   $i10, 7($sp)
	load    2($i11), $i10
	store   $i10, 8($sp)
	load    1($i11), $i10
	store   $i10, 9($sp)
	load    1($i9), $i10
	cmp     $i10, $i1, $i12
	bg      $i12, ble_else.61666
	ret
ble_else.61666:
	store   $i7, 10($sp)
	store   $i8, 11($sp)
	store   $i11, 12($sp)
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	store   $i3, 15($sp)
	store   $i6, 16($sp)
	store   $i5, 17($sp)
	store   $i1, 18($sp)
	store   $i9, 19($sp)
	load    1($i9), $i2
	sub     $i2, 1, $i2
	cmp     $i2, $i1, $i12
	bg      $i12, ble_else.61668
	b       ble_cont.61669
ble_else.61668:
	add     $i1, 1, $i1
	load    4($sp), $i2
	load    0($i2), $f1
	store   $f1, 20($sp)
	load    6($sp), $i2
	load    1($i2), $i2
	sub     $i1, $i2, $i1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_float_of_int
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    20($sp), $f2
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
	load    19($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i2
	load    14($sp), $i1
	load    17($sp), $i3
	load    5($sp), $i11
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.61670, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.61670:
	sub     $sp, 22, $sp
	load    21($sp), $ra
ble_cont.61669:
	li      0, $i1
	load    19($sp), $i2
	load    0($i2), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bg      $i12, ble_else.61671
	b       ble_cont.61672
ble_else.61671:
	load    15($sp), $i4
	load    0($i4), $i3
	load    0($i3), $i3
	load    0($i3), $f1
	load    10($sp), $i5
	store   $f1, 0($i5)
	load    1($i3), $f1
	store   $f1, 1($i5)
	load    2($i3), $f1
	store   $f1, 2($i5)
	load    1($i2), $i3
	load    18($sp), $i6
	add     $i6, 1, $i7
	cmp     $i3, $i7, $i12
	bg      $i12, ble_else.61673
	li      0, $i2
	b       ble_cont.61674
ble_else.61673:
	li      0, $i12
	cmp     $i6, $i12, $i12
	bg      $i12, ble_else.61675
	li      0, $i2
	b       ble_cont.61676
ble_else.61675:
	load    0($i2), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.61677
	li      0, $i2
	b       ble_cont.61678
ble_else.61677:
	li      0, $i2
ble_cont.61678:
ble_cont.61676:
ble_cont.61674:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61679
	load    0($i4), $i1
	load    2($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61681
	store   $i1, 21($sp)
	load    3($i1), $i2
	load    0($i2), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61683
	b       be_cont.61684
be_else.61683:
	load    5($i1), $i2
	load    7($i1), $i3
	load    1($i1), $i4
	load    4($i1), $i5
	store   $i5, 22($sp)
	load    0($i2), $i2
	load    0($i2), $f1
	load    8($sp), $i5
	store   $f1, 0($i5)
	load    1($i2), $f1
	store   $f1, 1($i5)
	load    2($i2), $f1
	store   $f1, 2($i5)
	load    6($i1), $i1
	load    0($i1), $i1
	load    0($i3), $i2
	load    0($i4), $i3
	load    1($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61685, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61685:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    22($sp), $i1
	load    0($i1), $i1
	load    10($sp), $i2
	load    0($i2), $f1
	load    0($i1), $f2
	load    8($sp), $i3
	load    0($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i2)
	load    1($i2), $f1
	load    1($i1), $f2
	load    1($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i2)
	load    2($i2), $f1
	load    2($i1), $f2
	load    2($i3), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
be_cont.61684:
	li      1, $i2
	load    21($sp), $i1
	load    2($i1), $i3
	load    1($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bl      $i12, bge_else.61686
	load    3($i1), $i3
	load    1($i3), $i3
	li      0, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.61688
	b       be_cont.61689
be_else.61688:
	load    9($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61690, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61690:
	sub     $sp, 24, $sp
	load    23($sp), $ra
be_cont.61689:
	li      2, $i2
	load    21($sp), $i1
	load    7($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61691, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61691:
	sub     $sp, 24, $sp
	load    23($sp), $ra
	b       bge_cont.61687
bge_else.61686:
bge_cont.61687:
	b       bge_cont.61682
bge_else.61681:
bge_cont.61682:
	b       be_cont.61680
be_else.61679:
	li      0, $i2
	load    13($sp), $i3
	load    14($sp), $i5
	load    0($sp), $i11
	mov     $i6, $i10
	mov     $i2, $i6
	mov     $i10, $i2
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61692, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61692:
	sub     $sp, 24, $sp
	load    23($sp), $ra
be_cont.61680:
	load    10($sp), $i1
	load    0($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_int_of_float
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61693
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61695
	b       bge_cont.61696
bge_else.61695:
	li      0, $i1
bge_cont.61696:
	b       ble_cont.61694
ble_else.61693:
	li      255, $i1
ble_cont.61694:
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_write
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    10($sp), $i1
	load    1($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_int_of_float
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61697
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61699
	b       bge_cont.61700
bge_else.61699:
	li      0, $i1
bge_cont.61700:
	b       ble_cont.61698
ble_else.61697:
	li      255, $i1
ble_cont.61698:
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_write
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    10($sp), $i1
	load    2($i1), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_int_of_float
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.61701
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61703
	b       bge_cont.61704
bge_else.61703:
	li      0, $i1
bge_cont.61704:
	b       ble_cont.61702
ble_else.61701:
	li      255, $i1
ble_cont.61702:
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_write
	sub     $sp, 24, $sp
	load    23($sp), $ra
	li      1, $i1
	load    18($sp), $i2
	load    13($sp), $i3
	load    15($sp), $i4
	load    14($sp), $i5
	load    16($sp), $i11
	store   $ra, 23($sp)
	load    0($i11), $i10
	li      cls.61705, $ra
	add     $sp, 24, $sp
	jr      $i10
cls.61705:
	sub     $sp, 24, $sp
	load    23($sp), $ra
ble_cont.61672:
	load    18($sp), $i1
	add     $i1, 1, $i2
	load    17($sp), $i1
	add     $i1, 2, $i1
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61706
	sub     $i1, 5, $i1
	b       bge_cont.61707
bge_else.61706:
bge_cont.61707:
	mov     $i1, $i3
	load    19($sp), $i1
	load    1($i1), $i4
	cmp     $i4, $i2, $i12
	bg      $i12, ble_else.61708
	ret
ble_else.61708:
	store   $i3, 23($sp)
	store   $i2, 24($sp)
	load    1($i1), $i1
	sub     $i1, 1, $i1
	cmp     $i1, $i2, $i12
	bg      $i12, ble_else.61710
	b       ble_cont.61711
ble_else.61710:
	add     $i2, 1, $i2
	load    13($sp), $i1
	load    11($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61712, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61712:
	sub     $sp, 26, $sp
	load    25($sp), $ra
ble_cont.61711:
	li      0, $i1
	load    24($sp), $i2
	load    15($sp), $i3
	load    14($sp), $i4
	load    13($sp), $i5
	load    16($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61713, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61713:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	add     $i1, 1, $i1
	load    23($sp), $i2
	add     $i2, 2, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61714
	sub     $i2, 5, $i2
	b       bge_cont.61715
bge_else.61714:
bge_cont.61715:
	mov     $i2, $i5
	load    14($sp), $i2
	load    13($sp), $i3
	load    15($sp), $i4
	load    12($sp), $i11
	load    0($i11), $i10
	jr      $i10
create_pixel.3191:
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_create_float_array
	sub     $sp, 1, $sp
	load    0($sp), $ra
	store   $i1, 0($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	store   $i1, 1($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	store   $i1, 4($i2)
	li      5, $i1
	li      0, $i2
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $i1, 2($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $i1, 3($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_float_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_float_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_float_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_float_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_float_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $i2
	store   $i1, 4($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_float_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	store   $i1, 4($i2)
	li      1, $i1
	li      0, $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 4($i2)
	mov     $hp, $i1
	add     $hp, 8, $hp
	store   $i2, 7($i1)
	load    6($sp), $i2
	store   $i2, 6($i1)
	load    5($sp), $i2
	store   $i2, 5($i1)
	load    4($sp), $i2
	store   $i2, 4($i1)
	load    3($sp), $i2
	store   $i2, 3($i1)
	load    2($sp), $i2
	store   $i2, 2($i1)
	load    1($sp), $i2
	store   $i2, 1($i1)
	load    0($sp), $i2
	store   $i2, 0($i1)
	ret
init_line_elements.3193:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61716
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_float_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $i1, 2($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_float_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $i1, 3($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_float_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_float_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_float_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_float_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	store   $i1, 4($i2)
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
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i2
	store   $i1, 4($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i2
	store   $i1, 4($i2)
	li      1, $i1
	li      0, $i2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_float_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_create_array
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $i1, 9($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $i2
	store   $i1, 4($i2)
	mov     $hp, $i1
	add     $hp, 8, $hp
	store   $i2, 7($i1)
	load    8($sp), $i2
	store   $i2, 6($i1)
	load    7($sp), $i2
	store   $i2, 5($i1)
	load    6($sp), $i2
	store   $i2, 4($i1)
	load    5($sp), $i2
	store   $i2, 3($i1)
	load    4($sp), $i2
	store   $i2, 2($i1)
	load    3($sp), $i2
	store   $i2, 1($i1)
	load    2($sp), $i2
	store   $i2, 0($i1)
	load    0($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61717
	store   $i1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     create_pixel.3191
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61718
	store   $i1, 11($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_float_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $i1, 12($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_float_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $i1, 13($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i2
	store   $i1, 4($i2)
	li      5, $i1
	li      0, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $i1, 14($sp)
	li      5, $i1
	li      0, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $i1, 15($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_float_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	store   $i1, 16($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_float_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_float_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_float_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_float_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $i2
	store   $i1, 4($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_float_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	store   $i1, 17($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_float_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_float_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_float_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_float_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $i2
	store   $i1, 4($i2)
	li      1, $i1
	li      0, $i2
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	store   $i1, 18($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_float_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	store   $i1, 19($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $i2
	store   $i1, 4($i2)
	mov     $hp, $i1
	add     $hp, 8, $hp
	store   $i2, 7($i1)
	load    18($sp), $i2
	store   $i2, 6($i1)
	load    17($sp), $i2
	store   $i2, 5($i1)
	load    16($sp), $i2
	store   $i2, 4($i1)
	load    15($sp), $i2
	store   $i2, 3($i1)
	load    14($sp), $i2
	store   $i2, 2($i1)
	load    13($sp), $i2
	store   $i2, 1($i1)
	load    12($sp), $i2
	store   $i2, 0($i1)
	load    11($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61719
	store   $i1, 20($sp)
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     create_pixel.3191
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    20($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	mov     $i3, $i1
	b       init_line_elements.3193
bge_else.61719:
	mov     $i3, $i1
	ret
bge_else.61718:
	mov     $i3, $i1
	ret
bge_else.61717:
	mov     $i3, $i1
	ret
bge_else.61716:
	ret
cordic_rec.6536.12078.13195:
	load    1($i11), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.61720
	mov     $f3, $f1
	ret
be_else.61720:
	li      l.25703, $i3
	load    0($i3), $f5
	fcmp    $f2, $f5, $i12
	bg      $i12, ble_else.61721
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f5
	fsub    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.61722
	mov     $f2, $f1
	ret
be_else.61722:
	li      l.25703, $i1
	load    0($i1), $f4
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.61723
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.61723:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.61721:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f5
	fadd    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.61724
	mov     $f2, $f1
	ret
be_else.61724:
	li      l.25703, $i1
	load    0($i1), $f4
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.61725
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.61725:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_rec.6536.12078.13147:
	load    1($i11), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.61726
	mov     $f3, $f1
	ret
be_else.61726:
	li      l.25703, $i3
	load    0($i3), $f5
	fcmp    $f2, $f5, $i12
	bg      $i12, ble_else.61727
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f5
	fsub    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fsub    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.61728
	mov     $f2, $f1
	ret
be_else.61728:
	li      l.25703, $i1
	load    0($i1), $f4
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.61729
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.61729:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.61727:
	add     $i1, 1, $i3
	fmul    $f4, $f2, $f5
	fadd    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f1
	li      min_caml_atan_table, $i4
	add     $i4, $i1, $i12
	load    0($i12), $f2
	fadd    $f3, $f2, $f2
	li      l.25696, $i1
	load    0($i1), $f3
	fmul    $f4, $f3, $f3
	cmp     $i3, $i2, $i12
	bne     $i12, be_else.61730
	mov     $f2, $f1
	ret
be_else.61730:
	li      l.25703, $i1
	load    0($i1), $f4
	fcmp    $f1, $f4, $i12
	bg      $i12, ble_else.61731
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fsub    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fadd    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fsub    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.61731:
	add     $i3, 1, $i1
	fmul    $f3, $f1, $f4
	fadd    $f5, $f4, $f4
	fmul    $f3, $f5, $f5
	fsub    $f1, $f5, $f1
	li      min_caml_atan_table, $i2
	add     $i2, $i3, $i12
	load    0($i12), $f5
	fadd    $f2, $f5, $f2
	li      l.25696, $i2
	load    0($i2), $f5
	fmul    $f3, $f5, $f3
	mov     $f4, $f14
	mov     $f3, $f4
	mov     $f2, $f3
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
calc_dirvec.3203:
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
	bl      $i12, bge_else.61732
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i5, 2($sp)
	store   $f1, 3($sp)
	store   $f2, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fsqr
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $f1, 5($sp)
	load    4($sp), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fsqr
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $f2
	fadd    $f2, $f1, $f1
	li      l.25743, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     sqrt.2729
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    3($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f2
	store   $f2, 6($sp)
	load    4($sp), $f3
	finv    $f1, $f15
	fmul    $f3, $f15, $f3
	store   $f3, 7($sp)
	li      l.25743, $i1
	load    0($i1), $f4
	finv    $f1, $f15
	fmul    $f4, $f15, $f1
	store   $f1, 8($sp)
	load    1($sp), $i1
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 9($sp)
	load    0($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i3
	load    0($i3), $i3
	store   $f2, 0($i3)
	store   $f3, 1($i3)
	store   $f1, 2($i3)
	add     $i2, 40, $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    0($i1), $i1
	store   $i1, 10($sp)
	mov     $f3, $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	load    6($sp), $f2
	store   $f2, 0($i1)
	load    8($sp), $f3
	store   $f3, 1($i1)
	store   $f1, 2($i1)
	load    0($sp), $i1
	add     $i1, 80, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    0($i1), $i1
	store   $i1, 11($sp)
	mov     $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fneg
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $f1, 12($sp)
	load    7($sp), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fneg
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    11($sp), $i1
	load    8($sp), $f2
	store   $f2, 0($i1)
	load    12($sp), $f2
	store   $f2, 1($i1)
	store   $f1, 2($i1)
	load    0($sp), $i1
	add     $i1, 1, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    0($i1), $i1
	store   $i1, 13($sp)
	load    6($sp), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fneg
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $f1, 14($sp)
	load    7($sp), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fneg
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $f1, 15($sp)
	load    8($sp), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fneg
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    13($sp), $i1
	load    14($sp), $f2
	store   $f2, 0($i1)
	load    15($sp), $f2
	store   $f2, 1($i1)
	store   $f1, 2($i1)
	load    0($sp), $i1
	add     $i1, 41, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    0($i1), $i1
	store   $i1, 16($sp)
	load    6($sp), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fneg
	sub     $sp, 18, $sp
	load    17($sp), $ra
	store   $f1, 17($sp)
	load    8($sp), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fneg
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    16($sp), $i1
	load    17($sp), $f2
	store   $f2, 0($i1)
	store   $f1, 1($i1)
	load    7($sp), $f1
	store   $f1, 2($i1)
	load    0($sp), $i1
	add     $i1, 81, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    0($i1), $i1
	store   $i1, 18($sp)
	load    8($sp), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fneg
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $i1
	store   $f1, 0($i1)
	load    6($sp), $f1
	store   $f1, 1($i1)
	load    7($sp), $f1
	store   $f1, 2($i1)
	ret
bge_else.61732:
	store   $i7, 19($sp)
	store   $i9, 20($sp)
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 21($sp)
	store   $f4, 22($sp)
	store   $i1, 23($sp)
	store   $i6, 24($sp)
	store   $i4, 25($sp)
	store   $f6, 26($sp)
	store   $f7, 27($sp)
	store   $f5, 28($sp)
	store   $f3, 29($sp)
	store   $i8, 30($sp)
	fmul    $f2, $f2, $f1
	li      l.25895, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     sqrt.2729
	sub     $sp, 32, $sp
	load    31($sp), $ra
	store   $f1, 31($sp)
	li      l.25743, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	mov     $hp, $i11
	add     $hp, 2, $hp
	li      cordic_rec.6536.12078.13195, $i1
	store   $i1, 0($i11)
	load    30($sp), $i1
	store   $i1, 1($i11)
	li      l.25743, $i1
	load    0($i1), $f2
	li      l.25703, $i1
	load    0($i1), $f3
	li      l.25743, $i1
	load    0($i1), $f4
	li      l.25703, $i1
	load    0($i1), $f5
	fcmp    $f1, $f5, $i12
	bg      $i12, ble_else.61734
	li      1, $i1
	fmul    $f4, $f1, $f4
	fsub    $f2, $f4, $f2
	li      l.25743, $i2
	load    0($i2), $f4
	fadd    $f1, $f4, $f1
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f3, $f4, $f3
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.61736, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.61736:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	b       ble_cont.61735
ble_else.61734:
	li      1, $i1
	fmul    $f4, $f1, $f4
	fadd    $f2, $f4, $f2
	li      l.25743, $i2
	load    0($i2), $f4
	fsub    $f1, $f4, $f1
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f3, $f4, $f3
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.61737, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.61737:
	sub     $sp, 33, $sp
	load    32($sp), $ra
ble_cont.61735:
	load    29($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 32($sp)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61738
	load    28($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61740
	load    27($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61742
	load    26($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61744
	fsub    $f1, $f2, $f1
	load    25($sp), $i11
	store   $ra, 33($sp)
	load    0($i11), $i10
	li      cls.61746, $ra
	add     $sp, 34, $sp
	jr      $i10
cls.61746:
	sub     $sp, 34, $sp
	load    33($sp), $ra
	b       ble_cont.61745
ble_else.61744:
	fsub    $f2, $f1, $f1
	load    25($sp), $i11
	store   $ra, 33($sp)
	load    0($i11), $i10
	li      cls.61747, $ra
	add     $sp, 34, $sp
	jr      $i10
cls.61747:
	sub     $sp, 34, $sp
	load    33($sp), $ra
	fneg    $f1, $f1
ble_cont.61745:
	b       ble_cont.61743
ble_else.61742:
	fsub    $f2, $f1, $f1
	load    19($sp), $i11
	store   $ra, 33($sp)
	load    0($i11), $i10
	li      cls.61748, $ra
	add     $sp, 34, $sp
	jr      $i10
cls.61748:
	sub     $sp, 34, $sp
	load    33($sp), $ra
ble_cont.61743:
	b       ble_cont.61741
ble_else.61740:
	load    19($sp), $i11
	store   $ra, 33($sp)
	load    0($i11), $i10
	li      cls.61749, $ra
	add     $sp, 34, $sp
	jr      $i10
cls.61749:
	sub     $sp, 34, $sp
	load    33($sp), $ra
ble_cont.61741:
	b       ble_cont.61739
ble_else.61738:
	fneg    $f1, $f1
	load    25($sp), $i11
	store   $ra, 33($sp)
	load    0($i11), $i10
	li      cls.61750, $ra
	add     $sp, 34, $sp
	jr      $i10
cls.61750:
	sub     $sp, 34, $sp
	load    33($sp), $ra
	fneg    $f1, $f1
ble_cont.61739:
	store   $f1, 33($sp)
	li      l.25703, $i1
	load    0($i1), $f1
	load    32($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61751
	load    28($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61753
	load    27($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61755
	load    26($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61757
	fsub    $f2, $f1, $f1
	load    24($sp), $i11
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61759, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61759:
	sub     $sp, 35, $sp
	load    34($sp), $ra
	b       ble_cont.61758
ble_else.61757:
	fsub    $f1, $f2, $f1
	load    24($sp), $i11
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61760, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61760:
	sub     $sp, 35, $sp
	load    34($sp), $ra
ble_cont.61758:
	b       ble_cont.61756
ble_else.61755:
	fsub    $f1, $f2, $f1
	load    20($sp), $i11
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61761, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61761:
	sub     $sp, 35, $sp
	load    34($sp), $ra
	fneg    $f1, $f1
ble_cont.61756:
	b       ble_cont.61754
ble_else.61753:
	load    20($sp), $i11
	mov     $f2, $f1
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61762, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61762:
	sub     $sp, 35, $sp
	load    34($sp), $ra
ble_cont.61754:
	b       ble_cont.61752
ble_else.61751:
	fneg    $f2, $f1
	load    24($sp), $i11
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61763, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61763:
	sub     $sp, 35, $sp
	load    34($sp), $ra
ble_cont.61752:
	load    33($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    31($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 34($sp)
	load    23($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 35($sp)
	fmul    $f1, $f1, $f1
	li      l.25895, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     sqrt.2729
	sub     $sp, 37, $sp
	load    36($sp), $ra
	store   $f1, 36($sp)
	li      l.25743, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	mov     $hp, $i11
	add     $hp, 2, $hp
	li      cordic_rec.6536.12078.13147, $i1
	store   $i1, 0($i11)
	load    30($sp), $i1
	store   $i1, 1($i11)
	li      l.25743, $i1
	load    0($i1), $f2
	li      l.25703, $i1
	load    0($i1), $f3
	li      l.25743, $i1
	load    0($i1), $f4
	li      l.25703, $i1
	load    0($i1), $f5
	fcmp    $f1, $f5, $i12
	bg      $i12, ble_else.61764
	li      1, $i1
	fmul    $f4, $f1, $f4
	fsub    $f2, $f4, $f2
	li      l.25743, $i2
	load    0($i2), $f4
	fadd    $f1, $f4, $f1
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fsub    $f3, $f4, $f3
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	store   $ra, 37($sp)
	load    0($i11), $i10
	li      cls.61766, $ra
	add     $sp, 38, $sp
	jr      $i10
cls.61766:
	sub     $sp, 38, $sp
	load    37($sp), $ra
	b       ble_cont.61765
ble_else.61764:
	li      1, $i1
	fmul    $f4, $f1, $f4
	fadd    $f2, $f4, $f2
	li      l.25743, $i2
	load    0($i2), $f4
	fsub    $f1, $f4, $f1
	li      min_caml_atan_table, $i2
	load    0($i2), $f4
	fadd    $f3, $f4, $f3
	li      l.25696, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	store   $ra, 37($sp)
	load    0($i11), $i10
	li      cls.61767, $ra
	add     $sp, 38, $sp
	jr      $i10
cls.61767:
	sub     $sp, 38, $sp
	load    37($sp), $ra
ble_cont.61765:
	load    22($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 37($sp)
	li      l.25703, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61768
	load    28($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61770
	load    27($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61772
	load    26($sp), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.61774
	fsub    $f1, $f2, $f1
	load    25($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.61776, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.61776:
	sub     $sp, 39, $sp
	load    38($sp), $ra
	b       ble_cont.61775
ble_else.61774:
	fsub    $f2, $f1, $f1
	load    25($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.61777, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.61777:
	sub     $sp, 39, $sp
	load    38($sp), $ra
	fneg    $f1, $f1
ble_cont.61775:
	b       ble_cont.61773
ble_else.61772:
	fsub    $f2, $f1, $f1
	load    19($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.61778, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.61778:
	sub     $sp, 39, $sp
	load    38($sp), $ra
ble_cont.61773:
	b       ble_cont.61771
ble_else.61770:
	load    19($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.61779, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.61779:
	sub     $sp, 39, $sp
	load    38($sp), $ra
ble_cont.61771:
	b       ble_cont.61769
ble_else.61768:
	fneg    $f1, $f1
	load    25($sp), $i11
	store   $ra, 38($sp)
	load    0($i11), $i10
	li      cls.61780, $ra
	add     $sp, 39, $sp
	jr      $i10
cls.61780:
	sub     $sp, 39, $sp
	load    38($sp), $ra
	fneg    $f1, $f1
ble_cont.61769:
	store   $f1, 38($sp)
	li      l.25703, $i1
	load    0($i1), $f1
	load    37($sp), $f2
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61781
	load    28($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61783
	load    27($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61785
	load    26($sp), $f1
	fcmp    $f1, $f2, $i12
	bg      $i12, ble_else.61787
	fsub    $f2, $f1, $f1
	load    24($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61789, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61789:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	b       ble_cont.61788
ble_else.61787:
	fsub    $f1, $f2, $f1
	load    24($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61790, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61790:
	sub     $sp, 40, $sp
	load    39($sp), $ra
ble_cont.61788:
	b       ble_cont.61786
ble_else.61785:
	fsub    $f1, $f2, $f1
	load    20($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61791, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61791:
	sub     $sp, 40, $sp
	load    39($sp), $ra
	fneg    $f1, $f1
ble_cont.61786:
	b       ble_cont.61784
ble_else.61783:
	load    20($sp), $i11
	mov     $f2, $f1
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61792, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61792:
	sub     $sp, 40, $sp
	load    39($sp), $ra
ble_cont.61784:
	b       ble_cont.61782
ble_else.61781:
	fneg    $f2, $f1
	load    24($sp), $i11
	store   $ra, 39($sp)
	load    0($i11), $i10
	li      cls.61793, $ra
	add     $sp, 40, $sp
	jr      $i10
cls.61793:
	sub     $sp, 40, $sp
	load    39($sp), $ra
ble_cont.61782:
	load    38($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    36($sp), $f2
	fmul    $f1, $f2, $f2
	load    34($sp), $f1
	load    29($sp), $f3
	load    22($sp), $f4
	load    35($sp), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    21($sp), $i11
	load    0($i11), $i10
	jr      $i10
calc_dirvecs.3211:
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61794
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
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26356, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f3
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	li      l.25703, $i2
	load    0($i2), $f2
	load    2($sp), $f4
	load    4($sp), $i2
	load    3($sp), $i3
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.61795, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.61795:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_float_of_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.25895, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f3
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	li      l.25703, $i2
	load    0($i2), $f2
	load    3($sp), $i2
	add     $i2, 2, $i3
	load    2($sp), $f4
	load    4($sp), $i2
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.61796, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.61796:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i1
	sub     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, 1, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61797
	sub     $i2, 5, $i2
	b       bge_cont.61798
bge_else.61797:
bge_cont.61798:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61799
	store   $i1, 6($sp)
	store   $i2, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_float_of_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26356, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f3
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	li      l.25703, $i2
	load    0($i2), $f2
	load    2($sp), $f4
	load    7($sp), $i2
	load    3($sp), $i3
	load    5($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.61800, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.61800:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    6($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_float_of_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.25895, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f3
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	li      l.25703, $i2
	load    0($i2), $f2
	load    3($sp), $i2
	add     $i2, 2, $i3
	load    2($sp), $f4
	load    7($sp), $i2
	load    5($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.61801, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.61801:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    6($sp), $i1
	sub     $i1, 1, $i1
	load    7($sp), $i2
	add     $i2, 1, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61802
	sub     $i2, 5, $i2
	b       bge_cont.61803
bge_else.61802:
bge_cont.61803:
	load    2($sp), $f1
	load    3($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61799:
	ret
bge_else.61794:
	ret
calc_dirvec_rows.3216:
	load    2($i11), $i4
	load    1($i11), $i5
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61806
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	store   $i4, 2($sp)
	store   $i3, 3($sp)
	store   $i2, 4($sp)
	store   $i5, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_float_of_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26356, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 6($sp)
	li      4, $i1
	store   $i1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_float_of_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26356, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f3
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	li      l.25703, $i2
	load    0($i2), $f2
	load    6($sp), $f4
	load    4($sp), $i2
	load    3($sp), $i3
	load    5($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.61807, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.61807:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_float_of_int
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.25895, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f3
	li      0, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	li      l.25703, $i2
	load    0($i2), $f2
	load    3($sp), $i2
	add     $i2, 2, $i3
	load    6($sp), $f4
	load    4($sp), $i2
	load    5($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.61808, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.61808:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      3, $i1
	load    4($sp), $i2
	add     $i2, 1, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61809
	sub     $i2, 5, $i2
	b       bge_cont.61810
bge_else.61809:
bge_cont.61810:
	load    6($sp), $f1
	load    3($sp), $i3
	load    2($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.61811, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.61811:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    1($sp), $i1
	sub     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, 2, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61812
	sub     $i2, 5, $i2
	b       bge_cont.61813
bge_else.61812:
bge_cont.61813:
	load    3($sp), $i3
	add     $i3, 4, $i3
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61814
	store   $i1, 8($sp)
	store   $i3, 9($sp)
	store   $i2, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_float_of_int
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      l.26354, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.26356, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	li      4, $i1
	load    10($sp), $i2
	load    9($sp), $i3
	load    2($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.61815, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.61815:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $i1
	sub     $i1, 1, $i1
	load    10($sp), $i2
	add     $i2, 2, $i2
	li      5, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61816
	sub     $i2, 5, $i2
	b       bge_cont.61817
bge_else.61816:
bge_cont.61817:
	load    9($sp), $i3
	add     $i3, 4, $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61814:
	ret
bge_else.61806:
	ret
create_dirvec_elements.3222:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61820
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	store   $i1, 2($sp)
	store   $i3, 3($sp)
	li      3, $i1
	li      l.25703, $i2
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
	bl      $i12, bge_else.61821
	store   $i1, 5($sp)
	li      3, $i1
	li      l.25703, $i2
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
	bl      $i12, bge_else.61822
	store   $i1, 7($sp)
	li      3, $i1
	li      l.25703, $i2
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
	bl      $i12, bge_else.61823
	store   $i1, 9($sp)
	li      3, $i1
	li      l.25703, $i2
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
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61824
	store   $i1, 11($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_float_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	mov     $i1, $i2
	store   $i2, 12($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    12($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    11($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61825
	store   $i1, 13($sp)
	li      3, $i1
	li      l.25703, $i2
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
	load    14($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    13($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61826
	store   $i1, 15($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_float_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	mov     $i1, $i2
	store   $i2, 16($sp)
	load    3($sp), $i1
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
	load    15($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61827
	store   $i1, 17($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_float_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	mov     $i1, $i2
	store   $i2, 18($sp)
	load    3($sp), $i1
	load    0($i1), $i1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    18($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    17($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	load    0($sp), $i11
	mov     $i3, $i1
	load    0($i11), $i10
	jr      $i10
bge_else.61827:
	ret
bge_else.61826:
	ret
bge_else.61825:
	ret
bge_else.61824:
	ret
bge_else.61823:
	ret
bge_else.61822:
	ret
bge_else.61821:
	ret
bge_else.61820:
	ret
create_dirvecs.3225:
	load    3($i11), $i2
	load    2($i11), $i3
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61836
	store   $i11, 0($sp)
	store   $i4, 1($sp)
	store   $i1, 2($sp)
	store   $i3, 3($sp)
	store   $i2, 4($sp)
	li      120, $i1
	store   $i1, 5($sp)
	li      3, $i1
	li      l.25703, $i2
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
	li      l.25703, $i2
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
	li      l.25703, $i2
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
	li      l.25703, $i2
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
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_float_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $i1, $i2
	store   $i2, 11($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    11($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    7($sp), $i2
	store   $i1, 115($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_float_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	mov     $i1, $i2
	store   $i2, 12($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    12($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    7($sp), $i2
	store   $i1, 114($i2)
	li      3, $i1
	li      l.25703, $i2
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
	mov     $i2, $i1
	load    7($sp), $i2
	store   $i1, 113($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_float_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	mov     $i1, $i2
	store   $i2, 14($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    14($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    7($sp), $i2
	store   $i1, 112($i2)
	li      111, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.61837, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.61837:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    2($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61838
	store   $i1, 15($sp)
	li      120, $i1
	store   $i1, 16($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_float_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	mov     $i1, $i2
	store   $i2, 17($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    17($sp), $i1
	store   $i1, 0($i2)
	load    16($sp), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    15($sp), $i2
	load    3($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i3, $i2, $i12
	load    0($i12), $i1
	store   $i1, 18($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_float_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	mov     $i1, $i2
	store   $i2, 19($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    19($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    18($sp), $i2
	store   $i1, 118($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	mov     $i1, $i2
	store   $i2, 20($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    20($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    18($sp), $i2
	store   $i1, 117($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_float_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	mov     $i1, $i2
	store   $i2, 21($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_create_array
	sub     $sp, 23, $sp
	load    22($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    21($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    18($sp), $i2
	store   $i1, 116($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_create_float_array
	sub     $sp, 23, $sp
	load    22($sp), $ra
	mov     $i1, $i2
	store   $i2, 22($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_create_array
	sub     $sp, 24, $sp
	load    23($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    22($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    18($sp), $i2
	store   $i1, 115($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_create_float_array
	sub     $sp, 24, $sp
	load    23($sp), $ra
	mov     $i1, $i2
	store   $i2, 23($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_create_array
	sub     $sp, 25, $sp
	load    24($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    23($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    18($sp), $i2
	store   $i1, 114($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_create_float_array
	sub     $sp, 25, $sp
	load    24($sp), $ra
	mov     $i1, $i2
	store   $i2, 24($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_create_array
	sub     $sp, 26, $sp
	load    25($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    24($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    18($sp), $i2
	store   $i1, 113($i2)
	li      112, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61839, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61839:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    15($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61840
	store   $i1, 25($sp)
	li      120, $i1
	store   $i1, 26($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_create_float_array
	sub     $sp, 28, $sp
	load    27($sp), $ra
	mov     $i1, $i2
	store   $i2, 27($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_create_array
	sub     $sp, 29, $sp
	load    28($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    27($sp), $i1
	store   $i1, 0($i2)
	load    26($sp), $i1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_create_array
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    25($sp), $i2
	load    3($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i3, $i2, $i12
	load    0($i12), $i1
	store   $i1, 28($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_create_float_array
	sub     $sp, 30, $sp
	load    29($sp), $ra
	mov     $i1, $i2
	store   $i2, 29($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_create_array
	sub     $sp, 31, $sp
	load    30($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    29($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    28($sp), $i2
	store   $i1, 118($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_create_float_array
	sub     $sp, 31, $sp
	load    30($sp), $ra
	mov     $i1, $i2
	store   $i2, 30($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_create_array
	sub     $sp, 32, $sp
	load    31($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    30($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    28($sp), $i2
	store   $i1, 117($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_create_float_array
	sub     $sp, 32, $sp
	load    31($sp), $ra
	mov     $i1, $i2
	store   $i2, 31($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    31($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    28($sp), $i2
	store   $i1, 116($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_float_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	mov     $i1, $i2
	store   $i2, 32($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_create_array
	sub     $sp, 34, $sp
	load    33($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    32($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    28($sp), $i2
	store   $i1, 115($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_create_float_array
	sub     $sp, 34, $sp
	load    33($sp), $ra
	mov     $i1, $i2
	store   $i2, 33($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_create_array
	sub     $sp, 35, $sp
	load    34($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    33($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    28($sp), $i2
	store   $i1, 114($i2)
	li      113, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 34($sp)
	load    0($i11), $i10
	li      cls.61841, $ra
	add     $sp, 35, $sp
	jr      $i10
cls.61841:
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    25($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61842
	store   $i1, 34($sp)
	li      120, $i1
	store   $i1, 35($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_create_float_array
	sub     $sp, 37, $sp
	load    36($sp), $ra
	mov     $i1, $i2
	store   $i2, 36($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    36($sp), $i1
	store   $i1, 0($i2)
	load    35($sp), $i1
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    34($sp), $i2
	load    3($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i3, $i2, $i12
	load    0($i12), $i1
	store   $i1, 37($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_float_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	mov     $i1, $i2
	store   $i2, 38($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_create_array
	sub     $sp, 40, $sp
	load    39($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    38($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    37($sp), $i2
	store   $i1, 118($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 39($sp)
	add     $sp, 40, $sp
	jal     min_caml_create_float_array
	sub     $sp, 40, $sp
	load    39($sp), $ra
	mov     $i1, $i2
	store   $i2, 39($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_create_array
	sub     $sp, 41, $sp
	load    40($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    39($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    37($sp), $i2
	store   $i1, 117($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 40($sp)
	add     $sp, 41, $sp
	jal     min_caml_create_float_array
	sub     $sp, 41, $sp
	load    40($sp), $ra
	mov     $i1, $i2
	store   $i2, 40($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_create_array
	sub     $sp, 42, $sp
	load    41($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    40($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    37($sp), $i2
	store   $i1, 116($i2)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 41($sp)
	add     $sp, 42, $sp
	jal     min_caml_create_float_array
	sub     $sp, 42, $sp
	load    41($sp), $ra
	mov     $i1, $i2
	store   $i2, 41($sp)
	load    4($sp), $i1
	load    0($i1), $i1
	store   $ra, 42($sp)
	add     $sp, 43, $sp
	jal     min_caml_create_array
	sub     $sp, 43, $sp
	load    42($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    41($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	load    37($sp), $i2
	store   $i1, 115($i2)
	li      114, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 42($sp)
	load    0($i11), $i10
	li      cls.61843, $ra
	add     $sp, 43, $sp
	jr      $i10
cls.61843:
	sub     $sp, 43, $sp
	load    42($sp), $ra
	load    34($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61842:
	ret
bge_else.61840:
	ret
bge_else.61838:
	ret
bge_else.61836:
	ret
init_dirvec_constants.3227:
	load    3($i11), $i3
	load    2($i11), $i4
	load    1($i11), $i5
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61848
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
	li      cls.61849, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.61849:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61850
	store   $i1, 6($sp)
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    3($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61851
	store   $i1, 7($sp)
	load    2($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61853
	store   $i2, 8($sp)
	store   $i4, 9($sp)
	mov     $i3, $i2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     setup_rect_table.3000
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61854
be_else.61853:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61855
	store   $i2, 8($sp)
	store   $i4, 9($sp)
	mov     $i3, $i2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     setup_surface_table.3003
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61856
be_else.61855:
	store   $i2, 8($sp)
	store   $i4, 9($sp)
	mov     $i3, $i2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     setup_second_table.3006
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    8($sp), $i2
	load    9($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.61856:
be_cont.61854:
	sub     $i2, 1, $i2
	load    7($sp), $i1
	load    1($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.61857, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.61857:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	b       bge_cont.61852
bge_else.61851:
bge_cont.61852:
	load    6($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61858
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
	li      cls.61859, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.61859:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61860
	store   $i1, 11($sp)
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    3($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61861
	store   $i1, 12($sp)
	load    2($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61863
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	mov     $i3, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_rect_table.3000
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61864
be_else.61863:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61865
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	mov     $i3, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_surface_table.3003
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61866
be_else.61865:
	store   $i2, 13($sp)
	store   $i4, 14($sp)
	mov     $i3, $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     setup_second_table.3006
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    13($sp), $i2
	load    14($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.61866:
be_cont.61864:
	sub     $i2, 1, $i2
	load    12($sp), $i1
	load    1($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.61867, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.61867:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	b       bge_cont.61862
bge_else.61861:
bge_cont.61862:
	load    11($sp), $i1
	sub     $i1, 1, $i2
	load    4($sp), $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61860:
	ret
bge_else.61858:
	ret
bge_else.61850:
	ret
bge_else.61848:
	ret
init_vecset_constants.3230:
	load    5($i11), $i2
	load    4($i11), $i3
	load    3($i11), $i4
	load    2($i11), $i5
	load    1($i11), $i6
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61872
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
	bl      $i12, bge_else.61873
	store   $i1, 8($sp)
	add     $i2, $i3, $i12
	load    0($i12), $i2
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i2), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61875
	store   $i3, 9($sp)
	store   $i4, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_rect_table.3000
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61876
be_else.61875:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61877
	store   $i3, 9($sp)
	store   $i4, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_surface_table.3003
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61878
be_else.61877:
	store   $i3, 9($sp)
	store   $i4, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     setup_second_table.3006
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    9($sp), $i2
	load    10($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.61878:
be_cont.61876:
	sub     $i2, 1, $i2
	load    8($sp), $i1
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.61879, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.61879:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       bge_cont.61874
bge_else.61873:
bge_cont.61874:
	load    7($sp), $i1
	load    118($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    5($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.61880, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.61880:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    7($sp), $i1
	load    117($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61881
	store   $i1, 11($sp)
	load    4($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61883
	store   $i2, 12($sp)
	store   $i4, 13($sp)
	mov     $i3, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     setup_rect_table.3000
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    12($sp), $i2
	load    13($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61884
be_else.61883:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61885
	store   $i2, 12($sp)
	store   $i4, 13($sp)
	mov     $i3, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     setup_surface_table.3003
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    12($sp), $i2
	load    13($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61886
be_else.61885:
	store   $i2, 12($sp)
	store   $i4, 13($sp)
	mov     $i3, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     setup_second_table.3006
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    12($sp), $i2
	load    13($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.61886:
be_cont.61884:
	sub     $i2, 1, $i2
	load    11($sp), $i1
	load    5($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.61887, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.61887:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	b       bge_cont.61882
bge_else.61881:
bge_cont.61882:
	li      116, $i2
	load    7($sp), $i1
	load    3($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.61888, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.61888:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    2($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61889
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
	li      cls.61890, $ra
	add     $sp, 17, $sp
	jr      $i10
cls.61890:
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $i1
	load    118($i1), $i1
	load    6($sp), $i2
	load    0($i2), $i2
	sub     $i2, 1, $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.61891
	store   $i1, 16($sp)
	load    4($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61893
	store   $i2, 17($sp)
	store   $i4, 18($sp)
	mov     $i3, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     setup_rect_table.3000
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    17($sp), $i2
	load    18($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61894
be_else.61893:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61895
	store   $i2, 17($sp)
	store   $i4, 18($sp)
	mov     $i3, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     setup_surface_table.3003
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    17($sp), $i2
	load    18($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61896
be_else.61895:
	store   $i2, 17($sp)
	store   $i4, 18($sp)
	mov     $i3, $i2
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     setup_second_table.3006
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    17($sp), $i2
	load    18($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.61896:
be_cont.61894:
	sub     $i2, 1, $i2
	load    16($sp), $i1
	load    5($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61897, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61897:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	b       bge_cont.61892
bge_else.61891:
bge_cont.61892:
	li      117, $i2
	load    15($sp), $i1
	load    3($sp), $i11
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.61898, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.61898:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    14($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61899
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
	bl      $i12, bge_else.61900
	store   $i1, 21($sp)
	load    4($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    1($i1), $i4
	load    0($i1), $i1
	load    1($i3), $i5
	li      1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61902
	store   $i2, 22($sp)
	store   $i4, 23($sp)
	mov     $i3, $i2
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     setup_rect_table.3000
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    22($sp), $i2
	load    23($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61903
be_else.61902:
	li      2, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.61904
	store   $i2, 22($sp)
	store   $i4, 23($sp)
	mov     $i3, $i2
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     setup_surface_table.3003
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    22($sp), $i2
	load    23($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.61905
be_else.61904:
	store   $i2, 22($sp)
	store   $i4, 23($sp)
	mov     $i3, $i2
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     setup_second_table.3006
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    22($sp), $i2
	load    23($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.61905:
be_cont.61903:
	sub     $i2, 1, $i2
	load    21($sp), $i1
	load    5($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.61906, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.61906:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	b       bge_cont.61901
bge_else.61900:
bge_cont.61901:
	li      118, $i2
	load    20($sp), $i1
	load    3($sp), $i11
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.61907, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.61907:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    19($sp), $i1
	sub     $i1, 1, $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61908
	store   $i1, 24($sp)
	load    1($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      119, $i2
	load    3($sp), $i11
	store   $ra, 25($sp)
	load    0($i11), $i10
	li      cls.61909, $ra
	add     $sp, 26, $sp
	jr      $i10
cls.61909:
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.61908:
	ret
bge_else.61899:
	ret
bge_else.61889:
	ret
bge_else.61872:
	ret
setup_reflections.3247:
	load    6($i11), $i2
	load    5($i11), $i3
	load    4($i11), $i4
	load    3($i11), $i5
	load    2($i11), $i6
	load    1($i11), $i7
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.61914
	add     $i3, $i1, $i12
	load    0($i12), $i3
	load    2($i3), $i8
	li      2, $i12
	cmp     $i8, $i12, $i12
	bne     $i12, be_else.61915
	store   $i2, 0($sp)
	store   $i7, 1($sp)
	store   $i5, 2($sp)
	store   $i6, 3($sp)
	store   $i4, 4($sp)
	store   $i1, 5($sp)
	store   $i3, 6($sp)
	load    7($i3), $i1
	load    0($i1), $f1
	li      l.25743, $i1
	load    0($i1), $f2
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fless
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.61916
	ret
be_else.61916:
	load    6($sp), $i1
	load    1($i1), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61918
	load    5($sp), $i2
	sll     $i2, 2, $i2
	store   $i2, 7($sp)
	load    4($sp), $i2
	load    0($i2), $i2
	store   $i2, 8($sp)
	li      l.25743, $i2
	load    0($i2), $f1
	load    7($i1), $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 9($sp)
	load    3($sp), $i1
	load    0($i1), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fneg
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $f1, 10($sp)
	load    3($sp), $i1
	load    1($i1), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $f1, 11($sp)
	load    3($sp), $i1
	load    2($i1), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fneg
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $f1, 12($sp)
	load    7($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 13($sp)
	load    3($sp), $i1
	load    0($i1), $f1
	store   $f1, 14($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_float_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $i1, $i2
	store   $i2, 15($sp)
	load    2($sp), $i1
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
	store   $i2, 16($sp)
	load    14($sp), $f1
	store   $f1, 0($i1)
	load    11($sp), $f1
	store   $f1, 1($i1)
	load    12($sp), $f1
	store   $f1, 2($i1)
	load    2($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 17($sp)
	load    0($i11), $i10
	li      cls.61919, $ra
	add     $sp, 18, $sp
	jr      $i10
cls.61919:
	sub     $sp, 18, $sp
	load    17($sp), $ra
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    9($sp), $f1
	store   $f1, 2($i1)
	load    16($sp), $i2
	store   $i2, 1($i1)
	load    13($sp), $i2
	store   $i2, 0($i1)
	load    8($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	store   $i1, 17($sp)
	load    7($sp), $i1
	add     $i1, 2, $i1
	store   $i1, 18($sp)
	load    3($sp), $i1
	load    1($i1), $f1
	store   $f1, 19($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	mov     $i1, $i2
	store   $i2, 20($sp)
	load    2($sp), $i1
	load    0($i1), $i1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    20($sp), $i1
	store   $i1, 0($i2)
	store   $i2, 21($sp)
	load    10($sp), $f1
	store   $f1, 0($i1)
	load    19($sp), $f1
	store   $f1, 1($i1)
	load    12($sp), $f1
	store   $f1, 2($i1)
	load    2($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 22($sp)
	load    0($i11), $i10
	li      cls.61920, $ra
	add     $sp, 23, $sp
	jr      $i10
cls.61920:
	sub     $sp, 23, $sp
	load    22($sp), $ra
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    9($sp), $f1
	store   $f1, 2($i1)
	load    21($sp), $i2
	store   $i2, 1($i1)
	load    18($sp), $i2
	store   $i2, 0($i1)
	load    17($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    8($sp), $i1
	add     $i1, 2, $i1
	store   $i1, 22($sp)
	load    7($sp), $i1
	add     $i1, 3, $i1
	store   $i1, 23($sp)
	load    3($sp), $i1
	load    2($i1), $f1
	store   $f1, 24($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_create_float_array
	sub     $sp, 26, $sp
	load    25($sp), $ra
	mov     $i1, $i2
	store   $i2, 25($sp)
	load    2($sp), $i1
	load    0($i1), $i1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_create_array
	sub     $sp, 27, $sp
	load    26($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    25($sp), $i1
	store   $i1, 0($i2)
	store   $i2, 26($sp)
	load    10($sp), $f1
	store   $f1, 0($i1)
	load    11($sp), $f1
	store   $f1, 1($i1)
	load    24($sp), $f1
	store   $f1, 2($i1)
	load    2($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 27($sp)
	load    0($i11), $i10
	li      cls.61921, $ra
	add     $sp, 28, $sp
	jr      $i10
cls.61921:
	sub     $sp, 28, $sp
	load    27($sp), $ra
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    9($sp), $f1
	store   $f1, 2($i1)
	load    26($sp), $i2
	store   $i2, 1($i1)
	load    23($sp), $i2
	store   $i2, 0($i1)
	load    22($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    8($sp), $i1
	add     $i1, 3, $i1
	load    4($sp), $i2
	store   $i1, 0($i2)
	ret
be_else.61918:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.61923
	load    5($sp), $i2
	sll     $i2, 2, $i2
	add     $i2, 1, $i2
	store   $i2, 27($sp)
	load    4($sp), $i2
	load    0($i2), $i2
	store   $i2, 28($sp)
	li      l.25743, $i2
	load    0($i2), $f1
	load    7($i1), $i2
	load    0($i2), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 29($sp)
	load    4($i1), $i2
	load    3($sp), $i3
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
	li      l.25831, $i2
	load    0($i2), $f2
	load    4($i1), $i2
	load    0($i2), $f3
	fmul    $f2, $f3, $f2
	fmul    $f2, $f1, $f2
	load    0($i3), $f3
	fsub    $f2, $f3, $f2
	store   $f2, 30($sp)
	li      l.25831, $i2
	load    0($i2), $f2
	load    4($i1), $i2
	load    1($i2), $f3
	fmul    $f2, $f3, $f2
	fmul    $f2, $f1, $f2
	load    1($i3), $f3
	fsub    $f2, $f3, $f2
	store   $f2, 31($sp)
	li      l.25831, $i2
	load    0($i2), $f2
	load    4($i1), $i1
	load    2($i1), $f3
	fmul    $f2, $f3, $f2
	fmul    $f2, $f1, $f1
	load    2($i3), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 32($sp)
	li      3, $i1
	li      l.25703, $i2
	load    0($i2), $f1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_create_float_array
	sub     $sp, 34, $sp
	load    33($sp), $ra
	mov     $i1, $i2
	store   $i2, 33($sp)
	load    2($sp), $i1
	load    0($i1), $i1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_create_array
	sub     $sp, 35, $sp
	load    34($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    33($sp), $i1
	store   $i1, 0($i2)
	store   $i2, 34($sp)
	load    30($sp), $f1
	store   $f1, 0($i1)
	load    31($sp), $f1
	store   $f1, 1($i1)
	load    32($sp), $f1
	store   $f1, 2($i1)
	load    2($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    1($sp), $i11
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 35($sp)
	load    0($i11), $i10
	li      cls.61924, $ra
	add     $sp, 36, $sp
	jr      $i10
cls.61924:
	sub     $sp, 36, $sp
	load    35($sp), $ra
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    29($sp), $f1
	store   $f1, 2($i1)
	load    34($sp), $i2
	store   $i2, 1($i1)
	load    27($sp), $i2
	store   $i2, 0($i1)
	load    28($sp), $i2
	load    0($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	load    4($sp), $i2
	store   $i1, 0($i2)
	ret
be_else.61923:
	ret
be_else.61915:
	ret
bge_else.61914:
	ret
l.26613:	.float  1.2800000000E+02
l.26562:	.float  1.5707963268E+00
l.26560:	.float  6.2831853072E+00
l.26558:	.float  3.1415926536E+00
l.26356:	.float  9.0000000000E-01
l.26354:	.float  2.0000000000E-01
l.26170:	.float  1.5000000000E+02
l.26160:	.float  -1.5000000000E+02
l.26143:	.float  -2.0000000000E+00
l.26141:	.float  3.9062500000E-03
l.26127:	.float  1.0000000000E+08
l.26124:	.float  1.0000000000E+09
l.26114:	.float  2.0000000000E+01
l.26112:	.float  5.0000000000E-02
l.26106:	.float  2.5000000000E-01
l.26098:	.float  3.0000000000E-01
l.26096:	.float  2.5500000000E+02
l.26091:	.float  1.5000000000E-01
l.26085:	.float  3.1415927000E+00
l.26083:	.float  3.0000000000E+01
l.26081:	.float  1.5000000000E+01
l.26079:	.float  1.0000000000E-04
l.26066:	.float  -1.0000000000E-01
l.26054:	.float  1.0000000000E-02
l.26052:	.float  -2.0000000000E-01
l.26012:	.float  -1.0000000000E+00
l.25977:	.float  -2.0000000000E+02
l.25975:	.float  2.0000000000E+02
l.25968:	.float  1.7453293000E-02
l.25932:	.float  1.0000000000E-04
l.25922:	.float  1.0000000000E-03
l.25915:	.float  1.0000000000E-02
l.25907:	.float  1.0000000000E+01
l.25895:	.float  1.0000000000E-01
l.25874:	.float  3.0000000000E+00
l.25831:	.float  2.0000000000E+00
l.25743:	.float  1.0000000000E+00
l.25710:	.float  -6.0725293501E-01
l.25705:	.float  6.0725293501E-01
l.25703:	.float  0.0000000000E+00
l.25696:	.float  5.0000000000E-01
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
# * fless
# fless($f1, $f2) := ($f1 < $f2) ? 1 : 0
######################################################################
min_caml_fless:
	fcmp $f1, $f2, $cond
	bge $cond, FLESS_RET
	li 1, $i1
	ret
FLESS_RET:
	li 0, $i1
	ret


######################################################################
# * fispos
# fispos($f1) := ($f1 > 0) ? 1 : 0
######################################################################
min_caml_fispos:
	fcmp $f1, $fzero, $cond
	bg $cond, FISPOS_RET
	li 0, $i1
	ret
FISPOS_RET:
	li 1, $i1
	ret


######################################################################
# * fisneg
# fisneg($f1) := ($f1 < 0) ? 1 : 0
######################################################################
min_caml_fisneg:
	fcmp $f1, $fzero, $cond
	bl $cond, FISNEG_RET
	li 0, $i1
	ret
FISNEG_RET:
	li 1, $i1
	ret


######################################################################
# * fiszero
# fiszero($f1) := ($f1 == 0) ? 1 : 0
######################################################################
min_caml_fiszero:
	fcmp $f1, $fzero, $cond
	be $cond, FISZERO_RET
	li 0, $i1
	ret
FISZERO_RET:
	li 1, $i1
	ret


######################################################################
# * fhalf
# fhalf($f1) := $f1 / 2.0
######################################################################
min_caml_fhalf:
	load FHALF_DAT($zero), $f2
	fmul $f1, $f2, $f1
	ret
FHALF_DAT:
	.float 0.5


######################################################################
# * fsqr
# fsqr($f1) := $f1 * $f1
######################################################################
min_caml_fsqr:
	fmul $f1, $f1, $f1
	ret


######################################################################
# * fabs
######################################################################
min_caml_fabs:
	fcmp $f1, $fzero, $cond
	ble $cond, FABS_NEG
	ret
FABS_NEG:
	fneg $f1, $f1
	ret


######################################################################
# * fneg
######################################################################
min_caml_fneg:
	fneg $f1, $f1
	ret


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
# * read
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
