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


module ALU(
    input [15:0] aIn,
    input [15:0] bIn,
    input [3:0] op,
    input negA,
    input negB,
    input zeroB, 
    input negQ,
    input inc,
    input dir,
    input rot,
    input arth,
    output [15:0] aluOut,
    output overflow
  );
  
  // Input A negator
  wire [15:0] negAOut;
  
  Neg16B negA (
    .dIn(aIn[15:0]),
    .sel(negA),
    .dOut(negAOut[15:0])
  );
  
  // Input B negator
  wire [15:0] negBOut;
  
  Neg16B negB (
    .dIn(bIn[15:0]),
    .sel(negB),
    .dOut(negBOut[15:0])
  );
  
  // Select output operation
  wire [15:0] orOut;
  wire [15:0] adderOut;
  wire [15:0] shifterOut;
  wire [15:0] xorOut;
  wire [3:0] countOut;
  wire [15:0] unk01Out;
  wire [15:0] unk02Out;
  
  // Operation: OR
  assign orOut[15:0] = negAOut[15:0] | negBOut[15:0];
  
  // Operation: Add
  RCAdder16B rca(
    .aIn(negAOut[15:0]),
    .bIn(negBOut[15:0]),
    .cIn(inc),
    .dOut(adderOut[15:0]),
    .cOut(overflow)
  );
  
  // Operation: Shift
  // TODO: Implement rotation and arithmetic shift
  BarrelShifter16B shft(
    .dIn(negAOut[15:0]),
    .shAmt(negBOut[3:0]),
    .dOut(shifterOut[15:0]),
    .dir(dir),
    .rot(rot),
    .arth(arth)
  );
  
  // Operation: XOR
  assign xorOut[15:0] = negAOut[15:0] ^ negBOut[15:0];
  
  // Operation: Bit count
  // TODO: Make bit counter
  BitCounter16B counter(
    .dIn(negAOut[15:0]),
    .dOut(countOut[3:0])
  );
  
  // Operation: UNUSED
  // Operation: UNUSED
  
  // Output selector Mux
  // TODO: Make Mux16B8to1
  wire [15:0] opMuxOut;
  Mux16B8to1 opMux(
    .aIn(negAOut[15:0]),
    .bIn(orOut[15:0]),
    .cIn(adderOut[15:0]),
    .dIn(shifterOut[15:0]),
    .eIn(xorOut[15:0]),
    .fIn(countOut[3:0]),
    .gIn(unk01Out[15:0]),
    .hIn(unk02Out[15:0]),
    .sel(op[3:0]),
    .dOut(opMuxOut[15:0])
  );
  
  // Output negator
  Neg16B negOut(
    .dIn(opMuxOut[15:0]),
    .sel(negQ),
    .dOut(aluOut[15:0])
  );
  
endmodule