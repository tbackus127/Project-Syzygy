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
    output reg serialDataOut
  );
  
  reg [15:0] mem [255:0];
  reg [3:0] bitCount;
  reg [7:0] byteCount;
  
  always @ (posedge clk) begin
    if(serialWriteEn) begin
      mem[byteCount[7:0]][bitCount[3:0]] <= serialDataIn;
      if(bitCount[3:0] == 4'b1111) begin
        byteCount[7:0] <= byteCount[7:0] + 1;
      end
      bitCount[3:0] <= bitCount[3:0] + 1;
    end else if (randomRead) begin
      dOut[15:0] <= mem[regSelect[7:0]][15:0];
    end else if (randomWrite) begin
      mem[regSelect[7:0]][15:0] <= dIn[15:0];
    end
    serialDataOut <= mem[byteCount[7:0]][bitCount[3:0]];
  end
  
endmodule
