package sim;

import static java.lang.Math.*;
import java.awt.*;
import java.awt.event.*;
import java.beans.*;
import java.io.*;
import java.util.*;
import javax.swing.*;
import asm.*;
import cpu.*;

public class Simulator {
	
	private CPU cpu;
	private JFrame frame;
	private JDesktopPane desktop;
	
	public Simulator(CPU cpu, Program prog, InputStream in, OutputStream out) {
		this.cpu = cpu;
		cpu.init(prog, in, out);
	}
	
	public void runGUI() {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				setupGUI();
			}
		});
	}
	
	public void runCUI() {
		try {
			System.err.println("Simulating...");
			for (;;) {
				cpu.step();
			}
		} catch (ExecuteException e) {
			System.err.println(e.getMessage());
		}
	}
	
	private void setupGUI() {
		try {
			UIManager.setLookAndFeel("com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel");
		} catch (Exception e) {
		}
		desktop = new JDesktopPane();
		desktop.setPreferredSize(new Dimension(800, 500));
		JMenuBar menubar = new JMenuBar();
		JMenu styleMenu = new LookAndFeelMenu("Style");
		JMenu viewMenu = new JMenu("View");
		for (String name : cpu.getViews()) {
			viewMenu.add(new JMenuItem(new AbstractAction(name) {
				public void actionPerformed(ActionEvent e) {
					addView(cpu.createView(e.getActionCommand()));
				}
			}));
		}
		viewMenu.add(new JSeparator());
		viewMenu.add(new JMenuItem(new AbstractAction("Minimize") {
			public void actionPerformed(ActionEvent arg0) {
				for (JInternalFrame f : desktop.getAllFrames()) {
					try {
						f.setIcon(true);
					} catch (PropertyVetoException e) {
					}
				}
			}
		}));
		viewMenu.add(new JMenuItem(new AbstractAction("Clear") {
			public void actionPerformed(ActionEvent arg0) {
				for (JInternalFrame f : desktop.getAllFrames()) {
					if (f.isClosable()) {
						try {
							f.setClosed(true);
						} catch (PropertyVetoException e) {
						}
					} else {
						f.setLocation(0, 0);
						try {
							f.setMaximum(false);
							f.setIcon(false);
						} catch (PropertyVetoException e) {
						}
					}
				}
			}
		}));
		menubar.add(styleMenu);
		menubar.add(viewMenu);
		frame = new JFrame("しみゅれーた");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setContentPane(desktop);
		frame.setJMenuBar(menubar);
		frame.pack();
		addView(new RunView());
		frame.setLocationRelativeTo(null);
		frame.setVisible(true);
	}
	
	public void addView(SimView view) {
		setLocation(view);
		desktop.add(view);
		view.refresh();
		view.setVisible(true);
		desktop.getDesktopManager().activateFrame(view);
	}
	
	public void refreshAll() {
		for (JInternalFrame f : desktop.getAllFrames()) {
			if (f instanceof SimView) {
				((SimView)f).refresh();
			}
		}
		frame.repaint();
	}
	
	private void setLocation(SimView view) {
		int x = 0, y = 0;
		long minArea = Long.MAX_VALUE;
		TreeSet<Integer> xs = new TreeSet<Integer>(), ys = new TreeSet<Integer>();
		xs.add(0);
		ys.add(0);
		xs.add(desktop.getWidth() - view.getWidth());
		ys.add(desktop.getHeight() - view.getHeight() - view.getMinimumSize().height);
		for (JInternalFrame f : desktop.getAllFrames()) if (f != view && !f.isIcon()) {
			xs.add(f.getX() + f.getWidth());
			xs.add(f.getX() - view.getWidth());
			ys.add(f.getY() + f.getHeight());
			ys.add(f.getY() - view.getHeight());
		}
		for (int py : ys) if (0 <= py && py + view.getHeight() <= desktop.getHeight() - view.getMinimumSize().height) {
			for (int px : xs) if (0 <= px && px + view.getWidth() <= desktop.getWidth()) {
				long tmp = 0;
				for (JInternalFrame f : desktop.getAllFrames()) if (f != view && !f.isIcon()) {
					long dx = max(0, min(px + view.getWidth(), f.getX() + f.getWidth()) - max(px, f.getX()));
					long dy = max(0, min(py + view.getHeight(), f.getY() + f.getHeight()) - max(py, f.getY()));
					tmp += dx * dy;
				}
				if (minArea > tmp) {
					minArea = tmp;
					x = px;
					y = py;
				}
			}
		}
		view.setLocation(x, y);
	}
	
	private class RunView extends SimView {
		
		private boolean running;
		private CPU.Status status;
		
		private RunView() {
			super("Run");
			setClosable(false);
			JPanel panel = new JPanel(new GridLayout(1, 2));
			panel.add(new JButton(new AbstractAction("run") {
				public void actionPerformed(ActionEvent ae) {
					running = true;
					new Thread(new Runnable() {
						public void run() {
							try {
								while (running) {
									cpu.step();
								}
							} catch (final ExecuteException e) {
								SwingUtilities.invokeLater(new Runnable() {
									public void run() {
										JOptionPane.showMessageDialog(frame, e.getMessage());
									}
								});
							}
						}
					}).start();
					JOptionPane.showOptionDialog(frame, "Running...", "Running", JOptionPane.CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE, null, new String[] {"Stop"}, "Stop");
					running = false;
					refreshAll();
				}
			}));
			panel.add(new JButton(new AbstractAction("step") {
				public void actionPerformed(ActionEvent ae) {
					try {
						cpu.step();
					} catch (ExecuteException e) {
						JOptionPane.showMessageDialog(frame, e.getMessage());
					}
					refreshAll();
				}
			}));
			add(status = cpu.getStatus(), BorderLayout.CENTER);
			add(panel, BorderLayout.SOUTH);
			pack();
		}
		
		public void refresh() {
			status.refresh();
		}
		
	}
	
}
