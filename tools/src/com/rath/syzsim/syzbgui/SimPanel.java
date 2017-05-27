
package com.rath.syzsim.syzbgui;

import java.awt.BorderLayout;
import java.awt.Dimension;

import javax.swing.JPanel;

import com.rath.syzsim.syzbcore.SyzInternals;

/**
 * This class forms the panel that contains everything in the simulator.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class SimPanel extends JPanel {

  /** Serial version UID. */
  private static final long serialVersionUID = 1L;

  /** Margin between panels, in pixels. */
  public static final int MARGIN_PANEL = 8;

  /** Margin at the bottom of each panel, in pixels. */
  private static final int MARGIN_BOTTOM = 38;

  /** The parent frame's size, in a Dimension object. */
  private final Dimension frameSize;

  /** Handle to the component JPanel. */
  private final ComponentPanel compPanel;

  /** Handle to the memory JPanel. */
  private final MemoryPanel memPanel;

  /** Handle to the peripheral JPanel. */
  private final PeripheralPanel perPanel;

  /**
   * Default constructor.
   * 
   * @param dim the size to make this panel, as a Dimension object.
   * @param si the internal values of the CPU.
   */
  public SimPanel(final Dimension dim, final SyzInternals si) {
    super();
    this.frameSize = dim;

    // Calculate panel sizes
    final int subPanelWidth = (int) this.frameSize.getWidth() / 3 - MARGIN_PANEL;
    final int subPanelHeight = (int) this.frameSize.getHeight() - MARGIN_BOTTOM;
    final int memoryPanelRed = 48;

    // Create and add component panel
    this.compPanel = new ComponentPanel(new Dimension(subPanelWidth + (memoryPanelRed >> 1), subPanelHeight), si);
    add(compPanel, BorderLayout.CENTER);

    // Create and add memory panel
    this.memPanel = new MemoryPanel(new Dimension(subPanelWidth - memoryPanelRed, subPanelHeight), si);
    add(memPanel, BorderLayout.CENTER);

    // Create and add peripheral panel
    this.perPanel = new PeripheralPanel(new Dimension(subPanelWidth + (memoryPanelRed >> 1), subPanelHeight), si);
    add(perPanel, BorderLayout.CENTER);

  }

  /**
   * Gets the preferred size of this JPanel.
   * 
   * @return the preferred size as a Dimension object.
   */
  @Override
  public Dimension getPreferredSize() {

    return this.frameSize;
  }

  /**
   * Gets the minimum (preferred) size of this JPanel.
   * 
   * @return the preferred size as a Dimension object.
   */
  @Override
  public Dimension getMinimumSize() {

    return getPreferredSize();
  }

  /**
   * Gets the maximum (preferred) size of this JPanel.
   * 
   * @return the preferred size as a Dimension object.
   */
  @Override
  public Dimension getMaximumSize() {

    return getPreferredSize();
  }
}
