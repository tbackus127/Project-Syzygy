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
    input cpuClock,
    
    // CPU control signals
    input periphSelect,
    input [3:0] regSelect,
    input readEn,
    input writeEn,
    input reset,
    input [31:0] dIn,
    input exec,
    
    // SD signals (minus dOut and debugOuts)
    input miso,
    output serialClockOut,
    output [31:0] dOut,
    output chipSel,
    output mosi,
    output [15:0] debugOut,   // SD connections, count
    output [7:0] debugOut2    // Controller State
  );
  
  // Register Read Decoder
  //   Enables the corresponding interface register's read signal if this peripheral
  //   is selected, the read enable signal is on, and if the execute signal is off.
  wire [15:0] wRegExtReadEn;
  Dmx4to16 regReadDmx(
    .sel(regSelect[3:0]),
    .en(periphSelect & readEn & ~exec),
    .out(wRegExtReadEn[15:0])
  );
  
  // Register Write Decoder
  //   Enables the corresponding interface register's write signal if this peripheral
  //   is selected, the write enable signal is on, and if the execute signal is off.
  wire [15:0] wRegExtWriteEn;
  Dmx4to16 regWriteDmx(
    .sel(regSelect[3:0]),
    .en(periphSelect & writeEn & ~exec),
    .out(wRegExtWriteEn[15:0])
  );
  
  // R0 - Peripheral Instruction Register
  //   Triggered on falling clock edge, dOut2 always outputs
  //   Instruction decoder (below):
  //     0: Read from block memory
  //     1: Write to block memory
  //     2: Read 512 bytes of data from the SD card into block memory (overwrites block memory)
  //     3: Write 512 bytes of data to the SD card from block memory
  wire [15:0] wR0ExtOut;
  wire [15:0] wR0InstrOut;
  SyzFETRegister3Out regInstr(
    .dIn(dIn[15:0]),
    .clockSig(cpuClock),
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
  //   Can only be written by controller
  wire [15:0] wR1ExtOut;
  wire [1:0] wControllerStatus;
  SyzFETRegister2Out regStatus(
    .dIn({14'b00000000000000, wControllerStatus[1:0]}),
    .clockSig(cpuClock),
    .read(wRegExtReadEn[1]),
    .write(wRegExtWriteEn[1] | wStatusUpdate),
    .asyncReset(reset),
    .dOut(wR1ExtOut[15:0]),
    .debugOut()
  );
  
  // R2 - Peripheral Data Register
  //   Triggered on falling clock edge, dOut2 always outputs
  //   Only written by the interface when a block memory read command is issued
  wire [15:0] wR2In;
  wire [15:0] wBlockMemDOut;
  Mux16B2to1 r2InMux(
    .aIn(dIn[15:0]),
    .bIn(wBlockMemDOut[15:0]),
    .sel(wInstrSignals[0]),
    .dOut(wR2In[15:0])
  );
  wire [15:0] wR2ExtOut;
  wire [15:0] wR2DataOut;
  SyzFETRegister3Out regData(
    .dIn(wR2In[15:0]),
    .clockSig(cpuClock),
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
    .clockSig(cpuClock),
    .read(wRegExtReadEn[3]),
    .write(wRegExtWriteEn[3]),
    .asyncReset(reset),
    .dOut(wR3ExtOut[15:0]),
    .dOut2(wR3AddrOut[15:0]),
    .debugOut()
  );
  SyzFETRegister3Out regAddressMSB(
    .dIn(dIn[31:16]),
    .clockSig(cpuClock),
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
    .ctrlClk(cpuClock),
    .addr(wR3AddrOut[31:0]),
    .exec(wControllerExecSignal & (wInstrSignals[2] | wInstrSignals[3])),
    .accessMode(wInstrSignals[1] | wInstrSignals[3]),
    .blockMemMSB(wBlockMemMSBToController),
    .miso(miso),
    .serialClockOut(serialClockOut),
    .shiftBlockMemEn(wBlockMemShiftEn),
    .status(wControllerStatus[1:0]),
    .updateStatus(wStatusUpdate),
    .blockMemLSB(wBLockMemLSBFromController),
    .chipSelect(chipSel),
    .mosi(mosi),
    .debugOut(debugOut[15:0]),
    .debugOut2(debugOut2[7:0])
  );

  SDBlockMemory blockMem(
    .blkMemClk(cpuClock),
    .dIn(wR2DataOut[15:0]),
    .regSelect(wR3AddrOut[7:0]),
    .randomRead(wInstrSignals[0]),
    .randomWrite(wInstrSignals[1]),
    .serialDataIn(wBLockMemLSBFromController),
    .serialClock(serialClockOut),
    .serialWriteEn(wBlockMemShiftEn),
    .dOut(wBlockMemDOut[15:0]),
    .serialDataOut(wBlockMemMSBToController)
  );
  
endmodule
