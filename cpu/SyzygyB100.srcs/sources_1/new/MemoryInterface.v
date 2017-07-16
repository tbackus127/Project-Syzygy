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
    output [15:0] dataToMem,
    output [15:0] addrToMem,
    output memReadEn,
    output memWriteEn
  );
  
  // TODO: And writeEn's with periphSelect
  
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
  SyzFETRegister3Out regInstr(
    .dIn(dIn[15:0]),
    .clockSig(cpuClock),
    .read(wReadEnSignals[0]),
    .write(wWriteEnSignals[0]),
    .asyncReset(res),
    .dOut(wR0Output[15:0]),
    .dOut2(wInstrOut[15:0]),
    .debugOut()  
  );
  // 0: Read, 1: Write
  assign memReadEn = exec & ~wInstrOut[0];
  assign memWriteEn = exec & wInstrOut[0];
  
  // R1: Peripheral's status register
  // Always READY (0x0)
  
  // R2: Peripheral's data input register
  wire [15:0] wR2Output;
  SyzFETRegister3Out regDatIn(
   .dIn(dIn[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[2] | memWriteEn),
   .write(wWriteEnSignals[2]),
   .asyncReset(reset),
   .dOut(wR2Output[15:0]),
   .dOut2(dataToMem[15:0]),
   .debugOut()
  );
  
  // R3: Peripheral's data output register
  wire [15:0] wR3Output;
  SyzFETRegister2Out regDatOut(
   .dIn(dataFromMem[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[3]),
   .write(memReadEn),
   .asyncReset(reset),
   .dOut(wR3Output[15:0]),
   .debugOut()
  );
  
  // R4: Peripheral's address register
  wire [15:0] wR4Output;
  SyzFETRegister3Out regAddr(
   .dIn(dIn[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[4]),
   .write(wWriteEnSignals[4]),
   .asyncReset(reset),
   .dOut(wR4Output[15:0]),
   .dOut2(addrToMem[15:0]),
   .debugOut()
  );
  
endmodule
