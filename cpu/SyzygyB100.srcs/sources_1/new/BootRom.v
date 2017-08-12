`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2017 01:58:13 PM
// Design Name: 
// Module Name: BootRom
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


module BootRom(
    input readEn,
    input [7:0] addr,
    output [15:0] instrOut,
    output [15:0] debugOut
  );
  
  reg [15:0] rom [0:255];
  
  initial begin
    $readmemh("../../../../os/boot/testVNSwitch.hex", rom);
  end
  
  assign instrOut[15:0] = (readEn) ? rom[addr][15:0] : 16'h0000;
  assign debugOut[15:0] = rom[addr][15:0];
  
endmodule
