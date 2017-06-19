`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2017 03:47:42 AM
// Design Name: 
// Module Name: SDController
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


module SDController(
    input clk,
    input [31:0] addr,
    input exec,
    input readEn,
    input writeEn,
    input blockMemMSB,
    input [15:0] dataFromBlockMem,
    input miso,
    inout [15:0] regData,
    output reg [15:0] dataToBlockMem,
    output reg status,
    output reg blockMemLSB,
    output reg chipSelect = 1'b1,
    output mosi
  );
  
  reg [3:0] state = 4'h0;
  reg [6:0] count = 7'b0000000;
  reg [2:0] step = 3'h0;
  reg [47:0] command = 48'h000000000000;
  reg [7:0] error = 8'h00;
  reg [15:0] data = 16'h0000;
  
  assign mosi = command[47];
  
  always @ (posedge clk) begin
    case(state[3:0])
      
      // Setup
      4'h0: begin
        count[6:0] <= 7'b1100100;
        state[3:0] <= 4'h1;
      end
      
      // Flush bits
      4'h1: begin
        if(count[6:0] > 0)
          count[6:0] <= count[6:0] - 1;
        else
          state[3:0] <= 4'h2;
      end
      
      // Ready CMD0
      4'h2: begin
        command[47:0] <= 48'h400000000095;
        count[6:0] <= 48;
        step[2:0] <= 1;
        state[3:0] <= 4'h3;
      end
      
      // Send Command
      4'h3: begin
        if(count[6:0] > 0) begin
          count[6:0] <= count[6:0] - 1;
          command[47:0] <= command[47:0] << 1;
        end else begin
          command[47:0] <= 48'hff0000000000;
          state[3:0] <= 4'h4;
        end
      end
      
      // Get SD response
      4'h4: begin
        
      end
      
    endcase
  end
  
endmodule
