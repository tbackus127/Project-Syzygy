
package com.rath.syzasm.test;

import static org.junit.Assert.*;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;

public class TestAssemblerErrors {

  private static final HashMap<String, Integer> labels = new HashMap<String, Integer>();
  private static final String[] nopStr = { "", " ", "\\", "p", "cp", "\n", "\t", "j", "0", "\0", null };

  @Test
  public void testNoOps() {
    int errorCount = 0;
    for (final String s : nopStr) {
      try {
        Assembler.parseInstruction(s, labels, 0);
      }
      catch (IllegalArgumentException iae) {
        errorCount++;
      }
    }
    assertEquals(nopStr.length, errorCount);
  }

}
