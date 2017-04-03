`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2017 08:51:43 PM
// Design Name: 
// Module Name: Mux2to1
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


module Mux2to1(
    input aIn,
    input bIn,
    input sel,
    output out
    );
    
    assign out = (sel) ? bIn : aIn;
    
endmodule
