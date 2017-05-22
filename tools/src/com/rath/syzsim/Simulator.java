package com.rath.syzsim;

import javax.swing.SwingUtilities;

import com.rath.syzsim.syzbcore.SyzInternals;
import com.rath.syzsim.syzbgui.SimFrame;

/**
 * Main class for Syzygy B100 Simulator.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class Simulator {

  /**
   * Main method.
   * 
   * @param args runtime arguments (ignored).
   */
  public static void main(String[] args) {

    // Run the window out of the main thread
    SwingUtilities.invokeLater(new Runnable() {

      @Override
      public void run() {

        // Create core data structure
        final SyzInternals si = new SyzInternals();

        // Create the window
        @SuppressWarnings("unused")
        final SimFrame frame = new SimFrame(si);

      }
    });
  }
}
