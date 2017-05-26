
package com.rath.syzsim.syzbgui;

import java.awt.Dimension;

import javax.swing.JPanel;

public abstract class PeripheralBase extends JPanel {
  
  private static final long serialVersionUID = 1L;
  protected final Dimension size;
  protected final short[] regs = new short[16];
  
  public PeripheralBase(final Dimension size) {
    super();
    this.size = size;
    setSize(getPreferredSize());
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
  
  public abstract void setPeriphReg(final short reg, final short val);
  
  public abstract void execPeriph();
  
}
