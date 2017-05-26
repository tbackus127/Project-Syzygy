
package com.rath.syzsim.syzbgui;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.DefaultListModel;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import com.rath.syzasm.Assembler;
import com.rath.syzasm.Disassembler;
import com.rath.syzsim.syzbcore.SyzInternals;
import com.rath.syzsim.syzbcore.SyzOps;

public class MemoryPanel extends JPanel {
  
  private static final long serialVersionUID = 1L;
  
  public static final Font FONT_MONOSPACED = new Font("Courier New", Font.PLAIN, 12);
  
  private final SyzInternals internals;
  private final Dimension size;
  private final int entrySep;
  
  private DefaultListModel<String> memList;
  private JTextField memField;
  private int memIndex;
  
  public MemoryPanel(final Dimension size, final SyzInternals si) {
    super();
    this.size = size;
    setSize(getPreferredSize());
    this.internals = si;
    this.entrySep = (int) (this.size.getHeight() * 0.85D);
    setupMemList();
    
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
  
  private final void setupMemList() {
    
    // Instructions Label
    final JLabel memLabel = new JLabel("Main Memory");
    add(memLabel);
    
    // Set up list and scroll box
    this.memList = new DefaultListModel<String>();
    final JList<String> list = new JList<String>(this.memList);
    list.setFont(FONT_MONOSPACED);
    
    // Default memory values
    for (int i = 0; i < 65536; i++) {
      this.memList.add(i, SyzOps.toHex(i) + ": 0x0000 (NO-OP)");
    }
    
    // Continue list setup
    list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    final JScrollPane scrollList = new JScrollPane(list);
    final int compX = (int) (this.size.getWidth() - SimPanel.MARGIN_PANEL);
    final int scrollY = (int) (this.entrySep - SimPanel.MARGIN_PANEL);
    scrollList.setPreferredSize(new Dimension(compX, scrollY));
    add(scrollList);
    
    // Selection listener
    final ListSelectionListener lsl = new ListSelectionListener() {
      
      @Override
      public void valueChanged(ListSelectionEvent evt) {
        
        final JList<?> list = (JList<?>) evt.getSource();
        memIndex = list.getSelectedIndex();
      }
    };
    list.addListSelectionListener(lsl);
    list.setSelectedIndex(0);
    
    // Memory editing label
    final JLabel instrEntryLabel = new JLabel("New Memory Value:");
    add(instrEntryLabel);
    
    // Memory editing text field
    this.memField = new JTextField();
    this.memField.setPreferredSize(new Dimension(compX, 24));
    add(this.memField, BorderLayout.LINE_END);
    
    // Memory editing key listener
    final KeyListener instrListener = new KeyListener() {
      
      @Override
      public void keyPressed(KeyEvent evt) {}
      
      @Override
      public void keyReleased(KeyEvent evt) {
        
        // Ensure bounds
        if (memIndex < 0 || memIndex > 65535) memIndex = 0;
        
        // On Enter key
        if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
          
          final String entry = memField.getText();
          short value = 0;
          
          // If it's a number set it to the raw numeric value
          if (Assembler.isNumber(entry)) {
            value = Short.decode(entry);
          } else {
            
            // Or if it's a valid instruction, set the index to the instruction's value
            try {
              value = Assembler.parseInstruction(entry, null, 0);
            } catch (IllegalArgumentException iae) {
              value = 0;
            }
          }
          
          // Update the list and internals
          internals.setMem(memIndex, value);
          memList.setElementAt(SyzOps.toHex(memIndex) + ": 0x" + toHex(value) + " ("
              + Disassembler.disassemble(value) + ")", memIndex);
          memField.setText(null);
          list.setSelectedIndex(++memIndex);
        }
      }
      
      @Override
      public void keyTyped(KeyEvent evt) {}
      
    };
    this.memField.addKeyListener(instrListener);
  }
  
  /**
   * Converts a short to its String representation.
   * 
   * @param val the short to convert.
   * @return the String representation of the short.
   */
  public static final String toHex(final short val) {
    
    String conv = Integer.toHexString(val).toUpperCase();
    if (conv.length() > 4) {
      conv = conv.substring(4);
    }
    for (int i = conv.length(); i < 4; i++) {
      conv = "0" + conv;
    }
    return conv;
  }
}
