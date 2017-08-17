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
    input PS2Clk,
    input PS2Data,
    inout [3:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp  
  );
  
  reg [3:0] regNum;
  reg [15:0] regData;
  reg intrRdEn;
  reg intrWrEn;
  
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
    .segsIn(regData[15:0]),
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
  
  wire [15:0] wKeycodeOut;
  KeyboardInterface kbdIntr(
    .ctrlClock(clk),
    .cpuClock(wCPUClk),
    .periphSelect(1'b1),
    .dIn(16'h0000),
    .regSelect(regNum[3:0]),
    .readEn(intrRdEn),
    .writeEn(intrWrEn),
    .reset(1'b0),
    .exec(buttonCenter),
    .debugRegSelect(4'h0),
    .ps2Clk(PS2Clk),
    .ps2Dat(PS2Data),
    .dOut(wKeycodeOut[15:0]),
    .debugOut()
  );
  
  always @ (posedge clk) begin
    if(buttonUp == 1'b1) begin
      regNum[3:0] = wSwitchesOut[3:0];
    end
    
    if(buttonDown == 1'b1) begin
      regData[15:0] = wSwitchesOut[15:0];
    end
    
    if(buttonLeft == 1'b1) begin
      intrRdEn = 1'b1;
      regData[15:0] = wKeycodeOut[15:0];
    end else begin
      intrRdEn = 1'b0;
    end
    
    if(buttonRight == 1'b1) begin
      intrWrEn = 1'b1;
    end else begin
      intrWrEn = 1'b0;
    end
  end
  
endmodule
