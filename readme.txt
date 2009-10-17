####注意####
ステップバック機能を搭載したいので入出力はリダイレクトじゃなくなりました

*シミュレータとアセンブラの使い方
起動方法: java -jar sim.jar または sim.bat
シェルスクリプトがいい人は自分で書いてね
引数: アセンブリファイル
オプション:
	-cpu hoge	対象CPUを指定する(デフォルトは最新のやつ)
	-encoding hoge	アセンブリファイルのエンコーディングを指定(デフォルトはUTF-8)
	-asm hoge	アセンブルの結果をhogeにバイナリ出力する(先頭にはプログラムサイズが入る)
	-vhdl hoge	アセンブルの結果をhogeにVHDL向け二進数出力する
	-gui	GUIモードでシミュレーションを行う
	-cui	CUIモードでシミュレーションを行う
	-in	hoge	入力ファイルを指定(指定しないとread時にエラーになる)
	-out hoge	出力ファイルを指定(指定しないとwriteしたものが消滅する)
	
	-xyx	標準出力にRS232C向け二進数出力

例えば、
sim fib.s -asm fib.bin
で、バイナリファイルが作られ、
sim fib.s -cui -in in.dat -out out.dat
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
%pcでpcの値に、 %{ exp } でexpを計算した値に、それぞれ置き換わる (例: li $ra %{ %pc + 2 } )

*デバッグ用CPU
-cpu Scalar.Debugを指定すると、デバッグ用命令が使用できる
アセンブラの場合は次の命令が使用可能
debug_int %Reg		レジスタの値をint値として標準エラーに出力
debug_float %Reg	レジスタの値を浮動小数として標準エラーに出力
break	ブレークポイント(GUIモードでのみサポート)
MinCamlの場合はdebug.sとくっつけることで次の外部関数が使用できる
val debug_int : int -> unit
val debug_float : float -> unit
val break : unit -> unit
