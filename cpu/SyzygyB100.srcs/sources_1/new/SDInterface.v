`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2017 02:20:17 AM
// Design Name: 
// Module Name: SDInterface
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


module SDInterface(
    input clk,
    input [3:0] regRead,
    input readEn,
    input [3:0] regWrite,
    input writeEn,
    input reset,
    input [31:0] dIn,
    input exec,
    input miso,
    output [31:0] dOut,
    output chipSel,
    output mosi
  );
  
  // R0 - Peripheral Instruction Register
  wire [15:0] wR0Out;
  SyzFETRegister2Out regInstr(
    .dIn(dIn[15:0]),
    .clockSig(clk),
    .read(regRead[0]),
    .write(regWrite[0]),
    .asyncReset(reset),
    .dOut(wR0Out[15:0]),
    .debugOut()
  );
  
  // R1 - Peripheral Status Register
  wire wR1In;
  wire [15:0] wR1Out;
  SyzFETRegister2Out regStatus(
    .dIn({15'b000000000000000, wR1In}),
    .clockSig(clk),
    .read(regRead[1]),
    .write(regWrite[1]),
    .asyncReset(reset),
    .dOut(wR1Out[15:0]),
    .debugOut()
  );
  
  // R2 - Peripheral Data Register
  wire [15:0] wR2Out;
  SyzFETRegister2Out regData(
    .dIn(dIn[15:0]),
    .clockSig(clk),
    .read(regRead[2]),
    .write(regWrite[2]),
    .asyncReset(reset),
    .dOut(wR2Out[15:0]),
    .debugOut()
  );
    
  // R3 - Peripheral Address Register
  wire [31:0] wR3Out;
  SyzFETRegister2Out regAddressLSB(
    .dIn(dIn[15:0]),
    .clockSig(clk),
    .read(regRead[3]),
    .write(regWrite[3]),
    .asyncReset(reset),
    .dOut(wR3Out[15:0]),
    .debugOut()
  );
  SyzFETRegister2Out regAddressMSB(
    .dIn(dIn[31:16]),
    .clockSig(clk),
    .read(regRead[3]),
    .write(regWrite[3]),
    .asyncReset(reset),
    .dOut(wR3Out[31:16]),
    .debugOut()
  );
  
  // SD Controller
  wire [15:0] wRegData;
  wire [15:0] wDataFromBlockMem;
  wire [15:0] wDataToBlockMem;
  wire blockMemLSB;
  wire blockMemMSB;
  SDController controller(
    .clk(clk),
    .addr(wR3Out[31:0]),
    .exec(exec),
    .readEn(readEn),
    .writeEn(writeEn),
    .blockMemMSB(blockMemMSB),
    .dataFromBlockMem(wDataFromBlockMem[15:0]),
    .miso(miso),
    .regData(wRegData[15:0]),
    .dataToBlockMem(wDataToBlockMem[15:0]),
    .status(wR1In),
    .blockMemLSB(blockMemLSB),
    .chipSelect(chipSel),
    .mosi(mosi)
  );
  
  // SD Block Memory - holds an entire block of data for easy read/write
  SDBlockMemory blockMem(
    .clk(clk),
    .dIn(wR2Out[15:0]),
    .regSelect(wR3Out[7:0]),
    .read(),
    .write(),
    .serialDataIn(blockMemLSB),
    .serialSDToMemEn(),
    .dOut(wDataFromBlockMem[15:0]),
    .serialDataOut(blockMemMSB)
  );
  
endmodule
