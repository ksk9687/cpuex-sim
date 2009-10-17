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
	li      l.6886, $i2
	load    0($i2), $f1
	li      l.6888, $i2
	load    0($i2), $f2
	li      l.6890, $i2
	load    0($i2), $f3
	li      l.6892, $i2
	load    0($i2), $f4
	mov     $hp, $i2
	add     $hp, 3, $hp
	li      cordic_sin.2715, $i3
	store   $i3, 0($i2)
	store   $f4, 2($i2)
	store   $i1, 1($i2)
	mov     $hp, $i3
	add     $hp, 3, $hp
	li      cordic_cos.2717, $i4
	store   $i4, 0($i3)
	store   $f4, 2($i3)
	store   $i1, 1($i3)
	mov     $hp, $i4
	add     $hp, 2, $hp
	li      cordic_atan.2719, $i5
	store   $i5, 0($i4)
	store   $i1, 1($i4)
	mov     $hp, $i1
	store   $i1, 0($sp)
	add     $hp, 5, $hp
	li      sin.2721, $i5
	store   $i5, 0($i1)
	store   $f3, 4($i1)
	store   $f2, 3($i1)
	store   $f1, 2($i1)
	store   $i2, 1($i1)
	mov     $hp, $i1
	store   $i1, 1($sp)
	add     $hp, 5, $hp
	li      cos.2723, $i2
	store   $i2, 0($i1)
	store   $f3, 4($i1)
	store   $f2, 3($i1)
	store   $f1, 2($i1)
	store   $i3, 1($i1)
	mov     $hp, $i1
	store   $i1, 2($sp)
	add     $hp, 2, $hp
	li      atan.2725, $i2
	store   $i2, 0($i1)
	store   $i4, 1($i1)
	li      1, $i1
	li      0, $i2
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_create_array
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $i1, 3($sp)
	li      0, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_float_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
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
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_create_array
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_float_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_float_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	li      1, $i1
	li      l.6799, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	li      50, $i1
	store   $i1, 9($sp)
	li      1, $i1
	li      -1, $i2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	mov     $i1, $i2
	load    9($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	li      1, $i2
	store   $i2, 11($sp)
	li      1, $i2
	load    0($i1), $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	mov     $i1, $i2
	load    11($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_create_array
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $i1, 12($sp)
	li      1, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_create_float_array
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $i1, 13($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_create_array
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $i1, 14($sp)
	li      1, $i1
	li      l.6772, $i2
	load    0($i2), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_create_float_array
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $i1, 15($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_create_float_array
	sub     $sp, 17, $sp
	load    16($sp), $ra
	store   $i1, 16($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_create_array
	sub     $sp, 18, $sp
	load    17($sp), $ra
	store   $i1, 17($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_create_float_array
	sub     $sp, 19, $sp
	load    18($sp), $ra
	store   $i1, 18($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_create_float_array
	sub     $sp, 20, $sp
	load    19($sp), $ra
	store   $i1, 19($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     min_caml_create_float_array
	sub     $sp, 21, $sp
	load    20($sp), $ra
	store   $i1, 20($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_create_float_array
	sub     $sp, 22, $sp
	load    21($sp), $ra
	store   $i1, 21($sp)
	li      2, $i1
	li      0, $i2
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_create_array
	sub     $sp, 23, $sp
	load    22($sp), $ra
	store   $i1, 22($sp)
	li      2, $i1
	li      0, $i2
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_create_array
	sub     $sp, 24, $sp
	load    23($sp), $ra
	store   $i1, 23($sp)
	li      1, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_create_float_array
	sub     $sp, 25, $sp
	load    24($sp), $ra
	store   $i1, 24($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_create_float_array
	sub     $sp, 26, $sp
	load    25($sp), $ra
	store   $i1, 25($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_create_float_array
	sub     $sp, 27, $sp
	load    26($sp), $ra
	store   $i1, 26($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_create_float_array
	sub     $sp, 28, $sp
	load    27($sp), $ra
	store   $i1, 27($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_create_float_array
	sub     $sp, 29, $sp
	load    28($sp), $ra
	store   $i1, 28($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     min_caml_create_float_array
	sub     $sp, 30, $sp
	load    29($sp), $ra
	store   $i1, 29($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     min_caml_create_float_array
	sub     $sp, 31, $sp
	load    30($sp), $ra
	store   $i1, 30($sp)
	li      0, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_create_float_array
	sub     $sp, 32, $sp
	load    31($sp), $ra
	mov     $i1, $i2
	store   $i2, 31($sp)
	li      0, $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	li      0, $i2
	mov     $hp, $i3
	add     $hp, 2, $hp
	store   $i1, 1($i3)
	load    31($sp), $i1
	store   $i1, 0($i3)
	mov     $i3, $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	mov     $i1, $i2
	li      5, $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_create_array
	sub     $sp, 33, $sp
	load    32($sp), $ra
	store   $i1, 32($sp)
	li      0, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_create_float_array
	sub     $sp, 34, $sp
	load    33($sp), $ra
	store   $i1, 33($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_create_float_array
	sub     $sp, 35, $sp
	load    34($sp), $ra
	store   $i1, 34($sp)
	li      60, $i1
	load    33($sp), $i2
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_create_array
	sub     $sp, 36, $sp
	load    35($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    34($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	store   $i1, 35($sp)
	li      0, $i1
	li      l.6636, $i2
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
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    36($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	li      180, $i2
	li      0, $i3
	li      l.6636, $i4
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
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_create_array
	sub     $sp, 38, $sp
	load    37($sp), $ra
	store   $i1, 37($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     min_caml_create_array
	sub     $sp, 39, $sp
	load    38($sp), $ra
	store   $i1, 38($sp)
	mov     $hp, $i1
	add     $hp, 8, $hp
	li      read_screen_settings.2895, $i2
	store   $i2, 0($i1)
	load    6($sp), $i2
	store   $i2, 7($i1)
	load    0($sp), $i2
	store   $i2, 6($i1)
	load    29($sp), $i3
	store   $i3, 5($i1)
	load    28($sp), $i3
	store   $i3, 4($i1)
	load    27($sp), $i3
	store   $i3, 3($i1)
	load    5($sp), $i3
	store   $i3, 2($i1)
	load    1($sp), $i3
	store   $i3, 1($i1)
	mov     $hp, $i4
	add     $hp, 5, $hp
	li      read_light.2897, $i5
	store   $i5, 0($i4)
	store   $i2, 4($i4)
	load    7($sp), $i5
	store   $i5, 3($i4)
	store   $i3, 2($i4)
	load    8($sp), $i6
	store   $i6, 1($i4)
	mov     $hp, $i6
	add     $hp, 3, $hp
	li      rotate_quadratic_matrix.2899, $i7
	store   $i7, 0($i6)
	store   $i2, 2($i6)
	store   $i3, 1($i6)
	mov     $hp, $i2
	add     $hp, 3, $hp
	li      read_nth_object.2902, $i3
	store   $i3, 0($i2)
	store   $i6, 2($i2)
	load    4($sp), $i3
	store   $i3, 1($i2)
	mov     $hp, $i6
	add     $hp, 3, $hp
	li      read_object.2904, $i7
	store   $i7, 0($i6)
	store   $i2, 2($i6)
	load    3($sp), $i2
	store   $i2, 1($i6)
	mov     $hp, $i7
	add     $hp, 2, $hp
	li      read_all_object.2906, $i8
	store   $i8, 0($i7)
	store   $i6, 1($i7)
	mov     $hp, $i6
	add     $hp, 2, $hp
	li      read_and_network.2912, $i8
	store   $i8, 0($i6)
	load    10($sp), $i8
	store   $i8, 1($i6)
	mov     $hp, $i9
	store   $i9, 39($sp)
	add     $hp, 6, $hp
	li      read_parameter.2914, $i10
	store   $i10, 0($i9)
	store   $i1, 5($i9)
	store   $i4, 4($i9)
	store   $i6, 3($i9)
	store   $i7, 2($i9)
	load    12($sp), $i1
	store   $i1, 1($i9)
	mov     $hp, $i1
	add     $hp, 2, $hp
	li      solver_rect_surface.2916, $i4
	store   $i4, 0($i1)
	load    13($sp), $i4
	store   $i4, 1($i1)
	mov     $hp, $i6
	add     $hp, 2, $hp
	li      solver_rect.2925, $i7
	store   $i7, 0($i6)
	store   $i1, 1($i6)
	mov     $hp, $i1
	add     $hp, 2, $hp
	li      solver_surface.2931, $i7
	store   $i7, 0($i1)
	store   $i4, 1($i1)
	mov     $hp, $i7
	add     $hp, 2, $hp
	li      solver_second.2950, $i9
	store   $i9, 0($i7)
	store   $i4, 1($i7)
	mov     $hp, $i9
	store   $i9, 40($sp)
	add     $hp, 5, $hp
	li      solver.2956, $i10
	store   $i10, 0($i9)
	store   $i1, 4($i9)
	store   $i7, 3($i9)
	store   $i6, 2($i9)
	store   $i3, 1($i9)
	mov     $hp, $i1
	add     $hp, 2, $hp
	li      solver_rect_fast.2960, $i6
	store   $i6, 0($i1)
	store   $i4, 1($i1)
	mov     $hp, $i6
	add     $hp, 2, $hp
	li      solver_surface_fast.2967, $i7
	store   $i7, 0($i6)
	store   $i4, 1($i6)
	mov     $hp, $i7
	add     $hp, 2, $hp
	li      solver_second_fast.2973, $i9
	store   $i9, 0($i7)
	store   $i4, 1($i7)
	mov     $hp, $i9
	add     $hp, 5, $hp
	li      solver_fast.2979, $i10
	store   $i10, 0($i9)
	store   $i6, 4($i9)
	store   $i7, 3($i9)
	store   $i1, 2($i9)
	store   $i3, 1($i9)
	mov     $hp, $i6
	add     $hp, 2, $hp
	li      solver_surface_fast2.2983, $i7
	store   $i7, 0($i6)
	store   $i4, 1($i6)
	mov     $hp, $i7
	add     $hp, 2, $hp
	li      solver_second_fast2.2990, $i10
	store   $i10, 0($i7)
	store   $i4, 1($i7)
	mov     $hp, $i10
	store   $i10, 41($sp)
	add     $hp, 5, $hp
	li      solver_fast2.2997, $i11
	store   $i11, 0($i10)
	store   $i6, 4($i10)
	store   $i7, 3($i10)
	store   $i1, 2($i10)
	store   $i3, 1($i10)
	mov     $hp, $i1
	add     $hp, 2, $hp
	li      iter_setup_dirvec_constants.3009, $i6
	store   $i6, 0($i1)
	store   $i3, 1($i1)
	mov     $hp, $i6
	store   $i6, 42($sp)
	add     $hp, 3, $hp
	li      setup_dirvec_constants.3012, $i7
	store   $i7, 0($i6)
	store   $i2, 2($i6)
	store   $i1, 1($i6)
	mov     $hp, $i1
	add     $hp, 2, $hp
	li      setup_startp_constants.3014, $i6
	store   $i6, 0($i1)
	store   $i3, 1($i1)
	mov     $hp, $i6
	store   $i6, 43($sp)
	add     $hp, 4, $hp
	li      setup_startp.3017, $i7
	store   $i7, 0($i6)
	load    26($sp), $i7
	store   $i7, 3($i6)
	store   $i1, 2($i6)
	store   $i2, 1($i6)
	mov     $hp, $i1
	store   $i1, 44($sp)
	add     $hp, 2, $hp
	li      check_all_inside.3039, $i2
	store   $i2, 0($i1)
	store   $i3, 1($i1)
	mov     $hp, $i2
	add     $hp, 8, $hp
	li      shadow_check_and_group.3045, $i6
	store   $i6, 0($i2)
	store   $i9, 7($i2)
	store   $i4, 6($i2)
	store   $i3, 5($i2)
	load    35($sp), $i6
	store   $i6, 4($i2)
	store   $i5, 3($i2)
	load    16($sp), $i5
	store   $i5, 2($i2)
	store   $i1, 1($i2)
	mov     $hp, $i10
	add     $hp, 3, $hp
	li      shadow_check_one_or_group.3048, $i11
	store   $i11, 0($i10)
	store   $i2, 2($i10)
	store   $i8, 1($i10)
	mov     $hp, $i2
	store   $i2, 45($sp)
	add     $hp, 6, $hp
	li      shadow_check_one_or_matrix.3051, $i11
	store   $i11, 0($i2)
	store   $i9, 5($i2)
	store   $i4, 4($i2)
	store   $i10, 3($i2)
	store   $i6, 2($i2)
	store   $i5, 1($i2)
	mov     $hp, $i2
	add     $hp, 10, $hp
	li      solve_each_element.3054, $i6
	store   $i6, 0($i2)
	load    15($sp), $i6
	store   $i6, 9($i2)
	load    25($sp), $i9
	store   $i9, 8($i2)
	store   $i4, 7($i2)
	load    40($sp), $i10
	store   $i10, 6($i2)
	store   $i3, 5($i2)
	load    14($sp), $i11
	store   $i11, 4($i2)
	store   $i5, 3($i2)
	load    17($sp), $i5
	store   $i5, 2($i2)
	store   $i1, 1($i2)
	mov     $hp, $i1
	add     $hp, 3, $hp
	li      solve_one_or_network.3058, $i5
	store   $i5, 0($i1)
	store   $i2, 2($i1)
	store   $i8, 1($i1)
	mov     $hp, $i2
	add     $hp, 6, $hp
	li      trace_or_matrix.3062, $i5
	store   $i5, 0($i2)
	store   $i6, 5($i2)
	store   $i9, 4($i2)
	store   $i4, 3($i2)
	store   $i10, 2($i2)
	store   $i1, 1($i2)
	mov     $hp, $i1
	store   $i1, 46($sp)
	add     $hp, 4, $hp
	li      judge_intersection.3066, $i5
	store   $i5, 0($i1)
	store   $i2, 3($i1)
	store   $i6, 2($i1)
	load    12($sp), $i2
	store   $i2, 1($i1)
	mov     $hp, $i1
	add     $hp, 10, $hp
	li      solve_each_element_fast.3068, $i5
	store   $i5, 0($i1)
	store   $i6, 9($i1)
	store   $i7, 8($i1)
	load    41($sp), $i5
	store   $i5, 7($i1)
	store   $i4, 6($i1)
	store   $i3, 5($i1)
	store   $i11, 4($i1)
	load    16($sp), $i3
	store   $i3, 3($i1)
	load    17($sp), $i7
	store   $i7, 2($i1)
	load    44($sp), $i9
	store   $i9, 1($i1)
	mov     $hp, $i9
	add     $hp, 3, $hp
	li      solve_one_or_network_fast.3072, $i10
	store   $i10, 0($i9)
	store   $i1, 2($i9)
	store   $i8, 1($i9)
	mov     $hp, $i1
	add     $hp, 5, $hp
	li      trace_or_matrix_fast.3076, $i8
	store   $i8, 0($i1)
	store   $i6, 4($i1)
	store   $i5, 3($i1)
	store   $i4, 2($i1)
	store   $i9, 1($i1)
	mov     $hp, $i4
	store   $i4, 47($sp)
	add     $hp, 4, $hp
	li      judge_intersection_fast.3080, $i5
	store   $i5, 0($i4)
	store   $i1, 3($i4)
	store   $i6, 2($i4)
	store   $i2, 1($i4)
	mov     $hp, $i1
	add     $hp, 3, $hp
	li      get_nvector_rect.3082, $i5
	store   $i5, 0($i1)
	load    18($sp), $i5
	store   $i5, 2($i1)
	store   $i11, 1($i1)
	mov     $hp, $i8
	add     $hp, 2, $hp
	li      get_nvector_plane.3084, $i9
	store   $i9, 0($i8)
	store   $i5, 1($i8)
	mov     $hp, $i9
	add     $hp, 3, $hp
	li      get_nvector_second.3086, $i10
	store   $i10, 0($i9)
	store   $i5, 2($i9)
	store   $i3, 1($i9)
	mov     $hp, $i3
	store   $i3, 48($sp)
	add     $hp, 4, $hp
	li      get_nvector.3088, $i10
	store   $i10, 0($i3)
	store   $i9, 3($i3)
	store   $i1, 2($i3)
	store   $i8, 1($i3)
	mov     $hp, $i1
	add     $hp, 5, $hp
	li      utexture.3091, $i3
	store   $i3, 0($i1)
	load    19($sp), $i3
	store   $i3, 4($i1)
	load    0($sp), $i8
	store   $i8, 3($i1)
	load    1($sp), $i8
	store   $i8, 2($i1)
	load    2($sp), $i8
	store   $i8, 1($i1)
	mov     $hp, $i8
	add     $hp, 3, $hp
	li      add_light.3094, $i9
	store   $i9, 0($i8)
	store   $i3, 2($i8)
	load    21($sp), $i9
	store   $i9, 1($i8)
	mov     $hp, $i9
	add     $hp, 9, $hp
	li      trace_reflections.3098, $i10
	store   $i10, 0($i9)
	load    45($sp), $i10
	store   $i10, 8($i9)
	load    37($sp), $i10
	store   $i10, 7($i9)
	store   $i2, 6($i9)
	store   $i5, 5($i9)
	store   $i4, 4($i9)
	store   $i11, 3($i9)
	store   $i7, 2($i9)
	store   $i8, 1($i9)
	mov     $hp, $i4
	add     $hp, 21, $hp
	li      trace_ray.3103, $i10
	store   $i10, 0($i4)
	store   $i1, 20($i4)
	store   $i9, 19($i4)
	store   $i6, 18($i4)
	store   $i3, 17($i4)
	load    25($sp), $i6
	store   $i6, 16($i4)
	load    45($sp), $i6
	store   $i6, 15($i4)
	load    43($sp), $i9
	store   $i9, 14($i4)
	load    21($sp), $i9
	store   $i9, 13($i4)
	store   $i2, 12($i4)
	load    4($sp), $i9
	store   $i9, 11($i4)
	store   $i5, 10($i4)
	load    38($sp), $i10
	store   $i10, 9($i4)
	load    7($sp), $i10
	store   $i10, 8($i4)
	load    46($sp), $i10
	store   $i10, 7($i4)
	store   $i11, 6($i4)
	load    16($sp), $i10
	store   $i10, 5($i4)
	store   $i7, 4($i4)
	load    48($sp), $i11
	store   $i11, 3($i4)
	load    8($sp), $i11
	store   $i11, 2($i4)
	store   $i8, 1($i4)
	mov     $hp, $i8
	add     $hp, 13, $hp
	li      trace_diffuse_ray.3109, $i11
	store   $i11, 0($i8)
	store   $i1, 12($i8)
	store   $i3, 11($i8)
	store   $i6, 10($i8)
	store   $i2, 9($i8)
	store   $i9, 8($i8)
	store   $i5, 7($i8)
	load    7($sp), $i1
	store   $i1, 6($i8)
	load    47($sp), $i1
	store   $i1, 5($i8)
	store   $i10, 4($i8)
	store   $i7, 3($i8)
	load    48($sp), $i1
	store   $i1, 2($i8)
	load    20($sp), $i1
	store   $i1, 1($i8)
	mov     $hp, $i2
	add     $hp, 2, $hp
	li      iter_trace_diffuse_rays.3112, $i3
	store   $i3, 0($i2)
	store   $i8, 1($i2)
	mov     $hp, $i3
	add     $hp, 3, $hp
	li      trace_diffuse_rays.3117, $i5
	store   $i5, 0($i3)
	load    43($sp), $i5
	store   $i5, 2($i3)
	store   $i2, 1($i3)
	mov     $hp, $i2
	add     $hp, 3, $hp
	li      trace_diffuse_ray_80percent.3121, $i5
	store   $i5, 0($i2)
	store   $i3, 2($i2)
	load    32($sp), $i5
	store   $i5, 1($i2)
	mov     $hp, $i6
	add     $hp, 4, $hp
	li      calc_diffuse_using_1point.3125, $i7
	store   $i7, 0($i6)
	store   $i2, 3($i6)
	load    21($sp), $i2
	store   $i2, 2($i6)
	store   $i1, 1($i6)
	mov     $hp, $i7
	add     $hp, 3, $hp
	li      calc_diffuse_using_5points.3128, $i8
	store   $i8, 0($i7)
	store   $i2, 2($i7)
	store   $i1, 1($i7)
	mov     $hp, $i8
	store   $i8, 49($sp)
	add     $hp, 2, $hp
	li      do_without_neighbors.3134, $i9
	store   $i9, 0($i8)
	store   $i6, 1($i8)
	mov     $hp, $i6
	add     $hp, 2, $hp
	li      neighbors_exist.3137, $i9
	store   $i9, 0($i6)
	load    22($sp), $i9
	store   $i9, 1($i6)
	mov     $hp, $i10
	add     $hp, 3, $hp
	li      try_exploit_neighbors.3150, $i11
	store   $i11, 0($i10)
	store   $i8, 2($i10)
	store   $i7, 1($i10)
	mov     $hp, $i7
	add     $hp, 2, $hp
	li      write_rgb.3161, $i8
	store   $i8, 0($i7)
	store   $i2, 1($i7)
	mov     $hp, $i8
	add     $hp, 4, $hp
	li      pretrace_diffuse_rays.3163, $i11
	store   $i11, 0($i8)
	store   $i3, 3($i8)
	store   $i5, 2($i8)
	store   $i1, 1($i8)
	mov     $hp, $i1
	add     $hp, 10, $hp
	li      pretrace_pixels.3166, $i3
	store   $i3, 0($i1)
	load    6($sp), $i3
	store   $i3, 9($i1)
	store   $i4, 8($i1)
	load    25($sp), $i3
	store   $i3, 7($i1)
	load    27($sp), $i3
	store   $i3, 6($i1)
	load    24($sp), $i3
	store   $i3, 5($i1)
	store   $i2, 4($i1)
	load    30($sp), $i4
	store   $i4, 3($i1)
	store   $i8, 2($i1)
	load    23($sp), $i4
	store   $i4, 1($i1)
	mov     $hp, $i8
	add     $hp, 7, $hp
	li      pretrace_line.3173, $i11
	store   $i11, 0($i8)
	load    29($sp), $i11
	store   $i11, 6($i8)
	load    28($sp), $i11
	store   $i11, 5($i8)
	store   $i3, 4($i8)
	store   $i1, 3($i8)
	store   $i9, 2($i8)
	store   $i4, 1($i8)
	mov     $hp, $i1
	add     $hp, 7, $hp
	li      scan_pixel.3177, $i4
	store   $i4, 0($i1)
	store   $i7, 6($i1)
	store   $i10, 5($i1)
	store   $i2, 4($i1)
	store   $i6, 3($i1)
	store   $i9, 2($i1)
	load    49($sp), $i2
	store   $i2, 1($i1)
	mov     $hp, $i2
	add     $hp, 4, $hp
	li      scan_line.3183, $i4
	store   $i4, 0($i2)
	store   $i1, 3($i2)
	store   $i8, 2($i2)
	store   $i9, 1($i2)
	mov     $hp, $i1
	store   $i1, 50($sp)
	add     $hp, 2, $hp
	li      create_pixelline.3196, $i4
	store   $i4, 0($i1)
	store   $i9, 1($i1)
	mov     $hp, $i1
	add     $hp, 3, $hp
	li      tan.3198, $i4
	store   $i4, 0($i1)
	load    0($sp), $i4
	store   $i4, 2($i1)
	load    1($sp), $i4
	store   $i4, 1($i1)
	mov     $hp, $i4
	add     $hp, 3, $hp
	li      adjust_position.3200, $i6
	store   $i6, 0($i4)
	store   $i1, 2($i4)
	load    2($sp), $i1
	store   $i1, 1($i4)
	mov     $hp, $i1
	add     $hp, 3, $hp
	li      calc_dirvec.3203, $i6
	store   $i6, 0($i1)
	store   $i5, 2($i1)
	store   $i4, 1($i1)
	mov     $hp, $i4
	add     $hp, 2, $hp
	li      calc_dirvecs.3211, $i6
	store   $i6, 0($i4)
	store   $i1, 1($i4)
	mov     $hp, $i1
	add     $hp, 2, $hp
	li      calc_dirvec_rows.3216, $i6
	store   $i6, 0($i1)
	store   $i4, 1($i1)
	mov     $hp, $i4
	add     $hp, 2, $hp
	li      create_dirvec.3220, $i6
	store   $i6, 0($i4)
	load    3($sp), $i6
	store   $i6, 1($i4)
	mov     $hp, $i6
	add     $hp, 2, $hp
	li      create_dirvec_elements.3222, $i7
	store   $i7, 0($i6)
	store   $i4, 1($i6)
	mov     $hp, $i7
	add     $hp, 4, $hp
	li      create_dirvecs.3225, $i9
	store   $i9, 0($i7)
	store   $i5, 3($i7)
	store   $i6, 2($i7)
	store   $i4, 1($i7)
	mov     $hp, $i6
	add     $hp, 2, $hp
	li      init_dirvec_constants.3227, $i9
	store   $i9, 0($i6)
	load    42($sp), $i9
	store   $i9, 1($i6)
	mov     $hp, $i10
	add     $hp, 3, $hp
	li      init_vecset_constants.3230, $i11
	store   $i11, 0($i10)
	store   $i6, 2($i10)
	store   $i5, 1($i10)
	mov     $hp, $i5
	add     $hp, 4, $hp
	li      init_dirvecs.3232, $i6
	store   $i6, 0($i5)
	store   $i10, 3($i5)
	store   $i7, 2($i5)
	store   $i1, 1($i5)
	mov     $hp, $i1
	add     $hp, 4, $hp
	li      add_reflection.3234, $i6
	store   $i6, 0($i1)
	store   $i9, 3($i1)
	load    37($sp), $i6
	store   $i6, 2($i1)
	store   $i4, 1($i1)
	mov     $hp, $i4
	add     $hp, 4, $hp
	li      setup_rect_reflection.3241, $i6
	store   $i6, 0($i4)
	load    38($sp), $i6
	store   $i6, 3($i4)
	load    7($sp), $i7
	store   $i7, 2($i4)
	store   $i1, 1($i4)
	mov     $hp, $i10
	add     $hp, 4, $hp
	li      setup_surface_reflection.3244, $i11
	store   $i11, 0($i10)
	store   $i6, 3($i10)
	store   $i7, 2($i10)
	store   $i1, 1($i10)
	mov     $hp, $i1
	add     $hp, 4, $hp
	li      setup_reflections.3247, $i6
	store   $i6, 0($i1)
	store   $i10, 3($i1)
	store   $i4, 2($i1)
	load    4($sp), $i4
	store   $i4, 1($i1)
	mov     $hp, $i11
	add     $hp, 14, $hp
	li      rt.3249, $i4
	store   $i4, 0($i11)
	store   $i1, 13($i11)
	store   $i9, 12($i11)
	store   $i3, 11($i11)
	store   $i2, 10($i11)
	load    39($sp), $i1
	store   $i1, 9($i11)
	store   $i8, 8($i11)
	load    3($sp), $i1
	store   $i1, 7($i11)
	load    35($sp), $i1
	store   $i1, 6($i11)
	store   $i7, 5($i11)
	store   $i5, 4($i11)
	load    22($sp), $i1
	store   $i1, 3($i11)
	load    23($sp), $i1
	store   $i1, 2($i11)
	load    50($sp), $i1
	store   $i1, 1($i11)
	li      128, $i1
	li      128, $i2
	store   $ra, 51($sp)
	load    0($i11), $i10
	li      cls.10658, $ra
	add     $sp, 52, $sp
	jr      $i10
cls.10658:
	sub     $sp, 52, $sp
	load    51($sp), $ra
	li      0, $i12
	halt
cordic_rec.6601:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.10659
	mov     $f2, $f1
	ret
be_else.10659:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.10660
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fadd    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fsub    $f3, $f1, $f3
	li      l.6633, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.10660:
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fsub    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fadd    $f3, $f1, $f3
	li      l.6633, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
cordic_sin.2715:
	load    2($i11), $f2
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6601, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      0, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	li      l.6636, $i2
	load    0($i2), $f3
	li      l.6639, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_rec.6569:
	load    2($i11), $i2
	load    1($i11), $f5
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.10661
	ret
be_else.10661:
	fcmp    $f5, $f3, $i12
	bg      $i12, ble_else.10662
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fadd    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fsub    $f3, $f1, $f3
	li      l.6633, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.10662:
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fsub    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fadd    $f3, $f1, $f3
	li      l.6633, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
cordic_cos.2717:
	load    2($i11), $f2
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 3, $hp
	li      cordic_rec.6569, $i2
	store   $i2, 0($i11)
	store   $i1, 2($i11)
	store   $f1, 1($i11)
	li      0, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	li      l.6636, $i2
	load    0($i2), $f3
	li      l.6639, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
cordic_rec.6536:
	load    1($i11), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.10663
	mov     $f3, $f1
	ret
be_else.10663:
	li      l.6636, $i2
	load    0($i2), $f5
	fcmp    $f2, $f5, $i12
	bg      $i12, ble_else.10664
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fsub    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fadd    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fsub    $f3, $f1, $f3
	li      l.6633, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.10664:
	add     $i1, 1, $i2
	fmul    $f4, $f2, $f5
	fadd    $f1, $f5, $f5
	fmul    $f4, $f1, $f1
	fsub    $f2, $f1, $f2
	li      min_caml_atan_table, $i3
	add     $i3, $i1, $i12
	load    0($i12), $f1
	fadd    $f3, $f1, $f3
	li      l.6633, $i1
	load    0($i1), $f1
	fmul    $f4, $f1, $f4
	mov     $i2, $i1
	mov     $f5, $f1
	load    0($i11), $i10
	jr      $i10
cordic_atan.2719:
	load    1($i11), $i1
	mov     $hp, $i11
	add     $hp, 2, $hp
	li      cordic_rec.6536, $i2
	store   $i2, 0($i11)
	store   $i1, 1($i11)
	li      0, $i1
	li      l.6639, $i2
	load    0($i2), $f2
	li      l.6636, $i2
	load    0($i2), $f3
	li      l.6639, $i2
	load    0($i2), $f4
	mov     $f2, $f14
	mov     $f1, $f2
	mov     $f14, $f1
	load    0($i11), $i10
	jr      $i10
sin.2721:
	load    4($i11), $f2
	load    3($i11), $f3
	load    2($i11), $f4
	load    1($i11), $i1
	li      l.6636, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.10665
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.10666
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.10667
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.10668
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.10668:
	fsub    $f3, $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.10669, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.10669:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.10667:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.10666:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.10665:
	fneg    $f1, $f1
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.10670, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.10670:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
cos.2723:
	load    4($i11), $f2
	load    3($i11), $f3
	load    2($i11), $f4
	load    1($i11), $i1
	li      l.6636, $i2
	load    0($i2), $f5
	fcmp    $f5, $f1, $i12
	bg      $i12, ble_else.10671
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.10672
	fcmp    $f4, $f1, $i12
	bg      $i12, ble_else.10673
	fcmp    $f3, $f1, $i12
	bg      $i12, ble_else.10674
	fsub    $f1, $f3, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.10674:
	fsub    $f3, $f1, $f1
	load    0($i11), $i10
	jr      $i10
ble_else.10673:
	fsub    $f4, $f1, $f1
	mov     $i1, $i11
	store   $ra, 0($sp)
	load    0($i11), $i10
	li      cls.10675, $ra
	add     $sp, 1, $sp
	jr      $i10
cls.10675:
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
ble_else.10672:
	mov     $i1, $i11
	load    0($i11), $i10
	jr      $i10
ble_else.10671:
	fneg    $f1, $f1
	load    0($i11), $i10
	jr      $i10
atan.2725:
	load    1($i11), $i11
	load    0($i11), $i10
	jr      $i10
get_sqrt_init_rec.6510:
	li      49, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10676
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
be_else.10676:
	li      l.6665, $i2
	load    0($i2), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.10677
	li      l.6665, $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	add     $i1, 1, $i1
	b       get_sqrt_init_rec.6510
ble_else.10677:
	li      min_caml_rsqrt_table, $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	ret
get_sqrt_init.2727:
	li      0, $i1
	b       get_sqrt_init_rec.6510
sqrt.2729:
	li      l.6639, $i1
	load    0($i1), $f2
	fcmp    $f2, $f1, $i12
	bg      $i12, ble_else.10678
	store   $f1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     get_sqrt_init.2727
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	load    0($sp), $f4
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	li      l.6633, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	li      l.6680, $i1
	load    0($i1), $f3
	fmul    $f4, $f1, $f5
	fmul    $f5, $f1, $f1
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	fmul    $f1, $f4, $f1
	ret
ble_else.10678:
	li      l.6633, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f1, $f15, $f3
	fadd    $f1, $f3, $f3
	fmul    $f2, $f3, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f4
	fadd    $f2, $f4, $f2
	fmul    $f3, $f2, $f2
	li      l.6633, $i1
	load    0($i1), $f3
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	fadd    $f2, $f1, $f1
	fmul    $f3, $f1, $f1
	ret
mul_10.6365:
	sll     $i1, 3, $i2
	sll     $i1, 1, $i1
	add     $i2, $i1, $i1
	ret
skip.6367:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10679
	ret
be_else.10679:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10680
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10681
	b       skip.6367
bge_else.10681:
	ret
bge_else.10680:
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
	bl      $i12, bge_else.10682
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10683
	load    0($sp), $i1
	ret
bge_else.10683:
	store   $i1, 1($sp)
	load    0($sp), $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     mul_10.6365
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i2
	add     $i1, $i2, $i1
	b       read_rec.6369
bge_else.10682:
	load    0($sp), $i1
	ret
read_int.2731:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6367
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10684
	li      0, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     read_rec.6369
	sub     $sp, 1, $sp
	load    0($sp), $ra
	neg     $i1, $i1
	ret
be_else.10684:
	sub     $i1, 48, $i1
	b       read_rec.6369
skip.6319:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_read
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10685
	ret
be_else.10685:
	li      48, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10686
	li      58, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10687
	b       skip.6319
bge_else.10687:
	ret
bge_else.10686:
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
	bl      $i12, bge_else.10688
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10689
	li      l.6636, $i1
	load    0($i1), $f1
	ret
bge_else.10689:
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_float_of_int
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 1($sp)
	li      l.6701, $i1
	load    0($i1), $f1
	fmul    $f2, $f1, $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     read_rec2.6321
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $f2
	fadd    $f2, $f1, $f1
	ret
bge_else.10688:
	li      l.6636, $i1
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
	bne     $i12, be_else.10690
	li      l.6701, $i1
	load    0($i1), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     read_rec2.6321
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $f2
	fadd    $f2, $f1, $f1
	ret
be_else.10690:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10691
	li      10, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10692
	load    0($sp), $f1
	ret
bge_else.10692:
	li      l.6704, $i2
	load    0($i2), $f1
	load    0($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_float_of_int
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $f2
	fadd    $f2, $f1, $f1
	b       read_rec1.6323
bge_else.10691:
	load    0($sp), $f1
	ret
read_float.2733:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     skip.6319
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      45, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10693
	li      l.6636, $i1
	load    0($i1), $f1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     read_rec1.6323
	sub     $sp, 1, $sp
	load    0($sp), $ra
	fneg    $f1, $f1
	ret
be_else.10693:
	sub     $i1, 48, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_float_of_int
	sub     $sp, 1, $sp
	load    0($sp), $ra
	b       read_rec1.6323
xor.2765:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10694
	mov     $i2, $i1
	ret
be_else.10694:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10695
	li      1, $i1
	ret
be_else.10695:
	li      0, $i1
	ret
sgn.2768:
	store   $f1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_fiszero
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10696
	load    0($sp), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_fispos
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10697
	li      l.6710, $i1
	load    0($i1), $f1
	ret
be_else.10697:
	li      l.6639, $i1
	load    0($i1), $f1
	ret
be_else.10696:
	li      l.6636, $i1
	load    0($i1), $f1
	ret
fneg_cond.2770:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10698
	b       min_caml_fneg
be_else.10698:
	ret
add_mod5.2773:
	add     $i1, $i2, $i1
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10699
	sub     $i1, 5, $i1
	ret
bge_else.10699:
	ret
vecset.2776:
	store   $f1, 0($i1)
	store   $f2, 1($i1)
	store   $f3, 2($i1)
	ret
vecfill.2781:
	store   $f1, 0($i1)
	store   $f1, 1($i1)
	store   $f1, 2($i1)
	ret
vecbzero.2784:
	li      l.6636, $i2
	load    0($i2), $f1
	b       vecfill.2781
veccpy.2786:
	load    0($i2), $f1
	store   $f1, 0($i1)
	load    1($i2), $f1
	store   $f1, 1($i1)
	load    2($i2), $f1
	store   $f1, 2($i1)
	ret
vecunit_sgn.2794:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	load    0($i1), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_fsqr
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $f1, 2($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fsqr
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 3($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fsqr
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     sqrt.2729
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $f1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fiszero
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10703
	load    0($sp), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10705
	li      l.6639, $i1
	load    0($i1), $f1
	load    4($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.10706
be_else.10705:
	li      l.6710, $i1
	load    0($i1), $f1
	load    4($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
be_cont.10706:
	b       be_cont.10704
be_else.10703:
	li      l.6639, $i1
	load    0($i1), $f1
be_cont.10704:
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
veciprod.2797:
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
	ret
veciprod2.2800:
	load    0($i1), $f4
	fmul    $f4, $f1, $f1
	load    1($i1), $f4
	fmul    $f4, $f2, $f2
	fadd    $f1, $f2, $f1
	load    2($i1), $f2
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	ret
vecaccum.2805:
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
	ret
vecadd.2809:
	load    0($i1), $f1
	load    0($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 0($i1)
	load    1($i1), $f1
	load    1($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 1($i1)
	load    2($i1), $f1
	load    2($i2), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i1)
	ret
vecscale.2815:
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
vecaccumv.2818:
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
o_texturetype.2822:
	load    0($i1), $i1
	ret
o_form.2824:
	load    1($i1), $i1
	ret
o_reflectiontype.2826:
	load    2($i1), $i1
	ret
o_isinvert.2828:
	load    6($i1), $i1
	ret
o_isrot.2830:
	load    3($i1), $i1
	ret
o_param_a.2832:
	load    4($i1), $i1
	load    0($i1), $f1
	ret
o_param_b.2834:
	load    4($i1), $i1
	load    1($i1), $f1
	ret
o_param_c.2836:
	load    4($i1), $i1
	load    2($i1), $f1
	ret
o_param_abc.2838:
	load    4($i1), $i1
	ret
o_param_x.2840:
	load    5($i1), $i1
	load    0($i1), $f1
	ret
o_param_y.2842:
	load    5($i1), $i1
	load    1($i1), $f1
	ret
o_param_z.2844:
	load    5($i1), $i1
	load    2($i1), $f1
	ret
o_diffuse.2846:
	load    7($i1), $i1
	load    0($i1), $f1
	ret
o_hilight.2848:
	load    7($i1), $i1
	load    1($i1), $f1
	ret
o_color_red.2850:
	load    8($i1), $i1
	load    0($i1), $f1
	ret
o_color_green.2852:
	load    8($i1), $i1
	load    1($i1), $f1
	ret
o_color_blue.2854:
	load    8($i1), $i1
	load    2($i1), $f1
	ret
o_param_r1.2856:
	load    9($i1), $i1
	load    0($i1), $f1
	ret
o_param_r2.2858:
	load    9($i1), $i1
	load    1($i1), $f1
	ret
o_param_r3.2860:
	load    9($i1), $i1
	load    2($i1), $f1
	ret
o_param_ctbl.2862:
	load    10($i1), $i1
	ret
p_rgb.2864:
	load    0($i1), $i1
	ret
p_intersection_points.2866:
	load    1($i1), $i1
	ret
p_surface_ids.2868:
	load    2($i1), $i1
	ret
p_calc_diffuse.2870:
	load    3($i1), $i1
	ret
p_energy.2872:
	load    4($i1), $i1
	ret
p_received_ray_20percent.2874:
	load    5($i1), $i1
	ret
p_group_id.2876:
	load    6($i1), $i1
	load    0($i1), $i1
	ret
p_set_group_id.2878:
	load    6($i1), $i1
	store   $i2, 0($i1)
	ret
p_nvectors.2881:
	load    7($i1), $i1
	ret
d_vec.2883:
	load    0($i1), $i1
	ret
d_const.2885:
	load    1($i1), $i1
	ret
r_surface_id.2887:
	load    0($i1), $i1
	ret
r_dvec.2889:
	load    1($i1), $i1
	ret
r_bright.2891:
	load    2($i1), $f1
	ret
rad.2893:
	li      l.6716, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	ret
read_screen_settings.2895:
	load    7($i11), $i1
	store   $i1, 0($sp)
	load    6($i11), $i1
	store   $i1, 1($sp)
	load    5($i11), $i1
	store   $i1, 2($sp)
	load    4($i11), $i1
	store   $i1, 3($sp)
	load    3($i11), $i1
	store   $i1, 4($sp)
	load    2($i11), $i1
	store   $i1, 5($sp)
	load    1($i11), $i1
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_float.2733
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_float.2733
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_float.2733
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_float.2733
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     rad.2893
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $f1, 7($sp)
	load    6($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.10713, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.10713:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $f1, 8($sp)
	load    7($sp), $f1
	load    1($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.10714, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.10714:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $f1, 9($sp)
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     read_float.2733
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     rad.2893
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $f1, 10($sp)
	load    6($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.10715, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.10715:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $f1, 11($sp)
	load    10($sp), $f1
	load    1($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.10716, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.10716:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $f1, 12($sp)
	load    8($sp), $f2
	fmul    $f2, $f1, $f3
	li      l.6718, $i1
	load    0($i1), $f4
	fmul    $f3, $f4, $f3
	load    2($sp), $i1
	store   $f3, 0($i1)
	li      l.6720, $i2
	load    0($i2), $f3
	load    9($sp), $f4
	fmul    $f4, $f3, $f3
	store   $f3, 1($i1)
	load    11($sp), $f3
	fmul    $f2, $f3, $f2
	li      l.6718, $i2
	load    0($i2), $f4
	fmul    $f2, $f4, $f2
	store   $f2, 2($i1)
	load    4($sp), $i1
	store   $f3, 0($i1)
	li      l.6636, $i2
	load    0($i2), $f2
	store   $f2, 1($i1)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fneg
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    4($sp), $i1
	store   $f1, 2($i1)
	load    9($sp), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fneg
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $i1
	store   $f1, 0($i1)
	load    8($sp), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fneg
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    3($sp), $i1
	store   $f1, 1($i1)
	load    9($sp), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fneg
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    11($sp), $f2
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
read_light.2897:
	load    4($i11), $i1
	store   $i1, 0($sp)
	load    3($i11), $i1
	store   $i1, 1($sp)
	load    2($i11), $i1
	store   $i1, 2($sp)
	load    1($i11), $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_int.2731
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_float.2733
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     rad.2893
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $f1, 4($sp)
	load    0($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.10718, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.10718:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fneg
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    1($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     read_float.2733
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     rad.2893
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $f1, 5($sp)
	load    4($sp), $f1
	load    2($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.10719, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10719:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $f1, 6($sp)
	load    5($sp), $f1
	load    0($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.10720, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.10720:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 0($i1)
	load    5($sp), $f1
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.10721, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.10721:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     read_float.2733
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    3($sp), $i1
	store   $f1, 0($i1)
	ret
rotate_quadratic_matrix.2899:
	store   $i1, 0($sp)
	store   $i2, 1($sp)
	load    2($i11), $i1
	store   $i1, 2($sp)
	load    1($i11), $i11
	store   $i11, 3($sp)
	load    0($i2), $f1
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10723, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10723:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $f1, 4($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	load    2($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.10724, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.10724:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $f1, 5($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	load    3($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.10725, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10725:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $f1, 6($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.10726, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.10726:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $f1, 7($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	load    3($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.10727, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.10727:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $f1, 8($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	load    2($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.10728, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.10728:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	load    6($sp), $f3
	fmul    $f3, $f2, $f4
	store   $f4, 9($sp)
	load    7($sp), $f4
	load    5($sp), $f5
	fmul    $f5, $f4, $f6
	fmul    $f6, $f2, $f6
	load    4($sp), $f7
	fmul    $f7, $f1, $f8
	fsub    $f6, $f8, $f6
	store   $f6, 10($sp)
	fmul    $f7, $f4, $f6
	fmul    $f6, $f2, $f6
	fmul    $f5, $f1, $f8
	fadd    $f6, $f8, $f6
	store   $f6, 11($sp)
	fmul    $f3, $f1, $f3
	store   $f3, 12($sp)
	fmul    $f5, $f4, $f3
	fmul    $f3, $f1, $f3
	fmul    $f7, $f2, $f6
	fadd    $f3, $f6, $f3
	store   $f3, 13($sp)
	fmul    $f7, $f4, $f3
	fmul    $f3, $f1, $f1
	fmul    $f5, $f2, $f2
	fsub    $f1, $f2, $f1
	store   $f1, 14($sp)
	mov     $f4, $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fneg
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $f1, 15($sp)
	load    6($sp), $f1
	load    5($sp), $f2
	fmul    $f2, $f1, $f2
	store   $f2, 16($sp)
	load    4($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 17($sp)
	load    0($sp), $i1
	load    0($i1), $f1
	store   $f1, 18($sp)
	load    1($i1), $f1
	store   $f1, 19($sp)
	load    2($i1), $f1
	store   $f1, 20($sp)
	load    9($sp), $f1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     min_caml_fsqr
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 21($sp)
	load    12($sp), $f1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     min_caml_fsqr
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    19($sp), $f2
	fmul    $f2, $f1, $f1
	load    21($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 22($sp)
	load    15($sp), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fsqr
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    20($sp), $f2
	fmul    $f2, $f1, $f1
	load    22($sp), $f2
	fadd    $f2, $f1, $f1
	load    0($sp), $i1
	store   $f1, 0($i1)
	load    10($sp), $f1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     min_caml_fsqr
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 23($sp)
	load    13($sp), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fsqr
	sub     $sp, 25, $sp
	load    24($sp), $ra
	load    19($sp), $f2
	fmul    $f2, $f1, $f1
	load    23($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 24($sp)
	load    16($sp), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fsqr
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    20($sp), $f2
	fmul    $f2, $f1, $f1
	load    24($sp), $f2
	fadd    $f2, $f1, $f1
	load    0($sp), $i1
	store   $f1, 1($i1)
	load    11($sp), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fsqr
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 25($sp)
	load    14($sp), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fsqr
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    19($sp), $f2
	fmul    $f2, $f1, $f1
	load    25($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 26($sp)
	load    17($sp), $f1
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fsqr
	sub     $sp, 28, $sp
	load    27($sp), $ra
	load    20($sp), $f2
	fmul    $f2, $f1, $f1
	load    26($sp), $f3
	fadd    $f3, $f1, $f1
	load    0($sp), $i1
	store   $f1, 2($i1)
	li      l.6665, $i1
	load    0($i1), $f1
	load    10($sp), $f3
	load    18($sp), $f4
	fmul    $f4, $f3, $f5
	load    11($sp), $f6
	fmul    $f5, $f6, $f5
	load    13($sp), $f7
	load    19($sp), $f8
	fmul    $f8, $f7, $f9
	load    14($sp), $f10
	fmul    $f9, $f10, $f9
	fadd    $f5, $f9, $f5
	load    16($sp), $f9
	fmul    $f2, $f9, $f11
	load    17($sp), $f12
	fmul    $f11, $f12, $f11
	fadd    $f5, $f11, $f5
	fmul    $f1, $f5, $f1
	load    1($sp), $i1
	store   $f1, 0($i1)
	li      l.6665, $i2
	load    0($i2), $f1
	load    9($sp), $f5
	fmul    $f4, $f5, $f11
	fmul    $f11, $f6, $f6
	load    12($sp), $f11
	fmul    $f8, $f11, $f13
	fmul    $f13, $f10, $f10
	fadd    $f6, $f10, $f6
	load    15($sp), $f10
	fmul    $f2, $f10, $f13
	fmul    $f13, $f12, $f12
	fadd    $f6, $f12, $f6
	fmul    $f1, $f6, $f1
	store   $f1, 1($i1)
	li      l.6665, $i2
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
read_nth_object.2902:
	store   $i1, 0($sp)
	load    2($i11), $i1
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
	bne     $i12, be_else.10730
	li      0, $i1
	ret
be_else.10730:
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_int.2731
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     read_int.2731
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     read_int.2731
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_create_float_array
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     read_float.2733
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     read_float.2733
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     read_float.2733
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $i1
	store   $f1, 2($i1)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_create_float_array
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_float.2733
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_float.2733
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_float.2733
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	store   $f1, 2($i1)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     read_float.2733
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fisneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $i1, 9($sp)
	li      2, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_create_float_array
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     read_float.2733
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     read_float.2733
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $i1
	store   $f1, 1($i1)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_create_float_array
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $i1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     read_float.2733
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     read_float.2733
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     read_float.2733
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $i1
	store   $f1, 2($i1)
	li      3, $i1
	li      l.6636, $i2
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
	bne     $i12, be_else.10731
	b       be_cont.10732
be_else.10731:
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     read_float.2733
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     rad.2893
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	store   $f1, 0($i1)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     read_float.2733
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     rad.2893
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	store   $f1, 1($i1)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     read_float.2733
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     rad.2893
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $i1
	store   $f1, 2($i1)
be_cont.10732:
	load    4($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10733
	li      1, $i1
	b       be_cont.10734
be_else.10733:
	load    9($sp), $i1
be_cont.10734:
	store   $i1, 13($sp)
	li      4, $i1
	li      l.6636, $i2
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
	bne     $i12, be_else.10735
	load    0($i1), $f1
	store   $f1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fiszero
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10737
	load    14($sp), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     sgn.2768
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $f1, 15($sp)
	load    14($sp), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fsqr
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.10738
be_else.10737:
	li      l.6636, $i1
	load    0($i1), $f1
be_cont.10738:
	load    7($sp), $i1
	store   $f1, 0($i1)
	load    1($i1), $f1
	store   $f1, 16($sp)
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fiszero
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10739
	load    16($sp), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     sgn.2768
	sub     $sp, 18, $sp
	load    17($sp), $ra
	store   $f1, 17($sp)
	load    16($sp), $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fsqr
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.10740
be_else.10739:
	li      l.6636, $i1
	load    0($i1), $f1
be_cont.10740:
	load    7($sp), $i1
	store   $f1, 1($i1)
	load    2($i1), $f1
	store   $f1, 18($sp)
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fiszero
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10741
	load    18($sp), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     sgn.2768
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
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	b       be_cont.10742
be_else.10741:
	li      l.6636, $i1
	load    0($i1), $f1
be_cont.10742:
	load    7($sp), $i1
	store   $f1, 2($i1)
	b       be_cont.10736
be_else.10735:
	li      2, $i12
	cmp     $i3, $i12, $i12
	bne     $i12, be_else.10743
	load    9($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10745
	li      1, $i2
	b       be_cont.10746
be_else.10745:
	li      0, $i2
be_cont.10746:
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     vecunit_sgn.2794
	sub     $sp, 21, $sp
	load    20($sp), $ra
	b       be_cont.10744
be_else.10743:
be_cont.10744:
be_cont.10736:
	load    6($sp), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10747
	b       be_cont.10748
be_else.10747:
	load    7($sp), $i1
	load    12($sp), $i2
	load    1($sp), $i11
	store   $ra, 20($sp)
	load    0($i11), $i10
	li      cls.10749, $ra
	add     $sp, 21, $sp
	jr      $i10
cls.10749:
	sub     $sp, 21, $sp
	load    20($sp), $ra
be_cont.10748:
	li      1, $i1
	ret
read_object.2904:
	load    2($i11), $i2
	load    1($i11), $i3
	li      60, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10750
	ret
bge_else.10750:
	store   $i11, 0($sp)
	store   $i3, 1($sp)
	store   $i1, 2($sp)
	mov     $i2, $i11
	store   $ra, 3($sp)
	load    0($i11), $i10
	li      cls.10752, $ra
	add     $sp, 4, $sp
	jr      $i10
cls.10752:
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10753
	load    1($sp), $i1
	load    2($sp), $i2
	store   $i2, 0($i1)
	ret
be_else.10753:
	load    2($sp), $i1
	add     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
read_all_object.2906:
	load    1($i11), $i11
	li      0, $i1
	load    0($i11), $i10
	jr      $i10
read_net_item.2908:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     read_int.2731
	sub     $sp, 2, $sp
	load    1($sp), $ra
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10755
	load    0($sp), $i1
	add     $i1, 1, $i1
	li      -1, $i2
	b       min_caml_create_array
be_else.10755:
	store   $i1, 1($sp)
	load    0($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     read_net_item.2908
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    0($sp), $i2
	load    1($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
	ret
read_or_network.2910:
	store   $i1, 0($sp)
	li      0, $i1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     read_net_item.2908
	sub     $sp, 2, $sp
	load    1($sp), $ra
	mov     $i1, $i2
	load    0($i2), $i1
	li      -1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10756
	load    0($sp), $i1
	add     $i1, 1, $i1
	b       min_caml_create_array
be_else.10756:
	store   $i2, 1($sp)
	load    0($sp), $i1
	add     $i1, 1, $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     read_or_network.2910
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    0($sp), $i2
	load    1($sp), $i3
	add     $i1, $i2, $i12
	store   $i3, 0($i12)
	ret
read_and_network.2912:
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	load    1($i11), $i1
	store   $i1, 2($sp)
	li      0, $i1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     read_net_item.2908
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    0($i1), $i2
	li      -1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10757
	ret
be_else.10757:
	load    1($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i2, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
read_parameter.2914:
	load    5($i11), $i1
	load    4($i11), $i2
	store   $i2, 0($sp)
	load    3($i11), $i2
	store   $i2, 1($sp)
	load    2($i11), $i2
	store   $i2, 2($sp)
	load    1($i11), $i2
	store   $i2, 3($sp)
	mov     $i1, $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10759, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10759:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    0($sp), $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10760, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10760:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    2($sp), $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10761, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10761:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i1
	load    1($sp), $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10762, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10762:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     read_or_network.2910
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	store   $i1, 0($i2)
	ret
solver_rect_surface.2916:
	store   $f3, 0($sp)
	store   $i5, 1($sp)
	store   $f2, 2($sp)
	store   $i4, 3($sp)
	store   $f1, 4($sp)
	store   $i3, 5($sp)
	store   $i2, 6($sp)
	store   $i1, 7($sp)
	load    1($i11), $i1
	store   $i1, 8($sp)
	add     $i2, $i3, $i12
	load    0($i12), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fiszero
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10764
	load    7($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_abc.2838
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $i1, 9($sp)
	load    7($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_isinvert.2828
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	load    5($sp), $i1
	load    6($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fisneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $i1, $i2
	load    10($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     xor.2765
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    5($sp), $i2
	load    9($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     fneg_cond.2770
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    4($sp), $f2
	fsub    $f1, $f2, $f1
	load    5($sp), $i1
	load    6($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 11($sp)
	load    3($sp), $i1
	add     $i2, $i1, $i12
	load    0($i12), $f2
	fmul    $f1, $f2, $f1
	load    2($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fabs
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    3($sp), $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $f2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10765
	li      0, $i1
	ret
be_else.10765:
	load    1($sp), $i1
	load    6($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	load    11($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fabs
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    1($sp), $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $f2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10766
	li      0, $i1
	ret
be_else.10766:
	load    8($sp), $i1
	load    11($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.10764:
	li      0, $i1
	ret
solver_rect.2925:
	store   $f1, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $i2, 3($sp)
	store   $i1, 4($sp)
	load    1($i11), $i11
	store   $i11, 5($sp)
	li      0, $i3
	li      1, $i4
	li      2, $i5
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.10767, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10767:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10768
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
	li      cls.10769, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10769:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10770
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
	li      cls.10771, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10771:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10772
	li      0, $i1
	ret
be_else.10772:
	li      3, $i1
	ret
be_else.10770:
	li      2, $i1
	ret
be_else.10768:
	li      1, $i1
	ret
solver_surface.2931:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $f1, 2($sp)
	store   $i2, 3($sp)
	load    1($i11), $i2
	store   $i2, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_param_abc.2838
	sub     $sp, 6, $sp
	load    5($sp), $ra
	mov     $i1, $i2
	store   $i2, 5($sp)
	load    3($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     veciprod.2797
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fispos
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10773
	li      0, $i1
	ret
be_else.10773:
	load    2($sp), $f1
	load    1($sp), $f2
	load    0($sp), $f3
	load    5($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     veciprod2.2800
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fneg
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    4($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
quadratic.2937:
	store   $f1, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fsqr
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $f1, 4($sp)
	load    3($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_param_a.2832
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 5($sp)
	load    2($sp), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fsqr
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $f1, 6($sp)
	load    3($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_param_b.2834
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	load    5($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 7($sp)
	load    1($sp), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fsqr
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $f1, 8($sp)
	load    3($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_c.2836
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 9($sp)
	load    3($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_isrot.2830
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10774
	load    9($sp), $f1
	ret
be_else.10774:
	load    1($sp), $f1
	load    2($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 10($sp)
	load    3($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_param_r1.2856
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	fmul    $f2, $f1, $f1
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 11($sp)
	load    0($sp), $f1
	load    1($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 12($sp)
	load    3($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_param_r2.2858
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fmul    $f2, $f1, $f1
	load    11($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 13($sp)
	load    2($sp), $f1
	load    0($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 14($sp)
	load    3($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     o_param_r3.2860
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $f2
	fmul    $f2, $f1, $f1
	load    13($sp), $f2
	fadd    $f2, $f1, $f1
	ret
bilinear.2942:
	store   $f4, 0($sp)
	store   $f1, 1($sp)
	store   $f6, 2($sp)
	store   $f3, 3($sp)
	store   $i1, 4($sp)
	store   $f5, 5($sp)
	store   $f2, 6($sp)
	fmul    $f1, $f4, $f1
	store   $f1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     o_param_a.2832
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 8($sp)
	load    5($sp), $f1
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 9($sp)
	load    4($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_param_b.2834
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	fmul    $f2, $f1, $f1
	load    8($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 10($sp)
	load    2($sp), $f1
	load    3($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 11($sp)
	load    4($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_param_c.2836
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	fmul    $f2, $f1, $f1
	load    10($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 12($sp)
	load    4($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_isrot.2830
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10775
	load    12($sp), $f1
	ret
be_else.10775:
	load    5($sp), $f1
	load    3($sp), $f2
	fmul    $f2, $f1, $f1
	load    2($sp), $f2
	load    6($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 13($sp)
	load    4($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     o_param_r1.2856
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 14($sp)
	load    2($sp), $f1
	load    1($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	load    3($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 15($sp)
	load    4($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     o_param_r2.2858
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f2, $f1, $f1
	load    14($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 16($sp)
	load    5($sp), $f1
	load    1($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	load    6($sp), $f3
	fmul    $f3, $f2, $f2
	fadd    $f1, $f2, $f1
	store   $f1, 17($sp)
	load    4($sp), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     o_param_r3.2860
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	fmul    $f2, $f1, $f1
	load    16($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fhalf
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
	ret
solver_second.2950:
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
	jal     quadratic.2937
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fiszero
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10776
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
	jal     bilinear.2942
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $f1, 7($sp)
	load    2($sp), $f1
	load    1($sp), $f2
	load    0($sp), $f3
	load    3($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     quadratic.2937
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $f1, 8($sp)
	load    3($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_form.2824
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10777
	li      l.6639, $i1
	load    0($i1), $f1
	load    8($sp), $f2
	fsub    $f2, $f1, $f1
	b       be_cont.10778
be_else.10777:
	load    8($sp), $f1
be_cont.10778:
	store   $f1, 9($sp)
	load    7($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	load    6($sp), $f3
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
	bne     $i12, be_else.10779
	li      0, $i1
	ret
be_else.10779:
	load    10($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $f1, 11($sp)
	load    3($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_isinvert.2828
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10780
	load    11($sp), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fneg
	sub     $sp, 13, $sp
	load    12($sp), $ra
	b       be_cont.10781
be_else.10780:
	load    11($sp), $f1
be_cont.10781:
	load    7($sp), $f2
	fsub    $f1, $f2, $f1
	load    6($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
be_else.10776:
	li      0, $i1
	ret
solver.2956:
	store   $i2, 0($sp)
	store   $i3, 1($sp)
	load    4($i11), $i2
	store   $i2, 2($sp)
	load    3($i11), $i2
	store   $i2, 3($sp)
	load    2($i11), $i2
	store   $i2, 4($sp)
	load    1($i11), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 5($sp)
	load    0($i3), $f1
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_param_x.2840
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 7($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $f1, 8($sp)
	load    5($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_y.2842
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 9($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $f1, 10($sp)
	load    5($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_param_z.2844
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 11($sp)
	load    5($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_form.2824
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10782
	load    7($sp), $f1
	load    9($sp), $f2
	load    11($sp), $f3
	load    5($sp), $i1
	load    0($sp), $i2
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10782:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10783
	load    7($sp), $f1
	load    9($sp), $f2
	load    11($sp), $f3
	load    5($sp), $i1
	load    0($sp), $i2
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10783:
	load    7($sp), $f1
	load    9($sp), $f2
	load    11($sp), $f3
	load    5($sp), $i1
	load    0($sp), $i2
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
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
	store   $f1, 8($sp)
	load    5($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_b.2834
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $f1, $f2
	load    8($sp), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10784
	li      0, $i1
	b       be_cont.10785
be_else.10784:
	load    2($sp), $i1
	load    2($i1), $f1
	load    7($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fabs
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $f1, 9($sp)
	load    5($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_param_c.2836
	sub     $sp, 11, $sp
	load    10($sp), $ra
	mov     $f1, $f2
	load    9($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fless
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10786
	li      0, $i1
	b       be_cont.10787
be_else.10786:
	load    4($sp), $i1
	load    1($i1), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fiszero
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10788
	li      1, $i1
	b       be_cont.10789
be_else.10788:
	li      0, $i1
be_cont.10789:
be_cont.10787:
be_cont.10785:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10790
	load    4($sp), $i1
	load    2($i1), $f1
	load    3($sp), $f2
	fsub    $f1, $f2, $f1
	load    3($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 10($sp)
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fabs
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $f1, 11($sp)
	load    5($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_param_a.2832
	sub     $sp, 13, $sp
	load    12($sp), $ra
	mov     $f1, $f2
	load    11($sp), $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10791
	li      0, $i1
	b       be_cont.10792
be_else.10791:
	load    2($sp), $i1
	load    2($i1), $f1
	load    10($sp), $f2
	fmul    $f2, $f1, $f1
	load    0($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fabs
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $f1, 12($sp)
	load    5($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_param_c.2836
	sub     $sp, 14, $sp
	load    13($sp), $ra
	mov     $f1, $f2
	load    12($sp), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fless
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10793
	li      0, $i1
	b       be_cont.10794
be_else.10793:
	load    4($sp), $i1
	load    3($i1), $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fiszero
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10795
	li      1, $i1
	b       be_cont.10796
be_else.10795:
	li      0, $i1
be_cont.10796:
be_cont.10794:
be_cont.10792:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10797
	load    4($sp), $i1
	load    4($i1), $f1
	load    0($sp), $f2
	fsub    $f1, $f2, $f1
	load    5($i1), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 13($sp)
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fabs
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $f1, 14($sp)
	load    5($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     o_param_a.2832
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $f1, $f2
	load    14($sp), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fless
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10798
	li      0, $i1
	b       be_cont.10799
be_else.10798:
	load    2($sp), $i1
	load    1($i1), $f1
	load    13($sp), $f2
	fmul    $f2, $f1, $f1
	load    3($sp), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fabs
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $f1, 15($sp)
	load    5($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     o_param_b.2834
	sub     $sp, 17, $sp
	load    16($sp), $ra
	mov     $f1, $f2
	load    15($sp), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fless
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10800
	li      0, $i1
	b       be_cont.10801
be_else.10800:
	load    4($sp), $i1
	load    5($i1), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fiszero
	sub     $sp, 17, $sp
	load    16($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10802
	li      1, $i1
	b       be_cont.10803
be_else.10802:
	li      0, $i1
be_cont.10803:
be_cont.10801:
be_cont.10799:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10804
	li      0, $i1
	ret
be_else.10804:
	load    6($sp), $i1
	load    13($sp), $f1
	store   $f1, 0($i1)
	li      3, $i1
	ret
be_else.10797:
	load    6($sp), $i1
	load    10($sp), $f1
	store   $f1, 0($i1)
	li      2, $i1
	ret
be_else.10790:
	load    6($sp), $i1
	load    7($sp), $f1
	store   $f1, 0($i1)
	li      1, $i1
	ret
solver_surface_fast.2967:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $f1, 2($sp)
	store   $i2, 3($sp)
	load    1($i11), $i1
	store   $i1, 4($sp)
	load    0($i2), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fisneg
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10805
	li      0, $i1
	ret
be_else.10805:
	load    3($sp), $i1
	load    1($i1), $f1
	load    2($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    1($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    0($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    4($sp), $i1
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
	bne     $i12, be_else.10806
	load    4($sp), $i1
	load    1($i1), $f1
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f3
	load    2($sp), $f4
	fmul    $f3, $f4, $f3
	fadd    $f1, $f3, $f1
	load    3($i1), $f3
	load    1($sp), $f5
	fmul    $f3, $f5, $f3
	fadd    $f1, $f3, $f1
	store   $f1, 7($sp)
	load    0($sp), $i1
	mov     $f5, $f3
	mov     $f2, $f1
	mov     $f4, $f2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     quadratic.2937
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $f1, 8($sp)
	load    0($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_form.2824
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10807
	li      l.6639, $i1
	load    0($i1), $f1
	load    8($sp), $f2
	fsub    $f2, $f1, $f1
	b       be_cont.10808
be_else.10807:
	load    8($sp), $f1
be_cont.10808:
	store   $f1, 9($sp)
	load    7($sp), $f1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fsqr
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	load    6($sp), $f3
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
	bne     $i12, be_else.10809
	li      0, $i1
	ret
be_else.10809:
	load    0($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_isinvert.2828
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10810
	load    10($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	load    4($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.10811
be_else.10810:
	load    10($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    7($sp), $f2
	fadd    $f2, $f1, $f1
	load    4($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    5($sp), $i1
	store   $f1, 0($i1)
be_cont.10811:
	li      1, $i1
	ret
be_else.10806:
	li      0, $i1
	ret
solver_fast.2979:
	store   $i1, 0($sp)
	store   $i2, 1($sp)
	store   $i3, 2($sp)
	load    4($i11), $i2
	store   $i2, 3($sp)
	load    3($i11), $i2
	store   $i2, 4($sp)
	load    2($i11), $i2
	store   $i2, 5($sp)
	load    1($i11), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 6($sp)
	load    0($i3), $f1
	store   $f1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     o_param_x.2840
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 8($sp)
	load    2($sp), $i1
	load    1($i1), $f1
	store   $f1, 9($sp)
	load    6($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_param_y.2842
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 10($sp)
	load    2($sp), $i1
	load    2($i1), $f1
	store   $f1, 11($sp)
	load    6($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_param_z.2844
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 12($sp)
	load    1($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     d_const.2885
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    0($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	store   $i1, 13($sp)
	load    6($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     o_form.2824
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10812
	load    1($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     d_vec.2883
	sub     $sp, 15, $sp
	load    14($sp), $ra
	mov     $i1, $i2
	load    8($sp), $f1
	load    10($sp), $f2
	load    12($sp), $f3
	load    6($sp), $i1
	load    13($sp), $i3
	load    5($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10812:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10813
	load    8($sp), $f1
	load    10($sp), $f2
	load    12($sp), $f3
	load    6($sp), $i1
	load    13($sp), $i2
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10813:
	load    8($sp), $f1
	load    10($sp), $f2
	load    12($sp), $f3
	load    6($sp), $i1
	load    13($sp), $i2
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
solver_surface_fast2.2983:
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	load    1($i11), $i1
	store   $i1, 2($sp)
	load    0($i2), $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fisneg
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10814
	li      0, $i1
	ret
be_else.10814:
	load    1($sp), $i1
	load    0($i1), $f1
	load    0($sp), $i1
	load    3($i1), $f2
	fmul    $f1, $f2, $f1
	load    2($sp), $i1
	store   $f1, 0($i1)
	li      1, $i1
	ret
solver_second_fast2.2990:
	store   $i1, 0($sp)
	store   $i3, 1($sp)
	store   $f3, 2($sp)
	store   $f2, 3($sp)
	store   $f1, 4($sp)
	store   $i2, 5($sp)
	load    1($i11), $i1
	store   $i1, 6($sp)
	load    0($i2), $f1
	store   $f1, 7($sp)
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fiszero
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10815
	load    5($sp), $i1
	load    1($i1), $f1
	load    4($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($i1), $f2
	load    3($sp), $f3
	fmul    $f2, $f3, $f2
	fadd    $f1, $f2, $f1
	load    3($i1), $f2
	load    2($sp), $f3
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
	bne     $i12, be_else.10816
	li      0, $i1
	ret
be_else.10816:
	load    0($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_isinvert.2828
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10817
	load    10($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $f2
	fsub    $f2, $f1, $f1
	load    5($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    6($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.10818
be_else.10817:
	load    10($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     sqrt.2729
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $f2
	fadd    $f2, $f1, $f1
	load    5($sp), $i1
	load    4($i1), $f2
	fmul    $f1, $f2, $f1
	load    6($sp), $i1
	store   $f1, 0($i1)
be_cont.10818:
	li      1, $i1
	ret
be_else.10815:
	li      0, $i1
	ret
solver_fast2.2997:
	store   $i1, 0($sp)
	store   $i2, 1($sp)
	load    4($i11), $i2
	store   $i2, 2($sp)
	load    3($i11), $i2
	store   $i2, 3($sp)
	load    2($i11), $i2
	store   $i2, 4($sp)
	load    1($i11), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_param_ctbl.2862
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	load    0($i1), $f1
	store   $f1, 7($sp)
	load    1($i1), $f1
	store   $f1, 8($sp)
	load    2($i1), $f1
	store   $f1, 9($sp)
	load    1($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     d_const.2885
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    0($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	store   $i1, 10($sp)
	load    5($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_form.2824
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10819
	load    1($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     d_vec.2883
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $i1, $i2
	load    7($sp), $f1
	load    8($sp), $f2
	load    9($sp), $f3
	load    5($sp), $i1
	load    10($sp), $i3
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10819:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10820
	load    7($sp), $f1
	load    8($sp), $f2
	load    9($sp), $f3
	load    5($sp), $i1
	load    10($sp), $i2
	load    6($sp), $i3
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10820:
	load    7($sp), $f1
	load    8($sp), $f2
	load    9($sp), $f3
	load    5($sp), $i1
	load    10($sp), $i2
	load    6($sp), $i3
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
setup_rect_table.3000:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      6, $i1
	li      l.6636, $i2
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
	bne     $i12, be_else.10821
	load    0($sp), $i1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     o_isinvert.2828
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $i1, 3($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fisneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	mov     $i1, $i2
	load    3($sp), $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     xor.2765
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	load    0($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_param_a.2832
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     fneg_cond.2770
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    2($sp), $i1
	store   $f1, 0($i1)
	li      l.6639, $i2
	load    0($i2), $f1
	load    1($sp), $i2
	load    0($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 1($i1)
	b       be_cont.10822
be_else.10821:
	li      l.6636, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 1($i1)
be_cont.10822:
	load    1($sp), $i1
	load    1($i1), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fiszero
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10823
	load    0($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_isinvert.2828
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fisneg
	sub     $sp, 7, $sp
	load    6($sp), $ra
	mov     $i1, $i2
	load    5($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     xor.2765
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	load    0($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_param_b.2834
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     fneg_cond.2770
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    2($sp), $i1
	store   $f1, 2($i1)
	li      l.6639, $i2
	load    0($i2), $f1
	load    1($sp), $i2
	load    1($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 3($i1)
	b       be_cont.10824
be_else.10823:
	li      l.6636, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 3($i1)
be_cont.10824:
	load    1($sp), $i1
	load    2($i1), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fiszero
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10825
	load    0($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_isinvert.2828
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fisneg
	sub     $sp, 9, $sp
	load    8($sp), $ra
	mov     $i1, $i2
	load    7($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     xor.2765
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	load    0($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_c.2836
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     fneg_cond.2770
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    2($sp), $i1
	store   $f1, 4($i1)
	li      l.6639, $i2
	load    0($i2), $f1
	load    1($sp), $i2
	load    2($i2), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 5($i1)
	b       be_cont.10826
be_else.10825:
	li      l.6636, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 5($i1)
be_cont.10826:
	ret
setup_surface_table.3003:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      4, $i1
	li      l.6636, $i2
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
	load    0($sp), $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_param_a.2832
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 4($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $f1, 5($sp)
	load    0($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_param_b.2834
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $f2
	fmul    $f2, $f1, $f1
	load    4($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 6($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $f1, 7($sp)
	load    0($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     o_param_c.2836
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fmul    $f2, $f1, $f1
	load    6($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fispos
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10827
	li      l.6636, $i1
	load    0($i1), $f1
	load    2($sp), $i1
	store   $f1, 0($i1)
	b       be_cont.10828
be_else.10827:
	li      l.6710, $i1
	load    0($i1), $f1
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    2($sp), $i1
	store   $f1, 0($i1)
	load    0($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_a.2832
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    2($sp), $i1
	store   $f1, 1($i1)
	load    0($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_b.2834
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    2($sp), $i1
	store   $f1, 2($i1)
	load    0($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_c.2836
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    2($sp), $i1
	store   $f1, 3($i1)
be_cont.10828:
	ret
setup_second_table.3006:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	li      5, $i1
	li      l.6636, $i2
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
	jal     quadratic.2937
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $f1, 3($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $f1, 4($sp)
	load    0($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_param_a.2832
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    4($sp), $f2
	fmul    $f2, $f1, $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fneg
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $f1, 5($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $f1, 6($sp)
	load    0($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_param_b.2834
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fneg
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $f1, 7($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $f1, 8($sp)
	load    0($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_c.2836
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $f1, 9($sp)
	load    2($sp), $i1
	load    3($sp), $f1
	store   $f1, 0($i1)
	load    0($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_isrot.2830
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10829
	load    2($sp), $i1
	load    5($sp), $f1
	store   $f1, 1($i1)
	load    7($sp), $f1
	store   $f1, 2($i1)
	load    9($sp), $f1
	store   $f1, 3($i1)
	b       be_cont.10830
be_else.10829:
	load    1($sp), $i1
	load    2($i1), $f1
	store   $f1, 10($sp)
	load    0($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_param_r2.2858
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 11($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $f1, 12($sp)
	load    0($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_param_r3.2860
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fmul    $f2, $f1, $f1
	load    11($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fhalf
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    5($sp), $f2
	fsub    $f2, $f1, $f1
	load    2($sp), $i1
	store   $f1, 1($i1)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $f1, 13($sp)
	load    0($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     o_param_r1.2856
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 14($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $f1, 15($sp)
	load    0($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     o_param_r3.2860
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f2, $f1, $f1
	load    14($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fhalf
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	load    2($sp), $i1
	store   $f1, 2($i1)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $f1, 16($sp)
	load    0($sp), $i1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     o_param_r1.2856
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 17($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $f1, 18($sp)
	load    0($sp), $i1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     o_param_r2.2858
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $f2
	fmul    $f2, $f1, $f1
	load    17($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fhalf
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    9($sp), $f2
	fsub    $f2, $f1, $f1
	load    2($sp), $i1
	store   $f1, 3($i1)
be_cont.10830:
	load    3($sp), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fiszero
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10831
	li      l.6639, $i1
	load    0($i1), $f1
	load    3($sp), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    2($sp), $i1
	store   $f1, 4($i1)
	b       be_cont.10832
be_else.10831:
be_cont.10832:
	load    2($sp), $i1
	ret
iter_setup_dirvec_constants.3009:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.10833
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	store   $i1, 2($sp)
	add     $i3, $i2, $i12
	load    0($i12), $i2
	store   $i2, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     d_const.2885
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	load    2($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     d_vec.2883
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	load    3($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_form.2824
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10834
	load    5($sp), $i1
	load    3($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     setup_rect_table.3000
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.10835
be_else.10834:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10836
	load    5($sp), $i1
	load    3($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     setup_surface_table.3003
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	b       be_cont.10837
be_else.10836:
	load    5($sp), $i1
	load    3($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     setup_second_table.3006
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i2
	load    4($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.10837:
be_cont.10835:
	sub     $i2, 1, $i2
	load    2($sp), $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.10833:
	ret
setup_dirvec_constants.3012:
	load    2($i11), $i2
	load    1($i11), $i11
	load    0($i2), $i2
	sub     $i2, 1, $i2
	load    0($i11), $i10
	jr      $i10
setup_startp_constants.3014:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.10839
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	store   $i1, 2($sp)
	add     $i3, $i2, $i12
	load    0($i12), $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_param_ctbl.2862
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	load    3($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_form.2824
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	load    2($sp), $i1
	load    0($i1), $f1
	store   $f1, 6($sp)
	load    3($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_param_x.2840
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fsub    $f2, $f1, $f1
	load    4($sp), $i1
	store   $f1, 0($i1)
	load    2($sp), $i1
	load    1($i1), $f1
	store   $f1, 7($sp)
	load    3($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     o_param_y.2842
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	load    4($sp), $i1
	store   $f1, 1($i1)
	load    2($sp), $i1
	load    2($i1), $f1
	store   $f1, 8($sp)
	load    3($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_z.2844
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $f2
	fsub    $f2, $f1, $f1
	load    4($sp), $i1
	store   $f1, 2($i1)
	load    5($sp), $i2
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10840
	load    3($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_abc.2838
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    4($sp), $i2
	load    0($i2), $f1
	load    1($i2), $f2
	load    2($i2), $f3
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     veciprod2.2800
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    4($sp), $i1
	store   $f1, 3($i1)
	b       be_cont.10841
be_else.10840:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.10842
	b       ble_cont.10843
ble_else.10842:
	load    0($i1), $f1
	load    1($i1), $f2
	load    2($i1), $f3
	load    3($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     quadratic.2937
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    5($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10844
	li      l.6639, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	b       be_cont.10845
be_else.10844:
be_cont.10845:
	load    4($sp), $i1
	store   $f1, 3($i1)
ble_cont.10843:
be_cont.10841:
	load    1($sp), $i1
	sub     $i1, 1, $i2
	load    2($sp), $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.10839:
	ret
setup_startp.3017:
	store   $i1, 0($sp)
	load    3($i11), $i2
	load    2($i11), $i3
	store   $i3, 1($sp)
	load    1($i11), $i3
	store   $i3, 2($sp)
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     veccpy.2786
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i2
	load    0($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
is_rect_outside.3019:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $i1, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     min_caml_fabs
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $f1, 3($sp)
	load    2($sp), $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_param_a.2832
	sub     $sp, 5, $sp
	load    4($sp), $ra
	mov     $f1, $f2
	load    3($sp), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fless
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10847
	li      0, $i1
	b       be_cont.10848
be_else.10847:
	load    1($sp), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fabs
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $f1, 4($sp)
	load    2($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_param_b.2834
	sub     $sp, 6, $sp
	load    5($sp), $ra
	mov     $f1, $f2
	load    4($sp), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fless
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10849
	li      0, $i1
	b       be_cont.10850
be_else.10849:
	load    0($sp), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fabs
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $f1, 5($sp)
	load    2($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_param_c.2836
	sub     $sp, 7, $sp
	load    6($sp), $ra
	mov     $f1, $f2
	load    5($sp), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fless
	sub     $sp, 7, $sp
	load    6($sp), $ra
be_cont.10850:
be_cont.10848:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10851
	load    2($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_isinvert.2828
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10852
	li      1, $i1
	ret
be_else.10852:
	li      0, $i1
	ret
be_else.10851:
	load    2($sp), $i1
	b       o_isinvert.2828
is_plane_outside.3024:
	store   $i1, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	store   $f1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_param_abc.2838
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f1
	load    2($sp), $f2
	load    1($sp), $f3
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     veciprod2.2800
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $f1, 4($sp)
	load    0($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_isinvert.2828
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	load    4($sp), $f1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fisneg
	sub     $sp, 7, $sp
	load    6($sp), $ra
	mov     $i1, $i2
	load    5($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     xor.2765
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10853
	li      1, $i1
	ret
be_else.10853:
	li      0, $i1
	ret
is_second_outside.3029:
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     quadratic.2937
	sub     $sp, 2, $sp
	load    1($sp), $ra
	store   $f1, 1($sp)
	load    0($sp), $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     o_form.2824
	sub     $sp, 3, $sp
	load    2($sp), $ra
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10854
	li      l.6639, $i1
	load    0($i1), $f1
	load    1($sp), $f2
	fsub    $f2, $f1, $f1
	b       be_cont.10855
be_else.10854:
	load    1($sp), $f1
be_cont.10855:
	store   $f1, 2($sp)
	load    0($sp), $i1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     o_isinvert.2828
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $i1, 3($sp)
	load    2($sp), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fisneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	mov     $i1, $i2
	load    3($sp), $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     xor.2765
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10856
	li      1, $i1
	ret
be_else.10856:
	li      0, $i1
	ret
is_outside.3034:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $i1, 2($sp)
	store   $f1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_param_x.2840
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 4($sp)
	load    2($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_param_y.2842
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    1($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 5($sp)
	load    2($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_param_z.2844
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    0($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 6($sp)
	load    2($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_form.2824
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10857
	load    4($sp), $f1
	load    5($sp), $f2
	load    6($sp), $f3
	load    2($sp), $i1
	b       is_rect_outside.3019
be_else.10857:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10858
	load    4($sp), $f1
	load    5($sp), $f2
	load    6($sp), $f3
	load    2($sp), $i1
	b       is_plane_outside.3024
be_else.10858:
	load    4($sp), $f1
	load    5($sp), $f2
	load    6($sp), $f3
	load    2($sp), $i1
	b       is_second_outside.3029
check_all_inside.3039:
	load    1($i11), $i3
	add     $i2, $i1, $i12
	load    0($i12), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.10859
	li      1, $i1
	ret
be_else.10859:
	store   $f3, 0($sp)
	store   $f2, 1($sp)
	store   $f1, 2($sp)
	store   $i2, 3($sp)
	store   $i11, 4($sp)
	store   $i1, 5($sp)
	add     $i3, $i4, $i12
	load    0($i12), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     is_outside.3034
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10860
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    2($sp), $f1
	load    1($sp), $f2
	load    0($sp), $f3
	load    3($sp), $i2
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10860:
	li      0, $i1
	ret
shadow_check_and_group.3045:
	load    7($i11), $i3
	load    6($i11), $i4
	load    5($i11), $i5
	load    4($i11), $i6
	load    3($i11), $i7
	load    2($i11), $i8
	load    1($i11), $i9
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.10861
	li      0, $i1
	ret
be_else.10861:
	store   $i9, 0($sp)
	store   $i8, 1($sp)
	store   $i7, 2($sp)
	store   $i2, 3($sp)
	store   $i11, 4($sp)
	store   $i1, 5($sp)
	store   $i5, 6($sp)
	store   $i4, 7($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 8($sp)
	mov     $i6, $i2
	mov     $i3, $i11
	mov     $i8, $i3
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.10862, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.10862:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    7($sp), $i2
	load    0($i2), $f1
	store   $f1, 9($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10863
	li      0, $i1
	b       be_cont.10864
be_else.10863:
	li      l.6764, $i1
	load    0($i1), $f2
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     min_caml_fless
	sub     $sp, 11, $sp
	load    10($sp), $ra
be_cont.10864:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10865
	load    8($sp), $i1
	load    6($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_isinvert.2828
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10866
	li      0, $i1
	ret
be_else.10866:
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10865:
	li      l.6766, $i1
	load    0($i1), $f1
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	load    2($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    1($sp), $i2
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
	li      0, $i1
	load    3($sp), $i2
	load    0($sp), $i11
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.10867, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.10867:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10868
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10868:
	li      1, $i1
	ret
shadow_check_one_or_group.3048:
	load    2($i11), $i3
	load    1($i11), $i4
	add     $i2, $i1, $i12
	load    0($i12), $i5
	li      -1, $i12
	cmp     $i5, $i12, $i12
	bne     $i12, be_else.10869
	li      0, $i1
	ret
be_else.10869:
	store   $i2, 0($sp)
	store   $i11, 1($sp)
	store   $i1, 2($sp)
	add     $i4, $i5, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i3, $i11
	store   $ra, 3($sp)
	load    0($i11), $i10
	li      cls.10870, $ra
	add     $sp, 4, $sp
	jr      $i10
cls.10870:
	sub     $sp, 4, $sp
	load    3($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10871
	load    2($sp), $i1
	add     $i1, 1, $i1
	load    0($sp), $i2
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10871:
	li      1, $i1
	ret
shadow_check_one_or_matrix.3051:
	load    5($i11), $i3
	load    4($i11), $i4
	load    3($i11), $i5
	load    2($i11), $i6
	load    1($i11), $i7
	add     $i2, $i1, $i12
	load    0($i12), $i8
	load    0($i8), $i9
	li      -1, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.10872
	li      0, $i1
	ret
be_else.10872:
	store   $i8, 0($sp)
	store   $i5, 1($sp)
	store   $i2, 2($sp)
	store   $i11, 3($sp)
	store   $i1, 4($sp)
	li      99, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.10873
	li      1, $i1
	b       be_cont.10874
be_else.10873:
	store   $i4, 5($sp)
	mov     $i6, $i2
	mov     $i9, $i1
	mov     $i3, $i11
	mov     $i7, $i3
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.10875, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10875:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10876
	li      0, $i1
	b       be_cont.10877
be_else.10876:
	load    5($sp), $i1
	load    0($i1), $f1
	li      l.6768, $i1
	load    0($i1), $f2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_fless
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10878
	li      0, $i1
	b       be_cont.10879
be_else.10878:
	li      1, $i1
	load    0($sp), $i2
	load    1($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.10880, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10880:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10881
	li      0, $i1
	b       be_cont.10882
be_else.10881:
	li      1, $i1
be_cont.10882:
be_cont.10879:
be_cont.10877:
be_cont.10874:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10883
	load    4($sp), $i1
	add     $i1, 1, $i1
	load    2($sp), $i2
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10883:
	li      1, $i1
	load    0($sp), $i2
	load    1($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.10884, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.10884:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10885
	load    4($sp), $i1
	add     $i1, 1, $i1
	load    2($sp), $i2
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10885:
	li      1, $i1
	ret
solve_each_element.3054:
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
	add     $i2, $i1, $i12
	load    0($i12), $i10
	li      -1, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.10886
	ret
be_else.10886:
	store   $i9, 3($sp)
	store   $i5, 4($sp)
	store   $i4, 5($sp)
	store   $i6, 6($sp)
	store   $i3, 7($sp)
	store   $i2, 8($sp)
	store   $i11, 9($sp)
	store   $i1, 10($sp)
	store   $i10, 11($sp)
	store   $i8, 12($sp)
	mov     $i3, $i2
	mov     $i10, $i1
	mov     $i7, $i11
	mov     $i5, $i3
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.10888, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.10888:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10889
	load    11($sp), $i1
	load    12($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_isinvert.2828
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10890
	ret
be_else.10890:
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    8($sp), $i2
	load    7($sp), $i3
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10889:
	store   $i1, 13($sp)
	load    6($sp), $i1
	load    0($i1), $f2
	store   $f2, 14($sp)
	li      l.6636, $i1
	load    0($i1), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fless
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10892
	b       be_cont.10893
be_else.10892:
	load    5($sp), $i1
	load    0($i1), $f2
	load    14($sp), $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fless
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10894
	b       be_cont.10895
be_else.10894:
	li      l.6766, $i1
	load    0($i1), $f1
	load    14($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 15($sp)
	load    7($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    4($sp), $i2
	load    0($i2), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 16($sp)
	load    1($i1), $f3
	fmul    $f3, $f1, $f3
	load    1($i2), $f4
	fadd    $f3, $f4, $f3
	store   $f3, 17($sp)
	load    2($i1), $f4
	fmul    $f4, $f1, $f1
	load    2($i2), $f4
	fadd    $f1, $f4, $f1
	store   $f1, 18($sp)
	li      0, $i1
	load    8($sp), $i2
	load    3($sp), $i11
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 19($sp)
	load    0($i11), $i10
	li      cls.10896, $ra
	add     $sp, 20, $sp
	jr      $i10
cls.10896:
	sub     $sp, 20, $sp
	load    19($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10897
	b       be_cont.10898
be_else.10897:
	load    5($sp), $i1
	load    15($sp), $f1
	store   $f1, 0($i1)
	load    16($sp), $f1
	load    17($sp), $f2
	load    18($sp), $f3
	load    1($sp), $i1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     vecset.2776
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    2($sp), $i1
	load    11($sp), $i2
	store   $i2, 0($i1)
	load    0($sp), $i1
	load    13($sp), $i2
	store   $i2, 0($i1)
be_cont.10898:
be_cont.10895:
be_cont.10893:
	load    10($sp), $i1
	add     $i1, 1, $i1
	load    8($sp), $i2
	load    7($sp), $i3
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_one_or_network.3058:
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i2, $i1, $i12
	load    0($i12), $i6
	li      -1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.10899
	ret
be_else.10899:
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 2($sp)
	store   $i1, 3($sp)
	add     $i5, $i6, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i4, $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10901, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10901:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i1
	add     $i1, 1, $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
trace_or_matrix.3062:
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
	bne     $i12, be_else.10902
	ret
be_else.10902:
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 2($sp)
	store   $i1, 3($sp)
	li      99, $i12
	cmp     $i10, $i12, $i12
	bne     $i12, be_else.10904
	li      1, $i1
	mov     $i9, $i2
	mov     $i8, $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10906, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10906:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	b       be_cont.10905
be_else.10904:
	store   $i9, 4($sp)
	store   $i8, 5($sp)
	store   $i4, 6($sp)
	store   $i6, 7($sp)
	mov     $i3, $i2
	mov     $i10, $i1
	mov     $i7, $i11
	mov     $i5, $i3
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.10907, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.10907:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10908
	b       be_cont.10909
be_else.10908:
	load    7($sp), $i1
	load    0($i1), $f1
	load    6($sp), $i1
	load    0($i1), $f2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fless
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10910
	b       be_cont.10911
be_else.10910:
	li      1, $i1
	load    4($sp), $i2
	load    0($sp), $i3
	load    5($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.10912, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.10912:
	sub     $sp, 9, $sp
	load    8($sp), $ra
be_cont.10911:
be_cont.10909:
be_cont.10905:
	load    3($sp), $i1
	add     $i1, 1, $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
judge_intersection.3066:
	load    3($i11), $i2
	load    2($i11), $i3
	store   $i3, 0($sp)
	load    1($i11), $i4
	li      l.6772, $i5
	load    0($i5), $f1
	store   $f1, 0($i3)
	li      0, $i3
	load    0($i4), $i4
	mov     $i2, $i11
	mov     $i4, $i2
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 1($sp)
	load    0($i11), $i10
	li      cls.10913, $ra
	add     $sp, 2, $sp
	jr      $i10
cls.10913:
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i1
	load    0($i1), $f2
	store   $f2, 1($sp)
	li      l.6768, $i1
	load    0($i1), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_fless
	sub     $sp, 3, $sp
	load    2($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10914
	li      0, $i1
	ret
be_else.10914:
	li      l.6775, $i1
	load    0($i1), $f2
	load    1($sp), $f1
	b       min_caml_fless
solve_each_element_fast.3068:
	store   $i11, 0($sp)
	store   $i3, 1($sp)
	store   $i1, 2($sp)
	store   $i2, 3($sp)
	load    9($i11), $i1
	store   $i1, 4($sp)
	load    8($i11), $i1
	store   $i1, 5($sp)
	load    7($i11), $i1
	store   $i1, 6($sp)
	load    6($i11), $i1
	store   $i1, 7($sp)
	load    5($i11), $i1
	store   $i1, 8($sp)
	load    4($i11), $i1
	store   $i1, 9($sp)
	load    3($i11), $i1
	store   $i1, 10($sp)
	load    2($i11), $i1
	store   $i1, 11($sp)
	load    1($i11), $i1
	store   $i1, 12($sp)
	mov     $i3, $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     d_vec.2883
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    2($sp), $i2
	load    3($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i4
	li      -1, $i12
	cmp     $i4, $i12, $i12
	bne     $i12, be_else.10915
	ret
be_else.10915:
	store   $i1, 13($sp)
	store   $i4, 14($sp)
	load    1($sp), $i2
	load    6($sp), $i11
	mov     $i4, $i1
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.10917, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.10917:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10918
	load    14($sp), $i1
	load    8($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     o_isinvert.2828
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10919
	ret
be_else.10919:
	load    2($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	load    1($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10918:
	store   $i1, 15($sp)
	load    7($sp), $i1
	load    0($i1), $f2
	store   $f2, 16($sp)
	li      l.6636, $i1
	load    0($i1), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fless
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10921
	b       be_cont.10922
be_else.10921:
	load    4($sp), $i1
	load    0($i1), $f2
	load    16($sp), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fless
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10923
	b       be_cont.10924
be_else.10923:
	li      l.6766, $i1
	load    0($i1), $f1
	load    16($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 17($sp)
	load    13($sp), $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    5($sp), $i2
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
	li      0, $i1
	load    3($sp), $i2
	load    12($sp), $i11
	mov     $f3, $f14
	mov     $f1, $f3
	mov     $f2, $f1
	mov     $f14, $f2
	store   $ra, 21($sp)
	load    0($i11), $i10
	li      cls.10925, $ra
	add     $sp, 22, $sp
	jr      $i10
cls.10925:
	sub     $sp, 22, $sp
	load    21($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10926
	b       be_cont.10927
be_else.10926:
	load    4($sp), $i1
	load    17($sp), $f1
	store   $f1, 0($i1)
	load    18($sp), $f1
	load    19($sp), $f2
	load    20($sp), $f3
	load    10($sp), $i1
	store   $ra, 21($sp)
	add     $sp, 22, $sp
	jal     vecset.2776
	sub     $sp, 22, $sp
	load    21($sp), $ra
	load    11($sp), $i1
	load    14($sp), $i2
	store   $i2, 0($i1)
	load    9($sp), $i1
	load    15($sp), $i2
	store   $i2, 0($i1)
be_cont.10927:
be_cont.10924:
be_cont.10922:
	load    2($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	load    1($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
solve_one_or_network_fast.3072:
	load    2($i11), $i4
	load    1($i11), $i5
	add     $i2, $i1, $i12
	load    0($i12), $i6
	li      -1, $i12
	cmp     $i6, $i12, $i12
	bne     $i12, be_else.10928
	ret
be_else.10928:
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 2($sp)
	store   $i1, 3($sp)
	add     $i5, $i6, $i12
	load    0($i12), $i2
	li      0, $i1
	mov     $i4, $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10930, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10930:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i1
	add     $i1, 1, $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
trace_or_matrix_fast.3076:
	load    4($i11), $i4
	load    3($i11), $i5
	load    2($i11), $i6
	load    1($i11), $i7
	add     $i2, $i1, $i12
	load    0($i12), $i8
	load    0($i8), $i9
	li      -1, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.10931
	ret
be_else.10931:
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 2($sp)
	store   $i1, 3($sp)
	li      99, $i12
	cmp     $i9, $i12, $i12
	bne     $i12, be_else.10933
	li      1, $i1
	mov     $i8, $i2
	mov     $i7, $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.10935, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.10935:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	b       be_cont.10934
be_else.10933:
	store   $i8, 4($sp)
	store   $i7, 5($sp)
	store   $i4, 6($sp)
	store   $i6, 7($sp)
	mov     $i3, $i2
	mov     $i9, $i1
	mov     $i5, $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.10936, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.10936:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10937
	b       be_cont.10938
be_else.10937:
	load    7($sp), $i1
	load    0($i1), $f1
	load    6($sp), $i1
	load    0($i1), $f2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fless
	sub     $sp, 9, $sp
	load    8($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10939
	b       be_cont.10940
be_else.10939:
	li      1, $i1
	load    4($sp), $i2
	load    0($sp), $i3
	load    5($sp), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.10941, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.10941:
	sub     $sp, 9, $sp
	load    8($sp), $ra
be_cont.10940:
be_cont.10938:
be_cont.10934:
	load    3($sp), $i1
	add     $i1, 1, $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
judge_intersection_fast.3080:
	load    3($i11), $i2
	load    2($i11), $i3
	store   $i3, 0($sp)
	load    1($i11), $i4
	li      l.6772, $i5
	load    0($i5), $f1
	store   $f1, 0($i3)
	li      0, $i3
	load    0($i4), $i4
	mov     $i2, $i11
	mov     $i4, $i2
	mov     $i3, $i10
	mov     $i1, $i3
	mov     $i10, $i1
	store   $ra, 1($sp)
	load    0($i11), $i10
	li      cls.10942, $ra
	add     $sp, 2, $sp
	jr      $i10
cls.10942:
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i1
	load    0($i1), $f2
	store   $f2, 1($sp)
	li      l.6768, $i1
	load    0($i1), $f1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_fless
	sub     $sp, 3, $sp
	load    2($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10943
	li      0, $i1
	ret
be_else.10943:
	li      l.6775, $i1
	load    0($i1), $f2
	load    1($sp), $f1
	b       min_caml_fless
get_nvector_rect.3082:
	store   $i1, 0($sp)
	load    2($i11), $i1
	store   $i1, 1($sp)
	load    1($i11), $i2
	load    0($i2), $i2
	store   $i2, 2($sp)
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     vecbzero.2784
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $i1
	sub     $i1, 1, $i2
	store   $i2, 3($sp)
	sub     $i1, 1, $i1
	load    0($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $f1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     sgn.2768
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fneg
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i1
	load    1($sp), $i2
	add     $i2, $i1, $i12
	store   $f1, 0($i12)
	ret
get_nvector_plane.3084:
	store   $i1, 0($sp)
	load    1($i11), $i2
	store   $i2, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     o_param_a.2832
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_fneg
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i1
	store   $f1, 0($i1)
	load    0($sp), $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     o_param_b.2834
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_fneg
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i1
	store   $f1, 1($i1)
	load    0($sp), $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     o_param_c.2836
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_fneg
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i1
	store   $f1, 2($i1)
	ret
get_nvector_second.3086:
	store   $i1, 0($sp)
	load    2($i11), $i2
	store   $i2, 1($sp)
	load    1($i11), $i2
	store   $i2, 2($sp)
	load    0($i2), $f1
	store   $f1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_param_x.2840
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 4($sp)
	load    2($sp), $i1
	load    1($i1), $f1
	store   $f1, 5($sp)
	load    0($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_param_y.2842
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 6($sp)
	load    2($sp), $i1
	load    2($i1), $f1
	store   $f1, 7($sp)
	load    0($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     o_param_z.2844
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 8($sp)
	load    0($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     o_param_a.2832
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    4($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 9($sp)
	load    0($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_param_b.2834
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 10($sp)
	load    0($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_param_c.2836
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 11($sp)
	load    0($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_isrot.2830
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10946
	load    1($sp), $i1
	load    9($sp), $f1
	store   $f1, 0($i1)
	load    10($sp), $f1
	store   $f1, 1($i1)
	load    11($sp), $f1
	store   $f1, 2($i1)
	b       be_cont.10947
be_else.10946:
	load    0($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_param_r3.2860
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 12($sp)
	load    0($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_param_r2.2858
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	load    12($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     min_caml_fhalf
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    9($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 0($i1)
	load    0($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_param_r3.2860
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    4($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 13($sp)
	load    0($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     o_param_r1.2856
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    8($sp), $f2
	fmul    $f2, $f1, $f1
	load    13($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fhalf
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    10($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 1($i1)
	load    0($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     o_param_r2.2858
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    4($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 14($sp)
	load    0($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     o_param_r1.2856
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    6($sp), $f2
	fmul    $f2, $f1, $f1
	load    14($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fhalf
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    11($sp), $f2
	fadd    $f2, $f1, $f1
	load    1($sp), $i1
	store   $f1, 2($i1)
be_cont.10947:
	load    0($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     o_isinvert.2828
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $i1, $i2
	load    1($sp), $i1
	b       vecunit_sgn.2794
get_nvector.3088:
	store   $i1, 0($sp)
	store   $i2, 1($sp)
	load    3($i11), $i2
	store   $i2, 2($sp)
	load    2($i11), $i2
	store   $i2, 3($sp)
	load    1($i11), $i2
	store   $i2, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     o_form.2824
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10948
	load    1($sp), $i1
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10948:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10949
	load    0($sp), $i1
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.10949:
	load    0($sp), $i1
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
utexture.3091:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	load    4($i11), $i2
	store   $i2, 2($sp)
	load    3($i11), $i2
	store   $i2, 3($sp)
	load    2($i11), $i2
	store   $i2, 4($sp)
	load    1($i11), $i2
	store   $i2, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_texturetype.2822
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	load    1($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_color_red.2850
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    2($sp), $i1
	store   $f1, 0($i1)
	load    1($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_color_green.2852
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    2($sp), $i1
	store   $f1, 1($i1)
	load    1($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_color_blue.2854
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    2($sp), $i1
	store   $f1, 2($i1)
	load    6($sp), $i2
	li      1, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10950
	load    0($sp), $i1
	load    0($i1), $f1
	store   $f1, 7($sp)
	load    1($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     o_param_x.2840
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    7($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 8($sp)
	li      l.6813, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_floor
	sub     $sp, 10, $sp
	load    9($sp), $ra
	li      l.6815, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    8($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.6704, $i1
	load    0($i1), $f2
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fless
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $i1, 9($sp)
	load    0($sp), $i1
	load    2($i1), $f1
	store   $f1, 10($sp)
	load    1($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     o_param_z.2844
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    10($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 11($sp)
	li      l.6813, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_floor
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      l.6815, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    11($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.6704, $i1
	load    0($i1), $f2
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fless
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    9($sp), $i2
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10951
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10953
	li      l.6799, $i1
	load    0($i1), $f1
	b       be_cont.10954
be_else.10953:
	li      l.6636, $i1
	load    0($i1), $f1
be_cont.10954:
	b       be_cont.10952
be_else.10951:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10955
	li      l.6636, $i1
	load    0($i1), $f1
	b       be_cont.10956
be_else.10955:
	li      l.6799, $i1
	load    0($i1), $f1
be_cont.10956:
be_cont.10952:
	load    2($sp), $i1
	store   $f1, 1($i1)
	ret
be_else.10950:
	li      2, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10958
	load    0($sp), $i1
	load    1($i1), $f1
	li      l.6808, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    3($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.10959, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.10959:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_fsqr
	sub     $sp, 13, $sp
	load    12($sp), $ra
	li      l.6799, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f2
	load    2($sp), $i1
	store   $f2, 0($i1)
	li      l.6799, $i2
	load    0($i2), $f2
	li      l.6639, $i2
	load    0($i2), $f3
	fsub    $f3, $f1, $f1
	fmul    $f2, $f1, $f1
	store   $f1, 1($i1)
	ret
be_else.10958:
	li      3, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10961
	load    0($sp), $i1
	load    0($i1), $f1
	store   $f1, 12($sp)
	load    1($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     o_param_x.2840
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    12($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 13($sp)
	load    0($sp), $i1
	load    2($i1), $f1
	store   $f1, 14($sp)
	load    1($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     o_param_z.2844
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 15($sp)
	load    13($sp), $f1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     min_caml_fsqr
	sub     $sp, 17, $sp
	load    16($sp), $ra
	store   $f1, 16($sp)
	load    15($sp), $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     min_caml_fsqr
	sub     $sp, 18, $sp
	load    17($sp), $ra
	load    16($sp), $f2
	fadd    $f2, $f1, $f1
	store   $ra, 17($sp)
	add     $sp, 18, $sp
	jal     sqrt.2729
	sub     $sp, 18, $sp
	load    17($sp), $ra
	li      l.6704, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	store   $f1, 17($sp)
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_floor
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    17($sp), $f2
	fsub    $f2, $f1, $f1
	li      l.6788, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    4($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.10962, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.10962:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     min_caml_fsqr
	sub     $sp, 19, $sp
	load    18($sp), $ra
	li      l.6799, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    2($sp), $i1
	store   $f2, 1($i1)
	li      l.6639, $i2
	load    0($i2), $f2
	fsub    $f2, $f1, $f1
	li      l.6799, $i2
	load    0($i2), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 2($i1)
	ret
be_else.10961:
	li      4, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10964
	load    0($sp), $i1
	load    0($i1), $f1
	store   $f1, 18($sp)
	load    1($sp), $i1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     o_param_x.2840
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    18($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 19($sp)
	load    1($sp), $i1
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     o_param_a.2832
	sub     $sp, 21, $sp
	load    20($sp), $ra
	store   $ra, 20($sp)
	add     $sp, 21, $sp
	jal     sqrt.2729
	sub     $sp, 21, $sp
	load    20($sp), $ra
	load    19($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 20($sp)
	load    0($sp), $i1
	load    2($i1), $f1
	store   $f1, 21($sp)
	load    1($sp), $i1
	store   $ra, 22($sp)
	add     $sp, 23, $sp
	jal     o_param_z.2844
	sub     $sp, 23, $sp
	load    22($sp), $ra
	load    21($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 22($sp)
	load    1($sp), $i1
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     o_param_c.2836
	sub     $sp, 24, $sp
	load    23($sp), $ra
	store   $ra, 23($sp)
	add     $sp, 24, $sp
	jal     sqrt.2729
	sub     $sp, 24, $sp
	load    23($sp), $ra
	load    22($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 23($sp)
	load    20($sp), $f1
	store   $ra, 24($sp)
	add     $sp, 25, $sp
	jal     min_caml_fsqr
	sub     $sp, 25, $sp
	load    24($sp), $ra
	store   $f1, 24($sp)
	load    23($sp), $f1
	store   $ra, 25($sp)
	add     $sp, 26, $sp
	jal     min_caml_fsqr
	sub     $sp, 26, $sp
	load    25($sp), $ra
	load    24($sp), $f2
	fadd    $f2, $f1, $f1
	store   $f1, 25($sp)
	load    20($sp), $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fabs
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      l.6782, $i1
	load    0($i1), $f2
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fless
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10965
	load    20($sp), $f1
	load    23($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     min_caml_fabs
	sub     $sp, 27, $sp
	load    26($sp), $ra
	load    5($sp), $i11
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.10967, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.10967:
	sub     $sp, 27, $sp
	load    26($sp), $ra
	li      l.6786, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.6788, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.10966
be_else.10965:
	li      l.6784, $i1
	load    0($i1), $f1
be_cont.10966:
	store   $f1, 26($sp)
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_floor
	sub     $sp, 28, $sp
	load    27($sp), $ra
	load    26($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 27($sp)
	load    0($sp), $i1
	load    1($i1), $f1
	store   $f1, 28($sp)
	load    1($sp), $i1
	store   $ra, 29($sp)
	add     $sp, 30, $sp
	jal     o_param_y.2842
	sub     $sp, 30, $sp
	load    29($sp), $ra
	load    28($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 29($sp)
	load    1($sp), $i1
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     o_param_b.2834
	sub     $sp, 31, $sp
	load    30($sp), $ra
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     sqrt.2729
	sub     $sp, 31, $sp
	load    30($sp), $ra
	load    29($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 30($sp)
	load    25($sp), $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fabs
	sub     $sp, 32, $sp
	load    31($sp), $ra
	li      l.6782, $i1
	load    0($i1), $f2
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fless
	sub     $sp, 32, $sp
	load    31($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10968
	load    25($sp), $f1
	load    30($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     min_caml_fabs
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    5($sp), $i11
	store   $ra, 31($sp)
	load    0($i11), $i10
	li      cls.10970, $ra
	add     $sp, 32, $sp
	jr      $i10
cls.10970:
	sub     $sp, 32, $sp
	load    31($sp), $ra
	li      l.6786, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.6788, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	b       be_cont.10969
be_else.10968:
	li      l.6784, $i1
	load    0($i1), $f1
be_cont.10969:
	store   $f1, 31($sp)
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     min_caml_floor
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    31($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 32($sp)
	li      l.6794, $i1
	load    0($i1), $f1
	store   $f1, 33($sp)
	li      l.6633, $i1
	load    0($i1), $f1
	load    27($sp), $f2
	fsub    $f1, $f2, $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     min_caml_fsqr
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    33($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 34($sp)
	li      l.6633, $i1
	load    0($i1), $f1
	load    32($sp), $f2
	fsub    $f1, $f2, $f1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     min_caml_fsqr
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    34($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 35($sp)
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_fisneg
	sub     $sp, 37, $sp
	load    36($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10971
	load    35($sp), $f1
	b       be_cont.10972
be_else.10971:
	li      l.6636, $i1
	load    0($i1), $f1
be_cont.10972:
	li      l.6799, $i1
	load    0($i1), $f2
	fmul    $f2, $f1, $f1
	li      l.6801, $i1
	load    0($i1), $f2
	finv    $f2, $f15
	fmul    $f1, $f15, $f1
	load    2($sp), $i1
	store   $f1, 2($i1)
	ret
be_else.10964:
	ret
add_light.3094:
	store   $f1, 0($sp)
	store   $f3, 1($sp)
	store   $f2, 2($sp)
	load    2($i11), $i1
	store   $i1, 3($sp)
	load    1($i11), $i1
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fispos
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10975
	b       be_cont.10976
be_else.10975:
	load    0($sp), $f1
	load    4($sp), $i1
	load    3($sp), $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     vecaccum.2805
	sub     $sp, 6, $sp
	load    5($sp), $ra
be_cont.10976:
	load    2($sp), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fispos
	sub     $sp, 6, $sp
	load    5($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10977
	ret
be_else.10977:
	load    2($sp), $f1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fsqr
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_fsqr
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    1($sp), $f2
	fmul    $f1, $f2, $f1
	load    4($sp), $i1
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
trace_reflections.3098:
	load    8($i11), $i3
	load    7($i11), $i4
	load    6($i11), $i5
	load    5($i11), $i6
	load    4($i11), $i7
	load    3($i11), $i8
	load    2($i11), $i9
	load    1($i11), $i10
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.10980
	store   $i10, 0($sp)
	store   $i6, 1($sp)
	store   $i3, 2($sp)
	store   $i5, 3($sp)
	store   $i8, 4($sp)
	store   $i9, 5($sp)
	store   $f2, 6($sp)
	store   $f1, 7($sp)
	store   $i2, 8($sp)
	store   $i11, 9($sp)
	store   $i1, 10($sp)
	store   $i7, 11($sp)
	add     $i4, $i1, $i12
	load    0($i12), $i1
	store   $i1, 12($sp)
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     r_dvec.2889
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $i1, 13($sp)
	load    11($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.10981, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.10981:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10982
	b       be_cont.10983
be_else.10982:
	load    5($sp), $i1
	load    0($i1), $i1
	sll     $i1, 2, $i1
	load    4($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	store   $i1, 14($sp)
	load    12($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     r_surface_id.2887
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $i2
	cmp     $i2, $i1, $i12
	bne     $i12, be_else.10984
	li      0, $i1
	load    3($sp), $i2
	load    0($i2), $i2
	load    2($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.10986, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.10986:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10987
	load    13($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     d_vec.2883
	sub     $sp, 16, $sp
	load    15($sp), $ra
	mov     $i1, $i2
	load    1($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     veciprod.2797
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $f1, 15($sp)
	load    12($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     r_bright.2891
	sub     $sp, 17, $sp
	load    16($sp), $ra
	store   $f1, 16($sp)
	load    7($sp), $f2
	fmul    $f1, $f2, $f1
	load    15($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 17($sp)
	load    13($sp), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     d_vec.2883
	sub     $sp, 19, $sp
	load    18($sp), $ra
	mov     $i1, $i2
	load    8($sp), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     veciprod.2797
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    16($sp), $f2
	fmul    $f2, $f1, $f2
	load    17($sp), $f1
	load    6($sp), $f3
	load    0($sp), $i11
	store   $ra, 18($sp)
	load    0($i11), $i10
	li      cls.10989, $ra
	add     $sp, 19, $sp
	jr      $i10
cls.10989:
	sub     $sp, 19, $sp
	load    18($sp), $ra
	b       be_cont.10988
be_else.10987:
be_cont.10988:
	b       be_cont.10985
be_else.10984:
be_cont.10985:
be_cont.10983:
	load    10($sp), $i1
	sub     $i1, 1, $i1
	load    7($sp), $f1
	load    6($sp), $f2
	load    8($sp), $i2
	load    9($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.10980:
	ret
trace_ray.3103:
	store   $i11, 0($sp)
	load    20($i11), $i4
	store   $i4, 1($sp)
	load    19($i11), $i4
	store   $i4, 2($sp)
	load    18($i11), $i4
	store   $i4, 3($sp)
	load    17($i11), $i4
	store   $i4, 4($sp)
	load    16($i11), $i4
	store   $i4, 5($sp)
	load    15($i11), $i4
	store   $i4, 6($sp)
	load    14($i11), $i4
	store   $i4, 7($sp)
	load    13($i11), $i4
	load    12($i11), $i5
	store   $i5, 8($sp)
	load    11($i11), $i5
	load    10($i11), $i6
	store   $i6, 9($sp)
	load    9($i11), $i6
	store   $i6, 10($sp)
	load    8($i11), $i6
	load    7($i11), $i7
	load    6($i11), $i8
	store   $i8, 11($sp)
	load    5($i11), $i8
	store   $i8, 12($sp)
	load    4($i11), $i8
	load    3($i11), $i9
	load    2($i11), $i10
	load    1($i11), $i11
	li      4, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.10991
	store   $f2, 13($sp)
	store   $i11, 14($sp)
	store   $i3, 15($sp)
	store   $i9, 16($sp)
	store   $i5, 17($sp)
	store   $i8, 18($sp)
	store   $i4, 19($sp)
	store   $i10, 20($sp)
	store   $f1, 21($sp)
	store   $i6, 22($sp)
	store   $i1, 23($sp)
	store   $i2, 24($sp)
	store   $i7, 25($sp)
	mov     $i3, $i1
	store   $ra, 26($sp)
	add     $sp, 27, $sp
	jal     p_surface_ids.2868
	sub     $sp, 27, $sp
	load    26($sp), $ra
	store   $i1, 26($sp)
	load    24($sp), $i1
	load    25($sp), $i11
	store   $ra, 27($sp)
	load    0($i11), $i10
	li      cls.10992, $ra
	add     $sp, 28, $sp
	jr      $i10
cls.10992:
	sub     $sp, 28, $sp
	load    27($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10993
	li      -1, $i1
	load    23($sp), $i2
	load    26($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	li      0, $i12
	cmp     $i2, $i12, $i12
	bne     $i12, be_else.10994
	ret
be_else.10994:
	load    24($sp), $i1
	load    22($sp), $i2
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     veciprod.2797
	sub     $sp, 28, $sp
	load    27($sp), $ra
	store   $ra, 27($sp)
	add     $sp, 28, $sp
	jal     min_caml_fneg
	sub     $sp, 28, $sp
	load    27($sp), $ra
	store   $f1, 27($sp)
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fispos
	sub     $sp, 29, $sp
	load    28($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.10996
	ret
be_else.10996:
	load    27($sp), $f1
	store   $ra, 28($sp)
	add     $sp, 29, $sp
	jal     min_caml_fsqr
	sub     $sp, 29, $sp
	load    28($sp), $ra
	load    27($sp), $f2
	fmul    $f1, $f2, $f1
	load    21($sp), $f2
	fmul    $f1, $f2, $f1
	load    20($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	load    19($sp), $i1
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
be_else.10993:
	load    18($sp), $i1
	load    0($i1), $i1
	store   $i1, 28($sp)
	load    17($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 29($sp)
	store   $ra, 30($sp)
	add     $sp, 31, $sp
	jal     o_reflectiontype.2826
	sub     $sp, 31, $sp
	load    30($sp), $ra
	store   $i1, 30($sp)
	load    29($sp), $i1
	store   $ra, 31($sp)
	add     $sp, 32, $sp
	jal     o_diffuse.2846
	sub     $sp, 32, $sp
	load    31($sp), $ra
	load    21($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 31($sp)
	load    29($sp), $i1
	load    24($sp), $i2
	load    16($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.10999, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.10999:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    5($sp), $i1
	load    12($sp), $i2
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     veccpy.2786
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    29($sp), $i1
	load    12($sp), $i2
	load    1($sp), $i11
	store   $ra, 32($sp)
	load    0($i11), $i10
	li      cls.11000, $ra
	add     $sp, 33, $sp
	jr      $i10
cls.11000:
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    28($sp), $i1
	sll     $i1, 2, $i1
	load    11($sp), $i2
	load    0($i2), $i2
	add     $i1, $i2, $i1
	load    23($sp), $i2
	load    26($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    15($sp), $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     p_intersection_points.2866
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    23($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    12($sp), $i2
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     veccpy.2786
	sub     $sp, 33, $sp
	load    32($sp), $ra
	load    15($sp), $i1
	store   $ra, 32($sp)
	add     $sp, 33, $sp
	jal     p_calc_diffuse.2870
	sub     $sp, 33, $sp
	load    32($sp), $ra
	store   $i1, 32($sp)
	load    29($sp), $i1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     o_diffuse.2846
	sub     $sp, 34, $sp
	load    33($sp), $ra
	li      l.6633, $i1
	load    0($i1), $f2
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     min_caml_fless
	sub     $sp, 34, $sp
	load    33($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11001
	li      1, $i1
	load    23($sp), $i2
	load    32($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	load    15($sp), $i1
	store   $ra, 33($sp)
	add     $sp, 34, $sp
	jal     p_energy.2872
	sub     $sp, 34, $sp
	load    33($sp), $ra
	store   $i1, 33($sp)
	load    23($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    4($sp), $i2
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     veccpy.2786
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    23($sp), $i1
	load    33($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      l.6826, $i2
	load    0($i2), $f1
	load    31($sp), $f2
	fmul    $f1, $f2, $f1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     vecscale.2815
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    15($sp), $i1
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     p_nvectors.2881
	sub     $sp, 35, $sp
	load    34($sp), $ra
	load    23($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    9($sp), $i2
	store   $ra, 34($sp)
	add     $sp, 35, $sp
	jal     veccpy.2786
	sub     $sp, 35, $sp
	load    34($sp), $ra
	b       be_cont.11002
be_else.11001:
	li      0, $i1
	load    23($sp), $i2
	load    32($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
be_cont.11002:
	li      l.6828, $i1
	load    0($i1), $f1
	store   $f1, 34($sp)
	load    24($sp), $i1
	load    9($sp), $i2
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     veciprod.2797
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    34($sp), $f2
	fmul    $f2, $f1, $f1
	load    24($sp), $i1
	load    9($sp), $i2
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     vecaccum.2805
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    29($sp), $i1
	store   $ra, 35($sp)
	add     $sp, 36, $sp
	jal     o_hilight.2848
	sub     $sp, 36, $sp
	load    35($sp), $ra
	load    21($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 35($sp)
	li      0, $i1
	load    8($sp), $i2
	load    0($i2), $i2
	load    6($sp), $i11
	store   $ra, 36($sp)
	load    0($i11), $i10
	li      cls.11003, $ra
	add     $sp, 37, $sp
	jr      $i10
cls.11003:
	sub     $sp, 37, $sp
	load    36($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11004
	load    9($sp), $i1
	load    22($sp), $i2
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     veciprod.2797
	sub     $sp, 37, $sp
	load    36($sp), $ra
	store   $ra, 36($sp)
	add     $sp, 37, $sp
	jal     min_caml_fneg
	sub     $sp, 37, $sp
	load    36($sp), $ra
	load    31($sp), $f2
	fmul    $f1, $f2, $f1
	store   $f1, 36($sp)
	load    24($sp), $i1
	load    22($sp), $i2
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     veciprod.2797
	sub     $sp, 38, $sp
	load    37($sp), $ra
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fneg
	sub     $sp, 38, $sp
	load    37($sp), $ra
	mov     $f1, $f2
	load    36($sp), $f1
	load    35($sp), $f3
	load    14($sp), $i11
	store   $ra, 37($sp)
	load    0($i11), $i10
	li      cls.11006, $ra
	add     $sp, 38, $sp
	jr      $i10
cls.11006:
	sub     $sp, 38, $sp
	load    37($sp), $ra
	b       be_cont.11005
be_else.11004:
be_cont.11005:
	load    12($sp), $i1
	load    7($sp), $i11
	store   $ra, 37($sp)
	load    0($i11), $i10
	li      cls.11007, $ra
	add     $sp, 38, $sp
	jr      $i10
cls.11007:
	sub     $sp, 38, $sp
	load    37($sp), $ra
	load    10($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    31($sp), $f1
	load    35($sp), $f2
	load    24($sp), $i2
	load    2($sp), $i11
	store   $ra, 37($sp)
	load    0($i11), $i10
	li      cls.11008, $ra
	add     $sp, 38, $sp
	jr      $i10
cls.11008:
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      l.6701, $i1
	load    0($i1), $f1
	load    21($sp), $f2
	store   $ra, 37($sp)
	add     $sp, 38, $sp
	jal     min_caml_fless
	sub     $sp, 38, $sp
	load    37($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11009
	ret
be_else.11009:
	load    23($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11011
	b       bge_cont.11012
bge_else.11011:
	add     $i1, 1, $i1
	li      -1, $i2
	load    26($sp), $i3
	add     $i3, $i1, $i12
	store   $i2, 0($i12)
bge_cont.11012:
	load    30($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11013
	li      l.6639, $i1
	load    0($i1), $f1
	store   $f1, 37($sp)
	load    29($sp), $i1
	store   $ra, 38($sp)
	add     $sp, 39, $sp
	jal     o_diffuse.2846
	sub     $sp, 39, $sp
	load    38($sp), $ra
	load    37($sp), $f2
	fsub    $f2, $f1, $f1
	load    21($sp), $f2
	fmul    $f2, $f1, $f1
	load    23($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	load    0($i2), $f2
	load    13($sp), $f3
	fadd    $f3, $f2, $f2
	load    24($sp), $i2
	load    15($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.11013:
	ret
ble_else.10991:
	ret
trace_diffuse_ray.3109:
	store   $f1, 0($sp)
	store   $i1, 1($sp)
	load    12($i11), $i2
	store   $i2, 2($sp)
	load    11($i11), $i2
	store   $i2, 3($sp)
	load    10($i11), $i2
	store   $i2, 4($sp)
	load    9($i11), $i2
	store   $i2, 5($sp)
	load    8($i11), $i2
	store   $i2, 6($sp)
	load    7($i11), $i2
	store   $i2, 7($sp)
	load    6($i11), $i2
	store   $i2, 8($sp)
	load    5($i11), $i2
	load    4($i11), $i3
	store   $i3, 9($sp)
	load    3($i11), $i3
	store   $i3, 10($sp)
	load    2($i11), $i3
	store   $i3, 11($sp)
	load    1($i11), $i3
	store   $i3, 12($sp)
	mov     $i2, $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.11016, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.11016:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11017
	ret
be_else.11017:
	load    10($sp), $i1
	load    0($i1), $i1
	load    6($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 13($sp)
	load    1($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     d_vec.2883
	sub     $sp, 15, $sp
	load    14($sp), $ra
	mov     $i1, $i2
	load    13($sp), $i1
	load    11($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.11019, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.11019:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $i1
	load    9($sp), $i2
	load    2($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.11020, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.11020:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      0, $i1
	load    5($sp), $i2
	load    0($i2), $i2
	load    4($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.11021, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.11021:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11022
	load    7($sp), $i1
	load    8($sp), $i2
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     veciprod.2797
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     min_caml_fneg
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $f1, 14($sp)
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_fispos
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11023
	li      l.6636, $i1
	load    0($i1), $f1
	b       be_cont.11024
be_else.11023:
	load    14($sp), $f1
be_cont.11024:
	load    0($sp), $f2
	fmul    $f2, $f1, $f1
	store   $f1, 15($sp)
	load    13($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     o_diffuse.2846
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    15($sp), $f2
	fmul    $f2, $f1, $f1
	load    12($sp), $i1
	load    3($sp), $i2
	b       vecaccum.2805
be_else.11022:
	ret
iter_trace_diffuse_rays.3112:
	load    1($i11), $i5
	li      0, $i12
	cmp     $i4, $i12, $i12
	bl      $i12, bge_else.11026
	store   $i3, 0($sp)
	store   $i11, 1($sp)
	store   $i5, 2($sp)
	store   $i4, 3($sp)
	store   $i1, 4($sp)
	store   $i2, 5($sp)
	add     $i1, $i4, $i12
	load    0($i12), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     d_vec.2883
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     veciprod.2797
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $f1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fisneg
	sub     $sp, 8, $sp
	load    7($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11027
	load    3($sp), $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      l.6835, $i2
	load    0($i2), $f1
	load    6($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.11029, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.11029:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	b       be_cont.11028
be_else.11027:
	load    3($sp), $i1
	add     $i1, 1, $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      l.6833, $i2
	load    0($i2), $f1
	load    6($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    2($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.11030, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.11030:
	sub     $sp, 8, $sp
	load    7($sp), $ra
be_cont.11028:
	load    3($sp), $i1
	sub     $i1, 2, $i4
	load    4($sp), $i1
	load    5($sp), $i2
	load    0($sp), $i3
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11026:
	ret
trace_diffuse_rays.3117:
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i1, 2($sp)
	load    2($i11), $i1
	load    1($i11), $i2
	store   $i2, 3($sp)
	mov     $i1, $i11
	mov     $i3, $i1
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.11032, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.11032:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      118, $i4
	load    2($sp), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
trace_diffuse_ray_80percent.3121:
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i1, 2($sp)
	load    2($i11), $i4
	store   $i4, 3($sp)
	load    1($i11), $i5
	store   $i5, 4($sp)
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11033
	b       be_cont.11034
be_else.11033:
	load    0($i5), $i1
	mov     $i4, $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.11035, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.11035:
	sub     $sp, 6, $sp
	load    5($sp), $ra
be_cont.11034:
	load    2($sp), $i1
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11036
	b       be_cont.11037
be_else.11036:
	load    4($sp), $i1
	load    1($i1), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    3($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.11038, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.11038:
	sub     $sp, 6, $sp
	load    5($sp), $ra
be_cont.11037:
	load    2($sp), $i1
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11039
	b       be_cont.11040
be_else.11039:
	load    4($sp), $i1
	load    2($i1), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    3($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.11041, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.11041:
	sub     $sp, 6, $sp
	load    5($sp), $ra
be_cont.11040:
	load    2($sp), $i1
	li      3, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11042
	b       be_cont.11043
be_else.11042:
	load    4($sp), $i1
	load    3($i1), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    3($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.11044, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.11044:
	sub     $sp, 6, $sp
	load    5($sp), $ra
be_cont.11043:
	load    2($sp), $i1
	li      4, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11045
	ret
be_else.11045:
	load    4($sp), $i1
	load    4($i1), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
calc_diffuse_using_1point.3125:
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	load    3($i11), $i2
	store   $i2, 2($sp)
	load    2($i11), $i2
	store   $i2, 3($sp)
	load    1($i11), $i2
	store   $i2, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     p_received_ray_20percent.2874
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	load    1($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     p_nvectors.2881
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	load    1($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     p_intersection_points.2866
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	load    1($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     p_energy.2872
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	load    0($sp), $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    4($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     veccpy.2786
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    1($sp), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     p_group_id.2876
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    0($sp), $i2
	load    6($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	load    7($sp), $i4
	add     $i4, $i2, $i12
	load    0($i12), $i2
	load    2($sp), $i11
	mov     $i3, $i10
	mov     $i2, $i3
	mov     $i10, $i2
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.11047, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.11047:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    0($sp), $i1
	load    8($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    3($sp), $i1
	load    4($sp), $i3
	b       vecaccumv.2818
calc_diffuse_using_5points.3128:
	store   $i5, 0($sp)
	store   $i4, 1($sp)
	store   $i3, 2($sp)
	store   $i1, 3($sp)
	load    2($i11), $i3
	store   $i3, 4($sp)
	load    1($i11), $i3
	store   $i3, 5($sp)
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     p_received_ray_20percent.2874
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	load    3($sp), $i1
	sub     $i1, 1, $i1
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     p_received_ray_20percent.2874
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	load    3($sp), $i1
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     p_received_ray_20percent.2874
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	load    3($sp), $i1
	add     $i1, 1, $i1
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     p_received_ray_20percent.2874
	sub     $sp, 10, $sp
	load    9($sp), $ra
	store   $i1, 9($sp)
	load    3($sp), $i1
	load    1($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     p_received_ray_20percent.2874
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	load    0($sp), $i1
	load    6($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     veccpy.2786
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    0($sp), $i1
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     vecadd.2809
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    0($sp), $i1
	load    8($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     vecadd.2809
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    0($sp), $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     vecadd.2809
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    0($sp), $i1
	load    10($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i2
	load    5($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     vecadd.2809
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    3($sp), $i1
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     p_energy.2872
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    0($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i2
	load    4($sp), $i1
	load    5($sp), $i3
	b       vecaccumv.2818
do_without_neighbors.3134:
	load    1($i11), $i3
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.11048
	store   $i3, 0($sp)
	store   $i11, 1($sp)
	store   $i1, 2($sp)
	store   $i2, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     p_surface_ids.2868
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11049
	load    2($sp), $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     p_calc_diffuse.2870
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11050
	b       be_cont.11051
be_else.11050:
	load    2($sp), $i1
	load    0($sp), $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.11052, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.11052:
	sub     $sp, 5, $sp
	load    4($sp), $ra
be_cont.11051:
	load    3($sp), $i1
	add     $i1, 1, $i2
	load    2($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11049:
	ret
ble_else.11048:
	ret
neighbors_exist.3137:
	load    1($i11), $i3
	load    1($i3), $i4
	add     $i2, 1, $i5
	cmp     $i4, $i5, $i12
	bg      $i12, ble_else.11055
	li      0, $i1
	ret
ble_else.11055:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.11056
	li      0, $i1
	ret
ble_else.11056:
	load    0($i3), $i2
	add     $i1, 1, $i3
	cmp     $i2, $i3, $i12
	bg      $i12, ble_else.11057
	li      0, $i1
	ret
ble_else.11057:
	li      0, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.11058
	li      0, $i1
	ret
ble_else.11058:
	li      1, $i1
	ret
get_surface_id.3141:
	store   $i2, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     p_surface_ids.2868
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	ret
neighbors_are_available.3144:
	store   $i3, 0($sp)
	store   $i4, 1($sp)
	store   $i5, 2($sp)
	store   $i1, 3($sp)
	store   $i2, 4($sp)
	add     $i3, $i1, $i12
	load    0($i12), $i1
	mov     $i5, $i2
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     get_surface_id.3141
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	load    3($sp), $i1
	load    4($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    2($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     get_surface_id.3141
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.11059
	load    3($sp), $i1
	load    1($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    2($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     get_surface_id.3141
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.11060
	load    3($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    2($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     get_surface_id.3141
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.11061
	load    3($sp), $i1
	add     $i1, 1, $i1
	load    0($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    2($sp), $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     get_surface_id.3141
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $i2
	cmp     $i1, $i2, $i12
	bne     $i12, be_else.11062
	li      1, $i1
	ret
be_else.11062:
	li      0, $i1
	ret
be_else.11061:
	li      0, $i1
	ret
be_else.11060:
	li      0, $i1
	ret
be_else.11059:
	li      0, $i1
	ret
try_exploit_neighbors.3150:
	load    2($i11), $i7
	load    1($i11), $i8
	add     $i4, $i1, $i12
	load    0($i12), $i9
	li      4, $i12
	cmp     $i6, $i12, $i12
	bg      $i12, ble_else.11063
	store   $i8, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 2($sp)
	store   $i9, 3($sp)
	store   $i7, 4($sp)
	store   $i6, 5($sp)
	store   $i5, 6($sp)
	store   $i4, 7($sp)
	store   $i3, 8($sp)
	store   $i1, 9($sp)
	mov     $i6, $i2
	mov     $i9, $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     get_surface_id.3141
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11064
	load    9($sp), $i1
	load    8($sp), $i2
	load    7($sp), $i3
	load    6($sp), $i4
	load    5($sp), $i5
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     neighbors_are_available.3144
	sub     $sp, 11, $sp
	load    10($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11065
	load    9($sp), $i1
	load    7($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    5($sp), $i2
	load    4($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.11065:
	load    3($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     p_calc_diffuse.2870
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    5($sp), $i5
	add     $i1, $i5, $i12
	load    0($i12), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11066
	b       be_cont.11067
be_else.11066:
	load    9($sp), $i1
	load    8($sp), $i2
	load    7($sp), $i3
	load    6($sp), $i4
	load    0($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.11068, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.11068:
	sub     $sp, 11, $sp
	load    10($sp), $ra
be_cont.11067:
	load    5($sp), $i1
	add     $i1, 1, $i6
	load    9($sp), $i1
	load    1($sp), $i2
	load    8($sp), $i3
	load    7($sp), $i4
	load    6($sp), $i5
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11064:
	ret
ble_else.11063:
	ret
write_ppm_header.3157:
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
write_rgb_element.3159:
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_int_of_float
	sub     $sp, 1, $sp
	load    0($sp), $ra
	li      255, $i12
	cmp     $i1, $i12, $i12
	bg      $i12, ble_else.11071
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11073
	b       bge_cont.11074
bge_else.11073:
	li      0, $i1
bge_cont.11074:
	b       ble_cont.11072
ble_else.11071:
	li      255, $i1
ble_cont.11072:
	b       min_caml_write
write_rgb.3161:
	load    1($i11), $i1
	store   $i1, 0($sp)
	load    0($i1), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     write_rgb_element.3159
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i1
	load    1($i1), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     write_rgb_element.3159
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i1
	load    2($i1), $f1
	b       write_rgb_element.3159
pretrace_diffuse_rays.3163:
	load    3($i11), $i3
	load    2($i11), $i4
	load    1($i11), $i5
	li      4, $i12
	cmp     $i2, $i12, $i12
	bg      $i12, ble_else.11075
	store   $i3, 0($sp)
	store   $i4, 1($sp)
	store   $i5, 2($sp)
	store   $i11, 3($sp)
	store   $i2, 4($sp)
	store   $i1, 5($sp)
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     get_surface_id.3141
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11076
	load    5($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     p_calc_diffuse.2870
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    4($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11077
	b       be_cont.11078
be_else.11077:
	load    5($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     p_group_id.2876
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	load    2($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     vecbzero.2784
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     p_nvectors.2881
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $i1, 7($sp)
	load    5($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     p_intersection_points.2866
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    6($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i2
	load    4($sp), $i3
	load    7($sp), $i4
	add     $i4, $i3, $i12
	load    0($i12), $i4
	add     $i1, $i3, $i12
	load    0($i12), $i3
	load    0($sp), $i11
	mov     $i2, $i1
	mov     $i4, $i2
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.11079, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.11079:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    5($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     p_received_ray_20percent.2874
	sub     $sp, 9, $sp
	load    8($sp), $ra
	load    4($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	load    2($sp), $i2
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     veccpy.2786
	sub     $sp, 9, $sp
	load    8($sp), $ra
be_cont.11078:
	load    4($sp), $i1
	add     $i1, 1, $i2
	load    5($sp), $i1
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11076:
	ret
ble_else.11075:
	ret
pretrace_pixels.3166:
	store   $i3, 0($sp)
	store   $i11, 1($sp)
	load    9($i11), $i3
	load    8($i11), $i4
	load    7($i11), $i5
	load    6($i11), $i6
	load    5($i11), $i7
	load    4($i11), $i8
	load    3($i11), $i9
	load    2($i11), $i10
	load    1($i11), $i11
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.11082
	store   $i10, 2($sp)
	store   $i4, 3($sp)
	store   $i2, 4($sp)
	store   $i1, 5($sp)
	store   $i3, 6($sp)
	store   $i5, 7($sp)
	store   $i8, 8($sp)
	store   $f3, 9($sp)
	store   $f2, 10($sp)
	store   $i9, 11($sp)
	store   $f1, 12($sp)
	store   $i6, 13($sp)
	load    0($i7), $f1
	store   $f1, 14($sp)
	load    0($i11), $i1
	sub     $i2, $i1, $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     min_caml_float_of_int
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    14($sp), $f2
	fmul    $f2, $f1, $f1
	load    13($sp), $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f2
	load    12($sp), $f3
	fadd    $f2, $f3, $f2
	load    11($sp), $i2
	store   $f2, 0($i2)
	load    1($i1), $f2
	fmul    $f1, $f2, $f2
	load    10($sp), $f3
	fadd    $f2, $f3, $f2
	store   $f2, 1($i2)
	load    2($i1), $f2
	fmul    $f1, $f2, $f1
	load    9($sp), $f2
	fadd    $f1, $f2, $f1
	store   $f1, 2($i2)
	li      0, $i1
	mov     $i2, $i10
	mov     $i1, $i2
	mov     $i10, $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     vecunit_sgn.2794
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    8($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     vecbzero.2784
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    7($sp), $i1
	load    6($sp), $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     veccpy.2786
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i1
	li      l.6639, $i2
	load    0($i2), $f1
	load    4($sp), $i2
	load    5($sp), $i3
	add     $i3, $i2, $i12
	load    0($i12), $i3
	li      l.6636, $i2
	load    0($i2), $f2
	load    11($sp), $i2
	load    3($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.11083, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.11083:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    4($sp), $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     p_rgb.2864
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    8($sp), $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     veccpy.2786
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    4($sp), $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	load    0($sp), $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     p_set_group_id.2878
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    4($sp), $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      0, $i2
	load    2($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.11084, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.11084:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    4($sp), $i1
	sub     $i1, 1, $i1
	store   $i1, 15($sp)
	li      1, $i2
	load    0($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     add_mod5.2773
	sub     $sp, 17, $sp
	load    16($sp), $ra
	mov     $i1, $i3
	load    12($sp), $f1
	load    10($sp), $f2
	load    9($sp), $f3
	load    5($sp), $i1
	load    15($sp), $i2
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11082:
	ret
pretrace_line.3173:
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
scan_pixel.3177:
	load    6($i11), $i6
	load    5($i11), $i7
	store   $i7, 0($sp)
	load    4($i11), $i7
	load    3($i11), $i8
	load    2($i11), $i9
	load    1($i11), $i10
	load    0($i9), $i9
	cmp     $i9, $i1, $i12
	bg      $i12, ble_else.11086
	ret
ble_else.11086:
	store   $i3, 1($sp)
	store   $i11, 2($sp)
	store   $i6, 3($sp)
	store   $i10, 4($sp)
	store   $i4, 5($sp)
	store   $i5, 6($sp)
	store   $i2, 7($sp)
	store   $i1, 8($sp)
	store   $i8, 9($sp)
	store   $i7, 10($sp)
	add     $i4, $i1, $i12
	load    0($i12), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     p_rgb.2864
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $i1, $i2
	load    10($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     veccpy.2786
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $i1
	load    7($sp), $i2
	load    6($sp), $i3
	load    9($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.11088, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.11088:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11089
	load    8($sp), $i1
	load    5($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	li      0, $i2
	load    4($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.11091, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.11091:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	b       be_cont.11090
be_else.11089:
	li      0, $i6
	load    8($sp), $i1
	load    7($sp), $i2
	load    1($sp), $i3
	load    5($sp), $i4
	load    6($sp), $i5
	load    0($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.11092, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.11092:
	sub     $sp, 12, $sp
	load    11($sp), $ra
be_cont.11090:
	load    3($sp), $i11
	store   $ra, 11($sp)
	load    0($i11), $i10
	li      cls.11093, $ra
	add     $sp, 12, $sp
	jr      $i10
cls.11093:
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    8($sp), $i1
	add     $i1, 1, $i1
	load    7($sp), $i2
	load    1($sp), $i3
	load    5($sp), $i4
	load    6($sp), $i5
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
scan_line.3183:
	load    3($i11), $i6
	load    2($i11), $i7
	load    1($i11), $i8
	load    1($i8), $i9
	cmp     $i9, $i1, $i12
	bg      $i12, ble_else.11094
	ret
ble_else.11094:
	store   $i11, 0($sp)
	store   $i5, 1($sp)
	store   $i4, 2($sp)
	store   $i3, 3($sp)
	store   $i2, 4($sp)
	store   $i1, 5($sp)
	store   $i6, 6($sp)
	load    1($i8), $i2
	sub     $i2, 1, $i2
	cmp     $i2, $i1, $i12
	bg      $i12, ble_else.11096
	b       ble_cont.11097
ble_else.11096:
	add     $i1, 1, $i2
	mov     $i5, $i3
	mov     $i4, $i1
	mov     $i7, $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.11098, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.11098:
	sub     $sp, 8, $sp
	load    7($sp), $ra
ble_cont.11097:
	li      0, $i1
	load    5($sp), $i2
	load    4($sp), $i3
	load    3($sp), $i4
	load    2($sp), $i5
	load    6($sp), $i11
	store   $ra, 7($sp)
	load    0($i11), $i10
	li      cls.11099, $ra
	add     $sp, 8, $sp
	jr      $i10
cls.11099:
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    5($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 7($sp)
	li      2, $i2
	load    1($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     add_mod5.2773
	sub     $sp, 9, $sp
	load    8($sp), $ra
	mov     $i1, $i5
	load    7($sp), $i1
	load    3($sp), $i2
	load    2($sp), $i3
	load    4($sp), $i4
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
create_float5x3array.3189:
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_create_float_array
	sub     $sp, 1, $sp
	load    0($sp), $ra
	mov     $i2, $i1
	li      5, $i1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_create_array
	sub     $sp, 1, $sp
	load    0($sp), $ra
	store   $i1, 0($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	store   $i1, 1($i2)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	store   $i1, 2($i2)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	load    0($sp), $i2
	store   $i1, 3($i2)
	li      3, $i1
	li      l.6636, $i2
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
create_pixel.3191:
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 0($sp)
	add     $sp, 1, $sp
	jal     min_caml_create_float_array
	sub     $sp, 1, $sp
	load    0($sp), $ra
	store   $i1, 0($sp)
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     create_float5x3array.3189
	sub     $sp, 2, $sp
	load    1($sp), $ra
	store   $i1, 1($sp)
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
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     create_float5x3array.3189
	sub     $sp, 5, $sp
	load    4($sp), $ra
	store   $i1, 4($sp)
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     create_float5x3array.3189
	sub     $sp, 6, $sp
	load    5($sp), $ra
	store   $i1, 5($sp)
	li      1, $i1
	li      0, $i2
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_create_array
	sub     $sp, 7, $sp
	load    6($sp), $ra
	store   $i1, 6($sp)
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     create_float5x3array.3189
	sub     $sp, 8, $sp
	load    7($sp), $ra
	mov     $hp, $i2
	add     $hp, 8, $hp
	store   $i1, 7($i2)
	load    6($sp), $i1
	store   $i1, 6($i2)
	load    5($sp), $i1
	store   $i1, 5($i2)
	load    4($sp), $i1
	store   $i1, 4($i2)
	load    3($sp), $i1
	store   $i1, 3($i2)
	load    2($sp), $i1
	store   $i1, 2($i2)
	load    1($sp), $i1
	store   $i1, 1($i2)
	load    0($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	ret
init_line_elements.3193:
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.11100
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     create_pixel.3191
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    0($sp), $i2
	load    1($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	mov     $i3, $i1
	b       init_line_elements.3193
bge_else.11100:
	ret
create_pixelline.3196:
	load    1($i11), $i1
	store   $i1, 0($sp)
	load    0($i1), $i1
	store   $i1, 1($sp)
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     create_pixel.3191
	sub     $sp, 3, $sp
	load    2($sp), $ra
	mov     $i1, $i2
	load    1($sp), $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    0($sp), $i2
	load    0($i2), $i2
	sub     $i2, 2, $i2
	b       init_line_elements.3193
tan.3198:
	store   $f1, 0($sp)
	load    2($i11), $i1
	load    1($i11), $i2
	store   $i2, 1($sp)
	mov     $i1, $i11
	store   $ra, 2($sp)
	load    0($i11), $i10
	li      cls.11101, $ra
	add     $sp, 3, $sp
	jr      $i10
cls.11101:
	sub     $sp, 3, $sp
	load    2($sp), $ra
	store   $f1, 2($sp)
	load    0($sp), $f1
	load    1($sp), $i11
	store   $ra, 3($sp)
	load    0($i11), $i10
	li      cls.11102, $ra
	add     $sp, 4, $sp
	jr      $i10
cls.11102:
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	ret
adjust_position.3200:
	store   $f2, 0($sp)
	load    2($i11), $i1
	store   $i1, 1($sp)
	load    1($i11), $i1
	store   $i1, 2($sp)
	fmul    $f1, $f1, $f1
	li      l.6701, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f1
	store   $ra, 3($sp)
	add     $sp, 4, $sp
	jal     sqrt.2729
	sub     $sp, 4, $sp
	load    3($sp), $ra
	store   $f1, 3($sp)
	li      l.6639, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    2($sp), $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.11103, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.11103:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    0($sp), $f2
	fmul    $f1, $f2, $f1
	load    1($sp), $i11
	store   $ra, 4($sp)
	load    0($i11), $i10
	li      cls.11104, $ra
	add     $sp, 5, $sp
	jr      $i10
cls.11104:
	sub     $sp, 5, $sp
	load    4($sp), $ra
	load    3($sp), $f2
	fmul    $f1, $f2, $f1
	ret
calc_dirvec.3203:
	load    2($i11), $i4
	load    1($i11), $i5
	li      5, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11105
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i4, 2($sp)
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
	li      l.6639, $i1
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
	load    4($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f2
	store   $f2, 7($sp)
	li      l.6639, $i1
	load    0($i1), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	store   $f1, 8($sp)
	load    1($sp), $i1
	load    2($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $i1, 9($sp)
	load    0($sp), $i2
	add     $i1, $i2, $i12
	load    0($i12), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     d_vec.2883
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    6($sp), $f1
	load    7($sp), $f2
	load    8($sp), $f3
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     vecset.2776
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    0($sp), $i1
	add     $i1, 40, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     d_vec.2883
	sub     $sp, 11, $sp
	load    10($sp), $ra
	store   $i1, 10($sp)
	load    7($sp), $f1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     min_caml_fneg
	sub     $sp, 12, $sp
	load    11($sp), $ra
	mov     $f1, $f3
	load    6($sp), $f1
	load    8($sp), $f2
	load    10($sp), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     vecset.2776
	sub     $sp, 12, $sp
	load    11($sp), $ra
	load    0($sp), $i1
	add     $i1, 80, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 11($sp)
	add     $sp, 12, $sp
	jal     d_vec.2883
	sub     $sp, 12, $sp
	load    11($sp), $ra
	store   $i1, 11($sp)
	load    6($sp), $f1
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
	mov     $f1, $f3
	load    8($sp), $f1
	load    12($sp), $f2
	load    11($sp), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     vecset.2776
	sub     $sp, 14, $sp
	load    13($sp), $ra
	load    0($sp), $i1
	add     $i1, 1, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 13($sp)
	add     $sp, 14, $sp
	jal     d_vec.2883
	sub     $sp, 14, $sp
	load    13($sp), $ra
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
	mov     $f1, $f3
	load    14($sp), $f1
	load    15($sp), $f2
	load    13($sp), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     vecset.2776
	sub     $sp, 17, $sp
	load    16($sp), $ra
	load    0($sp), $i1
	add     $i1, 41, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 16($sp)
	add     $sp, 17, $sp
	jal     d_vec.2883
	sub     $sp, 17, $sp
	load    16($sp), $ra
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
	mov     $f1, $f2
	load    17($sp), $f1
	load    7($sp), $f3
	load    16($sp), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     vecset.2776
	sub     $sp, 19, $sp
	load    18($sp), $ra
	load    0($sp), $i1
	add     $i1, 81, $i1
	load    9($sp), $i2
	add     $i2, $i1, $i12
	load    0($i12), $i1
	store   $ra, 18($sp)
	add     $sp, 19, $sp
	jal     d_vec.2883
	sub     $sp, 19, $sp
	load    18($sp), $ra
	store   $i1, 18($sp)
	load    8($sp), $f1
	store   $ra, 19($sp)
	add     $sp, 20, $sp
	jal     min_caml_fneg
	sub     $sp, 20, $sp
	load    19($sp), $ra
	load    6($sp), $f2
	load    7($sp), $f3
	load    18($sp), $i1
	b       vecset.2776
bge_else.11105:
	store   $f3, 19($sp)
	store   $i3, 0($sp)
	store   $i2, 1($sp)
	store   $i11, 20($sp)
	store   $f4, 21($sp)
	store   $i5, 22($sp)
	store   $i1, 23($sp)
	mov     $i5, $i11
	mov     $f2, $f1
	mov     $f3, $f2
	store   $ra, 24($sp)
	load    0($i11), $i10
	li      cls.11106, $ra
	add     $sp, 25, $sp
	jr      $i10
cls.11106:
	sub     $sp, 25, $sp
	load    24($sp), $ra
	store   $f1, 24($sp)
	load    23($sp), $i1
	add     $i1, 1, $i1
	store   $i1, 25($sp)
	load    21($sp), $f2
	load    22($sp), $i11
	store   $ra, 26($sp)
	load    0($i11), $i10
	li      cls.11107, $ra
	add     $sp, 27, $sp
	jr      $i10
cls.11107:
	sub     $sp, 27, $sp
	load    26($sp), $ra
	mov     $f1, $f2
	load    24($sp), $f1
	load    19($sp), $f3
	load    21($sp), $f4
	load    25($sp), $i1
	load    1($sp), $i2
	load    0($sp), $i3
	load    20($sp), $i11
	load    0($i11), $i10
	jr      $i10
calc_dirvecs.3211:
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11108
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
	li      l.6858, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.6860, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f3
	li      0, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	li      l.6636, $i2
	load    0($i2), $f2
	load    2($sp), $f4
	load    4($sp), $i2
	load    3($sp), $i3
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.11109, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.11109:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     min_caml_float_of_int
	sub     $sp, 7, $sp
	load    6($sp), $ra
	li      l.6858, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.6701, $i1
	load    0($i1), $f2
	fadd    $f1, $f2, $f3
	li      0, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	li      l.6636, $i2
	load    0($i2), $f2
	load    3($sp), $i2
	add     $i2, 2, $i3
	load    2($sp), $f4
	load    4($sp), $i2
	load    5($sp), $i11
	store   $ra, 6($sp)
	load    0($i11), $i10
	li      cls.11110, $ra
	add     $sp, 7, $sp
	jr      $i10
cls.11110:
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    1($sp), $i1
	sub     $i1, 1, $i1
	store   $i1, 6($sp)
	li      1, $i2
	load    4($sp), $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     add_mod5.2773
	sub     $sp, 8, $sp
	load    7($sp), $ra
	mov     $i1, $i2
	load    2($sp), $f1
	load    6($sp), $i1
	load    3($sp), $i3
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11108:
	ret
calc_dirvec_rows.3216:
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11112
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
	li      l.6858, $i1
	load    0($i1), $f2
	fmul    $f1, $f2, $f1
	li      l.6860, $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	li      4, $i1
	load    3($sp), $i2
	load    2($sp), $i3
	load    4($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.11113, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.11113:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    1($sp), $i1
	sub     $i1, 1, $i1
	store   $i1, 5($sp)
	li      2, $i2
	load    3($sp), $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     add_mod5.2773
	sub     $sp, 7, $sp
	load    6($sp), $ra
	mov     $i1, $i2
	load    2($sp), $i1
	add     $i1, 4, $i3
	load    5($sp), $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11112:
	ret
create_dirvec.3220:
	load    1($i11), $i1
	store   $i1, 0($sp)
	li      3, $i1
	li      l.6636, $i2
	load    0($i2), $f1
	store   $ra, 1($sp)
	add     $sp, 2, $sp
	jal     min_caml_create_float_array
	sub     $sp, 2, $sp
	load    1($sp), $ra
	mov     $i1, $i2
	store   $i2, 1($sp)
	load    0($sp), $i1
	load    0($i1), $i1
	store   $ra, 2($sp)
	add     $sp, 3, $sp
	jal     min_caml_create_array
	sub     $sp, 3, $sp
	load    2($sp), $ra
	mov     $hp, $i2
	add     $hp, 2, $hp
	store   $i1, 1($i2)
	load    1($sp), $i1
	store   $i1, 0($i2)
	mov     $i2, $i1
	ret
create_dirvec_elements.3222:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.11115
	store   $i11, 0($sp)
	store   $i2, 1($sp)
	store   $i1, 2($sp)
	mov     $i3, $i11
	store   $ra, 3($sp)
	load    0($i11), $i10
	li      cls.11116, $ra
	add     $sp, 4, $sp
	jr      $i10
cls.11116:
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    1($sp), $i2
	load    2($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	sub     $i2, 1, $i2
	load    0($sp), $i11
	mov     $i3, $i1
	load    0($i11), $i10
	jr      $i10
bge_else.11115:
	ret
create_dirvecs.3225:
	load    3($i11), $i2
	load    2($i11), $i3
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11118
	store   $i11, 0($sp)
	store   $i3, 1($sp)
	store   $i1, 2($sp)
	store   $i2, 3($sp)
	li      120, $i1
	store   $i1, 4($sp)
	mov     $i4, $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.11119, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.11119:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	mov     $i1, $i2
	load    4($sp), $i1
	store   $ra, 5($sp)
	add     $sp, 6, $sp
	jal     min_caml_create_array
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    2($sp), $i2
	load    3($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	add     $i3, $i2, $i12
	load    0($i12), $i1
	li      118, $i2
	load    1($sp), $i11
	store   $ra, 5($sp)
	load    0($i11), $i10
	li      cls.11120, $ra
	add     $sp, 6, $sp
	jr      $i10
cls.11120:
	sub     $sp, 6, $sp
	load    5($sp), $ra
	load    2($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11118:
	ret
init_dirvec_constants.3227:
	load    1($i11), $i3
	li      0, $i12
	cmp     $i2, $i12, $i12
	bl      $i12, bge_else.11122
	store   $i1, 0($sp)
	store   $i11, 1($sp)
	store   $i2, 2($sp)
	add     $i1, $i2, $i12
	load    0($i12), $i1
	mov     $i3, $i11
	store   $ra, 3($sp)
	load    0($i11), $i10
	li      cls.11123, $ra
	add     $sp, 4, $sp
	jr      $i10
cls.11123:
	sub     $sp, 4, $sp
	load    3($sp), $ra
	load    2($sp), $i1
	sub     $i1, 1, $i2
	load    0($sp), $i1
	load    1($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11122:
	ret
init_vecset_constants.3230:
	load    2($i11), $i2
	load    1($i11), $i3
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11125
	store   $i11, 0($sp)
	store   $i1, 1($sp)
	add     $i3, $i1, $i12
	load    0($i12), $i1
	li      119, $i3
	mov     $i2, $i11
	mov     $i3, $i2
	store   $ra, 2($sp)
	load    0($i11), $i10
	li      cls.11126, $ra
	add     $sp, 3, $sp
	jr      $i10
cls.11126:
	sub     $sp, 3, $sp
	load    2($sp), $ra
	load    1($sp), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
bge_else.11125:
	ret
init_dirvecs.3232:
	load    3($i11), $i1
	store   $i1, 0($sp)
	load    2($i11), $i1
	load    1($i11), $i2
	store   $i2, 1($sp)
	li      4, $i2
	mov     $i1, $i11
	mov     $i2, $i1
	store   $ra, 2($sp)
	load    0($i11), $i10
	li      cls.11128, $ra
	add     $sp, 3, $sp
	jr      $i10
cls.11128:
	sub     $sp, 3, $sp
	load    2($sp), $ra
	li      9, $i1
	li      0, $i2
	li      0, $i3
	load    1($sp), $i11
	store   $ra, 2($sp)
	load    0($i11), $i10
	li      cls.11129, $ra
	add     $sp, 3, $sp
	jr      $i10
cls.11129:
	sub     $sp, 3, $sp
	load    2($sp), $ra
	li      4, $i1
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
add_reflection.3234:
	store   $i1, 0($sp)
	store   $i2, 1($sp)
	store   $f1, 2($sp)
	store   $f4, 3($sp)
	store   $f3, 4($sp)
	store   $f2, 5($sp)
	load    3($i11), $i1
	store   $i1, 6($sp)
	load    2($i11), $i1
	store   $i1, 7($sp)
	load    1($i11), $i11
	store   $ra, 8($sp)
	load    0($i11), $i10
	li      cls.11130, $ra
	add     $sp, 9, $sp
	jr      $i10
cls.11130:
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $i1, 8($sp)
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     d_vec.2883
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    5($sp), $f1
	load    4($sp), $f2
	load    3($sp), $f3
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     vecset.2776
	sub     $sp, 10, $sp
	load    9($sp), $ra
	load    8($sp), $i1
	load    6($sp), $i11
	store   $ra, 9($sp)
	load    0($i11), $i10
	li      cls.11131, $ra
	add     $sp, 10, $sp
	jr      $i10
cls.11131:
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $hp, $i1
	add     $hp, 3, $hp
	load    2($sp), $f1
	store   $f1, 2($i1)
	load    8($sp), $i2
	store   $i2, 1($i1)
	load    1($sp), $i2
	store   $i2, 0($i1)
	load    0($sp), $i2
	load    7($sp), $i3
	add     $i3, $i2, $i12
	store   $i1, 0($i12)
	ret
setup_rect_reflection.3241:
	load    3($i11), $i3
	store   $i3, 0($sp)
	load    2($i11), $i4
	store   $i4, 1($sp)
	load    1($i11), $i4
	store   $i4, 2($sp)
	sll     $i1, 2, $i1
	store   $i1, 3($sp)
	load    0($i3), $i1
	store   $i1, 4($sp)
	li      l.6639, $i1
	load    0($i1), $f1
	store   $f1, 5($sp)
	mov     $i2, $i1
	store   $ra, 6($sp)
	add     $sp, 7, $sp
	jal     o_diffuse.2846
	sub     $sp, 7, $sp
	load    6($sp), $ra
	load    5($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 6($sp)
	load    1($sp), $i1
	load    0($i1), $f1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     min_caml_fneg
	sub     $sp, 8, $sp
	load    7($sp), $ra
	store   $f1, 7($sp)
	load    1($sp), $i1
	load    1($i1), $f1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     min_caml_fneg
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $f1, 8($sp)
	load    1($sp), $i1
	load    2($i1), $f1
	store   $ra, 9($sp)
	add     $sp, 10, $sp
	jal     min_caml_fneg
	sub     $sp, 10, $sp
	load    9($sp), $ra
	mov     $f1, $f4
	store   $f4, 9($sp)
	load    3($sp), $i1
	add     $i1, 1, $i2
	load    1($sp), $i1
	load    0($i1), $f2
	load    6($sp), $f1
	load    8($sp), $f3
	load    4($sp), $i1
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.11133, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.11133:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    4($sp), $i1
	add     $i1, 1, $i1
	load    3($sp), $i2
	add     $i2, 2, $i2
	load    1($sp), $i3
	load    1($i3), $f3
	load    6($sp), $f1
	load    7($sp), $f2
	load    9($sp), $f4
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.11134, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.11134:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    4($sp), $i1
	add     $i1, 2, $i1
	load    3($sp), $i2
	add     $i2, 3, $i2
	load    1($sp), $i3
	load    2($i3), $f4
	load    6($sp), $f1
	load    7($sp), $f2
	load    8($sp), $f3
	load    2($sp), $i11
	store   $ra, 10($sp)
	load    0($i11), $i10
	li      cls.11135, $ra
	add     $sp, 11, $sp
	jr      $i10
cls.11135:
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    4($sp), $i1
	add     $i1, 3, $i1
	load    0($sp), $i2
	store   $i1, 0($i2)
	ret
setup_surface_reflection.3244:
	store   $i2, 0($sp)
	load    3($i11), $i3
	store   $i3, 1($sp)
	load    2($i11), $i4
	store   $i4, 2($sp)
	load    1($i11), $i4
	store   $i4, 3($sp)
	sll     $i1, 2, $i1
	add     $i1, 1, $i1
	store   $i1, 4($sp)
	load    0($i3), $i1
	store   $i1, 5($sp)
	li      l.6639, $i1
	load    0($i1), $f1
	store   $f1, 6($sp)
	mov     $i2, $i1
	store   $ra, 7($sp)
	add     $sp, 8, $sp
	jal     o_diffuse.2846
	sub     $sp, 8, $sp
	load    7($sp), $ra
	load    6($sp), $f2
	fsub    $f2, $f1, $f1
	store   $f1, 7($sp)
	load    0($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     o_param_abc.2838
	sub     $sp, 9, $sp
	load    8($sp), $ra
	mov     $i1, $i2
	load    2($sp), $i1
	store   $ra, 8($sp)
	add     $sp, 9, $sp
	jal     veciprod.2797
	sub     $sp, 9, $sp
	load    8($sp), $ra
	store   $f1, 8($sp)
	li      l.6665, $i1
	load    0($i1), $f1
	store   $f1, 9($sp)
	load    0($sp), $i1
	store   $ra, 10($sp)
	add     $sp, 11, $sp
	jal     o_param_a.2832
	sub     $sp, 11, $sp
	load    10($sp), $ra
	load    9($sp), $f2
	fmul    $f2, $f1, $f1
	load    8($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($sp), $i1
	load    0($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 10($sp)
	li      l.6665, $i1
	load    0($i1), $f1
	store   $f1, 11($sp)
	load    0($sp), $i1
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     o_param_b.2834
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	fmul    $f2, $f1, $f1
	load    8($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($sp), $i1
	load    1($i1), $f2
	fsub    $f1, $f2, $f1
	store   $f1, 12($sp)
	li      l.6665, $i1
	load    0($i1), $f1
	store   $f1, 13($sp)
	load    0($sp), $i1
	store   $ra, 14($sp)
	add     $sp, 15, $sp
	jal     o_param_c.2836
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    13($sp), $f2
	fmul    $f2, $f1, $f1
	load    8($sp), $f2
	fmul    $f1, $f2, $f1
	load    2($sp), $i1
	load    2($i1), $f2
	fsub    $f1, $f2, $f4
	load    7($sp), $f1
	load    10($sp), $f2
	load    12($sp), $f3
	load    5($sp), $i1
	load    4($sp), $i2
	load    3($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.11137, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.11137:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	load    5($sp), $i1
	add     $i1, 1, $i1
	load    1($sp), $i2
	store   $i1, 0($i2)
	ret
setup_reflections.3247:
	load    3($i11), $i2
	load    2($i11), $i3
	load    1($i11), $i4
	li      0, $i12
	cmp     $i1, $i12, $i12
	bl      $i12, bge_else.11139
	store   $i2, 0($sp)
	store   $i1, 1($sp)
	store   $i3, 2($sp)
	add     $i4, $i1, $i12
	load    0($i12), $i1
	store   $i1, 3($sp)
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_reflectiontype.2826
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11140
	load    3($sp), $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_diffuse.2846
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      l.6639, $i1
	load    0($i1), $f2
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     min_caml_fless
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      0, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11141
	ret
be_else.11141:
	load    3($sp), $i1
	store   $ra, 4($sp)
	add     $sp, 5, $sp
	jal     o_form.2824
	sub     $sp, 5, $sp
	load    4($sp), $ra
	li      1, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11143
	load    1($sp), $i1
	load    3($sp), $i2
	load    2($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.11143:
	li      2, $i12
	cmp     $i1, $i12, $i12
	bne     $i12, be_else.11144
	load    1($sp), $i1
	load    3($sp), $i2
	load    0($sp), $i11
	load    0($i11), $i10
	jr      $i10
be_else.11144:
	ret
be_else.11140:
	ret
bge_else.11139:
	ret
rt.3249:
	load    13($i11), $i3
	store   $i3, 0($sp)
	load    12($i11), $i3
	store   $i3, 1($sp)
	load    11($i11), $i3
	store   $i3, 2($sp)
	load    10($i11), $i3
	store   $i3, 3($sp)
	load    9($i11), $i3
	store   $i3, 4($sp)
	load    8($i11), $i3
	store   $i3, 5($sp)
	load    7($i11), $i3
	store   $i3, 6($sp)
	load    6($i11), $i3
	store   $i3, 7($sp)
	load    5($i11), $i3
	store   $i3, 8($sp)
	load    4($i11), $i3
	store   $i3, 9($sp)
	load    3($i11), $i3
	load    2($i11), $i4
	load    1($i11), $i5
	store   $i5, 10($sp)
	store   $i1, 0($i3)
	store   $i2, 1($i3)
	srl     $i1, 1, $i3
	store   $i3, 0($i4)
	srl     $i2, 1, $i2
	store   $i2, 1($i4)
	li      l.6884, $i2
	load    0($i2), $f1
	store   $f1, 11($sp)
	store   $ra, 12($sp)
	add     $sp, 13, $sp
	jal     min_caml_float_of_int
	sub     $sp, 13, $sp
	load    12($sp), $ra
	load    11($sp), $f2
	finv    $f1, $f15
	fmul    $f2, $f15, $f1
	load    2($sp), $i1
	store   $f1, 0($i1)
	load    10($sp), $i11
	store   $ra, 12($sp)
	load    0($i11), $i10
	li      cls.11148, $ra
	add     $sp, 13, $sp
	jr      $i10
cls.11148:
	sub     $sp, 13, $sp
	load    12($sp), $ra
	store   $i1, 12($sp)
	load    10($sp), $i11
	store   $ra, 13($sp)
	load    0($i11), $i10
	li      cls.11149, $ra
	add     $sp, 14, $sp
	jr      $i10
cls.11149:
	sub     $sp, 14, $sp
	load    13($sp), $ra
	store   $i1, 13($sp)
	load    10($sp), $i11
	store   $ra, 14($sp)
	load    0($i11), $i10
	li      cls.11150, $ra
	add     $sp, 15, $sp
	jr      $i10
cls.11150:
	sub     $sp, 15, $sp
	load    14($sp), $ra
	store   $i1, 14($sp)
	load    4($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.11151, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.11151:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     write_ppm_header.3157
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    9($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.11152, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.11152:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    7($sp), $i1
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     d_vec.2883
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    8($sp), $i2
	store   $ra, 15($sp)
	add     $sp, 16, $sp
	jal     veccpy.2786
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    7($sp), $i1
	load    1($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.11153, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.11153:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	load    6($sp), $i1
	load    0($i1), $i1
	sub     $i1, 1, $i1
	load    0($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.11154, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.11154:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i2
	li      0, $i3
	load    13($sp), $i1
	load    5($sp), $i11
	store   $ra, 15($sp)
	load    0($i11), $i10
	li      cls.11155, $ra
	add     $sp, 16, $sp
	jr      $i10
cls.11155:
	sub     $sp, 16, $sp
	load    15($sp), $ra
	li      0, $i1
	li      2, $i5
	load    12($sp), $i2
	load    13($sp), $i3
	load    14($sp), $i4
	load    3($sp), $i11
	load    0($i11), $i10
	jr      $i10
l.6892:	.float  6.0725293501E-01
l.6890:	.float  1.5707963268E+00
l.6888:	.float  6.2831853072E+00
l.6886:	.float  3.1415926536E+00
l.6884:	.float  1.2800000000E+02
l.6860:	.float  9.0000000000E-01
l.6858:	.float  2.0000000000E-01
l.6835:	.float  1.5000000000E+02
l.6833:	.float  -1.5000000000E+02
l.6828:	.float  -2.0000000000E+00
l.6826:	.float  3.9062500000E-03
l.6815:	.float  2.0000000000E+01
l.6813:	.float  5.0000000000E-02
l.6808:	.float  2.5000000000E-01
l.6801:	.float  3.0000000000E-01
l.6799:	.float  2.5500000000E+02
l.6794:	.float  1.5000000000E-01
l.6788:	.float  3.1415927000E+00
l.6786:	.float  3.0000000000E+01
l.6784:	.float  1.5000000000E+01
l.6782:	.float  1.0000000000E-04
l.6775:	.float  1.0000000000E+08
l.6772:	.float  1.0000000000E+09
l.6768:	.float  -1.0000000000E-01
l.6766:	.float  1.0000000000E-02
l.6764:	.float  -2.0000000000E-01
l.6720:	.float  -2.0000000000E+02
l.6718:	.float  2.0000000000E+02
l.6716:	.float  1.7453293000E-02
l.6710:	.float  -1.0000000000E+00
l.6704:	.float  1.0000000000E+01
l.6701:	.float  1.0000000000E-01
l.6680:	.float  3.0000000000E+00
l.6665:	.float  2.0000000000E+00
l.6639:	.float  1.0000000000E+00
l.6636:	.float  0.0000000000E+00
l.6633:	.float  5.0000000000E-01
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
