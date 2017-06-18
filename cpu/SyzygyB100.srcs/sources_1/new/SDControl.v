`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2017 08:23:29 PM
// Design Name: 
// Module Name: SDControl
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


module SDControl(
    input clk,
    input [15:0] sw,
    input btnL,
    inout [7:0] JB,
    output [15:0] led
  );
  
  // Normalize manual input/output (deshort switches, debounce buttons, etc.)
  wire [15:0] switches;
  wire buttonLeft;    // Manual clock
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(1'b0),
    .btnCIn(1'b0),
    .btnDIn(1'b0),
    .btnRIn(1'b0),
    .segsIn(16'h0000),
    .switchOut(switches[15:0]),
    .btnLOut(buttonLeft),
    .btnUOut(),
    .btnCOut(),
    .btnDOut(),
    .btnROut(),
    .segsOut(),
    .anOut(),
    .dpOut()
  );
  
  // JB[0] = Chip Select/DAT3 (Rightmost switch)
  assign JB[0] = switches[0];
  
  // JB[1] = MOSI/CMD (Leftmost switch
  assign JB[1] = switches[15];
  
  // JB[2] = MISO/DAT0
  ShiftRegister sreg(
    .clk(buttonLeft),
    .res(1'b0),
    .serialIn(JB[2]),
    .valOut(led[15:0])
  );
  
  // JB[3] = Serial Clock
  assign JB[3] = buttonLeft;
  
  // JB[4] = DAT1
  // JB[5] = DAT2
  // JB[6] = Card Detect
  // JB[7] = Write Protect
  
  
endmodule
