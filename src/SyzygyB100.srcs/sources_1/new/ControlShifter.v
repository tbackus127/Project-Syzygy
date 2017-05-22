`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2017 09:34:50 PM
// Design Name: 
// Module Name: ControlShifter
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


module ControlShifter(
    input clk,
    input [15:0] sw,
    output [15:0] led
  );
    
  BarrelShifter16B shft(
    .dIn(16'b0110011001100110),
    .shAmt(sw[3:0]),
    .dOut(led[15:0]),
    .dir(sw[4]),
    .rot(sw[5]),
    .arth(sw[6])
  );
    
endmodule
