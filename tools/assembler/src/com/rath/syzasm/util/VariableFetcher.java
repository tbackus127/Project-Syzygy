
package com.rath.syzasm.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.Scanner;

/**
 * This class fetches values of variables from config files.
 * 
 * @author Tim Backus tbackus127@gmail.com
 *
 */
public class VariableFetcher {
  
  /** The relative path to the config files' directory. */
  private static final String CONFIG_DIR = "../os/conf/";
  
  private static final String CONFIG_DIR_TEST_LP = "../../../circuitry/SyzygyB100/os/conf/";
  private static final String CONFIG_DIR_TEST_DT = "../../../FPGA/SyzygyB100/os/conf/";
  
  /** The variable map (format: "filename-variableName" -> "value") */
  private static final HashMap<String, String> varMap = buildVarMap();
  
  /**
   * Performs a lookup using a config string in the assembly source.
   * 
   * @param confString the String from where to fetch the variable.
   * @return the value of the variable as a String.
   */
  public static final String lookup(final String confString) {
    
    if (confString.trim().length() <= 0) {
      return null;
    }
    
    // Get the file and variable name
    final String[] tokens = confString.split("\\.");
    if (tokens.length < 3) {
      return null;
    }
    final String category = tokens[1].trim().toLowerCase();
    final String varName = tokens[2].trim().toLowerCase();
    
    return varMap.get(category + "-" + varName);
  }
  
  /**
   * Constructs the variable map.
   * 
   * @return a map that maps from the filename-variable String to its value.
   */
  private static final HashMap<String, String> buildVarMap() {
    final HashMap<String, String> result = new HashMap<String, String>();
    
    // Set to test directory if we're in Eclipse workbench
    String cfgDir = CONFIG_DIR;
    if (!new File(cfgDir).exists()) cfgDir = CONFIG_DIR_TEST_LP;
    if (!new File(cfgDir).exists()) cfgDir = CONFIG_DIR_TEST_DT;
    
    // Go through all config files
    final File[] confFiles = new File(cfgDir).listFiles();
    for (final File f : confFiles) {
      Scanner fscan = null;
      try {
        fscan = new Scanner(f);
        
        System.out.println("Building variable map with \"" + f.getName() + "\".");
        
        // Scan through all lines
        while (fscan.hasNextLine()) {
          final String line = fscan.nextLine();
          
          // Ignore comments
          if (line.startsWith("#")) continue;
          String[] tokens = line.split("\\s+");
          
          // If it's a valid assignment
          if (tokens.length == 2) {
            final String fname = f.getName();
            final int dotIdx = fname.lastIndexOf('.');
            final String fileLabel = fname.substring(0, dotIdx);
            final String varKey = fileLabel + "-" + tokens[0].trim().toLowerCase();
            final String varValue = tokens[1].trim().toLowerCase();
            System.out.println("  Added mapping: \"" + varKey + "\" -> \"" + varValue + "\".");
            result.put(varKey, varValue);
          }
        }
        
      } catch (FileNotFoundException e) {
        e.printStackTrace();
      } finally {
        fscan.close();
      }
    }
    
    return result;
  }
}
