package sim;

import javax.swing.*;

public abstract class SimFrame extends JInternalFrame {
	
	public SimFrame(String title) {
		super(title, true, false, true, true);
	}
	
	public abstract void refresh();
	
}
