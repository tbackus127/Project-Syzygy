
package com.rath.syzasm.vals;

import java.util.HashMap;

public class ALUInstr {

  public static final short NEG_Q = (short) 0x0010;
  public static final short RS_INC = (short) 0x0008;

  public static final HashMap<String, Short> OPS = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      // JAVA, WHY DO I HAVE TO CAST TO A SHORT TO CREATE A SHORT!?
      put("pass", new Short((short) 0x0000));
      put("or", new Short((short) 0x0100));
      put("add", new Short((short) 0x0200));
      put("SHFT", new Short((short) 0x0300));
      put("xor", new Short((short) 0x0400));
      put("cnt", new Short((short) 0x0500));
      put("NOP6", new Short((short) 0x0600));
      put("NOP7", new Short((short) 0x0700));
    }
  };

  public static final HashMap<String, Short> PREFIXES = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      put("", new Short((short) 0x0000));
      put("z", new Short((short) 0x0020));
      put("nb", new Short((short) 0x0040));
      put("nzb", new Short((short) 0x0060));
      put("n", new Short((short) 0x0080));
      put("nz", new Short((short) 0x00a0));
      put("nn", new Short((short) 0x00c0));
      put("nnz", new Short((short) 0x00e0));
    }
  };

  public static final HashMap<String, String> ALIASES = new HashMap<String, String>() {

    private static final long serialVersionUID = 1L;

    {
      put("sub", "nbaddi");
      put("inc", "zaddi");
      put("dec", "nzbadd");
      put("nor", "orn");
      put("and", "nnorn");
      put("nand", "nnor");
      put("xnor", "xorn");
      put("neg", "passn");
    }
  };

  public static final HashMap<String, Short> SHIFTS = new HashMap<String, Short>() {

    private static final long serialVersionUID = 1L;

    {
      put("lsl", new Short((short) 0x0000));
      put("lrl", new Short((short) 0x0002));
      put("asl", new Short((short) 0x0004));
      put("arl", new Short((short) 0x0006));
      put("lsr", new Short((short) 0x0008));
      put("lrr", new Short((short) 0x000a));
      put("asr", new Short((short) 0x000c));
      put("arr", new Short((short) 0x000e));
    }
  };

}
