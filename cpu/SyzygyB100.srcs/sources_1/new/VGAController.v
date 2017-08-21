`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/21/2017 02:18:42 AM
// Design Name: 
// Module Name: VGAController
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


module VGAController(
    input clk,
    input reset,
    output reg [9:0] hCount,
    output reg [9:0] vCount,
    output hSync,
    output vSync,
    output disp
  );
  
  // Monitor phase boundaries
  parameter HCOUNT_MAX = 799;
  parameter VCOUNT_MAX = 524;
  parameter PULSE_END_H = 96;
  parameter PULSE_END_V = 2;
  parameter VID_START_H = 144;
  parameter VID_START_V = 35;
  parameter RETRACE_START_H = 784;
  parameter RETRACE_START_V = 515;
  
  // 25MHz clock divider
  reg [2:0] vgaClockCount = 3'b000;
  wire wVGAClock;
  assign wVGAClock = vgaClockCount[2];
  
  always @ (posedge clk) begin
    vgaClockCount <= vgaClockCount + 1;
  end
  
  always @ (posedge wVGAClock) begin
    
    // Sync reset
    if(reset) begin
      hCount[9:0] <= 0;
      vCount[9:0] <= 0;
      vgaClockCount[2:0] <= 0;
    end else begin
    
      // Ensure hCount bounds
      if(hCount >= HCOUNT_MAX) begin
        hCount <= 0;
        
        // Ensure vCount bounds
        if(vCount >= VCOUNT_MAX) begin
          vCount <= 0;
        end else begin
          vCount <= vCount + 1;
        end
        
      end else begin
        hCount <= hCount + 1;
      end
    end
  end
  
  // Check if we're in range for HSync, VSync, and addressable video
  assign hSync = (hCount[9:0] >= 0 && hCount[9:0] < PULSE_END_H) ? 1'b1 : 1'b0;
  assign vSync = (vCount[9:0] >= 0 && vCount[9:0] < PULSE_END_V) ? 1'b1 : 1'b0;
  assign disp = (hCount[9:0] >= VID_START_H && hCount[9:0] < RETRACE_START_H &&
    vCount[9:0] >= VID_START_V && vCount[9:0] < RETRACE_START_V
  ) ? 1'b1 : 1'b0;
  
endmodule
