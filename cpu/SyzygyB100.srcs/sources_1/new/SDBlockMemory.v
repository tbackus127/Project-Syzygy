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
    input read,
    input write,
    input serialDataIn,
    input serialSDToMemEn,
    output reg [15:0] dOut,
    output serialDataOut
  );
  
  reg [4095:0] mem;
  assign serialDataOut = mem[4095];
  
  always @ (posedge clk or negedge clk) begin
    
    // On the rising edge, set memory from serial signal only if the write from serial
    //   signal is on
    if(clk == 1'b1 && serialSDToMemEn == 1'b1) begin
        mem[0] <= serialDataIn;
      
    // On the falling edge shift or read/write data with random access
    end else if(clk == 1'b0) begin
      
      // Random write (calculate offset)
      if(write) begin
        mem[4095:0] <= dIn[15:0] << (regSelect[7:0] * 16);
        
      // Random read
      end else if(read) begin
        dOut[15:0] <= mem[4095:0]  >> (regSelect[7:0] * 16);
      
      // Shift everything left
      end else begin
        mem[4095:0] <= mem[4095:0] << 1; 
      end
    end
  end
  
endmodule
