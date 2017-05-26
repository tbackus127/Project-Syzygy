
package com.rath.syzsim.syzbgui;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridBagLayout;

import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class LEDPanel extends PeripheralBase {
  
  /** Serial version UID. */
  private static final long serialVersionUID = 1L;
  
  private static final int DEFAULT_HEIGHT = 36;
  
  private final boolean[] ledStates = new boolean[16];
  private final JCheckBox[] leds = new JCheckBox[16];
  
  public LEDPanel(final int width) {
    super(new Dimension(width, DEFAULT_HEIGHT));
    setLayout(new BorderLayout());
    
    final JPanel LEDPanel = new JPanel();
    LEDPanel.setLayout(new GridBagLayout());
    
    final JLabel label = new JLabel("LEDs");
    add(label, BorderLayout.NORTH);
    
    for (int i = 0; i < 16; i++) {
      leds[i] = new JCheckBox();
      leds[i].setEnabled(false);
      leds[i].setBorder(null);
      LEDPanel.add(leds[i]);
    }
    add(LEDPanel, BorderLayout.CENTER);
  }
  
  @Override
  public void setPeriphReg(short reg, short val) {
    super.regs[reg] = val;
  }
  
  @Override
  public void execPeriph() {
    // TODO Auto-generated method stub
    
  }
  
}
