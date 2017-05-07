package com.rath.syzasm.test;

import static org.junit.Assert.*;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;


public class TestJump {
  
  private static final HashMap<String, Short> jmpMap = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      put("jmp", (short) 0x02e00);
      put("jeq", (short) 0x02400);
      put("jne", (short) 0x02a00);
      put("jlt", (short) 0x02800);
      put("jle", (short) 0x02c00);
      put("jgt", (short) 0x02200);
      put("jge", (short) 0x02600);
    }
    
  };
  
  @Test
  public void testJumInstr() {
    System.out.println("Testing jump instructions...");
    int numErrors = 0;
    for (String s : jmpMap.keySet()) {
      System.out.print("  Testing \"" + s + "\", got ");
      short w = Assembler.parseInstruction(s, null, 0);
      System.out.println("0x" + Integer.toHexString(w) + ".");
      if (w != jmpMap.get(s)) {
        numErrors++;
      }
    }
    assertEquals(0, numErrors);
  }
  
}
