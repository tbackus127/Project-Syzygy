
package com.rath.syzasm;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Saves an assembled SyzygyB100 .bin file to a new .hex file with each line being a hex String representing the machine
 * code in the .bin file.
 * 
 * @author Tim Backus tbackus127@gmail.com
 *
 */
public class HexWriter {
  
  /**
   * Main method.
   * 
   * @param args runtime arguments. 0: the .bin file to convert.
   */
  public static void main(String[] args) {
    
    if (args.length > 0) {
      convertToHex(args[0]);
    } else {
      printUsage();
    }
  }
  
  /**
   * Converts a .bin file's instructions to a line-by-line hex representation.
   * 
   * @param binFilePath the file path to the .bin file.
   */
  private static final void convertToHex(final String binFilePath) {
    
    // Read all bytes from the file into an array
    Path path = Paths.get(binFilePath);
    byte[] binFileBytes = null;
    try {
      binFileBytes = Files.readAllBytes(path);
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
    if (binFileBytes == null || binFileBytes.length % 2 == 1) {
      System.out.println("Invalid .bin file.");
      return;
    }
    
    // Convert each word to hex, and write it out to the file
    final String fileName = binFilePath.replaceFirst("[.][^.]+$", "");
    final File hexFile = new File(fileName + ".hex");
    PrintStream hexOut = null;
    try {
      
      hexOut = new PrintStream(hexFile);
      for (int i = 0; i < binFileBytes.length; i += 2) {
        final String hexString = getHexValue(binFileBytes, i);
        System.out.println("Converted to " + hexString + ".");
        hexOut.println(hexString);
      }
      
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } finally {
      hexOut.close();
    }
    
  }
  
  /**
   * Converts two bytes into a hex String.
   * 
   * @param arr the byte array.
   * @param offset where to start the conversion from.
   * @return a hex number as a String.
   */
  private static final String getHexValue(final byte[] arr, final int offset) {
    
    final int wordVal = (Byte.toUnsignedInt(arr[offset]) << 8)
        | Byte.toUnsignedInt(arr[offset + 1]);
    return Integer.toHexString(wordVal);
  }
  
  /**
   * Prints the usage message.
   */
  private static final void printUsage() {
    System.out.println(
        "Pass in a .bin file assembled targeting the SyzygyB100 CPU as the runtime argument.");
  }
  
}
