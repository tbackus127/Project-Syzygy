//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Tue Aug 08 14:23:06 2017
//Host        : Compy running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target BlockRamDesign_wrapper.bd
//Design      : BlockRamDesign_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BlockRamDesign_wrapper
   (addra,
    clka,
    dina,
    douta,
    ena,
    rsta_busy,
    wea);
  input [15:0]addra;
  input clka;
  input [15:0]dina;
  output [15:0]douta;
  input ena;
  output rsta_busy;
  input [1:0]wea;

  wire [15:0]addra;
  wire clka;
  wire [15:0]dina;
  wire [15:0]douta;
  wire ena;
  wire rsta_busy;
  wire [1:0]wea;

  BlockRamDesign BlockRamDesign_i
       (.addra(addra),
        .clka(~clka),
        .dina(dina),
        .douta(douta),
        .ena(ena),
        .rsta_busy(rsta_busy),
        .wea(wea));
endmodule
