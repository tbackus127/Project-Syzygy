`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2017 03:48:39 PM
// Design Name: 
// Module Name: KeyboardControl
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


module KeyboardControl(
    input clk,
    input [15:0] sw,
    input btnL,
    input btnU,
    input btnC,
    input btnD,
    input btnR,
    inout PS2Clk,
    inout PS2Data,
    inout [3:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
    
  );
  
  wire [15:0] wSegsIn;
  wire [15:0] wSwitchesOut;
  wire buttonLeft;
  wire buttonUp;
  wire buttonCenter;
  wire buttonDown;
  wire buttonRight;
  wire wDPIn;
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(btnU),
    .btnCIn(btnC),
    .btnDIn(btnD),
    .btnRIn(btnR),
    .segsIn(wSegsIn[15:0]),
    .dpIn(~wDPIn),
    .switchOut(wSwitchesOut[15:0]),
    .btnLOut(buttonLeft),
    .btnUOut(buttonUp),
    .btnCOut(buttonCenter),
    .btnDOut(buttonDown),
    .btnROut(buttonRight),
    .segsOut(seg[6:0]),
    .anOut(an[3:0]),
    .dpOut(dp)
  );
  
  wire wMemClk;
  ClockDivider mcdiv(
    .cIn(clk),
    .reqCount(3),
    .cOut(wMemClk)
  );
  
  wire wCPUClk;
  ClockDivider ccdiv(
    .cIn(wMemClk),
    .reqCount(2),
    .cOut(wCPUClk)
  );
  
  PS2Controller ps2Ctrl(
    .ps2CtrlClk(wCPUClk),
    .readKeycode(1'b1),
    .res(1'b0),
    .ps2clk(PS2Clk),
    .ps2data(PS2Data),
    .keycode(wSegsIn[7:0]),
    .writeEn(),
    .writeClk(),
    .ctrlBusy(wDPIn)
  );
  
  assign led[15:0] = wSwitchesOut[15:0];
  
endmodule
