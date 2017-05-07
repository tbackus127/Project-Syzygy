
package com.rath.syzasm;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

import com.rath.syzasm.util.VariableFetcher;
import com.rath.syzasm.vals.ALUInstr;
import com.rath.syzasm.vals.IOInstr;
import com.rath.syzasm.vals.JumpInstr;
import com.rath.syzasm.vals.Opcodes;

public class Assembler {
  
  /**
   * Assembles a .syz file into machine code for the SyzygyB100 CPU.
   * 
   * @param args 0: .syz file.
   */
  public static void main(String[] args) {
    
    if (args.length > 0) {
      final File asmFile = new File(args[0]);
      assemble(asmFile);
    } else {
      printUsage();
    }
  }
  
  /**
   * Assembles a .syz source file into binary.
   * 
   * @param asmFile the .syz file to be assembled.
   */
  private static final void assemble(final File asmFile) {
    
    final HashMap<String, Short> labels = parseLabels(asmFile);
    final ArrayList<Short> instr = parseInstructions(asmFile, labels);
    
    final String fileName = asmFile.getName().substring(0, asmFile.getName().lastIndexOf('.'));
    writeToFile(instr, fileName);
    
  }
  
  /**
   * Finds all jump labels in a .syz assembly file.
   * 
   * @param asmFile the assembly file.
   * @return A HashMap that maps Label -> Line number.
   */
  private static final HashMap<String, Short> parseLabels(final File asmFile) {
    
    // Open a scanner on the file
    Scanner fscan = null;
    try {
      fscan = new Scanner(asmFile);
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
    
    // Keep track of the label map and current line
    final HashMap<String, Short> result = new HashMap<String, Short>();
    short currLine = 1;
    
    // Go through each line
    while (fscan.hasNextLine()) {
      final String line = fscan.nextLine().trim();
      
      // If it's a valid label (starts with ":"), add it to the map
      if (line.startsWith(":")) {
        final String label = line.substring(1, line.indexOf(' '));
        result.put(label, currLine);
        System.out.println("Added \"" + label + "\" to labels.");
      }
      
      currLine++;
    }
    
    return result;
  }
  
  /**
   * Parses all instructions in an assembly file.
   * 
   * @param asmFile a handle to the input assembly file.
   * @param labels a Map of labels in the assembly file -> instruction number.
   * @return a list of 16-bit binary instructions.
   */
  private static final ArrayList<Short> parseInstructions(final File asmFile, final HashMap<String, Short> labels) {
    
    // Open a scanner on the file
    Scanner fscan = null;
    try {
      fscan = new Scanner(asmFile);
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
    
    // Build list of instructions
    final ArrayList<Short> result = new ArrayList<Short>();
    int currLine = 1;
    
    // Scan through the assembly file
    while (fscan.hasNextLine()) {
      
      // Send the current line to the instruction parser
      final short instr = parseInstruction(fscan.nextLine().trim(), labels, currLine);
      result.add(instr);
      currLine++;
    }
    
    return result;
  }
  
  /**
   * Parses an instruction that spans one line and encodes it as a short.
   * 
   * @param line
   * @param labels
   * @param currLine
   * @return
   */
  public static final short parseInstruction(final String line, final HashMap<String, Short> labels,
      final int currLine) {
    short binInstr = 0;
    
    if (line == null || line.length() < 2) {
      throw new IllegalArgumentException("Line is too short or empty!");
    }
    
    // If there's only one string on this line (jump or ALU instruction)
    if (line.indexOf(' ') < 0) {
      
      if (line.startsWith("j")) {
        binInstr = parseJump(line, currLine);
      } else if (ALUInstr.INSTR_MAP.keySet().contains(line)) {
        binInstr = parseALUInstr(line, currLine);
      } else {
        throw new IllegalArgumentException("Not a valid instruction (line " + line + ").");
      }
      
    } else {
      
      final String[] operation = line.split(" ", 2);
      
      if (operation[0].trim().startsWith("io")) {
        binInstr = parseIOInstr(line, currLine);
        
      } else {
        
        switch (operation[0].trim().toLowerCase()) {
          case "push":
            binInstr = parsePush(operation[1], labels, currLine);
          break;
          case "copy":
            binInstr = parseCopy(operation[1], currLine);
          break;
          case "sys":
            binInstr = parseSys(operation[1], currLine);
          break;
          default:
        }
      }
    }
    
    return binInstr;
  }
  
  /**
   * Parses the push instruction.
   * 
   * @param pstr the line containing the push instruction.
   * @return the machine code as two bytes.
   */
  private static final short parsePush(final String pargs, final HashMap<String, Short> labels, final int line) {
    
    // Ensure correct argument count
    if (pargs.trim().indexOf(' ') > 0)
      throw new IllegalArgumentException("Push instruction does not have only one argument (line " + line + ").");
    
    // Decode the argument
    short num = Opcodes.PUSH;
    
    if (isNumber(pargs)) {
      
      // If it's just a normal number
      final short argNum = Short.decode(pargs);
      if (argNum < 0) {
        throw new IllegalArgumentException("Push cannot be negative!");
      }
      num |= argNum;
    } else if (pargs.trim().startsWith("$lbl.")) {
      
      // If it's a label (look it up)
      final String[] lbls = pargs.split("\\.", 2);
      if (lbls.length != 2) {
        throw new IllegalArgumentException("Invalid label!");
      }
      final String lbl = lbls[1];
      final Short lblValue = labels.get(lbl);
      if (lblValue == null) {
        throw new IllegalArgumentException("Referenced label does not exist!");
      }
      num |= (short) lblValue;
    } else {
      
      // Otherwise, it's probably a config value, so look it up
      final String lookupStr = VariableFetcher.lookup(pargs);
      if (lookupStr != null) {
        num |= Short.decode(lookupStr);
      } else {
        throw new IllegalArgumentException("Push instruction's value is not valid (line " + line + ").");
      }
    }
    
    return num;
  }
  
  /**
   * Performs parsing on a copy instruction.
   * 
   * @param args the tokens after the copy keyword.
   * @param line the line number.
   * @return a 16-bit machine instruction representation of the copy instruction.
   */
  private static final short parseCopy(final String args, final int line) {
    
    // Ensure copy arguments match syntax and get tokens
    if (!args.trim().matches("\\s*\\d{1,2}\\s*,\\s*\\d{1,2}"))
      throw new IllegalArgumentException("Invalid copy instruction syntax (line " + line + ").");
    final String[] tokens = args.split(",");
    
    // Set the instruction's opcode to copy.
    short num = Opcodes.COPY;
    
    // Parse and check range of first argument (source register)
    short argSrc = Short.parseShort(tokens[0].trim());
    if (argSrc < 0 || argSrc > 15)
      throw new IllegalArgumentException("Source register for copy instruction out of range (line " + line + ").");
    
    // Parse and check range of second argument (destination register)
    short argDest = Short.parseShort(tokens[1].trim());
    if (argDest < 0 || argDest > 15)
      throw new IllegalArgumentException("Source register for copy instruction out of range (line " + line + ").");
    
    // Set the arguments in the machine code
    num |= (argSrc << 8);
    num |= (argDest << 4);
    
    return num;
  }
  
  /**
   * Parses a jump instruction into 16-bit binary machine code.
   * 
   * @param str the instruction.
   * @param line the line number.
   * @return the two byte instruction as a short.
   */
  private static final short parseJump(final String str, final int line) {
    
    // Ensure only one token
    if (str.trim().indexOf(' ') >= 0) {
      throw new IllegalArgumentException("Jump instruction is invalid (line " + line + ").");
    }
    
    short num = Opcodes.JUMP;
    
    switch (str) {
      case "jmp":
        num |= JumpInstr.JMP;
      break;
      case "jeq":
        num |= JumpInstr.JEQ;
      break;
      case "jne":
        num |= JumpInstr.JNE;
      break;
      case "jlt":
        num |= JumpInstr.JLT;
      break;
      case "jle":
        num |= JumpInstr.JLE;
      break;
      case "jgt":
        num |= JumpInstr.JGT;
      break;
      case "jge":
        num |= JumpInstr.JGE;
      break;
      default:
        throw new IllegalArgumentException("Jump instruction is invalid (line " + line + ").");
    }
    
    return num;
  }
  
  /**
   * Parses an ALU instruction into a 16-bit machine instruction.
   * 
   * @param str the instruction.
   * @param line the current line.
   * @return the two bytes that make up this instruction.
   */
  private static final short parseALUInstr(final String str, final int line) {
    short num = Opcodes.ALU;
    num |= ALUInstr.INSTR_MAP.get(str);
    return num;
  }
  
  /**
   * Parses an I/O instruction into machine code.
   * 
   * @param str the instruction.
   * @param line the current line number.
   * @return the two bytes that make up this instruction.
   */
  private static final short parseIOInstr(final String str, final int line) {
    
    short num = Opcodes.IO;
    
    final String[] opTokens = str.split(" ", 2);
    
    // Get the interface number and check its range
    final short pid;
    final int commaIdx = opTokens[1].indexOf(',');
    if (commaIdx > 0) {
      
      // For two arguments
      pid = Short.parseShort(opTokens[1].trim().substring(0, commaIdx));
    } else {
      
      // For one argument
      pid = Short.parseShort(opTokens[1].trim());
    }
    if (pid < 0 || pid > 7)
      throw new IllegalArgumentException("I/O interface to execute out of range (line " + line + ").");
    
    // Set peripheral ID bits
    num |= (pid << 8);
    
    short regNum = 0;
    switch (opTokens[0].trim()) {
      
      // I/O peripheral execute command
      case "ioex":
        num |= IOInstr.IOEX;
      break;
    
      // I/O peripheral set register command
      case "iosr":
        
        // Get the register ID to write to.
        try {
          regNum = Short.parseShort(opTokens[1].trim().substring(commaIdx + 1, opTokens[1].length()));
        } catch (NumberFormatException nfe) {
          throw new IllegalArgumentException("I/O interface register is not a valid number (line " + line + ").");
        }
        if (regNum < 0 || regNum > 15)
          throw new IllegalArgumentException("I/O interface register out of range (line " + line + ").");
        
        // Set peripheral ID and write mode bits
        num |= (regNum << 4) | IOInstr.IOSR;
        
      break;
    
      // I/O peripheral get register value command
      case "iogr":
        
        // Get the register ID to read from.
        try {
          regNum = Short.parseShort(opTokens[1].trim().substring(commaIdx + 1, opTokens[1].length()));
        } catch (NumberFormatException nfe) {
          throw new IllegalArgumentException("I/O interface register is not a valid number (line " + line + ").");
        }
        if (regNum < 0 || regNum > 15)
          throw new IllegalArgumentException("I/O interface register out of range (line " + line + ").");
        
        // Set peripheral ID bits
        num |= (regNum << 4);
      break;
      default:
    }
    
    return num;
  }
  
  /**
   * Parses a system instruction into machine code.
   * 
   * @param str the instruction's arguments after the "sys" keyword.
   * @param line the current line number.
   * @return the two bytes that make up this instruction.
   */
  private static final short parseSys(final String str, final int line) {
    short num = Opcodes.SYS;
    
    // TODO: Write SYS instruction parser.
    
    return num;
  }
  
  /**
   * Writes the list of instructions to a .bin file to be executed on the Syzygy B100 CPU.
   * 
   * @param instr a List of 16-bit instructions.
   * @param fname the file name (sans extension) to output to.
   */
  private static final void writeToFile(final ArrayList<Short> instr, final String fname) {
    
    final File binFile = new File(fname + ".bin");
    DataOutputStream bout = null;
    try {
      bout = new DataOutputStream(new FileOutputStream(binFile));
      for (short val : instr) {
        bout.writeShort(val);
      }
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }
  
  /**
   * Checks whether or not a String is numeric and can fit within two bytes.
   * 
   * @param str the String to check.
   * @return true if the string is valid; false if not.
   */
  private static final boolean isNumber(final String str) {
    try {
      Short.decode(str);
    } catch (NumberFormatException nfe) {
      return false;
    }
    return true;
  }
  
  /**
   * Prints the usage message.
   */
  private static final void printUsage() {
    System.out.println("Pass in a .syz assembly file as the runtime argument.");
  }
}
