
package com.rath.syzsim.syzbgui;

import java.awt.BorderLayout;
import java.awt.Dimension;

import javax.swing.JPanel;

import com.rath.syzsim.syzbcore.SyzInternals;

public class ComponentPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  private static final int MARGIN_BOTTOM = 14;
  
  private final SyzInternals internals;
  private final Dimension size;
  private final RegisterPanel regPanel;
  private final ControlPanel ctrlPanel;
  
  public ComponentPanel(final Dimension size, final SyzInternals si) {
    super();
    this.size = size;
    setSize(getPreferredSize());
    this.internals = si;
    
    final int subPanelWidth = (int) (this.size.getWidth() - SimPanel.MARGIN_PANEL);
    final int sepLocation = (int) (this.size.getHeight() * 0.4D);
    final Dimension regPanelSize = new Dimension(subPanelWidth, sepLocation);
    final Dimension ctrlPanelSize = new Dimension(subPanelWidth,
        (int) (this.size.getHeight() - sepLocation - MARGIN_BOTTOM));
    
    this.regPanel = new RegisterPanel(regPanelSize, this.internals);
    add(this.regPanel, BorderLayout.NORTH);
    
    this.ctrlPanel = new ControlPanel(ctrlPanelSize, this.internals);
    add(this.ctrlPanel, BorderLayout.SOUTH);
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
