`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2017 03:57:59 AM
// Design Name: 
// Module Name: SevSegInterface
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


module SevSegInterface(
    input cpuClock,
    input periphSelect,
    input [15:0] dIn,
    input [3:0] regSelect,
    input readEn,
    input writeEn,
    input reset,
    input exec,
    output [15:0] dOut,
    output [15:0] segsOut,
    output [15:0] debugOut
  );
  
  // R0: Holds the 7-seg's value
  SyzFETRegister3Out segReg(
    .dIn(dIn[15:0]),
    .clockSig(cpuClock),
    .read(readEn & periphSelect),
    .write(writeEn & periphSelect),
    .reset(reset),
    .dOut(dOut[15:0]),
    .dOut2(segsOut[15:0]),
    .debugOut(debugOut[15:0])
  );
endmodule
