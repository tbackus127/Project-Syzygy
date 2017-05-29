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
    input en,
    output [15:0] dOut
  );
  
  assign dOut[0] = dIn[0] & en;
  assign dOut[1] = dIn[1] & en;
  assign dOut[2] = dIn[2] & en;
  assign dOut[3] = dIn[3] & en;
  assign dOut[4] = dIn[4] & en;
  assign dOut[5] = dIn[5] & en;
  assign dOut[6] = dIn[6] & en;
  assign dOut[7] = dIn[7] & en;
  assign dOut[8] = dIn[8] & en;
  assign dOut[9] = dIn[9] & en;
  assign dOut[10] = dIn[10] & en;
  assign dOut[11] = dIn[11] & en;
  assign dOut[12] = dIn[12] & en;
  assign dOut[13] = dIn[13] & en;
  assign dOut[14] = dIn[14] & en;
  assign dOut[15] = dIn[15] & en;
  
endmodule
