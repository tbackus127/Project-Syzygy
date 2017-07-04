`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2017 09:24:01 PM
// Design Name: 
// Module Name: BlockMemoryTest
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


module BlockMemoryTest(
    input clk,
    input btnL,
    input btnU,
    input btnC,
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
  );
  
  wire [15:0] wSwitches;
  wire buttonLeft;      
  wire buttonUp;
  wire buttonCenter;
  wire [15:0] segsIn;
  wire wDp;
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(btnU),
    .btnCIn(btnC),
    .btnDIn(),
    .btnRIn(),
    .segsIn(segsIn[15:0]),
    .dpIn(~wDp),
    .switchOut(wSwitches[15:0]),
    .btnLOut(buttonLeft),
    .btnUOut(buttonUp),
    .btnCOut(buttonCenter),
    .btnDOut(),
    .btnROut(),
    .segsOut(seg[6:0]),
    .anOut(an[3:0]),
    .dpOut(dp)
  );
  
  assign led[15:0] = wSwitches[15:0];
  
  SDBlockMemory sdbm(
    .blkMemClk(clk),
    .dIn(wSwitches[3:0]),
    .regSelect(wSwitches[11:4]),
    .randomRead(buttonLeft),
    .randomWrite(buttonUp),
    .serialDataIn(wSwitches[13]),
    .serialClock(buttonCenter),
    .serialWriteEn(wSwitches[15]),
    .dOut(segsIn[15:0]),
    .serialDataOut(wDp)
  );
  
endmodule
