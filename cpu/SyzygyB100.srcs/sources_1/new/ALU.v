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
    input [2:0] op,
    input negA,
    input negB,
    input zeroB, 
    input negQ,
    input arg,
    input arth,
    input rot,
    input misc,
    output [15:0] aluOut
  );
  
  wire [15:0] zeroBOut;
  Mux16B2to1 zeroBMux(
    .aIn(bIn[15:0]),
    .bIn(16'b0000000000000000),
    .sel(zeroB),
    .dOut(zeroBOut[15:0])
  );
  
  // Input A negator
  wire [15:0] negAOut;
  Neg16B negatorA (
    .dIn(aIn[15:0]),
    .sel(negA),
    .dOut(negAOut[15:0])
  );
  
  // Input B negator
  wire [15:0] negBOut;
  Neg16B negatorB (
    .dIn(zeroBOut[15:0]),
    .sel(negB),
    .dOut(negBOut[15:0])
  );
  
  // Select output operation
  wire [15:0] orOut;
  wire [15:0] adderOut;
  wire [15:0] shifterOut;
  wire [15:0] xorOut;
  wire [4:0] countOut;
  
  // Operation: OR
  assign orOut[15:0] = negAOut[15:0] | negBOut[15:0];
  
  // Operation: Add
  RCAdder16B rca(
    .aIn(negAOut[15:0]),
    .bIn(negBOut[15:0]),
    .cIn(arg),
    .dOut(adderOut[15:0]),
    .cOut(overflow)
  );
  
  // Operation: Shift
  BarrelShifter16B shft(
    .dIn(negAOut[15:0]),
    .shAmt(negBOut[3:0]),
    .dOut(shifterOut[15:0]),
    .dir(arg),
    .rot(rot),
    .arth(arth)
  );
  
  // Operation: XOR
  assign xorOut[15:0] = negAOut[15:0] ^ negBOut[15:0];
  
  // Operation: Bit count
  BitCounter16B counter(
    .dIn(negAOut[15:0]),
    .dOut(countOut[4:0])
  );
  
  // Output selector Mux
  wire [15:0] opMuxOut;
  Mux16B8to1 opMux(
    .dIn0(negAOut[15:0]),
    .dIn1(orOut[15:0]),
    .dIn2(adderOut[15:0]),
    .dIn3(shifterOut[15:0]),
    .dIn4(xorOut[15:0]),
    .dIn5({11'b00000000000, countOut[4:0]}),
    .dIn6(16'b0000000000000000),
    .dIn7(16'b0000000000000000),
    .sel(op[2:0]),
    .dOut(opMuxOut[15:0])
  );
  
  // Output negator
  Neg16B negOut(
    .dIn(opMuxOut[15:0]),
    .sel(negQ),
    .dOut(wBuf0[15:0])
  );
  
  wire [15:0] wBuf0;
    Buffer16B buf0(
    .dIn(wBuf0[15:0]),
    .dOut(wBuf1[15:0])
  );
  
  wire [15:0] wBuf1;
  Buffer16B buf1(
    .dIn(wBuf1[15:0]),
    .dOut(aluOut[15:0])
  );
  
  
endmodule