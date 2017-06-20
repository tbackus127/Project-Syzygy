`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2017 02:27:45 AM
// Design Name: 
// Module Name: SDInterfaceControl
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


module SDInterfaceControl(
    input clk,
    inout [7:0] JB,
    output [15:0] led
  );
  
  SDInterface sdint(
    .clk(clk),
    .regRead(),
    .readEn(),
    .regWrite(),
    .writeEn(),
    .reset(),
    .dIn(),
    .exec(),
    .miso(JB[2]),
    .serialClockOut(JB[3]),
    .dOut(),
    .chipSel(JB[0]),
    .mosi(JB[1]),
    .debugOut(led[7:0]),
    .debugOut2(led[15:8])
  );
  
endmodule
