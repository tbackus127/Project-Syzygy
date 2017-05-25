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
    input clk,
    input res,
    input [2:0] addr,
    output reg [15:0] instrOut
  );
  
  always @ (clk or addr) begin
    case(addr)
      0: instrOut = 16'h8007;
      1: instrOut = 16'h1260;
      2: instrOut = 16'h8006;
      3: instrOut = 16'h1270;
      4: instrOut = 16'h3200;
      5: instrOut = 16'h1280;
      6: instrOut = 16'h0000;
      7: instrOut = 16'h0000;
    endcase
  end
  
endmodule
