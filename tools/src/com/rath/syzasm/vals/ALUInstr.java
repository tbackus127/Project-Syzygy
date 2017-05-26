
package com.rath.syzasm.vals;

import java.util.HashMap;

/**
 * This class contains maps and values used by ALU instructions.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class ALUInstr {
  
  /** Bit mask for negating output. */
  private static final short NEG_Q = (short) 0x0010;
  
  /** Bit mask for right shift/increment. */
  private static final short RS_INC = (short) 0x0008;
  
  /** String mappings from ALU operation to their bit mask. */
  private static final HashMap<String, Short> OPS = new HashMap<String, Short>() {
    
    /** Serial verion UID. */
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
  
  /** String mappings from ALU pre-operations to their bit mask. */
  private static final HashMap<String, Short> PREFIXES = new HashMap<String, Short>() {
    
    /** Serial version UID. */
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
  
  /** Maps from easy instruction aliases to their internal form. */
  private static final HashMap<String, String> ALIASES = new HashMap<String, String>() {
    
    /** Serial version UID. */
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
  
  /** String mappings from shift instructions to their bit masks. */
  private static final HashMap<String, Short> SHIFTS = new HashMap<String, Short>() {
    
    /** Serial version UID. */
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
  
  /** A mapping of all instructions possible to its respective opcode. */
  public static final HashMap<String, Short> INSTR_MAP = buildInstructionMap();
  
  /**
   * Builds the master instruction map.
   * 
   * @return the map from keyword -> binary instruction.
   */
  private static final HashMap<String, Short> buildInstructionMap() {
    
    final HashMap<String, Short> result = new HashMap<String, Short>();
    
    // Go through all prefixes
    for (final String pre : PREFIXES.keySet()) {
      
      for (final String op : OPS.keySet()) {
        
        // Ignore special case instructions
        if (op.equals("SHFT") || op.equals("NOP6") || op.equals("NOP7")) continue;
        
        // Go through the permutations of NEG_Q and RS_INC
        for (int i = 0; i < 4; i++) {
          
          // Initialize keyword and binary
          String instrStr = pre + op;
          short instr = (short) (Opcodes.ALU | PREFIXES.get(pre) | OPS.get(op));
          
          switch (i) {
            
            // NEG_Q = 0, RS_INC = 0
            case 0:
            break;
          
            // NEG_Q = 1, RS_INC = 0
            case 1:
              instr |= NEG_Q;
              instrStr += "n";
            break;
          
            // NEG_Q = 0, RS_INC = 1
            case 2:
              if (op.equals("add")) {
                instr |= RS_INC;
                instrStr += "i";
              }
            break;
          
            // NEG_Q = 1, RS_INC = 1
            case 3:
              if (op.equals("add")) {
                instr |= RS_INC | NEG_Q;
                instrStr += "in";
              }
          }
          
          result.put(instrStr, instr);
        }
      }
    }
    
    // Add all shifts
    for (final String op : SHIFTS.keySet()) {
      
      // Each pre-operation (some are pointless, but valid operations).
      for (final String pre : PREFIXES.keySet()) {
        
        // NEG_Q on and off
        result.put(pre + op, (short) (Opcodes.ALU | OPS.get("SHFT") | PREFIXES.get(pre) | SHIFTS.get(op)));
        result.put(pre + op + "n",
            (short) (Opcodes.ALU | OPS.get("SHFT") | PREFIXES.get(pre) | SHIFTS.get(op) | (short) 0x0010));
      }
    }
    
    // Add aliased common operations
    for (String alias : ALIASES.keySet()) {
      
      final Short unaliasedInstr = result.get(ALIASES.get(alias));
      if (unaliasedInstr != null) {
        result.put(alias, result.get(ALIASES.get(alias)));
      } else {
        System.err.println("WARNING! Aliased instruction \"" + alias + "\" doesn't exist in the instruction map!");
      }
    }
    return result;
  }
  
}
