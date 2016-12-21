
package com.rath.syzbgui;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JPanel;

import com.rath.syzbbck.SyzInternals;

public class RegisterPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  
  private final Dimension size;
  private final SyzInternals internals;
  
  public RegisterPanel(final Dimension size, final SyzInternals si) {
    super();
    this.size = size;
    setSize(getPreferredSize());
    setBackground(Color.LIGHT_GRAY);
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
