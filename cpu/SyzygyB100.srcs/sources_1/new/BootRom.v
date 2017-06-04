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
    input en,
    input [3:0] addr,
    output reg [15:0] instrOut
  );
  
  always @ (en or addr) begin
    if(en) begin
      case(addr)
        0: instrOut[15:0] = 16'h3060;   // push 65535 (actually -1, npass)
        1: instrOut[15:0] = 16'h1260;   // copy 2, 6
        2: instrOut[15:0] = 16'h800a;   // push $lbl.delEnd
        3: instrOut[15:0] = 16'h1230;   // copy 2, 3
        4: instrOut[15:0] = 16'h3260;   // dec
        5: instrOut[15:0] = 16'h1260;   // copy 2, 6
        6: instrOut[15:0] = 16'h2400;   // jeq
        7: instrOut[15:0] = 16'h8002;   // push $lbl.delStart
        8: instrOut[15:0] = 16'h1230;   // copy 2, 3
        9: instrOut[15:0] = 16'h8e00;   // jmp
        10: instrOut[15:0] = 16'h1860;  // copy 8, 6
        11: instrOut[15:0] = 16'h3228;  // inc
        12: instrOut[15:0] = 16'h1280;  // copy 2, 8
        13: instrOut[15:0] = 16'h8000;  // push $lbl.start
        14: instrOut[15:0] = 16'h1230;  // copy 2, 3
        15: instrOut[15:0] = 16'h8e00;  // jmp
      endcase
    end else begin
      instrOut[15:0] = 16'h0000;
    end
  end
  
endmodule
