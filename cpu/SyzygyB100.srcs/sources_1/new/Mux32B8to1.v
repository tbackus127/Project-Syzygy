`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2017 03:44:56 AM
// Design Name: 
// Module Name: Mux32B8to1
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


module Mux32B8to1(
    input [31:0] dIn0,
    input [31:0] dIn1,
    input [31:0] dIn2,
    input [31:0] dIn3,
    input [31:0] dIn4,
    input [31:0] dIn5,
    input [31:0] dIn6,
    input [31:0] dIn7,
    input [2:0] sel,
    output reg [31:0] dOut = 32'h00000000
    );
    
    always @ (*) begin
    case(sel)
      3'b000: dOut[31:0] <= dIn0[31:0];
      3'b001: dOut[31:0] <= dIn1[31:0];
      3'b010: dOut[31:0] <= dIn2[31:0];
      3'b011: dOut[31:0] <= dIn3[31:0];
      3'b100: dOut[31:0] <= dIn4[31:0];
      3'b101: dOut[31:0] <= dIn5[31:0];
      3'b110: dOut[31:0] <= dIn6[31:0];
      3'b111: dOut[31:0] <= dIn7[31:0];
    endcase
  end
endmodule
