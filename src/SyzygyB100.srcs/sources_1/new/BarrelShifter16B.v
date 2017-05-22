`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2017 08:15:21 PM
// Design Name: 
// Module Name: BarrelShifter16B
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


module BarrelShifter16B(
    input [15:0] dIn,
    input [3:0] shAmt,
    output [15:0] dOut,
    input dir,
    input rot,
    input arth
  );
    
  // Reverse bits if shifting left
  Reverser16B rev1(
    .dIn(dIn[15:0]),
    .rev(dir),
    .dOut(shftIn[15:0])
  );
  
  wire [15:0] shftIn;
  
  // ---------------------------------------------------------------------------
  // Step 1
  // ---------------------------------------------------------------------------
  
  // Rotation multiplexers
  wire step1rotOut;
  Mux2to1 r00 (
    .aIn(1'b0),
    .bIn(shftIn[15]),
    .sel(rot),
    .out(step1rotOut)
  );
  
  // Shift multiplexers
  wire [15:0] step1out;
  Mux2to1 m10(
    .aIn(shftIn[0]),
    .bIn(step1rotOut),
    .sel(shAmt[0]),
    .out(step1out[0])
  );
  Mux2to1 m11(
    .aIn(shftIn[1]),
    .bIn(shftIn[0]),
    .sel(shAmt[0]),
    .out(step1out[1])
  );
  Mux2to1 m12(
    .aIn(shftIn[2]),
    .bIn(shftIn[1]),
    .sel(shAmt[0]),
    .out(step1out[2])
  );
  Mux2to1 m13(
    .aIn(shftIn[3]),
    .bIn(shftIn[2]),
    .sel(shAmt[0]),
    .out(step1out[3])
  );
  Mux2to1 m14(
    .aIn(shftIn[4]),
    .bIn(shftIn[3]),
    .sel(shAmt[0]),
    .out(step1out[4])
  );
  Mux2to1 m15(
    .aIn(shftIn[5]),
    .bIn(shftIn[4]),
    .sel(shAmt[0]),
    .out(step1out[5])
  );
  Mux2to1 m16(
    .aIn(shftIn[6]),
    .bIn(shftIn[5]),
    .sel(shAmt[0]),
    .out(step1out[6])
  );
  Mux2to1 m17(
    .aIn(shftIn[7]),
    .bIn(shftIn[6]),
    .sel(shAmt[0]),
    .out(step1out[7])
  );
  Mux2to1 m18(
    .aIn(shftIn[8]),
    .bIn(shftIn[7]),
    .sel(shAmt[0]),
    .out(step1out[8])
  );
  Mux2to1 m19(
    .aIn(shftIn[9]),
    .bIn(shftIn[8]),
    .sel(shAmt[0]),
    .out(step1out[9])
  );
  Mux2to1 m1A(
    .aIn(shftIn[10]),
    .bIn(shftIn[9]),
    .sel(shAmt[0]),
    .out(step1out[10])
  );
  Mux2to1 m1B(
    .aIn(shftIn[11]),
    .bIn(shftIn[10]),
    .sel(shAmt[0]),
    .out(step1out[11])
  );
  Mux2to1 m1C(
    .aIn(shftIn[12]),
    .bIn(shftIn[11]),
    .sel(shAmt[0]),
    .out(step1out[12])
  );
  Mux2to1 m1D(
    .aIn(shftIn[13]),
    .bIn(shftIn[12]),
    .sel(shAmt[0]),
    .out(step1out[13])
  );
  Mux2to1 m1E(
    .aIn(shftIn[14]),
    .bIn(shftIn[13]),
    .sel(shAmt[0]),
    .out(step1out[14])
  );
  Mux2to1 m1F(
    .aIn(shftIn[15]),
    .bIn(shftIn[14]),
    .sel(shAmt[0]),
    .out(step1out[15])
  );
  
  // ---------------------------------------------------------------------------
  // Step 2
  // ---------------------------------------------------------------------------
  
  // Rotation multiplexers
  wire [1:0] step2rotOut;
  Mux2to1 r10 (
    .aIn(1'b0),
    .bIn(step1out[14]),
    .sel(rot),
    .out(step2rotOut[0])
  );
  Mux2to1 r11 (
    .aIn(1'b0),
    .bIn(step1out[15]),
    .sel(rot),
    .out(step2rotOut[1])
  );
    
  // Shift multiplexers
  wire [15:0] step2out;
  Mux2to1 m20(
    .aIn(step1out[0]),
    .bIn(step2rotOut[0]),
    .sel(shAmt[1]),
    .out(step2out[0])
  );
  Mux2to1 m21(
    .aIn(step1out[1]),
    .bIn(step2rotOut[1]),
    .sel(shAmt[1]),
    .out(step2out[1])
  );
  Mux2to1 m22(
    .aIn(step1out[2]),
    .bIn(step1out[0]),
    .sel(shAmt[1]),
    .out(step2out[2])
  );
  Mux2to1 m23(
    .aIn(step1out[3]),
    .bIn(step1out[1]),
    .sel(shAmt[1]),
    .out(step2out[3])
  );
  Mux2to1 m24(
    .aIn(step1out[4]),
    .bIn(step1out[2]),
    .sel(shAmt[1]),
    .out(step2out[4])
  );
  Mux2to1 m25(
    .aIn(step1out[5]),
    .bIn(step1out[3]),
    .sel(shAmt[1]),
    .out(step2out[5])
  );
  Mux2to1 m26(
    .aIn(step1out[6]),
    .bIn(step1out[4]),
    .sel(shAmt[1]),
    .out(step2out[6])
  );
  Mux2to1 m27(
    .aIn(step1out[7]),
    .bIn(step1out[5]),
    .sel(shAmt[1]),
    .out(step2out[7])
  );
  Mux2to1 m28(
    .aIn(step1out[8]),
    .bIn(step1out[6]),
    .sel(shAmt[1]),
    .out(step2out[8])
  );
  Mux2to1 m29(
    .aIn(step1out[9]),
    .bIn(step1out[7]),
    .sel(shAmt[1]),
    .out(step2out[9])
  );
  Mux2to1 m2A(
    .aIn(step1out[10]),
    .bIn(step1out[8]),
    .sel(shAmt[1]),
    .out(step2out[10])
  );
  Mux2to1 m2B(
    .aIn(step1out[11]),
    .bIn(step1out[9]),
    .sel(shAmt[1]),
    .out(step2out[11])
  );
  Mux2to1 m2C(
    .aIn(step1out[12]),
    .bIn(step1out[10]),
    .sel(shAmt[1]),
    .out(step2out[12])
  );
  Mux2to1 m2D(
    .aIn(step1out[13]),
    .bIn(step1out[11]),
    .sel(shAmt[1]),
    .out(step2out[13])
  );
  Mux2to1 m2E(
    .aIn(step1out[14]),
    .bIn(step1out[12]),
    .sel(shAmt[1]),
    .out(step2out[14])
  );
  Mux2to1 m2F(
    .aIn(step1out[15]),
    .bIn(step1out[13]),
    .sel(shAmt[1]),
    .out(step2out[15])
  );
  
  
  // ---------------------------------------------------------------------------
  // Step 3
  // ---------------------------------------------------------------------------
  
  // Rotation multiplexers
  wire [3:0] step3rotOut;
  Mux2to1 r20 (
    .aIn(1'b0),
    .bIn(step2out[12]),
    .sel(rot),
    .out(step3rotOut[0])
  );
  Mux2to1 r21 (
    .aIn(1'b0),
    .bIn(step2out[13]),
    .sel(rot),
    .out(step3rotOut[1])
  );
  Mux2to1 r22 (
    .aIn(1'b0),
    .bIn(step2out[14]),
    .sel(rot),
    .out(step3rotOut[2])
  );
  Mux2to1 r23 (
    .aIn(1'b0),
    .bIn(step2out[15]),
    .sel(rot),
    .out(step3rotOut[3])
  );
  
  // Shift multiplexers
  wire [15:0] step3out;
  Mux2to1 m30(
    .aIn(step2out[0]),
    .bIn(step3rotOut[0]),
    .sel(shAmt[2]),
    .out(step3out[0])
  );
  Mux2to1 m31(
    .aIn(step2out[1]),
    .bIn(step3rotOut[1]),
    .sel(shAmt[2]),
    .out(step3out[1])
  );
  Mux2to1 m32(
    .aIn(step2out[2]),
    .bIn(step3rotOut[2]),
    .sel(shAmt[2]),
    .out(step3out[2])
  );
  Mux2to1 m33(
    .aIn(step2out[3]),
    .bIn(step3rotOut[3]),
    .sel(shAmt[2]),
    .out(step3out[3])
  );
  Mux2to1 m34(
    .aIn(step2out[4]),
    .bIn(step2out[0]),
    .sel(shAmt[2]),
    .out(step3out[4])
  );
  Mux2to1 m35(
    .aIn(step2out[5]),
    .bIn(step2out[1]),
    .sel(shAmt[2]),
    .out(step3out[5])
  );
  Mux2to1 m36(
    .aIn(step2out[6]),
    .bIn(step2out[2]),
    .sel(shAmt[2]),
    .out(step3out[6])
  );
  Mux2to1 m37(
    .aIn(step2out[7]),
    .bIn(step2out[3]),
    .sel(shAmt[2]),
    .out(step3out[7])
  );
  Mux2to1 m38(
    .aIn(step2out[8]),
    .bIn(step2out[4]),
    .sel(shAmt[2]),
    .out(step3out[8])
  );
  Mux2to1 m39(
    .aIn(step2out[9]),
    .bIn(step2out[5]),
    .sel(shAmt[2]),
    .out(step3out[9])
  );
  Mux2to1 m3A(
    .aIn(step2out[10]),
    .bIn(step2out[6]),
    .sel(shAmt[2]),
    .out(step3out[10])
  );
  Mux2to1 m3B(
    .aIn(step2out[11]),
    .bIn(step2out[7]),
    .sel(shAmt[2]),
    .out(step3out[11])
  );
  Mux2to1 m3C(
    .aIn(step2out[12]),
    .bIn(step2out[8]),
    .sel(shAmt[2]),
    .out(step3out[12])
  );
  Mux2to1 m3D(
    .aIn(step2out[13]),
    .bIn(step2out[9]),
    .sel(shAmt[2]),
    .out(step3out[13])
  );
  Mux2to1 m3E(
    .aIn(step2out[14]),
    .bIn(step2out[10]),
    .sel(shAmt[2]),
    .out(step3out[14])
  );
  Mux2to1 m3F(
    .aIn(step2out[15]),
    .bIn(step2out[11]),
    .sel(shAmt[2]),
    .out(step3out[15])
  );
  
  
  // ---------------------------------------------------------------------------
  // Step 4
  // ---------------------------------------------------------------------------
  
  // Rotation multiplexers
  wire [7:0] step4rotOut;
  Mux2to1 r30 (
    .aIn(1'b0),
    .bIn(step3out[8]),
    .sel(rot),
    .out(step4rotOut[0])
  );
  Mux2to1 r31 (
    .aIn(1'b0),
    .bIn(step3out[9]),
    .sel(rot),
    .out(step4rotOut[1])
  );
  Mux2to1 r32 (
    .aIn(1'b0),
    .bIn(step3out[10]),
    .sel(rot),
    .out(step4rotOut[2])
  );
  Mux2to1 r33 (
    .aIn(1'b0),
    .bIn(step3out[11]),
    .sel(rot),
    .out(step4rotOut[3])
  );
  Mux2to1 r34 (
    .aIn(1'b0),
    .bIn(step3out[12]),
    .sel(rot),
    .out(step4rotOut[4])
  );
  Mux2to1 r35 (
    .aIn(1'b0),
    .bIn(step3out[13]),
    .sel(rot),
    .out(step4rotOut[5])
  );
  Mux2to1 r36 (
    .aIn(1'b0),
    .bIn(step3out[14]),
    .sel(rot),
    .out(step4rotOut[6])
  );
  Mux2to1 r37 (
    .aIn(1'b0),
    .bIn(step3out[15]),
    .sel(rot),
    .out(step4rotOut[7])
  );
  
  // Shift multiplexers
  wire [15:0] step4out;
  Mux2to1 m40(
    .aIn(step3out[0]),
    .bIn(step4rotOut[0]),
    .sel(shAmt[3]),
    .out(step4out[0])
  );
  Mux2to1 m41(
    .aIn(step3out[1]),
    .bIn(step4rotOut[1]),
    .sel(shAmt[3]),
    .out(step4out[1])
  );
  Mux2to1 m42(
    .aIn(step3out[2]),
    .bIn(step4rotOut[2]),
    .sel(shAmt[3]),
    .out(step4out[2])
  );
  Mux2to1 m43(
    .aIn(step3out[3]),
    .bIn(step4rotOut[3]),
    .sel(shAmt[3]),
    .out(step4out[3])
  );
  Mux2to1 m44(
    .aIn(step3out[4]),
    .bIn(step4rotOut[4]),
    .sel(shAmt[3]),
    .out(step4out[4])
  );
  Mux2to1 m45(
    .aIn(step3out[5]),
    .bIn(step4rotOut[5]),
    .sel(shAmt[3]),
    .out(step4out[5])
  );
  Mux2to1 m46(
    .aIn(step3out[6]),
    .bIn(step4rotOut[6]),
    .sel(shAmt[3]),
    .out(step4out[6])
  );
  Mux2to1 m47(
    .aIn(step3out[7]),
    .bIn(step4rotOut[7]),
    .sel(shAmt[3]),
    .out(step4out[7])
  );
  Mux2to1 m48(
    .aIn(step3out[8]),
    .bIn(step3out[0]),
    .sel(shAmt[3]),
    .out(step4out[8])
  );
  Mux2to1 m49(
    .aIn(step3out[9]),
    .bIn(step3out[1]),
    .sel(shAmt[3]),
    .out(step4out[9])
  );
  Mux2to1 m4A(
    .aIn(step3out[10]),
    .bIn(step3out[2]),
    .sel(shAmt[3]),
    .out(step4out[10])
  );
  Mux2to1 m4B(
    .aIn(step3out[11]),
    .bIn(step3out[3]),
    .sel(shAmt[3]),
    .out(step4out[11])
  );
  Mux2to1 m4C(
    .aIn(step3out[12]),
    .bIn(step3out[4]),
    .sel(shAmt[3]),
    .out(step4out[12])
  );
  Mux2to1 m4D(
    .aIn(step3out[13]),
    .bIn(step3out[5]),
    .sel(shAmt[3]),
    .out(step4out[13])
  );
  Mux2to1 m4E(
    .aIn(step3out[14]),
    .bIn(step3out[6]),
    .sel(shAmt[3]),
    .out(step4out[14])
  );
  Mux2to1 m4F(
    .aIn(step3out[15]),
    .bIn(step3out[7]),
    .sel(shAmt[3]),
    .out(step4out[15])
  );
  
  // Reverse bits again if shifting left
  wire [15:0] rev2Out;
  Reverser16B rev2(
    .dIn(step4out[15:0]),
    .rev(dir),
    .dOut(rev2Out[15:0])
  );
  assign rev2Out[14:0] = dOut[14:0];
  
  // Arithmetic shift, sign bit preservation
  Mux2to1 arthMux(
    .aIn(rev2Out[15]),
    .bIn(dIn[15]),
    .sel(arth),
    .out(dOut[15])
  );
    
endmodule
