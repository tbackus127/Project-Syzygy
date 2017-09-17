package com.rath.umbra.generator;

import java.io.Reader;
import java.io.FileReader;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

import com.rath.umbra.entity.*;
import com.rath.umbra.grammar.UmbraParser;

public class Ucmp {
  
  public static void main(String[] args) {
    
    if(args.length != 1) {
      System.err.println("Pass a .umb file to compile.");
      return;
    }
    
    Reader reader = null;
    try {
      reader = new FileReader(args[0]);
      final PrintWriter writer = new PrintWriter(System.out, true);
      final Program prog = checkSyntax(reader);
      reader.close();
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }
  
  private static final Program checkSyntax(final Reader rd) {
    UmbraParser parser = new UmbraParser(rd);
    return parser.buildTree();
  }
}