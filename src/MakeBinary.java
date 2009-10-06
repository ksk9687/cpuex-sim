import java.io.*;
import java.util.*;

public class MakeBinary {
	
	//16進の数値をビッグエンディアンのバイナリファイルにする
	//数値はスペースor改行区切り
	public static void main(String[] args) {
		int n = Integer.parseInt(args[0]);
		Scanner sc = new Scanner(System.in);
		DataOutputStream out = new DataOutputStream(System.out);
		try {
			while (sc.hasNext()) {
				out.writeInt(sc.nextInt(n));
			}
			out.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}
