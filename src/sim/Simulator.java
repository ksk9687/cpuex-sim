package sim;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.*;
import javax.swing.*;
import asm.*;
import cpu.*;

public class Simulator {
	
	private CPU cpu;
	private InputStream in;
	private OutputStream out;
	private JFrame frame;
	private JDesktopPane desktop;
	
	public Simulator(CPU cpu, String[] lines, Statement[] ss, InputStream in, OutputStream out) {
		this.cpu = cpu;
		this.in = in;
		this.out = out;
		cpu.init(this, lines, ss);
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
				cpu.clock();
			}
		} catch (ExecuteException e) {
			System.err.println(e.getMessage());
		}
	}
	
	public int read() {
		if (in == null) {
			throw new ExecuteException("Cannot read!");
		}
		try {
			return in.read();
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	public int write(int i) {
		if (out == null) return 0;
		try {
			out.write(i & 0xff);
			out.flush();
			return 0;
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
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
	
	private Random r = new Random();
	private void setLocation(SimView view) {
		int x = 0, y = 0;
		if (view.getWidth() < desktop.getWidth()) {
			x = r.nextInt(desktop.getWidth() - view.getWidth());
		}
		if (view.getHeight() < desktop.getHeight()) {
			y = r.nextInt(desktop.getHeight() - view.getHeight());
		}
		view.setLocation(x, y);
	}
	
	private class RunView extends SimView {
		
		private long clock;
		private JLabel label;
		private boolean running;
		
		private RunView() {
			super("Run");
			setLayout(new GridLayout(3, 1));
			setClosable(false);
			add(new JButton(new AbstractAction("run") {
				public void actionPerformed(ActionEvent ae) {
					running = true;
					new Thread(new Runnable() {
						public void run() {
							try {
								while (running) {
									cpu.clock();
									clock++;
								}
							} catch (ExecuteException e) {
								JOptionPane.showMessageDialog(frame, e.getMessage());
							}
						}
					}).start();
					JOptionPane.showMessageDialog(frame, "Running...", "Running", JOptionPane.PLAIN_MESSAGE);
					running = false;
					refreshAll();
				}
			}));
			add(new JButton(new AbstractAction("step") {
				public void actionPerformed(ActionEvent ae) {
					try {
						cpu.clock();
						clock++;
					} catch (ExecuteException e) {
						JOptionPane.showMessageDialog(frame, e.getMessage());
					}
					refreshAll();
				}
			}));
			label = new JLabel("Clock");
			label.setHorizontalAlignment(JLabel.CENTER);
			add(label);
			pack();
		}
		
		public void refresh() {
			label.setText(String.format("%,d clock", clock));
		}
		
	}
	
}
