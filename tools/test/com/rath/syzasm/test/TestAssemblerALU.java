package com.rath.syzasm.test;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;

public class TestAssemblerALU {
  
  private static final HashMap<String, Short> aluMap = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      put("pass", (short) 0x3000);
      put("zaddi", (short) 0x3228);
      put("lsr", (short) 0x3308);
      put("lsl", (short) 0x3300);
      put("nnzasr", (short) 0x33ec);
      put("dec", (short) 0x3260);
      put("neg", (short) 0x3010);
      put("lsln", (short) 0x3310);
      put("and", (short) 0x31d0);
      put("nzorn", (short) 0x31b0);
      put("nncntn", (short) 0x35d0);
      put("xnor", (short) 0x3410);
      put("inc", (short) 0x3228);
      put("nzbaddn", (short) 0x3270);
      put("ncnt", (short) 0x3580);
      put("or", (short) 0x3100);
      put("add", (short) 0x3200);
      put("nnzaddin", (short) 0x32f8);
    }
  };
  
  @Test
  public void testALUInstr() {
    System.out.println("Testing ALU instructions...");
    int numErrors = 0;
    for (String s : aluMap.keySet()) {
      System.out.print("  Testing \"" + s + "\", got ");
      short w = 0;
      try {
        w = Assembler.parseInstruction(s, null, 0);
      } catch (IllegalArgumentException iae) {
        System.out.println(iae.getMessage());
      }
      System.out.println("0x" + Integer.toHexString(w) + ".");
      if (w != aluMap.get(s)) {
        numErrors++;
      }
    }
    assertEquals(0, numErrors);
  }
  
}
