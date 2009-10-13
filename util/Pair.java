package util;

public class Pair<F, S> {
	
	public F first;
	public S second;
	
	public Pair(F first, S second) {
		this.first = first;
		this.second = second;
	}
	
	public static <F, S> Pair<F, S> make(F first, S second) {
		return new Pair<F, S>(first, second);
	}
	
	public String toString() {
		return String.format("(%s, %s)", first, second);
	}
	
}
