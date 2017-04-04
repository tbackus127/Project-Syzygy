`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2017 01:13:21 PM
// Design Name: 
// Module Name: ALU
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

module RCAdder16B(
    input [15:0] aIn,
    input [15:0] bIn,
    input cIn,
    output [15:0] dOut,
    output cOut
  );
  
  wire [15:0] carry;
  FullAdder fa0 (
    .aIn(aIn[0]),
    .bIn(bIn[0]),
    .cIn(cIn),
    .sum(dOut[0]),
    .cOut(carry[0])
  );
  
  genvar i;
  for(i = 1; i < 15; i = i + 1) {
    FullAdder fa (
      .aIn(aIn[i]),
      .bIn(bIn[i]),
      .cIn(carry[i - 1]),
      .sum(dOut[i]),
      .cOut(carry[i])
    );
  }
  
  FullAdder faF (
    .aIn(aIn[15]),
    .bIn(bIn[15]),
    .cIn(carry[14]),
    .sum(dOut[15]),
    .cOut(cOut)
  );
  
endmodule