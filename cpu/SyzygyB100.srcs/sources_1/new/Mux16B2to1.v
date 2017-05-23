`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2017 09:05:34 PM
// Design Name: 
// Module Name: Mux16B2to1
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


module Mux16B2to1(
    input [15:0] aIn,
    input [15:0] bIn,
    input sel,
    output [15:0] dOut
  );
  
  assign dOut[15:0] = (sel) ? bIn [15:0] : aIn [15:0];
  
endmodule
