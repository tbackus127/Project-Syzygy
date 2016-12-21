import javax.swing.SwingUtilities;

import com.rath.syzbgui.SimFrame;

public class Main {
  
  public static void main(String[] args) {
    
    SwingUtilities.invokeLater(new Runnable() {
      
      @Override
      public void run() {
        
        @SuppressWarnings("unused")
        final SimFrame frame = new SimFrame();
      }
    });
  }
}
