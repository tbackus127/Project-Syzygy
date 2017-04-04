`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2017 02:12:40 PM
// Design Name: 
// Module Name: FullAdder
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

module FullAdder(
    input aIn,
    input bIn,
    input cIn,
    output sum,
    output cOut
  );
  
  wire abx;
  assign abx = aIn ^ bIn;
  
  assign sum = abx ^ cIn;
  assign cOut = (aIn & bIn) | (abx & cIn);
  
endmodule