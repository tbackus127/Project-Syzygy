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
    inout [3:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
  );
  
  reg controlMode;
  reg [7:0] snoopSelect;
  reg [15:0] dataVal;
  
  wire [15:0] wSegsIn;
  wire [15:0] wSwitchesOut;
  wire buttonLeft;
  wire buttonUp;
  wire buttonCenter;
  wire buttonDown;
  wire buttonRight;
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(btnU),
    .btnCIn(btnC),
    .btnDIn(btnD),
    .btnRIn(btnR),
    .segsIn(wSegsIn[15:0]),
    .dpIn(~controlMode),
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
    .en(wSwitchesOut[15]),
    .res(buttonDown),
    .dIn(dataVal[15:0]),
    .snoopSelect(snoopSelect[7:0]),
    .miso(JB[2]),
    .snoopOut(wSegsIn[15:0]),
    .serialClock(JB[3]),
    .chipSelect(JB[0]),
    .mosi(JB[1])
  );
  
  always @ (posedge clk) begin
    if(buttonLeft) begin
      snoopSelect[7:0] <= wSwitchesOut[7:0];
    end
    
    if(buttonUp) begin
      dataVal[15:0] <= wSwitchesOut[15:0];
    end
  end
  
endmodule
