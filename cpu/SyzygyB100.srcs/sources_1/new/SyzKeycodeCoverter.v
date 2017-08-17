`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2017 08:29:43 PM
// Design Name: 
// Module Name: SyzKeycodeCoverter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SyzKeycodeConverter(
    input convClk,
    input [15:0] keyIn,
    output reg [15:0] keyOut = 16'h0000
  );
  
  // Protocol codes
  parameter KEYCODE_RELEASE = 8'hf0;
  
  // Control Keys
  parameter KEYCODE_ESC = 8'h76;
  parameter KEYCODE_F1 = 8'h05;
  parameter KEYCODE_F2 = 8'h06;
  parameter KEYCODE_F3 = 8'h04;
  parameter KEYCODE_F4 = 8'h0c;
  parameter KEYCODE_F5 = 8'h03;
  parameter KEYCODE_F6 = 8'h0b;
  parameter KEYCODE_F7 = 8'h83;
  parameter KEYCODE_F8 = 8'h0a;
  parameter KEYCODE_F9 = 8'h01;
  parameter KEYCODE_F10 = 8'h09;
  parameter KEYCODE_F11 = 8'h78;
  parameter KEYCODE_F12 = 8'h07;
  parameter KEYCODE_RETURN = 8'h5a;
  parameter KEYCODE_BACKSPACE = 8'h66;
  parameter KEYCODE_CAPSLOCK = 8'h58;
  parameter KEYCODE_NUMLOCK = 8'h77;        // TODO: Find a different use for this
  parameter KEYCODE_SCRLOCK = 8'h7e;        // TODO: Find a different use for this
  
  // Number pad keys (used for control instead)
  parameter KEYCODE_NUM0 = 8'h70;           // Insert
  parameter KEYCODE_NUM1 = 8'h69;           // End
  parameter KEYCODE_NUM2 = 8'h72;           // Down arrow
  parameter KEYCODE_NUM3 = 8'h7a;           // Page down
  parameter KEYCODE_NUM4 = 8'h6b;           // Left arrow
  parameter KEYCODE_NUM5 = 8'h73;           // TODO: Find a use for this one.
  parameter KEYCODE_NUM6 = 8'h74;           // Right arrow
  parameter KEYCODE_NUM7 = 8'h6c;           // Home
  parameter KEYCODE_NUM8 = 8'h75;           // Up arrow
  parameter KEYCODE_NUM9 = 8'h7d;           // Page up
  parameter KEYCODE_NUMDEC = 8'h71;         // Delete
  
  // Modifier Keys
  parameter KEYCODE_SHIFT = 8'h12;
  parameter KEYCODE_ALT = 8'h11;
  parameter KEYCODE_CTRL = 8'h14;
  
  // Letters
  parameter KEYCODE_A = 8'h1c;
  parameter KEYCODE_B = 8'h32;
  parameter KEYCODE_C = 8'h21;
  parameter KEYCODE_D = 8'h23;
  parameter KEYCODE_E = 8'h24;
  parameter KEYCODE_F = 8'h2b;
  parameter KEYCODE_G = 8'h34;
  parameter KEYCODE_H = 8'h33;
  parameter KEYCODE_I = 8'h43;
  parameter KEYCODE_J = 8'h3b;
  parameter KEYCODE_K = 8'h42;
  parameter KEYCODE_L = 8'h4b;
  parameter KEYCODE_M = 8'h3a;
  parameter KEYCODE_N = 8'h31;
  parameter KEYCODE_O = 8'h44;
  parameter KEYCODE_P = 8'h4d;
  parameter KEYCODE_Q = 8'h15;
  parameter KEYCODE_R = 8'h2d;
  parameter KEYCODE_S = 8'h1b;
  parameter KEYCODE_T = 8'h2c;
  parameter KEYCODE_U = 8'h3c;
  parameter KEYCODE_V = 8'h2a;
  parameter KEYCODE_W = 8'h1d;
  parameter KEYCODE_X = 8'h22;
  parameter KEYCODE_Y = 8'h35;
  parameter KEYCODE_Z = 8'h1a;
  
  // Numbers
  parameter KEYCODE_0 = 8'h45;
  parameter KEYCODE_1 = 8'h16;
  parameter KEYCODE_2 = 8'h1e;
  parameter KEYCODE_3 = 8'h26;
  parameter KEYCODE_4 = 8'h25;
  parameter KEYCODE_5 = 8'h2e;
  parameter KEYCODE_6 = 8'h36;
  parameter KEYCODE_7 = 8'h3d;
  parameter KEYCODE_8 = 8'h3e;
  parameter KEYCODE_9 = 8'h46;
  
  // Symbols
  parameter KEYCODE_GRAVE = 8'h0e;
  parameter KEYCODE_HYPHEN = 8'h4e;
  parameter KEYCODE_EQUALS = 8'h55;
  parameter KEYCODE_LBRAC = 8'h54;
  parameter KEYCODE_RBRAC = 8'h5b;
  parameter KEYCODE_BSLASH = 8'h5d;
  parameter KEYCODE_SEMIC = 8'h4c;
  parameter KEYCODE_QUOTE = 8'h52;
  parameter KEYCODE_COMMA = 8'h41;
  parameter KEYCODE_PERIOD = 8'h49;
  parameter KEYCODE_SLASH = 8'h4a;
  
  // Miscellaneous keys
  parameter KEYCODE_SPACE = 8'h29;
  parameter KEYCODE_TAB = 8'h0d;

  // SYZ Keycode format: 
  //   0000 hacs kkkk kkkk
  //     a: Flag whether ALT is held down (0 = released, 1 = held)
  //     c: Whether CTRL is held down
  //     s: Whether SHIFT is held down
  //     h: Whether the key itself is held down
  //     k: Normalized keycode (because the standard one makes no sense)
  reg shiftHeld = 1'b0;
  reg altHeld = 1'b0;
  reg ctrlHeld = 1'b0;
  reg keyHeld = 1'b0;
  
  always @ (posedge convClk) begin
    
    // Key down
    if(keyIn[15:8] == keyIn[7:0]) begin
      
      // Switch on key state flags
      keyHeld <= 1'b1;
      if(keyIn[7:0] == KEYCODE_SHIFT) shiftHeld <= 1'b0;
      else if(keyIn[7:0] == KEYCODE_CTRL) ctrlHeld <= 1'b0;
      else if(keyIn[7:0] == KEYCODE_ALT) altHeld <= 1'b0;
      
    // Key released
    end else begin
      if(keyIn[15:8] == KEYCODE_RELEASE) begin
        
        // Switch off modifier flags
        keyHeld <= 1'b0;
        if(keyIn[7:0] == KEYCODE_SHIFT) shiftHeld <= 1'b1;
        else if(keyIn[7:0] == KEYCODE_CTRL) ctrlHeld <= 1'b1;
        else if(keyIn[7:0] == KEYCODE_ALT) altHeld <= 1'b1;
        
      end
    end
    
    // Convert PS/2 code to SYZ code
    case(keyIn[7:0])
      KEYCODE_ESC: keyOut[7:0] = 8'h01;
      KEYCODE_F1: keyOut[7:0] = 8'h02;
      KEYCODE_F2: keyOut[7:0] = 8'h03;
      KEYCODE_F3: keyOut[7:0] = 8'h04;
      KEYCODE_F4: keyOut[7:0] = 8'h05;
      KEYCODE_F5: keyOut[7:0] = 8'h06;
      KEYCODE_F6: keyOut[7:0] = 8'h07;
      KEYCODE_F7: keyOut[7:0] = 8'h08;
      KEYCODE_F8: keyOut[7:0] = 8'h09;
      KEYCODE_F9: keyOut[7:0] = 8'h0a;
      KEYCODE_F10: keyOut[7:0] = 8'h0b;
      KEYCODE_F11: keyOut[7:0] = 8'h0c;
      KEYCODE_F12: keyOut[7:0] = 8'h0d;
      KEYCODE_RETURN: keyOut[7:0] = 8'h0e;
      KEYCODE_BACKSPACE: keyOut[7:0] = 8'h0f;
      KEYCODE_CAPSLOCK: keyOut[7:0] = 8'h10;
      KEYCODE_NUMLOCK: keyOut[7:0] = 8'h11;
      KEYCODE_SCRLOCK: keyOut[7:0] = 8'h12;
      KEYCODE_NUM0: keyOut[7:0] = 8'h13;
      KEYCODE_NUM1: keyOut[7:0] = 8'h14;
      KEYCODE_NUM2: keyOut[7:0] = 8'h15;
      KEYCODE_NUM3: keyOut[7:0] = 8'h16;
      KEYCODE_NUM4: keyOut[7:0] = 8'h17;
      KEYCODE_NUM5: keyOut[7:0] = 8'h18;
      KEYCODE_NUM6: keyOut[7:0] = 8'h19;
      KEYCODE_NUM7: keyOut[7:0] = 8'h1a;
      KEYCODE_NUM8: keyOut[7:0] = 8'h1b;
      KEYCODE_NUM9: keyOut[7:0] = 8'h1c;
      KEYCODE_NUMDEC: keyOut[7:0] = 8'h1d;
      KEYCODE_SHIFT: keyOut[7:0] = 8'h1e;
      KEYCODE_ALT: keyOut[7:0] = 8'h1f;
      KEYCODE_CTRL: keyOut[7:0] = 8'h20;
      KEYCODE_A: keyOut[7:0] = 8'h21;
      KEYCODE_B: keyOut[7:0] = 8'h22;
      KEYCODE_C: keyOut[7:0] = 8'h23;
      KEYCODE_D: keyOut[7:0] = 8'h24;
      KEYCODE_E: keyOut[7:0] = 8'h25;
      KEYCODE_F: keyOut[7:0] = 8'h26;
      KEYCODE_G: keyOut[7:0] = 8'h27;
      KEYCODE_H: keyOut[7:0] = 8'h28;
      KEYCODE_I: keyOut[7:0] = 8'h29;
      KEYCODE_J: keyOut[7:0] = 8'h2a;
      KEYCODE_K: keyOut[7:0] = 8'h2b;
      KEYCODE_L: keyOut[7:0] = 8'h2c;
      KEYCODE_M: keyOut[7:0] = 8'h2d;
      KEYCODE_N: keyOut[7:0] = 8'h2e;
      KEYCODE_O: keyOut[7:0] = 8'h2f;
      KEYCODE_P: keyOut[7:0] = 8'h30;
      KEYCODE_Q: keyOut[7:0] = 8'h31;
      KEYCODE_R: keyOut[7:0] = 8'h32;
      KEYCODE_S: keyOut[7:0] = 8'h33;
      KEYCODE_T: keyOut[7:0] = 8'h34;
      KEYCODE_U: keyOut[7:0] = 8'h35;
      KEYCODE_V: keyOut[7:0] = 8'h36;
      KEYCODE_W: keyOut[7:0] = 8'h37;
      KEYCODE_X: keyOut[7:0] = 8'h38;
      KEYCODE_Y: keyOut[7:0] = 8'h39;
      KEYCODE_Z: keyOut[7:0] = 8'h3a;
      KEYCODE_0: keyOut[7:0] = 8'h3b;
      KEYCODE_1: keyOut[7:0] = 8'h3c;
      KEYCODE_2: keyOut[7:0] = 8'h3d;
      KEYCODE_3: keyOut[7:0] = 8'h3e;
      KEYCODE_4: keyOut[7:0] = 8'h3f;
      KEYCODE_5: keyOut[7:0] = 8'h40;
      KEYCODE_6: keyOut[7:0] = 8'h41;
      KEYCODE_7: keyOut[7:0] = 8'h42;
      KEYCODE_8: keyOut[7:0] = 8'h43;
      KEYCODE_9: keyOut[7:0] = 8'h44;
      KEYCODE_GRAVE: keyOut[7:0] = 8'h45;
      KEYCODE_HYPHEN: keyOut[7:0] = 8'h46;
      KEYCODE_EQUALS: keyOut[7:0] = 8'h47;
      KEYCODE_LBRAC: keyOut[7:0] = 8'h48;
      KEYCODE_RBRAC: keyOut[7:0] = 8'h49;
      KEYCODE_BSLASH: keyOut[7:0] = 8'h4a;
      KEYCODE_SEMIC: keyOut[7:0] = 8'h4b;
      KEYCODE_QUOTE: keyOut[7:0] = 8'h4c;
      KEYCODE_COMMA: keyOut[7:0] = 8'h4d;
      KEYCODE_PERIOD: keyOut[7:0] = 8'h4e;
      KEYCODE_SLASH: keyOut[7:0] = 8'h4f;
      KEYCODE_SPACE: keyOut[7:0] = 8'h50;
      KEYCODE_TAB: keyOut[7:0] = 8'h51;
      default: keyOut[7:0] = 8'h00;
    endcase
    
    keyOut[8] <= shiftHeld;
    keyOut[9] <= ctrlHeld;
    keyOut[10] <= altHeld;
    keyOut[11] <= keyHeld;
  end
  
endmodule