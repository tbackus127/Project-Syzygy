`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2017 02:02:53 PM
// Design Name: 
// Module Name: SyzMem
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


module SyzMem(
    input memClk,
    input [15:0] addrInPC,
    input [15:0] addrInAcc,
    input [15:0] dIn,
    input readEn,
    input writeEn,
    output [15:0] dOutPC,
    output [15:0] dOutAcc
  );
  
  // 64k RAM (only 12 bits for address, system supports up to 10MB)
  reg [15:0] mem [4095:0];
  
  reg [15:0] outVal;
  
  // If readEn or writeEn are set, it is a value request
  wire mode = readEn | writeEn;
  
  always @ (posedge memClk) begin
    case(mode)
      
      // Instruction request (read-only)
      1'b0: begin
        outVal[15:0] <= mem[addrInPC[11:0]][15:0];
      end
        
      // Value request (read/write)
      1'b1: begin
        if(writeEn) begin
          mem[addrInAcc[11:0]][15:0] <= dIn[15:0];
        end else begin
          outVal[15:0] <= mem[addrInAcc[11:0]][15:0];
        end
      end
      
    endcase
  end
  
  assign dOutPC[15:0] = outVal[15:0];
  assign dOutAcc[15:0] = (readEn == 1'b1) ? outVal[15:0] : 16'h0000; 
  
endmodule
