`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2017 09:30:47 PM
// Design Name: 
// Module Name: VGAInterface
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


module VGAInterface(
    input vgaClock,
    input reset,
    input [15:0] pixelData,
    output [15:0] vgaAddr,
    output [3:0] colorRed,
    output [3:0] colorGreen,
    output [3:0] colorBlue, 
    output hSync,
    output vSync
  );
  
  // 1:1 pixel scale in monochrome: 38.4kB video memory needed for 640x480
  // Add later: 8-bit color (rrrgggbbrrrgggbb) at 8x scaling
  // VGA clock: 25MHz
  // Back porch -> Front porch (for some reason)
  
  // Video memory: 0xB000 - 0xFAFF
  parameter VID_MEM_OFFSET = 16'hb000;
  wire wPixelValue;
  
  // VGA Controller
  wire [9:0] wHCount;
  wire [9:0] wVCount;
  wire wInDispArea;
  VGAController vgaCtrl(
    .vgaClock(vgaClock),
    .reset(reset),
    .hCount(wHCount[9:0]),
    .vCount(wVCount[9:0]),
    .hSync(hSync),
    .vSync(vSync),
    .disp(wInDispArea)
  );

  // Calculate memory address for this (x,y) coordinate
  assign vgaAddr[15:0] = (40 * wVCount[8:0]) + wHCount[9:4] + VID_MEM_OFFSET;
  
  // Select the corresponding bit for image data
  assign wPixelValue = pixelData[~wHCount[3:0]];
  
  // If the counters are in the display area, set the RGB signals according
  //   to its respective bit
  assign colorRed[3:0] = (wInDispArea == 1'b1) ? {4{wPixelValue}} : 4'h0;
  assign colorGreen[3:0] = (wInDispArea == 1'b1) ? {4{wPixelValue}} : 4'h0;
  assign colorBlue[3:0] = (wInDispArea == 1'b1) ? {4{wPixelValue}} : 4'h0;
  
endmodule
