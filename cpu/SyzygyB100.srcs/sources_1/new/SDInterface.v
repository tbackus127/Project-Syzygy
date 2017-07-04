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
  
  // R0: Peripheral's instruction register. See the SDController module for the supported
  //  operations. This register can only be written by the CPU.
  wire [15:0] wR0Output;
  wire [15:0] wR0InstrOut;
  SyzFETRegister3Out regInstr(
   .dIn(dIn[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[0]),
   .write(wWriteEnSignals[0]),
   .asyncReset(reset),
   .dOut(wR0Output[15:0]),
   .dOut2(wR0InstrOut[15:0]),
   .debugOut()
  );
  
  // R1: Peripheral's status register. This register can only be written by the controller,
  //  and is read-only for the CPU.
  wire [2:0] wR1StatusIn;
  wire wSetR1;
  wire wEnR1Write;
  wire [15:0] wR1Output;
  SyzFETRegister2Out regStatus(
   .dIn({13'b0000000000000, wR1StatusIn[2:0]}),
   .clockSig(wSetR1),
   .read(wReadEnSignals[1]),
   .write(wEnR1Write),
   .asyncReset(reset),
   .dOut(wR1Output[15:0]),
   .debugOut()
  );
  
  // R2: Peripheral's data input register. This register's value is read by the controller and
  //  is used to write to the SD card's memory. This register cannot be written by the controller,
  //  only the CPU.
  wire [15:0] wR2Output;
  wire [15:0] wR2DataOut;
  SyzFETRegister3Out regDataIn(
   .dIn(dIn[15:0]),
   .clockSig(cpuClock),
   .read(wReadEnSignals[2]),
   .write(wWriteEnSignals[2]),
   .asyncReset(reset),
   .dOut(wR2Output[15:0]),
   .dOut2(wR2DataOut[15:0]),
   .debugOut()
  );
  
  // R3: Peripheral's data output register. This register's value is updated by the controller,
  //  and is written after two bytes have been received. The controller will not continue reading
  //  until it receives a continue command. This register cannot be written by the CPU, only the
  //  controller.
  wire [15:0] wR3DataOutIn;
  wire wSetR3;
  wire wEnR3Write;
  wire [15:0] wR3Output;
  SyzFETRegister2Out regDataOut(
   .dIn(wR3DataOutIn[15:0]),
   .clockSig(wSetR3),
   .read(wReadEnSignals[3]),
   .write(wEnR3Write),
   .asyncReset(reset),
   .dOut(wR3Output[15:0]),
   .debugOut()
  );
  
  // R4: Peripheral's address register. These 16-bit register's values are concatenated together
  //  to form the 32-bit address that will be used for reading and writing to and from the SD card.
  //  These registers cannot be written by the controller, only the CPU.
  wire [31:0] wR4Output;
  wire [31:0] wR4AddrOut;
  SyzFETRegister3Out regAddrLSB(
    .dIn(dIn[15:0]),
    .clockSig(cpuClock),
    .read(wReadEnSignals[4]),
    .write(wWriteEnSignals[4]),
    .asyncReset(reset),
    .dOut(wR4Output[15:0]),
    .dOut2(wR4AddrOut[15:0]),
    .debugOut()
  );
  SyzFETRegister3Out regAddrMSB(
    .dIn(dIn[31:16]),
    .clockSig(cpuClock),
    .read(wReadEnSignals[4]),
    .write(wWriteEnSignals[4]),
    .asyncReset(reset),
    .dOut(wR4Output[31:16]),
    .dOut2(wR4AddrOut[31:16]),
    .debugOut()
  );
  
  // Or's all register output signals together so the dOut output won't have multiple drivers.
  Or32B5Way dOutOr(
    .aIn({16'h0000, wR0Output[15:0]}),                            // TODO: Multiplex this instead
    .bIn({16'h0000, wR1Output[15:0]}),
    .cIn({16'h0000, wR2Output[15:0]}),
    .dIn({16'h0000, wR3Output[15:0]}),
    .eIn(wR4Output[31:0]),
    .dOut(dOut[31:0])
  );
  
  // SD Controller
  SDController controller(
    .ctrlClk(cpuClock),
    .addr(wR4AddrOut[31:0]),
    .dIn(wR2DataOut[15:0]),
    .op(wR0InstrOut[15:0]),
    .exec(exec),
    .reset(reset),
    .miso(miso),
    .serialClockOut(serialClockOut),
    .status(wR1StatusIn[2:0]),
    .updateStatus(wEnR1Write),
    .clkR1(wSetR1),
    .dOut(wR3DataOutIn[15:0]),
    .updateDataOut(wEnR3Write),
    .clkR3(wSetR3),
    .chipSelect(chipSel),
    .mosi(mosi),
    .debugOut(debugOut[15:0]),
    .debugOut2(debugOut2[7:0])
  );
  
endmodule
