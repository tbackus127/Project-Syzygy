
package com.rath.syzbgui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.util.Arrays;

import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import com.rath.syzbbck.SyzInternals;

public class InstrPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  
  private final SyzInternals internals;
  private final Dimension size;
  private final int entrySep;
  
  private JList<String> instrList;
  private JTextField instrField;
  private int instrIndex;
  
  public InstrPanel(final Dimension size, final SyzInternals si) {
    super();
    this.size = size;
    setSize(getPreferredSize());
    this.internals = si;
    this.entrySep = (int) (this.size.getHeight() * 0.9D);
    setBackground(Color.RED);
    setupInstrList();
    
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
  
  private final void setupInstrList() {
    final String[] instr = new String[256];
    instr[0] = "00: push 0xff";
    instr[1] = "01: load 0, AB";
    for (int i = 2; i < 256; i++) {
      instr[i] = Integer.toHexString(i).toUpperCase() + ": ";
    }
    
    this.instrList = new JList<String>(instr);
    this.instrList.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    final JScrollPane scrollList = new JScrollPane(this.instrList);
    final int compX = (int) (this.size.getWidth() - SimPanel.MARGIN_PANEL);
    final int scrollY = (int) (this.entrySep - SimPanel.MARGIN_PANEL);
    scrollList.setPreferredSize(new Dimension(compX, scrollY));
    add(scrollList);
    
    final JLabel instrEntryLabel = new JLabel("Instruction Entry:");
    add(instrEntryLabel);
    
    this.instrField = new JTextField();
    this.instrField.setPreferredSize(new Dimension(compX, 24));
    add(this.instrField, BorderLayout.LINE_END);
    
    this.instrIndex = 0;
    
    final ListSelectionListener lsl = new ListSelectionListener() {
      
      @Override
      public void valueChanged(ListSelectionEvent evt) {
        final JList<?> list = (JList<?>) evt.getSource();
        instrIndex = list.getSelectedIndex();
      }
    };
    this.instrList.addListSelectionListener(lsl);
  }
}
