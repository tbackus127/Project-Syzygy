`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2017 03:51:27 PM
// Design Name: 
// Module Name: PS2Controller
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


module PS2Controller(
    input ps2CtrlClk,
    input readKeycode,
    input res,
    inout ps2clk,
    inout ps2data,
    output reg [15:0] keycode,
    output writeEn,
    output reg writeClk,
    output [15:0] debugOut
  );
  
  // Uses CPU clock
  // Keys detected only on key released
  // 
  // Keycode format:
  //   hgfe dcba xxxxxxxx
  //   a: Left Shift
  //   b: Left Ctrl
  //   c: Left WinKey (or other command key)
  //   x: Key value
  
  assign writeEn = 1'b1;
  
  wire [15:0] wKeycode;
  assign debugOut[15:0] = keycode[15:0];
  
  wire flag;
  
  reg intrWrite;
  reg [7:0] data;
  reg clk50MHz;
  reg start = 0;
  reg [2:0] bcount = 0;
  reg cn = 0;
  
  // PS2 Receiver from GPIO demo for Basys 3
  PS2Receiver ps2rec (
    .clk(clk50MHz),
    .kclk(ps2clk),
    .kdata(ps2data),
    .keycode(wKeycode),
    .oflag(flag)
  );
  
  // Code from demo's top
  always @ (posedge ps2CtrlClk) begin
    clk50MHz <= ~clk50MHz;
  end
  
  always @ (wKeycode or keycode)
    if (wKeycode[7:0] == 8'hf0) begin
      cn <= 1'b0;
      bcount <= 3'd0;
    end else if (wKeycode[15:8] == 8'hf0) begin
      cn <= wKeycode != keycode;
      bcount <= 3'd5;
    end else begin
      cn <= wKeycode[7:0] != keycode[7:0] || keycode[15:8] == 8'hf0;
      bcount <= 3'd2;
    end
    
  always @ (posedge ps2CtrlClk) begin
    if (flag == 1'b1 && cn == 1'b1) begin
      start <= 1'b1;
      keycode <= wKeycode;
    end else begin
      start <= 1'b0;
    end
  end
    
endmodule
