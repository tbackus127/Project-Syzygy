`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2017 07:43:33 PM
// Design Name: 
// Module Name: SyzygyB100
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

module SyzygyB100(
    input clk,
    input [15:0] sw,
    input btnL,
    input btnC,
    input btnR,
    // I/Os go here as inout
    output [6:0] seg,
    output [3:0] an,
    output [15:0] led,
    output dp
  );
  
  // Data bus
  wire [15:0] dataBus; 
  
  // R0: Instruction Register
  reg [15:0] regInstr;
  
  // R1: Program Counter
  reg [15:0] regPCounter;
  
  // R2: Accumulator
  reg [15:0] regAcc;
  
  // R3: Jump address
  reg [15:0] regJmp;
  
  // R4: I/O LSB
  reg [15:0] regIOL;
  
  // R5: I/O MSB
  reg [15:0] regIOM;
  
  // R6: ALU A
  reg [15:0] regALUA;
  
  // R7: ALU B
  reg [15:0] regALUB;
  
  // R8 - RF
  reg [15:0] regGP [7:0];
  
  wire wOverflow;
  ALU alu(
    .aIn(regALUA),
    .bIn(regALUB),
    .op(regInstr[7:4]),
    .negA(regInstr[8]),
    .negB(regInstr[9]),
    .zeroB(regInstr[10]),
    .negQ(regInstr[11]),
    .arg(regInstr[12]),
    .rot(regInstr[13]),
    .arth(regInstr[14]),
    .aluOut(regAcc),
    .overflow(wOverflow)
  );
  
endmodule











