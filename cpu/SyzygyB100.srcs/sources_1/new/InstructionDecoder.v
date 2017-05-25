`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 05:29:26 PM
// Design Name: 
// Module Name: InstructionDecoder
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

module InstructionDecoder(
    input [15:0] instrIn,
    output [14:0] pushVal,
    output [3:0] regReadSelect,
    output readEn,
    output [3:0] regWriteSelect,
    output writeEn,
    output [2:0] jumpCondition,
    output [2:0] aluOp,
    output [7:0] aluArgs,
    output [3:0] periphSelect,
    output [1:0] periphMode
  );
  
  
  
endmodule
