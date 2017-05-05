
package com.rath.syzasm.test;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;

import org.junit.Test;

import com.rath.syzasm.Assembler;

public class TestAssemblerPush {

  private static final HashMap<String, Integer> labels = new HashMap<String, Integer>() {

    private static final long serialVersionUID = 1L;

    {
      put("label1", 15);
      put("label2", 440);
      put("label3", 2498);
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
    int numErrors = 0;
    for (final String s : perr) {
      try {
        Assembler.parseInstruction(s, labels, 0);
      }
      catch (IllegalArgumentException iae) {
        numErrors++;
      }
    }

    assertEquals(perr.length, numErrors);
  }

  @Test
  public void testPushStandard() {
    int numErrors = 0;
    for(String s : pstd.keySet()) {
      if(Assembler.parseInstruction(s, labels, 0) != pstd.get(s)) {
        numErrors++;
      }
    }
    assertEquals(0, numErrors);
  }

}
