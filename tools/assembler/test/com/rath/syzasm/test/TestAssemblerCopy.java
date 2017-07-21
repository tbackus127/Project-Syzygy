package com.rath.syzasm.test;

import static org.junit.Assert.*;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;


public class TestAssemblerCopy {
  
  private static final String[] cpErr = {
    "copy", "copy ", "copy copy", "copy 0", "copy 0,", "copy 0, 16", "copy 16, 0", "copy -1, -1", "copy f, f",
    "copy $lbl.label1", "copy \0", "copy \\", "copy c", "copy c, copy 0, 2", "copy 0,,2", "copy 2, -1",
    "copy 2, 3,"
  };
  
  private static final HashMap<String, Short> cpMap = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;
    {
      put("copy 0, 0", (short) 0x1000);
      put("copy 0, 1", (short) 0x1010);
      put("copy 0, 4", (short) 0x1040);
      put("copy 0, 10", (short) 0x10a0);
      put("copy 0, 15", (short) 0x10f0);
      put("copy 1, 0", (short) 0x1100);
      put("copy 4, 0", (short) 0x1400);
      put("copy 10, 0", (short) 0x1a00);
      put("copy 15, 0", (short) 0x1f00);
      put("copy 1, 3", (short) 0x1130);
      put("copy 7, 13", (short) 0x17d0);
      put("copy 9, 12", (short) 0x19c0);
      put("copy 8, 15", (short) 0x18f0);
      put("copy 15, 15", (short) 0x1ff0);
    }
  };
  
  @Test
  public void testCopyErrors() {
    System.out.println("Testing copy errors...");
    int numErrors = 0;
    for(final String s : cpErr) {
      System.out.print("Testing \"" + s + "\", got ");
      try {
        Assembler.parseInstruction(s, null, 0);
      } catch (IllegalArgumentException iae) {
        System.out.println("ERROR (OK)");
        numErrors++;
      }
    }
    assertEquals(cpErr.length, numErrors);
  }
  
  @Test
  public void testCopyInstr() {
    System.out.println("Testing copy instructions...");
    int numErrors = 0;
    for (String s : cpMap.keySet()) {
      System.out.print("  Testing \"" + s + "\", got ");
      short w = Assembler.parseInstruction(s, null, 0);
      System.out.println("0x" + Integer.toHexString(w).substring(4) + ".");
      if (w != cpMap.get(s)) {
        numErrors++;
      }
    }
    assertEquals(0, numErrors);
  }
  
}
