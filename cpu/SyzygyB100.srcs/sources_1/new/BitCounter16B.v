`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2017 02:18:33 PM
// Design Name: 
// Module Name: BitCounter16B
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

module BitCounter16B(
    input [15:0] dIn,
    output [4:0] dOut
  );
  
  // Step 0 (Full Adders)
  wire [3:0] step0sum;
  wire [3:0] step0carry;
  FullAdder fa00(
    .aIn(dIn[14]),
    .bIn(dIn[13]),
    .cIn(dIn[12]),
    .sum(step0sum[0]),
    .cOut(step0carry[0])
  );
  FullAdder fa01(
    .aIn(dIn[11]),
    .bIn(dIn[10]),
    .cIn(dIn[9]),
    .sum(step0sum[1]),
    .cOut(step0carry[1])
  );
  FullAdder fa02(
    .aIn(dIn[7]),
    .bIn(dIn[6]),
    .cIn(dIn[5]),
    .sum(step0sum[2]),
    .cOut(step0carry[2])
  );
  FullAdder fa03(
    .aIn(dIn[4]),
    .bIn(dIn[3]),
    .cIn(dIn[2]),
    .sum(step0sum[3]),
    .cOut(step0carry[3])
  );
  
  // Step 1 (Full Adders)
  wire [3:0] step1sum;
  wire [3:0] step1carry;
  FullAdder fa10(
    .aIn(step0sum[0]),
    .bIn(step0sum[1]),
    .cIn(dIn[8]),
    .sum(step1sum[0]),
    .cOut(step1carry[0])
  );
  FullAdder fa11(
    .aIn(step0carry[0]),
    .bIn(step0carry[1]),
    .cIn(dIn[8]),
    .sum(step1sum[1]),
    .cOut(step1carry[1])
  );
  FullAdder fa12(
    .aIn(step0sum[2]),
    .bIn(step0sum[3]),
    .cIn(dIn[1]),
    .sum(step1sum[2]),
    .cOut(step1carry[2])
  );
  FullAdder fa13(
    .aIn(step0carry[2]),
    .bIn(step0carry[3]),
    .cIn(step1carry[2]),
    .sum(step1sum[3]),
    .cOut(step1carry[3])
  );
    
  // Step 2 (Full Adders)
  wire [2:0] step2sum;
  wire [2:0] step2carry;
  FullAdder fa20 (
    .aIn(step1sum[0]),
    .bIn(step1sum[2]),
    .cIn(dIn[0]),
    .sum(step2sum[0]),
    .cOut(step2carry[0])
  );
  FullAdder fa21 (
    .aIn(step1sum[1]),
    .bIn(step1sum[3]),
    .cIn(step2carry[0]),
    .sum(step2sum[1]),
    .cOut(step2carry[1])
  );
  FullAdder fa22 (
    .aIn(step1carry[1]),
    .bIn(step1carry[3]),
    .cIn(step2carry[1]),
    .sum(step2sum[2]),
    .cOut(step2carry[2])
  );
  
  // Step 3 (Half Adders)
  wire [2:0] step3out;
  HalfAdder ha0 (
    .aIn(step2sum[0]),
    .bIn(dIn[15]),
    .sum(dOut[0]),
    .carry(step3out[0])
  );
  HalfAdder ha1 (
    .aIn(step2sum[1]),
    .bIn(step3out[0]),
    .sum(dOut[1]),
    .carry(step3out[1])
  );
  HalfAdder ha2 (
    .aIn(step2sum[2]),
    .bIn(step3out[1]),
    .sum(dOut[2]),
    .carry(step3out[2])
  );
  HalfAdder ha3 (
    .aIn(step2carry[2]),
    .bIn(step3out[2]),
    .sum(dOut[3]),
    .carry(dOut[4])
  );
  
endmodule
  