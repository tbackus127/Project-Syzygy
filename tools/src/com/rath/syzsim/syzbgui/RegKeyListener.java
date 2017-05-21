
package com.rath.syzsim.syzbgui;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JLabel;
import javax.swing.JTextField;

import com.rath.syzsim.syzbcore.SyzInternals;

public class RegKeyListener implements KeyListener {
  
  private final SyzInternals internals;
  private final JLabel txtLabel;
  private final JTextField txtField;
  private final int regNum;
  
  public RegKeyListener(final SyzInternals itr, final JLabel lbl, final JTextField txt, final int rnum) {
    this.internals = itr;
    this.txtLabel = lbl;
    this.txtField = txt;
    this.regNum = rnum;
  }
  
  @Override
  public void keyReleased(KeyEvent evt) {
    if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
      try {
        internals.setReg(this.regNum, Short.parseShort(txtField.getText()));
      } catch (NumberFormatException nfe) {
        internals.setReg(this.regNum, (short) 0);
      }
      short b = internals.getReg(this.regNum);
      txtLabel.setText("(" + b + ")");
      txtField.setText("");
    }
  }
  
  @Override
  public void keyPressed(KeyEvent ignored) {}
  
  @Override
  public void keyTyped(KeyEvent ignored) {}
}
