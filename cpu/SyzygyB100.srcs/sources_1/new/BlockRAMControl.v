`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2017 02:21:32 PM
// Design Name: 
// Module Name: BlockRAMControl
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


module BlockRAMControl(
    input clk,
    input [15:0] sw,
    input btnL,
    input btnU,
    input btnC,
    input btnD,
    input btnR,
    inout [3:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
  );
  
  // Switch controls:
  //   0-11: 12-bit data/address
  //   15: Write enable
  
  reg [11:0] dat;
  reg [11:0] addr;
  
  wire [15:0] switches;
  wire buttonLeft;
  wire buttonUp;
  wire buttonDown;
  wire [15:0] dOut;
  wire wBusy;
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(btnU),
    .btnCIn(btnC),
    .btnDIn(btnD),
    .btnRIn(btnR),
    .segsIn(dOut),
    .dpIn(~wBusy),
    .switchOut(switches[15:0]),
    .btnLOut(buttonLeft),
    .btnUOut(buttonUp),
    .btnCOut(),
    .btnDOut(buttonDown),
    .btnROut(),
    .segsOut(seg[6:0]),
    .anOut(an[3:0]),
    .dpOut(dp)
  );
  
  BlockRamDesign_wrapper bram(
    .addra({4'h0, addr[11:0]}),
    .clka(buttonLeft),
    .dina({4'h0, dat[11:0]}),
    .douta(dOut[15:0]),
    .ena(1'b1),
    .rsta_busy(wBusy),
    .wea({switches[15], switches[15]})
  );
  
  always @ (posedge clk) begin
    if(buttonUp == 1'b1) begin
      dat[11:0] = switches[11:0];
    end
    
    if(buttonDown == 1'b1) begin
      addr[11:0] = switches[11:0];
    end
  end
  
  assign led[15:0] = switches[15:0];
  
endmodule
