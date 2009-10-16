package sim;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class LookAndFeelMenu extends JMenu {
	
	private ButtonGroup buttonGroup;
	private String lookAndFeel;
	
	public LookAndFeelMenu(String name) {
		super(name);
		lookAndFeel = UIManager.getLookAndFeel().getClass().getName();
		buttonGroup = new ButtonGroup();
		for (UIManager.LookAndFeelInfo i : UIManager.getInstalledLookAndFeels()) {
			add(createItem(i.getName(), i.getClassName()));
		}
	}
	
	private JRadioButtonMenuItem createItem(String name, String className) {
		JRadioButtonMenuItem item = new JRadioButtonMenuItem();
		item.setSelected(className.equals(lookAndFeel));
		item.setHideActionText(true);
		item.setAction(new AbstractAction() {
			public void actionPerformed(ActionEvent e) {
				ButtonModel m = buttonGroup.getSelection();
				setLookAndFeel(m.getActionCommand());
			}
		});
		item.setText(name);
		item.setActionCommand(className);
		buttonGroup.add(item);
		return item;
	}
	
	public void setLookAndFeel(String lookAndFeel) {
		String oldLookAndFeel = this.lookAndFeel;
		if (!oldLookAndFeel.equals(lookAndFeel)) {
			try {
				UIManager.setLookAndFeel(lookAndFeel);
				this.lookAndFeel = lookAndFeel;
				updateLookAndFeel();
				firePropertyChange("lookAndFeel", oldLookAndFeel, lookAndFeel);
			} catch (Exception e) {
			}
		}
	}
	
	private void updateLookAndFeel() {
		for (Window w : Frame.getWindows()) {
			SwingUtilities.updateComponentTreeUI(w);
		}
	}
	
}
