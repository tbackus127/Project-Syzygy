package com.rath.syzasm.test;

import static org.junit.Assert.*;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;


public class TestAssemblerIO {
  
  private static final String[] ioErr = {
    "ioex", "ioex ", "ioex  ", "ioex \n", "ioex \0", "ioex \\n", "ioex f", "ioex ioex", "ioex x, x", "ioex 3, z",
    "ioex 0, -1", "ioex -1, 0", "ioex -1, -1", "ioex 0, 16", "ioex 16, 0", "ioex 16, 16", "iosr 0, 16",
    "iosr 16, 0", "iosr 16, 16", "iosr -1, 0", "iosr 0, -1", "iosr -1, -1", "iogr 0, -1", "iogr -1, 0", "iogr f, f",
    "iogr 16, 16", "iogr --,,", "ioss 4, 2", "ioex -1", "ioex 16", "iosd -1", "iosd -1, 0", "iosd -1, -1",
    "iosd --1", "iosd 4, 16", "iogd -1, -1", "iogd 0, -1", "iogd 16, 0", "iogd 15, 16", "ioex 8", "ioex 10",
    "ioex 15", "iogr 8, 0", "iogr 15, 4", "iosd 8, 0", "iogd 16, 4"
  };
  
  private static final HashMap<String, Short> ioMap = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      put("ioex 0", (short) 0x4008);
      put("ioex 1", (short) 0x4108);
      put("ioex 6", (short) 0x4608);
      put("ioex 7", (short) 0x4708);
      put("iosr 0, 0", (short) 0x4004);
      put("iosr 6, 11", (short) 0x46b4);
      put("iosr 7, 15", (short) 0x47f4);
      put("iosr 1, 7", (short) 0x4174);
      put("iogr 0, 0", (short) 0x4000);
      put("iogr 6, 11", (short) 0x46b0);
      put("iogr 7, 15", (short) 0x47f0);
      put("iogr 1, 7", (short) 0x4170);
      put("iosd 0, 0", (short) 0x4006);
      put("iosd 6, 11", (short) 0x46b6);
      put("iosd 7, 15", (short) 0x47f6);
      put("iosd 1, 7", (short) 0x4176);
      put("iogd 0, 0", (short) 0x4002);
      put("iogd 6, 11", (short) 0x46b2);
      put("iogd 7, 15", (short) 0x47f2);
      put("iogd 1, 7", (short) 0x4172);
    }
  };
  
  @Test
  public void testIOErrs() {
    System.out.println("Testing IO errors...");
    int numErrors = 0;
    for(final String s : ioErr) {
      System.out.print("Testing \"" + s + "\", got ");
      try {
        Assembler.parseInstruction(s, null, 0);
      } catch (IllegalArgumentException iae) {
        System.out.println("ERROR (OK)");
        numErrors++;
      }
    }
    assertEquals(ioErr.length, numErrors);
  }
  
  @Test
  public void testIOInstr() {
    System.out.println("Testing IO instructions...");
    int numErrors = 0;
    for (String s : ioMap.keySet()) {
      System.out.print("  Testing \"" + s + "\", got ");
      short w = Assembler.parseInstruction(s, null, 0);
      System.out.println("0x" + Integer.toHexString(w) + ".");
      if (w != ioMap.get(s)) {
        numErrors++;
      }
    }
    assertEquals(0, numErrors);
  }
  
}
