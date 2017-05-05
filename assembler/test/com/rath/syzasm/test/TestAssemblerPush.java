
package com.rath.syzasm.test;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;

public class TestAssemblerPush {

  private static final HashMap<String, Short> labels = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      put("label1", (short) 15);
      put("label2", (short) 440);
      put("label3", (short) 2498);
    }
  };

  private static final String[] perr = { "push", "push ", "push  ", "push 0x", "push -1", "push --", "push \n",
      "push \\", "push 65536", "push krombopulous michael", "push push", "push push 1", "push $", "push $$",
      "push $push", "push 0xff03cm", "push $lib", "push $conf", "push $lib.", "push $conf.", "push $conf. ",
      "push $lib. ", "push $conf..", "push $conf.\nf" };

  private static final HashMap<String, Short> pstd = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      put("push 0", (short) 0x8000);
      put("push 1", (short) 0x8001);
      put("push 42", (short) 0x802a);
      put("push 8835", (short) 0xa283);
      put("push 32767", (short) 0xffff);
      put("push 0x0", (short) 0x8000);
      put("push 0x0000", (short) 0x8000);
      put("push 0x0fff", (short) 0x8fff);
      put("push 0x7fff", (short) 0xffff);

    }
  };

  @Test
  public void testPushInvalids() {
    System.out.println("Testing invalid pushes:");
    int numErrors = 0;
    for (final String s : perr) {
      System.out.println("  Testing \"" + s + "\".");
      try {
        Assembler.parseInstruction(s, labels, 0);
      }
      catch (IllegalArgumentException iae) {
        numErrors++;
        System.out.println("    Error!");
      }
    }

    assertEquals(perr.length, numErrors);
  }

  @Test
  public void testPushStandard() {
    System.out.println("Testing constant pushes:");
    int numErrors = 0;
    for(String s : pstd.keySet()) {
      System.out.println("  Testing \"" + s + "\".");
      if(Assembler.parseInstruction(s, labels, 0) != pstd.get(s)) {
        numErrors++;
      }
    }
    assertEquals(0, numErrors);
  }

}
