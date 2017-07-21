
package com.rath.syzasm.test;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;

public class TestAssemblerSys {
  
  private static final String[] sysErr = {
      "sys", "sys ", "sys,", "sys ,", "sys sys", "sys flag", "sys flag ", "sys flag,", "sys flag ,",
      "sys flag -1", "sys flag 0", "sys flag 1,", "sys flag 0, -", "sys flag 16, 0", "sys flag -1, 1",
      "sys flag 0, 0,", "sys flag -1, -1", "sys flag"
  };
  
  private static final HashMap<String, Short> sysStd = new HashMap<String, Short>() {
    
    private static final long serialVersionUID = 1L;
    
    {
      put("sys flag 0, 0", (short) 0x0100);
      put("sys flag 0, 1", (short) 0x0108);
      put("sys flag 1, 0", (short) 0x0110);
      put("sys flag 1, 1", (short) 0x0118);
      put("sys flag 10, 1", (short) 0x01a8);
      put("sys flag 15, 0", (short) 0x01f0);
      put("sys flag 15, 1", (short) 0x01f8);
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
