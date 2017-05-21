
package com.rath.syzsim.syzbgui;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JPanel;

import com.rath.syzsim.syzbcore.SyzInternals;

public class ControlPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  
  private final Dimension size;
  private final SyzInternals internals;
  
  public ControlPanel(final Dimension size, final SyzInternals si) {
    super();
    this.size = size;
    setSize(getPreferredSize());
    this.internals = si;
    
    // Step Button
    final JButton stepButton = new JButton("S");
    stepButton.addActionListener(new ActionListener() {
      
      @Override
      public void actionPerformed(ActionEvent evt) {
        
        // TODO: Make button do the thing
      }
      
    });
    add(stepButton);
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
}
