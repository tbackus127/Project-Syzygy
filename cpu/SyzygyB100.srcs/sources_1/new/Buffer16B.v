`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2017 11:45:09 PM
// Design Name: 
// Module Name: Buffer16B
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


module Buffer16B(
    input [15:0] dIn,
    output [15:0] dOut
  );
  
  wire [15:0] temp0;
  buf #(1) (temp0[15], dIn[15]);
  buf #(1) (temp0[14], dIn[14]);
  buf #(1) (temp0[13], dIn[13]);
  buf #(1) (temp0[12], dIn[12]);
  buf #(1) (temp0[11], dIn[11]);
  buf #(1) (temp0[10], dIn[10]);
  buf #(1) (temp0[9], dIn[9]);
  buf #(1) (temp0[8], dIn[8]);
  buf #(1) (temp0[7], dIn[7]);
  buf #(1) (temp0[6], dIn[6]);
  buf #(1) (temp0[5], dIn[5]);
  buf #(1) (temp0[4], dIn[4]);
  buf #(1) (temp0[3], dIn[3]);
  buf #(1) (temp0[2], dIn[2]);
  buf #(1) (temp0[1], dIn[1]);
  buf #(1) (temp0[0], dIn[0]);
  
  wire [15:0] temp1;
  buf(temp1[15], temp0[15]);
  buf(temp1[14], temp0[14]);
  buf(temp1[13], temp0[13]);
  buf(temp1[12], temp0[12]);
  buf(temp1[11], temp0[11]);
  buf(temp1[10], temp0[10]);
  buf(temp1[9], temp0[9]);
  buf(temp1[8], temp0[8]);
  buf(temp1[7], temp0[7]);
  buf(temp1[6], temp0[6]);
  buf(temp1[5], temp0[5]);
  buf(temp1[4], temp0[4]);
  buf(temp1[3], temp0[3]);
  buf(temp1[2], temp0[2]);
  buf(temp1[1], temp0[1]);
  buf(temp1[0], temp0[0]);
  
  assign dOut[15:0] = temp1[15:0];
  
endmodule
