
package com.rath.syzsim.syzbgui;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

import com.rath.syzsim.syzbcore.SyzInternals;

public class ControlPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  
  private final Dimension size;
  private final SyzInternals internals;
  
  public ControlPanel(final Dimension size, final SyzInternals si) {
    super();
    setLayout(null);
    this.size = size;
    setSize(getPreferredSize());
    this.internals = si;
    
    // Open assembly file button
    final JButton openASMButton = new JButton("Open .syz File");
    openASMButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // Open file chooser
        final JFileChooser fc = new JFileChooser();
        int fcVal = fc.showOpenDialog(null);
        if (fcVal != JFileChooser.APPROVE_OPTION) return;
        File asmFile = fc.getSelectedFile();
        
        // Check if it is a .syz file
        while (!asmFile.getName().endsWith(".syz")) {
          JOptionPane.showMessageDialog(null, "Please choose a valid .syz file.");
          fcVal = fc.showOpenDialog(null);
          asmFile = fc.getSelectedFile();
          if (fcVal == JFileChooser.CANCEL_OPTION) break;
        }
        if (asmFile == null) return;
        
        // Open a scanner on this file
        Scanner fscan = null;
        try {
          fscan = new Scanner(asmFile);
        } catch (FileNotFoundException e) {
          e.printStackTrace();
        }
        
        // Parse the .syz file
        parseSyzFile(fscan);
      }
      
    });
    openASMButton.setBounds(6, 4, 128, 24);
    add(openASMButton);
    
    // Open binary file button
    final JButton openBinButton = new JButton("Open .bin File");
    openBinButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // Open file chooser
        final JFileChooser fc = new JFileChooser();
        int fcVal = fc.showOpenDialog(null);
        if (fcVal != JFileChooser.APPROVE_OPTION) return;
        File asmFile = fc.getSelectedFile();
        
        // Check if it is a .syz file
        while (!asmFile.getName().endsWith(".bin")) {
          JOptionPane.showMessageDialog(null, "Please choose a valid .bin file.");
          fcVal = fc.showOpenDialog(null);
          asmFile = fc.getSelectedFile();
          if (fcVal == JFileChooser.CANCEL_OPTION) break;
        }
        if (asmFile == null) return;
        
        // Open a scanner on this file
        Scanner fscan = null;
        try {
          fscan = new Scanner(asmFile);
        } catch (FileNotFoundException e) {
          e.printStackTrace();
        }
        
        // Parse the .syz file
        parseBinFile(fscan);
      }
      
    });
    openBinButton.setBounds(140, 4, 128, 24);
    add(openBinButton);
    
    // Save .syz
    final JButton saveASMButton = new JButton("Save .syz File");
    saveASMButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // TODO: Make button do a thing
      }
      
    });
    saveASMButton.setBounds(6, 32, 128, 24);
    add(saveASMButton);
    
    // Save .bin
    final JButton saveBinButton = new JButton("Save .bin File");
    saveBinButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // TODO: Make button do a thing
      }
      
    });
    saveBinButton.setBounds(140, 32, 128, 24);
    add(saveBinButton);
    
    // Run
    final JButton runButton = new JButton("Run");
    runButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // TODO: Make interpreter thread
        if (internals.isRunning()) {
          internals.setRunning(false);
        } else {
          internals.setRunning(true);
        }
      }
      
    });
    runButton.setBounds(6, 72, 72, 24);
    add(runButton);
    
    // Pause
    final JButton pauseButton = new JButton("Pause");
    pauseButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // TODO: Make button do a thing
      }
      
    });
    pauseButton.setBounds(84, 72, 72, 24);
    add(pauseButton);
    
    // Delay
    final JLabel labelDelay = new JLabel("Delay (ms)");
    labelDelay.setBounds(164, 72, 60, 24);
    add(labelDelay);
    final JTextField fieldDelay = new JTextField(4);
    fieldDelay.setText("250");
    fieldDelay.setBounds(230, 72, 32, 24);
    fieldDelay.addKeyListener(new KeyListener() {
      
      @Override
      public void keyPressed(KeyEvent ign) {}
      
      @Override
      public void keyReleased(KeyEvent kvt) {
        
        // Update delay per key typed
        int delay = internals.getDelay();
        final String fieldText = fieldDelay.getText();
        if (fieldText.length() <= 0) {
          return;
        }
        try {
          delay = Integer.parseInt(fieldDelay.getText());
        } catch (NumberFormatException nfe) {}
        internals.setDelay(delay);
        System.out.println(internals.getDelay());
      }
      
      @Override
      public void keyTyped(KeyEvent ign) {}
      
    });
    add(fieldDelay);
    
    // Step
    final JButton stepButton = new JButton("Step");
    stepButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // TODO: Make button do a thing
      }
      
    });
    stepButton.setBounds(6, 100, 72, 24);
    add(stepButton);
    
    // Reset
    final JButton resetButton = new JButton("Reset");
    resetButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        final int resetResult = JOptionPane.showConfirmDialog(null,
            "This will zero everything! Are you sure?");
        if (resetResult == JOptionPane.YES_OPTION) internals.resetEverything();
      }
      
    });
    resetButton.setBounds(84, 100, 72, 24);
    add(resetButton);
  }
  
  @Override
  public Dimension getPreferredSize() {
    return this.size;
  }
  
  @Override
  public Dimension getMinimumSize() {
    return getPreferredSize();
  }
  
  @Override
  public Dimension getMaximumSize() {
    return getPreferredSize();
  }
  
  private static final short[] parseSyzFile(final Scanner fScan) {
    
    // TODO: .syz file -> Simulator memory
    return null;
  }
  
  private static final short[] parseBinFile(final Scanner fScan) {
    
    // TODO: .bin file -> Simulator memory
    return null;
  }
  
  private static final void writeSyzFile(final File fOut) {
    // TODO: Simulator memory -> .syz file
  }
  
  private static final void writeBinFile(final File fOut) {
    // TODO: Simulator memory -> .bin file
  }
}
