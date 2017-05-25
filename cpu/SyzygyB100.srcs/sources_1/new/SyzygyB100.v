`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2017 07:43:33 PM
// Design Name: 
// Module Name: SyzygyB100
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

module SyzygyB100(
    input clk,
    input [15:0] instrIn,
    output [15:0] dOut
  );
  
  // Data bus
  wire [15:0] wDataBus;
  
  // Reset lines
  wire [15:0] wRegReset;
  
  //----------------------------------------------------------------------------
  // Instruction Decoder
  //----------------------------------------------------------------------------
  
  // Decoder signals
  wire [15:0] wPushVal;
  wire [3:0] wRegReadSel;
  wire [3:0] wRegWriteSel;
  wire [3:0] wPeriphSel;
  wire [2:0] wJumpCondition;
  wire wReadEn;
  wire wWriteEn;
  wire wPeriphMode;
  
  // Instruction Decoder connections
  InstructionDecoder instrDec(
    .instrIn(wInstrRegOut[15:0]),
    .pushVal(wPushVal[15:0]),
    .regReadSelect(wRegReadSel[3:0]),
    .readEn(wReadEn),
    .regWriteSelect(wRegWriteSel[3:0]),
    .writeEn(wWriteEn),
    .jumpCondition(wJumpCondition[2:0]),
    .aluOp(wALUInstr[10:8]),
    .aluArgs(wALUInstr[7:0]),
    .periphSelect(wPeriphSel[3:0]),
    .periphMode(wPeriphMode)
  );
  
  // Register read (source) decoder
  wire [15:0] wRegReadExp;
  Dmx4to16 dmxRegReadSel(
    .sel(wRegReadSel[3:0]),
    .en(wReadEn),
    .out(wRegReadExp[15:0])
  );
  
  // Register write (destination) decoder
  wire [15:0] wRegWriteExp;
  Dmx4to16 dmxRegWriteSel(
    .sel(wRegWriteSel[3:0]),
    .en(wWriteEn),
    .out(wRegWriteExp[15:0])
  );

  //----------------------------------------------------------------------------
  // Registers
  //----------------------------------------------------------------------------
  
  // R0: Instruction Register
  wire [15:0] wInstrRegOut;
  SyzFETRegister regInstr(
    .dIn(instrIn[15:0]),
    .clk(clk),
    .read(),
    .write(),
    .asyncReset(wRegReset[0]),
    .dOut(wInstrRegOut[15:0])    
  );
  
  // R1: Program Counter
  wire [15:0] wProgCountOut;
  SyzFETRegister regProgCount(
    .dIn(),
    .clk(clk),
    .read(),
    .write(),
    .asyncReset(wRegReset[1]),
    .dOut(wProgCountOut[15:0])
  );
  
  // R2: Accumulator
  SyzFETRegister regAccum(
    // TODO: Figure out how to make this input from data bus OR ALU output
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(),
    .write(),
    .asyncReset(wRegReset[2]),
    .dOut(wDataBus[15:0])
  );
  
  // R3: Jump Address
  SyzFETRegister regJmpAddr(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[3]),
    .write(wRegWriteExp[3]),
    .asyncReset(wRegReset[3]),
    .dOut(wDataBus[15:0])
  );
  
  // R4: I/O LSB
  SyzFETRegister regIOLSB(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[4]),
    .write(wRegWriteExp[4]),
    .asyncReset(wRegReset[4]),
    .dOut(wDataBus[15:0])
  );
  
  // R5: I/O MSB
  SyzFETRegister regIOMSB(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[5]),
    .write(wRegWriteExp[5]),
    .asyncReset(wRegReset[5]),
    .dOut(wDataBus[15:0])
  );
  
  // R6: ALU A
  wire [15:0] wALUAin;
  SyzFETRegister regALUA(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[6]),
    .write(wRegWriteExp[6]),
    .asyncReset(wRegReset[6]),
    .dOut(wALUAin[15:0])
    // TODO: Find out how to send to ALU AND data bus!
  );
  
  // R7: ALU B
  wire [15:0] wALUBin;
  SyzFETRegister regALUB(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[7]),
    .write(wRegWriteExp[7]),
    .asyncReset(wRegReset[7]),
    .dOut(wALUBin[15:0])
    // TODO: Find out how to send to ALU AND data bus!
  );
  
  //----------------------------------------------------------------------------
  // ALU
  //----------------------------------------------------------------------------
  
  // ALU connections
  wire [11:0] wALUInstr;
  wire [15:0] wALUOut;
  ALU alu(
    .aIn(wALUAin[15:0]),
    .bIn(wALUBin[15:0]),
    .op(wALUInstr[10:8]),
    .negA(wALUInstr[7]),
    .negB(wALUInstr[6]),
    .zeroB(wALUInstr[5]),
    .negQ(wALUInstr[4]),
    .arg(wALUInstr[3]),
    .arth(wALUInstr[2]),
    .rot(wALUInstr[1]),
    .aluOut(wALUOut[15:0])
  );
  
endmodule











