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
  
  wire [15:0] temp;
  buf(temp[0], dIn[0]);
  buf(temp[1], dIn[1]);
  buf(temp[2], dIn[2]);
  buf(temp[3], dIn[3]);
  buf(temp[4], dIn[4]);
  buf(temp[5], dIn[5]);
  buf(temp[6], dIn[6]);
  buf(temp[7], dIn[7]);
  buf(temp[8], dIn[8]);
  buf(temp[9], dIn[9]);
  buf(temp[10], dIn[10]);
  buf(temp[11], dIn[11]);
  buf(temp[12], dIn[12]);
  buf(temp[13], dIn[13]);
  buf(temp[14], dIn[14]);
  buf(temp[15], dIn[15]);
  
  assign dOut[15:0] = temp[15:0];
  
endmodule
