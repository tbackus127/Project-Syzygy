
package com.rath.syzsim.syzbgui;

import java.awt.Dimension;

import javax.swing.JPanel;

import com.rath.syzsim.syzbcore.SyzInternals;

public class PeripheralPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  
  private final Dimension size;
  private final SyzInternals internals;
  
  public PeripheralPanel(final Dimension size, final SyzInternals si) {
    super();
    this.size = size;
    setSize(getPreferredSize());
    this.internals = si;
    
    final PeripheralBase ledPanel = new LEDPanel((int) size.getWidth());
    add(ledPanel);
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
