`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2017 08:03:15 PM
// Design Name: 
// Module Name: Mux16B8to1
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

module Mux16B8to1(
    input [15:0] dIn0,
    input [15:0] dIn1,
    input [15:0] dIn2,
    input [15:0] dIn3,
    input [15:0] dIn4,
    input [15:0] dIn5,
    input [15:0] dIn6,
    input [15:0] dIn7,
    input [2:0] sel,
    output [15:0] dOut
  );
  
  // Determine output of multiplexer
  reg [15:0] muxOut;
  always @(dIn0 or dIn1 or dIn2 or dIn3 or dIn4 or dIn5 or dIn6 or dIn7 or sel) begin
    case(sel)
      3'b000: muxOut[15:0] = dIn0[15:0];
      3'b001: muxOut[15:0] = dIn1[15:0];
      3'b010: muxOut[15:0] = dIn2[15:0];
      3'b011: muxOut[15:0] = dIn3[15:0];
      3'b100: muxOut[15:0] = dIn4[15:0];
      3'b101: muxOut[15:0] = dIn5[15:0];
      3'b110: muxOut[15:0] = dIn6[15:0];
      3'b111: muxOut[15:0] = dIn7[15:0];
    endcase
  end
  
  assign dOut[15:0] = muxOut[15:0];
  
endmodule
