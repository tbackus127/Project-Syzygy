`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2017 10:28:34 PM
// Design Name: 
// Module Name: SDClockDivider
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


module SDClockDivider(
    input clkIn,
    output clkOut
  );
  
  reg [24:0] divReg;
  assign clkOut = divReg[20];    // Min div=8
  
  always @ (posedge clkIn) begin
    divReg[24:0] <= divReg[24:0] + 1;
  end
  
endmodule
