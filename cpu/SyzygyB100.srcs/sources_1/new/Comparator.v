`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2017 02:50:59 PM
// Design Name: 
// Module Name: Comparator
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


module Comparator(
    input [15:0] dIn,
    input lt,
    input eq,
    input gt,
    output jmpEn
  );
  
  wire zero;
  assign zero = |dIn[15:0];
  
  wire neg;
  assign neg = ~dIn[15];
  
  wire pos;
  assign pos = ~zero & ~neg;
  
  assign jmpEn = (neg & lt) | (zero & eq) | (pos & gt);
  
endmodule
