`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2016 11:51:27 AM
// Design Name: 
// Module Name: SevSeg
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

// 7-Segment Display module
module SevSeg(
  input clk,
  input [15:0] valIn,
  input dpIn,
  output reg [6:0] segs,
  output reg [3:0] anodes,
  output wire dpOut
);

wire [1:0] dispIx;
wire [3:0] aen;
reg [3:0] digit;

// Clock divider - Will update 2^18x slower than the clock speed.
reg [19:0] clkDiv;
assign dispIx = clkDiv[19:18];
assign aen = 4'b1111;
assign dpOut = dpIn;

// Choose display to update
always @ (posedge clk) begin
  case (dispIx)
    0: digit = valIn[3:0];
    1: digit = valIn[7:4];
    2: digit = valIn[11:8];
    3: digit = valIn[15:12];
  endcase
end

// Bin -> 7seg decoder
// 0 = On, 1 = Off. I... why?
//    t
//  w   e
//    m
//  l   r
//    b
always @ (*) begin
  case (digit)  //     mwlbret
    4'b0000: segs = 7'b1000000;
    4'b0001: segs = 7'b1111001;
    4'b0010: segs = 7'b0100100;
    4'b0011: segs = 7'b0110000;
    4'b0100: segs = 7'b0011001;
    4'b0101: segs = 7'b0010010;
    4'b0110: segs = 7'b0000010;
    4'b0111: segs = 7'b1111000;
    4'b1000: segs = 7'b0000000;
    4'b1001: segs = 7'b0010000;
    4'b1010: segs = 7'b0001000;
    4'b1011: segs = 7'b0000011;
    4'b1100: segs = 7'b1000110;
    4'b1101: segs = 7'b0100001;
    4'b1110: segs = 7'b0000110;
    4'b1111: segs = 7'b0001110;
  endcase
end

// Anode selection
always @ (*) begin
  anodes = 4'b1111;
  if(aen[dispIx] == 1)
    anodes[dispIx] = 0;
end

// Update clock divider
always @ (posedge clk) begin
  clkDiv <= clkDiv + 1;
end

endmodule
