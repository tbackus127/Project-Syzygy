
package com.rath.syzasm.test;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;

public class TestAssemblerSys {
  
  private static final String[] sysErr = { "sys", "sys ", "sys,", "sys ,", "sys sys", "sys cmd",
      "sys cmd ", "sys cmd,", "sys cmd ,", "sys cmd -1", "sys cmd 0, -", "sys cmd 16, 0",
      "sys cmd -1, 1", "sys cmd 0, 0,", "sys cmd -1, -1", "sys cmd" };
  
  private static final HashMap<String, Short> sysStd = new HashMap<String, Short>() {
    
    private static final long serialVersionUID = 1L;
    
    {
      put("sys cmd 0", (short) 0x0100);
      put("sys cmd 1", (short) 0x0101);
      put("sys cmd 17", (short) 0x0111);
      put("sys cmd 255", (short) 0x01ff);
    }
  };
  
  @Test
  public void testSysInvalids() {
    System.out.println("Testing invalid system commands:");
    int numErrors = 0;
    for (final String s : sysErr) {
      System.out.print("  Testing \"" + s + "\", got ");
      short w = 0;
      try {
        w = Assembler.parseInstruction(s, null, 0);
        System.out.println("" + w + "\".");
      } catch (IllegalArgumentException iae) {
        numErrors++;
        System.out.println("ERROR (OK)");
      }
    }
    
    assertEquals(sysErr.length, numErrors);
  }
  
  @Test
  public void testSysStandard() {
    System.out.println("Testing system commands:");
    int numErrors = 0;
    for (String s : sysStd.keySet()) {
      System.out.print("  Testing \"" + s + "\", got ");
      short w = Assembler.parseInstruction(s, null, 0);
      System.out.println("0x" + Integer.toHexString(w) + ".");
      if (w != sysStd.get(s)) {
        numErrors++;
      }
    }
    assertEquals(0, numErrors);
  }
}
