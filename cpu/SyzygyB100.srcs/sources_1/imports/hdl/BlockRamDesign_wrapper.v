//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Sun Aug 20 21:20:59 2017
//Host        : Compy running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target BlockRamDesign_wrapper.bd
//Design      : BlockRamDesign_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BlockRamDesign_wrapper(
    input [15:0] addra,
    input [15:0] addrb,
    input clka,
    input clkb,
    input [15:0] dina,
    input [15:0] dinb,
    output [15:0] douta,
    output [15:0] doutb,
    input ena,
    input enb,
    input [1:0] wea,
    input [1:0] web
  );

  BlockRamDesign BlockRamDesign_i(
    .addra(addra),
    .addrb(addrb),
    .clka(clka),
    .clkb(clkb),
    .dina(dina),
    .dinb(dinb),
    .douta(douta),
    .doutb(doutb),
    .ena(ena),
    .enb(enb),
    .wea(wea),
    .web(web)
  );
  
endmodule
