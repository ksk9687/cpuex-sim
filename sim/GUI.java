package sim;

import javax.swing.*;

public class GUI {
	
	public JFrame frame;
	public Simulator sim;
	
	public GUI(Simulator sim) {
		frame = new JFrame("しみゅれーた");
		try {
			UIManager.setLookAndFeel("com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel");
		} catch (Exception e) {
		}
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.pack();
		frame.setVisible(true);
	}
	
}
