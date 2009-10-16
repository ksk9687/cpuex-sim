package sim;

import java.awt.*;
import javax.swing.*;

public abstract class SimView extends JInternalFrame {
	
	public static final Font FONT = new Font(Font.MONOSPACED, Font.PLAIN, 14);
	
	public SimView(String title) {
		super(title, true, true, true, true);
	}
	
	public abstract void refresh();
	
}
