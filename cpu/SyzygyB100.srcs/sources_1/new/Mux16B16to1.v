`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2017 12:28:54 AM
// Design Name: 
// Module Name: Mux16B16to1
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


module Mux16B16to1(
    input [15:0] dIn0,
    input [15:0] dIn1,
    input [15:0] dIn2,
    input [15:0] dIn3,
    input [15:0] dIn4,
    input [15:0] dIn5,
    input [15:0] dIn6,
    input [15:0] dIn7,
    input [15:0] dIn8,
    input [15:0] dIn9,
    input [15:0] dIn10,
    input [15:0] dIn11,
    input [15:0] dIn12,
    input [15:0] dIn13,
    input [15:0] dIn14,
    input [15:0] dIn15,
    input [3:0] sel,
    output reg [15:0] dOut
  );
  
  always @ (*) begin
    case(sel)
      4'b0000: dOut[15:0] <= dIn0[15:0];
      4'b0001: dOut[15:0] <= dIn1[15:0];
      4'b0010: dOut[15:0] <= dIn2[15:0];
      4'b0011: dOut[15:0] <= dIn3[15:0];
      4'b0100: dOut[15:0] <= dIn4[15:0];
      4'b0101: dOut[15:0] <= dIn5[15:0];
      4'b0110: dOut[15:0] <= dIn6[15:0];
      4'b0111: dOut[15:0] <= dIn7[15:0];
      4'b1000: dOut[15:0] <= dIn8[15:0];
      4'b1001: dOut[15:0] <= dIn9[15:0];
      4'b1010: dOut[15:0] <= dIn10[15:0];
      4'b1011: dOut[15:0] <= dIn11[15:0];
      4'b1100: dOut[15:0] <= dIn12[15:0];
      4'b1101: dOut[15:0] <= dIn13[15:0];
      4'b1110: dOut[15:0] <= dIn14[15:0];
      4'b1111: dOut[15:0] <= dIn15[15:0];
    endcase
  end
  
endmodule
