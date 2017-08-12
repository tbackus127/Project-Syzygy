`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2017 10:28:14 PM
// Design Name: 
// Module Name: ClockDivider
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


module ClockDivider(
    input cIn,
    input [31:0] reqCount,
    output reg cOut = 0
  );
  
  reg [31:0] counter = 32'h00000000;
  
  always @ (negedge cIn) begin
    if(counter == reqCount) begin
      cOut = ~cOut;
      counter = 0;
    end else begin
      counter = counter + 1;
    end
  end
  
endmodule
