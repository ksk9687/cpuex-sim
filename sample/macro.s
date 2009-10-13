#レジスタ名置き換え
.define $zero $i0
.define $ra $i15
.define $sp $i1
.define $hp $i2
.define $fzero $f0

#jmp
.define { jmp %Reg %Imm %Imm } { _jmp %1 %2 %{ %3 - %pc } }

#疑似命令
.define { mov %Reg %Reg } { addi %1 %2 0 }
.define { b %Imm } { jmp $i0 0 %1 }
.define { be %Reg %Imm } { jmp %1 5 %2 }
.define { bne %Reg %Imm } { jmp %1 2 %2 }
.define { bl %Reg %Imm } { jmp %1 6 %2 }
.define { ble %Reg %Imm } { jmp %1 4 %2 }
.define { bg %Reg %Imm } { jmp %1 3 %2 }
.define { bge %Reg %Imm } { jmp %1 1 %2 }

# 入力,出力の順にコンマで区切る形式
.define { add %Reg, %Reg, %Reg } { add %1 %2 %3 }
.define { add %Reg, %Imm, %Reg } { addi %1 %3 %2 }
.define { sub %Reg, %Reg, %Reg } { sub %1 %2 %3 }
.define { srl %Reg, %Imm, %Reg } { srl %1 %3 %2 }
.define { sll %Reg, %Imm, %Reg } { sll %1 %3 %2 }
.define { fadd %Reg, %Reg, %Reg } { fadd %1 %2 %3 }
.define { fsub %Reg, %Reg, %Reg } { fsub %1 %2 %3 }
.define { fmul %Reg, %Reg, %Reg } { fmul %1 %2 %3 }
.define { finv %Reg, %Reg } { finv %1 %2 }
.define { load %Imm(%Reg), %Reg } { load %2 %3 %1 }
.define { load %Reg, %Reg } { load 0(%1), %2 }
.define { load %Imm, %Reg } { load %1($zero), %2 }
.define { li %Reg, %Imm } { li %1 %2 }
.define { store %Reg, %Imm(%Reg) } { store %3 %1 %2 }
.define { store %Reg, %Reg } { store %1, 0(%2) }
.define { store %Reg, %Imm } { store %1, %2($zero) }
.define { cmp %Reg, %Reg, %Reg } { cmp %1 %2 %3 }
.define { jmp %Reg, %Imm, %Imm } { jmp %1 %2 %3 }
.define { mov %Reg, %Reg } { mov %1 %2 }
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
.define { %Reg = %Reg - %Imm } { add %2, -%3, %1 }
.define { %Reg = %Reg - %Reg } { sub %2, %3, %1 }
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
.define { %Reg = read } { read %1 }
.define { %Reg = %Reg } { mov %2, %1 }
