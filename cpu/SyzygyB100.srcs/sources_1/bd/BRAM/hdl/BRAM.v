//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Tue Jul 25 21:15:20 2017
//Host        : Compy running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target BRAM.bd
//Design      : BRAM
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "BRAM,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=BRAM,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "BRAM.hwdef" *) 
module BRAM
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

  wire [15:0]BRAM_PORTA_1_ADDR;
  wire BRAM_PORTA_1_CLK;
  wire [15:0]BRAM_PORTA_1_DIN;
  wire [15:0]BRAM_PORTA_1_DOUT;
  wire [1:0]BRAM_PORTA_1_WE;
  wire [15:0]BRAM_PORTB_1_ADDR;
  wire BRAM_PORTB_1_CLK;
  wire [15:0]BRAM_PORTB_1_DIN;
  wire [15:0]BRAM_PORTB_1_DOUT;
  wire [1:0]BRAM_PORTB_1_WE;

  assign BRAM_PORTA_1_ADDR = BRAM_PORTA_addr[15:0];
  assign BRAM_PORTA_1_CLK = BRAM_PORTA_clk;
  assign BRAM_PORTA_1_DIN = BRAM_PORTA_din[15:0];
  assign BRAM_PORTA_1_WE = BRAM_PORTA_we[1:0];
  assign BRAM_PORTA_dout[15:0] = BRAM_PORTA_1_DOUT;
  assign BRAM_PORTB_1_ADDR = BRAM_PORTB_addr[15:0];
  assign BRAM_PORTB_1_CLK = BRAM_PORTB_clk;
  assign BRAM_PORTB_1_DIN = BRAM_PORTB_din[15:0];
  assign BRAM_PORTB_1_WE = BRAM_PORTB_we[1:0];
  assign BRAM_PORTB_dout[15:0] = BRAM_PORTB_1_DOUT;
  BRAM_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(BRAM_PORTA_1_ADDR),
        .addrb(BRAM_PORTB_1_ADDR),
        .clka(BRAM_PORTA_1_CLK),
        .clkb(BRAM_PORTB_1_CLK),
        .dina(BRAM_PORTA_1_DIN),
        .dinb(BRAM_PORTB_1_DIN),
        .douta(BRAM_PORTA_1_DOUT),
        .doutb(BRAM_PORTB_1_DOUT),
        .wea(BRAM_PORTA_1_WE),
        .web(BRAM_PORTB_1_WE));
endmodule
