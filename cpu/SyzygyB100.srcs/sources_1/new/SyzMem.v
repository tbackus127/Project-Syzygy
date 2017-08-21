`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2017 02:02:53 PM
// Design Name: 
// Module Name: SyzMem
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


module SyzMem(
    input en,
    input memClk,
    input [15:0] addr,
    input [15:0] dIn,
    input readEn,
    input writeEn,
    input vgaClk,
    input [15:0] vgaAddr,
    output [15:0] dOut,
    output [15:0] vgaOut
  );
  
  wire [15:0] wMemDataOut;
  wire wDelClk;
  
  assign #8 wDelClk = memClk;
  
  BlockRamDesign_wrapper bram(
    .addra(addr[15:0]),
    .addrb(vgaAddr[15:0]),
    .clka(wDelClk),
    .clkb(vgaClk),
    .dina(dIn[15:0]),
    .dinb(16'h0000),
    .douta(wMemDataOut[15:0]),
    .doutb(vgaOut[15:0]),
    .ena(en),
    .enb(en),
    .wea({writeEn, writeEn}),
    .web(2'b00)
  );
  
  assign dOut[15:0] = (readEn) ? wMemDataOut[15:0] : 16'h0000;
  
endmodule
