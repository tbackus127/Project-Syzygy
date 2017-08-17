`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2017 03:14:26 PM
// Design Name: 
// Module Name: ControlSystem
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


module ControlSystem(
    input clk,
    input [15:0] sw,
    input btnL,
    input btnU,
    input btnC,
    input btnD,
    input btnR,
    input PS2Clk,
    input PS2Data,
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
  
  SyzBSystem syzs(
    .clk(clk),
    .en(1'b1),
    .res(buttonDown),
    .snoopSelect(wSwitchesOut[7:0]),
    .miso(JB[2]),
    .ps2Clk(PS2Clk),
    .ps2Dat(PS2Dat),
    .snoopOut(wSegsIn[15:0]),
    .vnMode(wDPIn),
    .serialClock(JB[3]),
    .chipSelect(JB[0]),
    .mosi(JB[1])
  );
  
  assign led[15:0] = wSegsIn[15:0];
  
endmodule
