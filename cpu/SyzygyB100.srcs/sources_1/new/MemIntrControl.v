`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2017 11:48:20 PM
// Design Name: 
// Module Name: MemIntrControl
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


module MemIntrControl(
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
  
  reg [3:0] regNum;
  reg [15:0] regData;
  reg intrRdEn;
  reg intrWrEn;
  
  wire [15:0] switches;
  wire buttonLeft;
  wire buttonUp;
  wire buttonCenter;
  wire buttonDown;
  wire buttonRight;
  wire wBusy;
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(btnU),
    .btnCIn(btnC),
    .btnDIn(btnD),
    .btnRIn(btnR),
    .segsIn(regData[15:0]),
    .dpIn(),
    .switchOut(switches[15:0]),
    .btnLOut(buttonLeft),
    .btnUOut(buttonUp),
    .btnCOut(buttonCenter),
    .btnDOut(buttonDown),
    .btnROut(buttonRight),
    .segsOut(seg[6:0]),
    .anOut(an[3:0]),
    .dpOut(dp)
  );
  
  wire [15:0] wDataMemToIntr;
  wire [15:0] wDataIntrToMem;
  wire [15:0] wAddrIntrToMem;
  wire [15:0] wDataIntrToSegs;
  wire wMemRdEn;
  wire wMemWrEn;
  MemoryInterface memInt(
    .cpuClock(clk),
    .periphSelect(1'b1),
    .dIn(regData[15:0]),
    .regSelect(regNum[3:0]),
    .readEn(intrRdEn),
    .writeEn(intrWrEn),
    .reset(1'b0),
    .exec(buttonCenter),
    .dataFromMem(wDataMemToIntr[15:0]),
    .debugRegSelect(),
    .memStatus(wBusy),
    .dOut(wDataIntrToSegs[15:0]),
    .dataToMem(wDataIntrToMem[15:0]),
    .addrToMem(wAddrIntrToMem[15:0]),
    .memReadEn(wMemRdEn),
    .memWriteEn(wMemWrEn),
    .debugOut()
  );
  
  SyzMem bram(
    .memClk(clk),
    .addr(wAddrIntrToMem[15:0]),
    .dIn(wDataIntrToMem[15:0]),
    .en(1'b1),
    .readEn(wMemRdEn),
    .writeEn(wMemWrEn),
    .dOut(wDataMemToIntr[15:0]),
    .busy(wBusy)
  );
  
  always @ (posedge clk) begin
    if(buttonUp == 1'b1) begin
      regNum[3:0] = switches[3:0];
    end
    
    if(buttonDown == 1'b1) begin
      regData[15:0] = switches[15:0];
    end
    
    if(buttonLeft == 1'b1) begin
      intrRdEn = 1'b1;
      regData[15:0] = wDataIntrToSegs[15:0];
    end else begin
      intrRdEn = 1'b0;
    end
    
    if(buttonRight == 1'b1) begin
      intrWrEn = 1'b1;
    end else begin
      intrWrEn = 1'b0;
   end
  end
  
  assign led[15:0] = switches[15:0];
  
endmodule
