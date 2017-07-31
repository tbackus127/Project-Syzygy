`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2017 02:02:53 PM
// Design Name: 
// Module Name: SyzMem
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


module SyzMem(
    input memClk,
    input [15:0] addrInPC,
    input [15:0] addrInAcc,
    input [15:0] dIn,
    input readEn,
    input writeEn,
    output [15:0] dOutPC,
    output [15:0] dOutAcc
  );
  
  wire [15:0] wMemDataOut;
  BRAM_wrapper blkmem (
    .memClk(memClk),
    .addrA(addrInPC[15:0]),
    .dInA(16'h0000),
    .addrB(addrInAcc[15:0]),
    .dInB(dIn[15:0]),
    .wrEnB(writeEn),
    .dOutA(dOutPC[15:0]),
    .dOutB(wMemDataOut[15:0])
  );
  
  assign dOutAcc[15:0] = (readEn) ? wMemDataOut[15:0] : 16'h0000;
  
endmodule
