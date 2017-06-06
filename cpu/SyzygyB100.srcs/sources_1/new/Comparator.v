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
  
  wire [15:0] wBuf;
  Buffer16B buf0(
    .dIn(dIn[15:0]),
    .dOut(wBuf[15:0])
  );
  
  
  wire zero;
  assign zero = ~(|wBuf[15:0]);
  
  wire neg;
  assign neg = wBuf[15];
  
  wire pos;
  assign pos = (~zero) & (~neg);
  
  assign jmpEn = (neg & lt) | (zero & eq) | (pos & gt);
  
endmodule
