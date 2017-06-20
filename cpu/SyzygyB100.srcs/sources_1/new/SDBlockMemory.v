`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2017 02:32:27 AM
// Design Name: 
// Module Name: SDBlockMemory
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


module SDBlockMemory(
    input clk,
    input [15:0] dIn,
    input [7:0] regSelect,
    input randomRead,
    input randomWrite,
    input serialDataIn,
    input serialWriteEn,
    output reg [15:0] dOut,
    output serialDataOut
  );
  
  reg [4095:0] mem;
  
  assign serialDataOut = mem[4095];
  
  always @ (posedge clk) begin
    
    // If we're getting data from the SD card, write LSB and left shift
    if(serialWriteEn) begin
      mem[0] <= serialDataIn;
      mem[4095:0] <= mem[4095:0] << 1; 
    
    // If we get a random read command
    end else if (randomRead) begin
      dOut[15:0] <= (mem[4095:0] >> (regSelect[7:0] << 4));
    
    // Random write
    end else if (randomWrite) begin
      mem[4095:0] <= (dIn[15:0] << (regSelect[7:0] << 4));
    end
  end
  
endmodule
