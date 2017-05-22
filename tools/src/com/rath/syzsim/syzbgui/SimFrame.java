
package com.rath.syzsim.syzbgui;

import java.awt.Dimension;

import javax.swing.JFrame;

import com.rath.syzsim.syzbcore.SyzInternals;

/**
 * This class forms the main frame to the simulator.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class SimFrame extends JFrame {

  /** Default window size. */
  private static final Dimension DEFAULT_SIZE = new Dimension(800, 600);

  /** Serial version UID. */
  private static final long serialVersionUID = 1L;

  /**
   * Default constructor.
   * 
   * @param si an already created SyzInternals object.
   */
  public SimFrame(final SyzInternals si) {
    super("Syzygy B100 Simulator");
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setSize(getPreferredSize());
    setResizable(false);
    setLocationRelativeTo(null);

    final SimPanel panel = new SimPanel(DEFAULT_SIZE, si);
    add(panel, null);

    setVisible(true);
  }

  /**
   * Gets the preferred window size.
   * 
   * @return the size as a Dimension.
   */
  @Override
  public Dimension getPreferredSize() {

    return DEFAULT_SIZE;
  }

  /**
   * Gets the minimum window size.
   * 
   * @return the preferred size.
   */
  @Override
  public Dimension getMinimumSize() {

    return getPreferredSize();
  }

  /**
   * Gets the maximum window size.
   * 
   * @return the preferred size.
   */
  @Override
  public Dimension getMaximumSize() {

    return getPreferredSize();
  }
}
