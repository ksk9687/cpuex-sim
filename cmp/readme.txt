This file is written in UTF-8.

ppm比較用プログラム

[概要]
どうも、ソフト係ではないxyxです。
やる気が出なかったので、適当にppmを比較するプログラムを作ってみますた。
[使い方]
gcc -O3 -mno-cygwin comp.c -o comp
か、VS入っている場合は、
cl /Ox comp.c
みたいに適当にコンパイルしてください。(VCでコンパイルしたものを入れておきます。)
ってかめっちゃ簡単なプログラムだし、標準ライブラリしか使ってないです。
あとは、
./comp 正しいppmファイル 比較したいppmファイル diffをとったppmファイル出力
で実行すると、THREATHOLDより大きな違いのある位置を標準出力に出し、diffをとったものを画像としてファイルに出力します。
例えば、
./comp original.ppm contest.ppm diff.ppm
こんな感じで使ってください。

細かいところはソースの中身いじってください。ヘッダーとかは決めうちなので。
THREATHOLDもめんどかったのでソースに直書きです。
