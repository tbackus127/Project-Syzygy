`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2017 01:58:13 PM
// Design Name: 
// Module Name: BootRom
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


module BootRom(
    input en,
    input [5:0] addr,
    output [15:0] instrOut,
    output [15:0] debugOut
  );
  
  reg [15:0] instr = 16'h0000;
  
  always @ (addr) begin
    case(addr)
      0: instr[15:0] = 16'h8000;   // COUNT_START: push 0
      1: instr[15:0] = 16'h1260;   //              copy 2, 6
      2: instr[15:0] = 16'h3260;   //              dec
      3: instr[15:0] = 16'h1290;   //              copy 2, 9
      4: instr[15:0] = 16'h801b;   // OUTER_START: push 27 (OUTER_END)
      5: instr[15:0] = 16'h1230;   //              copy 2, 3   
      6: instr[15:0] = 16'h1920;   //              copy 9, 2   
      7: instr[15:0] = 16'h2400;   //              jeq
      8: instr[15:0] = 16'h8000;   //              push 0
      9: instr[15:0] = 16'h1260;   //              copy 2, 6
      10: instr[15:0] = 16'h3260;  //              dec
      11: instr[15:0] = 16'h1260;  //              copy 2, 6
      12: instr[15:0] = 16'h8015;  // INNER_START: push 21 (INNER_END)
      13: instr[15:0] = 16'h1230;  //              copy 2, 3
      14: instr[15:0] = 16'h1620;  //              copy 6, 2
      15: instr[15:0] = 16'h2400;  //              jeq
      16: instr[15:0] = 16'h3260;  //              dec
      17: instr[15:0] = 16'h1260;  //              copy 2, 6
      18: instr[15:0] = 16'h800c;  //              push 12 (INNER_START)
      19: instr[15:0] = 16'h1230;  //              copy 2, 3
      20: instr[15:0] = 16'h2e00;  //              jmp
      21: instr[15:0] = 16'h1960;  //   INNER_END: copy 9, 6
      22: instr[15:0] = 16'h3260;  //              dec
      23: instr[15:0] = 16'h1290;  //              copy 2, 9
      24: instr[15:0] = 16'h8004;  //              push 4 (OUTER_START)
      25: instr[15:0] = 16'h1230;  //              copy 2, 3
      26: instr[15:0] = 16'h2e00;  //              jmp
      27: instr[15:0] = 16'h1860;  //  OUTER_END:  copy 8, 6
      28: instr[15:0] = 16'h3228;  //              inc
      29: instr[15:0] = 16'h1280;  //              copy 2, 8
      30: instr[15:0] = 16'h8000;  //              push 0 (COUNT_START)
      31: instr[15:0] = 16'h1230;  //              copy 2, 3
      32: instr[15:0] = 16'h2e00;  //              jmp
      default: instr[15:0] = 16'h0000;
    endcase
  end
  
  assign instrOut[15:0] = (en) ? instr[15:0] : 16'h0000;
  assign debugOut[15:0] = instr[15:0];
  
endmodule
