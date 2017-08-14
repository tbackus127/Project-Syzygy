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
    output reg writeEn,
    output reg writeClk,
    output reg ctrlBusy
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
  
  reg intrWrite;
  reg [7:0] data;
  
  // PS2 Interface from GPIO demo for Basys 3
  wire [7:0] wRcvData;
  wire wDataReady;
  wire wBusy;
  wire wErr;
  PS2Interface ps2intr (
    .ps2_clk(ps2clk),
    .ps2_data(ps2data),
    .clk(ps2CtrlClk),
    .rst(res),
    .tx_data(8'h00),
    .write_data(1'b0),
    .rx_data(wRcvData[7:0]),
    .read_data(wDataReady),
    .busy(wBusy),
    .err(wErr)
  );
  
  // 0xE0 = Extended prefix
  // 0xF0 = Key released
  always @ (negedge ps2CtrlClk) begin
    
    if(wRcvData[7:0] != 8'he0 || wRcvData[7:0] != 8'h00) begin
      keycode[7:0] = wRcvData[7:0];
    end
      
  end
  
endmodule
