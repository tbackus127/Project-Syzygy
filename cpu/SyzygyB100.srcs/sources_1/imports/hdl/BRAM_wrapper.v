//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Tue Jul 25 20:59:32 2017
//Host        : Compy running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target BRAM_wrapper.bd
//Design      : BRAM_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

// A: Instruction, B: Data Access
module BRAM_wrapper(
    input memClk,
    input [15:0] addrA,
    input [15:0] dInA,
    input [15:0] addrB,
    input [15:0] dInB,
    input wrEnB,
    output [15:0] dOutA,
    output [15:0] dOutB
  );

  BRAM BRAM_i (
    .BRAM_PORTA_addr(addrA[15:0]),
    .BRAM_PORTA_clk(~memClk),
    .BRAM_PORTA_din(dInA[15:0]),
    .BRAM_PORTA_dout(dOutA[15:0]),
    .BRAM_PORTA_we(2'b00),
    .BRAM_PORTB_addr(addrB[15:0]),
    .BRAM_PORTB_clk(~memClk),
    .BRAM_PORTB_din(dInB[15:0]),
    .BRAM_PORTB_dout(dOutB[15:0]),
    .BRAM_PORTB_we({wrEnB, wrEnB}));
endmodule
