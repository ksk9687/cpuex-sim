*シミュレータとアセンブラの使い方
起動方法: java -jar sim.jar
引数: アセンブリファイル
オプション:
	-cpu hoge	対象CPUを指定する(デフォルトは最新のやつ)
	-encoding hoge	アセンブリファイルのエンコーディングを指定(デフォルトはUTF-8)
	-asm hoge	アセンブルの結果をhogeにバイナリ出力する(先頭にはプログラムサイズが入る)
	-asm hoge -fillNop	末尾をNopで埋める
	-vhdl hoge	アセンブルの結果をhogeにVHDL向け二進数出力する
	-gui	GUIモードでシミュレーションを行う
	-cui	CUIモードでシミュレーションを行う
	-noOutput	結果を出力しない

例えば、
sim fib.s -asm fib.bin
で、バイナリファイルが作られ、
sim fib.s -cui < in.dat > out.dat
で、fib.sを入力in.datに対して実行してout.datに出力する

*アセンブリ言語の仕様
アセンブリファイルの先頭にsample\macro.sを最初に張り付けないとあまり幸せになれない
基本的に機械語と1対1対応
機械語の通りに命令とオペランドを空白区切りで並べて書く(マクロにより、他の形式で書くことも可能)
レジスタの前には$を付ける
ラベルは:を後ろにつける (空白をはさんでも大丈夫)
ラベル名は、a-z_.くらいで予約語とかぶらないように付けるのが安全
jmpやliなどの即値としてラベルを指定することができる
数値の指定方法は、10進(そのまま)、16進(0xを前に付ける)、2進(0bを前に付ける)に対応
大文字と小文字は区別されない
#から後ろがコメントになる
.define x y で以降のxが全てyに置換される(例: .define $ra $i15 ,　注: xは単項でないといけない)
.define { exp1 } { exp2 } で以降の式exp1がexp2として解釈される(例: .define { clear %Reg } { li %1 0 } )
.defineの使い方はsample\macro.sを参照
.skip x でxワード分の領域を確保(初期値0)
.int でint値埋め込み
.float でfloat値埋め込み
.begin name ~ .end name でブロックに名前nameを付けブロックの実行数とブロック内の実行命令数をカウントする
.count name で次の命令に名前nameを付け、その実行数をカウントする
%pcでpcの値に、 %{ exp } でexpを計算した値に、それぞれ置き換わる (例: li $ra %{ %pc + 2 } )

*デバッグ
break	ブレークポイント(GUIモードでのみサポート)
MinCamlの場合はdebug.sとくっつけることで次の外部関数が使用できる
val break : unit -> unit
