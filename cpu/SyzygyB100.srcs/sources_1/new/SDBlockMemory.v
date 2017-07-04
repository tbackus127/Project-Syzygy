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
    input blkMemClk,
    input [15:0] dIn,
    input [7:0] regSelect,
    input randomRead,
    input randomWrite,
    input serialDataIn,
    input serialClock,
    input serialWriteEn,
    output reg [15:0] dOut,
    output reg serialDataOut
  );
  
  reg [15:0] mem [255:0];
  reg [3:0] bitCount;
  reg [7:0] byteCount;
  reg didShift;

  always @ (negedge blkMemClk) begin
    
    // If the controller orders a serial bit write and we haven't shifted yet
    if(didShift == 1'b0 && serialWriteEn && serialClock) begin
      
      // Set the correct bit of the correct memory address
      mem[byteCount[7:0]][bitCount[3:0]] <= serialDataIn;
      
      // If we just set the last bit, increment the byte counter
      if(bitCount[3:0] == 4'b1111) begin
        byteCount[7:0] <= byteCount[7:0] + 1;
      end
      
      // Update the shift flag to prevent overshifting and increment the bit count
      didShift <= 1'b1;
      bitCount[3:0] <= bitCount[3:0] + 1;
      
    // If we did the shift but the controller isn't shifting data, reset the shift flag
    end else if (didShift == 1'b1 && serialClock == 1'b0) begin
      didShift <= 1'b0;
    
    // If the interface orders a random read
    end else if (randomRead) begin
      dOut[15:0] <= mem[regSelect[7:0]][15:0];
     
    // If the interface orders a random write
    end else if (randomWrite) begin
      mem[regSelect[7:0]][15:0] <= dIn[15:0];
    end
    
    // Always output the next serial data bit
    serialDataOut <= mem[byteCount[7:0]][bitCount[3:0]];
  end
  
endmodule
