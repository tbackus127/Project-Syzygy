
package com.rath.syzasm;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

import com.rath.syzasm.vals.Opcodes;

public class Assembler {

  /**
   * Assembles a .syz file into machine code for the SyzygyB100 CPU.
   * 
   * @param args 0: .syz file.
   */
  public static void main(String[] args) {

    final File asmFile = new File(args[0]);
    assemble(asmFile);
  }

  /**
   * 
   * @param fscan
   * @return
   */
  private static final boolean assemble(final File asmFile) {

    final HashMap<String, Integer> labels = parseLabels(asmFile);
    final ArrayList<Short> instr = parseInstructions(asmFile, labels);

    final String fileName = asmFile.getName().substring(0, asmFile.getName().lastIndexOf('.'));
    writeToFile(instr, fileName);

    return true;
  }

  private static final void writeToFile(final ArrayList<Short> instr, final String fname) {
    // TODO: Write method to save the assembled file.
  }

  private static final ArrayList<Short> parseInstructions(final File asmFile, final HashMap<String, Integer> labels) {

    // Open a scanner on the file
    Scanner fscan = null;
    try {
      fscan = new Scanner(asmFile);
    }
    catch (IOException ioe) {
      ioe.printStackTrace();
    }

    final ArrayList<Short> result = new ArrayList<Short>();
    int currLine = 1;

    while (fscan.hasNextLine()) {
      final String line = fscan.nextLine().trim();

      final String[] operation = line.split(" ", 2);
      short binInstr = 0;

      switch (operation[0].toLowerCase().trim()) {
        case "push":
          try {
            binInstr &= parsePush(operation[1], currLine);
          }
          catch (IllegalArgumentException iae) {
            System.err.println(iae.getMessage());
          }
        break;
        case "copy":
          try {
            binInstr &= parseCopy(operation[1], currLine);
          }
          catch (IllegalArgumentException iae) {
            System.err.println(iae.getMessage());
          }
        break;
        default:
      }

      // TODO: Parse ALU instructions
      // TODO: Parse IO instructions
      // TODO: Parse SYS instruction

      result.add(binInstr);
      currLine++;
    }

    return result;
  }

  /**
   * Parses the push instruction.
   * 
   * @param pstr the line containing the push instruction.
   * @return the machine code as two bytes.
   */
  private static final short parsePush(final String pargs, final int line) {

    if (pargs.trim().indexOf(' ') > 0)
      throw new IllegalArgumentException("Push instruction does not have only one argument (line " + line + ").");

    short num = Opcodes.PUSH;
    if (isNumber(pargs)) {
      num &= Short.decode(pargs);
    } else if (varLookup(pargs) != null) {
      num &= Short.decode(varLookup(pargs));
    } else {
      throw new IllegalArgumentException("Push instruction's value is not valid (line " + line + ").");
    }

    return num;
  }

  private static final short parseCopy(final String args, final int line) {

    // TODO: Write parseCopy().
    return (short) 0;
  }

  /**
   * Finds all jump labels in a .syz assembly file.
   * 
   * @param asmFile the assembly file.
   * @return A HashMap that maps Label -> Line number.
   */
  private static final HashMap<String, Integer> parseLabels(final File asmFile) {

    // Open a scanner on the file
    Scanner fscan = null;
    try {
      fscan = new Scanner(asmFile);
    }
    catch (IOException ioe) {
      ioe.printStackTrace();
    }

    // Keep track of the label map and current line
    final HashMap<String, Integer> result = new HashMap<String, Integer>();
    int currLine = 1;

    // Go through each line
    while (fscan.hasNextLine()) {
      final String line = fscan.nextLine().trim();

      // If it's a valid label (starts with ":"), add it to the map
      if (line.startsWith(":")) {
        result.put(line.substring(1, line.indexOf(' ')), currLine);
      }

      currLine++;
    }

    return result;
  }

  /**
   * 
   * @param token
   * @return
   */
  private static final String varLookup(final String token) {

    // TODO: Make lookup method
    return null;
  }

  /**
   * 
   * @param str
   * @return
   */
  private static final boolean isNumber(final String str) {
    try {
      Short.decode(str);
    }
    catch (NumberFormatException nfe) {
      return false;
    }
    return true;
  }
}
