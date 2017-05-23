`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2017 01:58:55 PM
// Design Name: 
// Module Name: Neg16B
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

module Neg16B(
    input [15:0] dIn,
    input sel,
    output [15:0] dOut
  );
  
  genvar i;
  for(i = 0; i < 16; i = i + 1) begin
    assign dOut[i] = dIn[i] ^ sel;
  end
  
endmodule