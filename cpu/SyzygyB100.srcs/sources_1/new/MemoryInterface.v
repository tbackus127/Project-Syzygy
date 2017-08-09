`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2017 04:45:48 PM
// Design Name: 
// Module Name: MemoryInterface
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


module MemoryInterface(
    input cpuClock,
    input periphSelect,
    input [15:0] dIn,
    input [3:0] regSelect,
    input readEn,
    input writeEn,
    input reset,
    input exec,
    input [15:0] dataFromMem,
    input [3:0] debugRegSelect,
    input memStatus,
    output [15:0] dOut,
    output [15:0] dataToMem,
    output [15:0] addrToMem,
    output memReadEn,
    output memWriteEn,
    output [31:0] debugOut
  );
  
  // Demultiplexer that chooses a peripheral register to read the value from, and sends its
  //  value to dOut, where it can be read by the CPU.
  wire [15:0] wReadEnSignals;
  Dmx4to16 readEnDmx(
    .sel(regSelect[3:0]),
    .en(periphSelect & readEn),
    .out(wReadEnSignals[15:0])
  );
  
  // Demultiplexer that chooses a peripheral register to write dIn's value to on the clock's
  //  falling edge.
  wire [15:0] wWriteEnSignals;
  Dmx4to16 writeEnDmx(
    .sel(regSelect[3:0]),
    .en(periphSelect & writeEn),
    .out(wWriteEnSignals[15:0])
  );
  
  // R0: Peripheral's instruction register
  wire [15:0] wR0Output;
  wire [15:0] wInstrOut;
  wire [15:0] wR0DebugOut;
  SyzFETRegister3Out regInstr(
    .dIn(dIn[15:0]),
    .clockSig(cpuClock),
    .read(wReadEnSignals[0]),
    .write(wWriteEnSignals[0]),
    .asyncReset(reset),
    .dOut(wR0Output[15:0]),
    .dOut2(wInstrOut[15:0]),
    .debugOut(wR0DebugOut[15:0])  
  );
  // 0: Read, 1: Write
  assign memReadEn = exec & ~wInstrOut[0];
  assign memWriteEn = exec & wInstrOut[0];
  
  // R1: Peripheral's status register
  // Not actually a register; just a signal from memory
  
  // R2: Peripheral's data input register
  wire [15:0] wR2Output;
  wire [15:0] wR2DebugOut;
  SyzFETRegister3Out regDatIn(
   .dIn(dIn[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[2]),
   .write(wWriteEnSignals[2]),
   .asyncReset(reset),
   .dOut(wR2Output[15:0]),
   .dOut2(dataToMem[15:0]),
   .debugOut(wR2DebugOut[15:0])
  );
  
  // R3: Peripheral's data output register
  wire [15:0] wR3Output;
  wire [15:0] wR3DebugOut;
  SyzFETRegister2Out regDatOut(
   .dIn(dataFromMem[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[3]),
   .write(memReadEn),
   .asyncReset(reset),
   .dOut(wR3Output[15:0]),
   .debugOut(wR3DebugOut[15:0])
  );
  
  // R4: Peripheral's address register
  wire [15:0] wR4Output;
  wire [15:0] wR4DebugOut;
  SyzFETRegister3Out regAddr(
   .dIn(dIn[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[4]),
   .write(wWriteEnSignals[4]),
   .asyncReset(reset),
   .dOut(wR4Output[15:0]),
   .dOut2(addrToMem[15:0]),
   .debugOut(wR4DebugOut[15:0])
  );
  
  // Output multiplexer
  Mux16B8to1 memIntrOutMux (
    .dIn0(wR0Output[15:0]),
    .dIn1({15'b000000000000000, memStatus}),
    .dIn2(wR2Output[15:0]),
    .dIn3(wR3Output[15:0]),
    .dIn4(wR4Output[15:0]),
    .dIn5(16'h0000),
    .dIn6(16'h0000),
    .dIn7(16'h0000),
    .sel(regSelect[3:0]),
    .dOut(dOut[15:0])
  );
  
  // Debug Output OR
  Mux16B8to1 memInterfaceRegSelect (
    .dIn0(wR0DebugOut[15:0]),
    .dIn1({15'b000000000000000, memStatus}),
    .dIn2(wR2DebugOut[15:0]),
    .dIn3(wR3DebugOut[15:0]),
    .dIn4(wR4DebugOut[15:0]),
    .dIn5(16'h0000),
    .dIn6(16'h0000),
    .dIn7(16'h0000),
    .sel(debugRegSelect[2:0]),
    .dOut(debugOut[15:0])
  );
  
endmodule
