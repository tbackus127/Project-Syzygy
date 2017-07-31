//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Tue Jul 25 21:15:20 2017
//Host        : Compy running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target BRAM_wrapper.bd
//Design      : BRAM_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BRAM_wrapper
   (BRAM_PORTA_addr,
    BRAM_PORTA_clk,
    BRAM_PORTA_din,
    BRAM_PORTA_dout,
    BRAM_PORTA_we,
    BRAM_PORTB_addr,
    BRAM_PORTB_clk,
    BRAM_PORTB_din,
    BRAM_PORTB_dout,
    BRAM_PORTB_we);
  input [15:0]BRAM_PORTA_addr;
  input BRAM_PORTA_clk;
  input [15:0]BRAM_PORTA_din;
  output [15:0]BRAM_PORTA_dout;
  input [1:0]BRAM_PORTA_we;
  input [15:0]BRAM_PORTB_addr;
  input BRAM_PORTB_clk;
  input [15:0]BRAM_PORTB_din;
  output [15:0]BRAM_PORTB_dout;
  input [1:0]BRAM_PORTB_we;

  wire [15:0]BRAM_PORTA_addr;
  wire BRAM_PORTA_clk;
  wire [15:0]BRAM_PORTA_din;
  wire [15:0]BRAM_PORTA_dout;
  wire [1:0]BRAM_PORTA_we;
  wire [15:0]BRAM_PORTB_addr;
  wire BRAM_PORTB_clk;
  wire [15:0]BRAM_PORTB_din;
  wire [15:0]BRAM_PORTB_dout;
  wire [1:0]BRAM_PORTB_we;

  BRAM BRAM_i
       (.BRAM_PORTA_addr(BRAM_PORTA_addr),
        .BRAM_PORTA_clk(BRAM_PORTA_clk),
        .BRAM_PORTA_din(BRAM_PORTA_din),
        .BRAM_PORTA_dout(BRAM_PORTA_dout),
        .BRAM_PORTA_we(BRAM_PORTA_we),
        .BRAM_PORTB_addr(BRAM_PORTB_addr),
        .BRAM_PORTB_clk(BRAM_PORTB_clk),
        .BRAM_PORTB_din(BRAM_PORTB_din),
        .BRAM_PORTB_dout(BRAM_PORTB_dout),
        .BRAM_PORTB_we(BRAM_PORTB_we));
endmodule
