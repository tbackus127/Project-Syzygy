
package com.rath.syzsim.syzbgui;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import com.rath.syzsim.syzbcore.SyzInternals;

/**
 * This class contains the value and manual value entry field for all registers.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class RegisterPanel extends JPanel {

  private static final int PADDING_TITLE_W = 86;
  private static final int PADDING_REGS_N = 24;
  private static final int PADDING_REG_NUM_W = 8;
  private static final int PADDING_REG_FIELD_W = 40;
  private static final int PADDING_REG_VAL_W = 82;
  private static final int PADDING_REG_ODDS = 134;
  private static final int REG_HEIGHT = 22;
  private static final int FIELD_HEIGHT = 18;
  private static final int LABEL_WIDTH = 40;
  private static final int FIELD_WIDTH = 44;
  private static final int VALUE_WIDTH = 120;

  private static final long serialVersionUID = 1L;

  private final Dimension size;
  private final SyzInternals internals;

  private final JLabel[] regLabels = new JLabel[16];
  private final JTextField[] regFields = new JTextField[16];
  private final JLabel[] regVals = new JLabel[16];

  public RegisterPanel(final Dimension size, final SyzInternals si) {
    super();
    setBackground(Color.GREEN);
    this.size = size;
    setSize(getPreferredSize());

    setLayout(null);
    this.internals = si;

    final JLabel regLabel = new JLabel("CPU Registers");
    regLabel.setBounds(PADDING_TITLE_W, 0, VALUE_WIDTH, FIELD_HEIGHT);
    add(regLabel);

    // Add all register controls
    for (int i = 0; i < regLabels.length / 2; i++) {

      // Alternate odd and even columns
      for (int j = 0; j <= 1; j++) {

        final int reg = i + j;

        // Labels
        final String labelStr = "R" + ((i << 1) + j) + ": ";
        regLabels[reg] = new JLabel(labelStr);
        regLabels[reg].setBounds(PADDING_REG_NUM_W + (j * PADDING_REG_ODDS), PADDING_REGS_N + REG_HEIGHT * i,
            LABEL_WIDTH, FIELD_HEIGHT);
        regLabels[reg].setFont(MemoryPanel.FONT_MONOSPACED);
        add(regLabels[reg]);

        // Text fields
        regFields[reg] = new JTextField(5);
        regFields[reg].setBounds(PADDING_REG_FIELD_W + (j * PADDING_REG_ODDS), PADDING_REGS_N + REG_HEIGHT * i,
            FIELD_WIDTH, FIELD_HEIGHT);
        add(regFields[reg]);

        // Value labels
        final short regByte = this.internals.getReg(reg);
        regVals[reg] = new JLabel("(" + regByte + ")");
        regVals[reg].setBounds(PADDING_REG_VAL_W + (j * PADDING_REG_ODDS), PADDING_REGS_N + REG_HEIGHT * i, VALUE_WIDTH,
            FIELD_HEIGHT);
        regVals[reg].setFont(MemoryPanel.FONT_MONOSPACED);
        add(regVals[reg]);

        // Field key listeners
        regFields[reg].addKeyListener(new RegKeyListener(this.internals, regVals[reg], regFields[reg], reg));
      }
    }
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
