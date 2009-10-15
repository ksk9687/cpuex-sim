package sim;

import java.awt.*;
import java.io.*;
import javax.swing.*;
import asm.*;
import cpu.*;

public class Simulator {
	
	private CPU cpu;
	private String[] lines;
	private DataInputStream in;
	private DataOutputStream out;
	private JFrame frame;
	private JDesktopPane desktop;
	private SimFrame[] frames;
	
	public Simulator(CPU cpu, String[] lines) {
		this.cpu = cpu;
		this.lines = lines;
		cpu.init(this, Assembler.assembleToBinary(cpu, lines));
		in = new DataInputStream(System.in);
		out = new DataOutputStream(System.out);
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
			for (;;) {
				cpu.clock();
			}
		} catch (ExecuteException e) {
			System.err.println(e.getMessage());
		}
	}
	
	public int read() {
		try {
			return in.read();
		} catch (IOException e) {
			throw new ExecuteException(e.getMessage());
		}
	}
	
	public void write(int i) {
		try {
			out.write(i & 0xff);
			out.flush();
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
		desktop.setPreferredSize(new Dimension(500, 500));
		
		frames = cpu.createFrames();
		for (SimFrame iframe : frames) {
			addFrame(iframe);
			iframe.refresh();
		}
		frame = new JFrame("しみゅれーた");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setContentPane(desktop);
		frame.pack();
		frame.setLocationRelativeTo(null);
		frame.setVisible(true);
	}
	
	public void addFrame(JInternalFrame iframe) {
		int n = desktop.getComponentCount();
		iframe.setLocation(50 * n, 50 * n);
		iframe.setVisible(true);
		desktop.add(iframe);
		desktop.getDesktopManager().activateFrame(iframe);
	}
	
}
