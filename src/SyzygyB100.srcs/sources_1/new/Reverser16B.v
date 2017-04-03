`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2017 10:06:51 PM
// Design Name: 
// Module Name: Reverser16B
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


module Reverser16B(
    input [15:0] dIn,
    input rev,
    output [15:0] dOut
  );
  
  Mux2to1 mux0(
    .aIn(dIn[0]),
    .bIn(dIn[15]),
    .sel(rev),
    .out(dOut[0])
  );
  Mux2to1 mux1(
    .aIn(dIn[1]),
    .bIn(dIn[14]),
    .sel(rev),
    .out(dOut[1])
  );
  Mux2to1 mux2(
    .aIn(dIn[2]),
    .bIn(dIn[13]),
    .sel(rev),
    .out(dOut[2])
  );
  Mux2to1 mux3(
    .aIn(dIn[3]),
    .bIn(dIn[12]),
    .sel(rev),
    .out(dOut[3])
  );
  Mux2to1 mux4(
    .aIn(dIn[4]),
    .bIn(dIn[11]),
    .sel(rev),
    .out(dOut[4])
  );
  Mux2to1 mux5(
    .aIn(dIn[5]),
    .bIn(dIn[10]),
    .sel(rev),
    .out(dOut[5])
  );
  Mux2to1 mux6(
    .aIn(dIn[6]),
    .bIn(dIn[9]),
    .sel(rev),
    .out(dOut[6])
  );
  Mux2to1 mux7(
    .aIn(dIn[7]),
    .bIn(dIn[8]),
    .sel(rev),
    .out(dOut[7])
  );
  Mux2to1 mux8(
    .aIn(dIn[8]),
    .bIn(dIn[7]),
    .sel(rev),
    .out(dOut[8])
  );
  Mux2to1 mux9(
    .aIn(dIn[9]),
    .bIn(dIn[6]),
    .sel(rev),
    .out(dOut[9])
  );
  Mux2to1 muxA(
    .aIn(dIn[10]),
    .bIn(dIn[5]),
    .sel(rev),
    .out(dOut[10])
  );
  Mux2to1 muxB(
    .aIn(dIn[11]),
    .bIn(dIn[4]),
    .sel(rev),
    .out(dOut[11])
  );
  Mux2to1 muxC(
    .aIn(dIn[12]),
    .bIn(dIn[3]),
    .sel(rev),
    .out(dOut[12])
  );
  Mux2to1 muxD(
    .aIn(dIn[13]),
    .bIn(dIn[2]),
    .sel(rev),
    .out(dOut[13])
  );
  Mux2to1 muxE(
    .aIn(dIn[14]),
    .bIn(dIn[1]),
    .sel(rev),
    .out(dOut[14])
  );
  Mux2to1 muxF(
    .aIn(dIn[15]),
    .bIn(dIn[0]),
    .sel(rev),
    .out(dOut[15])
  );
  
endmodule
