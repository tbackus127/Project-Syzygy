
package com.rath.syzbgui;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JPanel;

import com.rath.syzbbck.SyzInternals;

public class MemoryPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  private final SyzInternals internals;
  private final Dimension size;
  
  public MemoryPanel(final Dimension size, final SyzInternals si) {
    super();
    this.size = size;
    setSize(getPreferredSize());
    setBackground(Color.BLUE);
    this.internals = si;
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
