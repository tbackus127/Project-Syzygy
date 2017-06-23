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
    
    // CPU clock signal (must already be divided)
    input clk,
    
    // CPU control signals
    input periphSelect,
    input [3:0] regSelect,
    input accessMode,
    input reset,
    input [31:0] dIn,
    input exec,
    
    // SD signals (minus dOut and debugOuts)
    input miso,
    output serialClockOut,
    output [31:0] dOut,
    output chipSel,
    output mosi,
    output [7:0] debugOut,
    output [7:0] debugOut2
  );
  
  // Register Read Decoder
  wire [15:0] wRegExtReadEn;
  Dmx4to16 regReadDmx(
    .sel(regSelect[3:0]),
    .en(periphSelect & ~accessMode & ~exec),
    .out(wRegExtReadEn[15:0])
  );
  
  // Register Write Decoder
  wire [15:0] wRegExtWriteEn;
  Dmx4to16 regWriteDmx(
    .sel(regSelect[3:0]),
    .en(periphSelect & accessMode & ~exec),
    .out(wRegExtWriteEn[15:0])
  );
  
  // R0 - Peripheral Instruction Register
  wire [15:0] wR0ExtOut;
  wire [15:0] wR0InstrOut;
  SyzFETRegister3Out regInstr(
    .dIn(dIn[15:0]),
    .clockSig(clk),
    .read(wRegExtReadEn[0]),
    .write(wRegExtWriteEn[0]),
    .asyncReset(reset),
    .dOut(wR0ExtOut[15:0]),
    .dOut2(wR0InstrOut[15:0]),
    .debugOut()
  );
  wire [3:0] wInstrSignals;
  Dmx2to4 instrDmx(
    .sel(wR0InstrOut[1:0]),
    .en(exec),
    .out(wInstrSignals[3:0])
  );
  
  // R1 - Peripheral Status Register
  wire [15:0] wR1ExtOut;
  wire [1:0] wControllerStatus;
  SyzFETRegister2Out regStatus(
    .dIn({14'b00000000000000, wControllerStatus[1:0]}),
    .clockSig(clk),
    .read(wRegExtReadEn[1]),
    .write(wRegExtWriteEn[1] | serialClockOut),
    .asyncReset(reset),
    .dOut(wR1ExtOut[15:0]),
    .debugOut()
  );
  
  // R2 - Peripheral Data Register
  wire [15:0] wR2In;
  wire [15:0] wBlockMemDOut;
  Mux16B2to1 r2InMux(
    .aIn(dIn[15:0]),
    .bIn(wBlockMemDOut[15:0]),
    .sel(wInstrSignals[1]),
    .dOut(wR2In[15:0])
  );
  wire [15:0] wR2ExtOut;
  wire [15:0] wR2DataOut;
  SyzFETRegister3Out regData(
    .dIn(wR2In[15:0]),
    .clockSig(clk),
    .read(wRegExtReadEn[2]),
    .write(wRegExtWriteEn[2]),
    .asyncReset(reset),
    .dOut(wR2ExtOut[15:0]),
    .dOut2(wR2DataOut[15:0]),
    .debugOut()
  );
    
  // R3 - Peripheral Address Register
  wire [31:0] wR3ExtOut;
  wire [31:0] wR3AddrOut;
  SyzFETRegister3Out regAddressLSB(
    .dIn(dIn[15:0]),
    .clockSig(clk),
    .read(wRegExtReadEn[3]),
    .write(wRegExtWriteEn[3]),
    .asyncReset(reset),
    .dOut(wR3ExtOut[15:0]),
    .dOut2(wR3AddrOut[15:0]),
    .debugOut()
  );
  SyzFETRegister3Out regAddressMSB(
    .dIn(dIn[31:16]),
    .clockSig(clk),
    .read(wRegExtReadEn[3]),
    .write(wRegExtWriteEn[3]),
    .asyncReset(reset),
    .dOut(wR3ExtOut[31:16]),
    .dOut2(wR3AddrOut[31:16]),
    .debugOut()
  );
  
  // Or register outputs for interface-CPU data connection to prevent multi-driven nets
  //   Each register requires a read signal for it to output; only one may be read from at
  //   any given time.
  Or32B4Way extOutOr (
    .aIn({16'h0000, wR0ExtOut[15:0]}),
    .bIn({16'h0000, wR1ExtOut[15:0]}),
    .cIn({16'h0000, wR2ExtOut[15:0]}),
    .dIn(wR3ExtOut[31:0]),
    .dOut(dOut[31:0])
  );
  
  // SD Controller - exec on when clock tick triggers
  wire wControllerExecSignal;
  wire wBlockMemMSBToController;
  wire wBLockMemLSBFromController;
  wire wBlockMemShiftEn;
  buf #(1) (wControllerExecSignal, exec);
  SDController controller(
    .clk(clk),
    .addr(wR3AddrOut[31:0]),
    .exec(wControllerExecSignal & (wInstrSignals[2] | wInstrSignals[3])),
    .accessMode(accessMode),
    .blockMemMSB(wBlockMemMSBToController),
    .miso(miso),
    .serialClockOut(serialClockOut),
    .shiftBlockMemEn(wBlockMemShiftEn),
    .status(wControllerStatus[1:0]),
    .blockMemLSB(wBLockMemLSBFromController),
    .chipSelect(chipSel),
    .mosi(mosi),
    .debugOut(debugOut[7:0]),
    .debugOut2(debugOut2[7:0])
  );
  
  // SD Block Memory - holds an entire block of data for easy read/write
  SDBlockMemory blockMem(
    .clk(clk),
    .dIn(wR2DataOut[15:0]),
    .regSelect(wR3AddrOut[7:0]),
    .randomRead(wInstrSignals[1]),
    .randomWrite(wInstrSignals[0]),
    .serialDataIn(wBLockMemLSBFromController),
    .serialWriteEn(wBlockMemShiftEn),
    .dOut(wBlockMemDOut[15:0]),
    .serialDataOut(wBlockMemMSBToController)
  );
  
endmodule
