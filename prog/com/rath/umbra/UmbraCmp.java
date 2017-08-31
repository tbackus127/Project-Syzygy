
import java.io.*;

public class UmbraCmp {
  
  public static void main(String[] args) {
    
    File fileIn;
    
    if((fileIn = checkArgs(args)) == null) {
      printUsage();
      return;
    }
    
    final UmbraCmp compiler = new UmbraCmp();
    final Reader reader = new FileReader(fileIn);
    final PrintWriter writer = new PrintWriter(System.out, true);
    
    Program program = compiler.checkSyntax(reader);
    // Print syntax tree here
    
    // compiler.translate();
    
  }
  
  
  
  private static final File checkArgs(final String[] args) {
    
    if(args.length != 1)
      return null;
    
    final File fileIn = new File(args[0]);
    if(!fileIn.exists()) {
      return null;
    }
    
    return fileIn;
  }
  
  private static final void printUsage() {
    System.err.println("Usage: \"java UmbraCmp <PATH_TO_.umb_FILE>\"");
  }
  
}