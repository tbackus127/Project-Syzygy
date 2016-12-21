
package com.rath.syzbgui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JPanel;

public class SimPanel extends JPanel {
  
  public static final int MARGIN_PANEL = 8;
  
  private static final long serialVersionUID = 1L;
  private static final int MARGIN_BOTTOM = 38;
  
  private final Dimension frameSize;
  private final InstrPanel instrPanel;
  private final ComponentPanel compPanel;
  private final MemoryPanel memPanel;
  
  public SimPanel(final Dimension dim) {
    super();
    this.frameSize = dim;
    setBackground(Color.BLACK);
    
    final Dimension subPanelSize = new Dimension((int) this.frameSize.getWidth() / 3 - MARGIN_PANEL,
        (int) this.frameSize.getHeight() - MARGIN_BOTTOM);
    this.instrPanel = new InstrPanel(subPanelSize, null);
    add(instrPanel, BorderLayout.WEST);
    
    this.compPanel = new ComponentPanel(subPanelSize, null);
    add(compPanel, BorderLayout.CENTER);
    
    this.memPanel = new MemoryPanel(subPanelSize, null);
    add(memPanel, BorderLayout.CENTER);
  }
  
  @Override
  public Dimension getPreferredSize() {
    return this.frameSize;
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
