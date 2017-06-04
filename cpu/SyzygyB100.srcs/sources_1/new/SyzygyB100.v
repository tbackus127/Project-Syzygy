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
    input clockSig,
    input en,
    input res,
    input [15:0] extInstrIn,
    input [3:0] extRegSel,
    output [15:0] extDOut,
    output [15:0] extDOut2,
    output [31:0] extPerDOut,
    output [3:0] extPerSel,
    output [3:0] extPerReg,
    output extPerModeAcc,
    output extPerModeExec,
    output extPerMode32
  );
  
  // Data bus
  wire [15:0] wDataBus;
  
  // Register reset lines
  wire [15:0] wRegReset;
  assign wRegReset [15:0] = {15{res}};
  
  //----------------------------------------------------------------------------
  // Instruction Decoder
  //----------------------------------------------------------------------------
  
  // Decoder signals
  wire [14:0] wPushVal;
  wire [3:0] wRegReadSel;
  wire [3:0] wRegWriteSel;
  wire [3:0] wPeriphSel;
  wire [2:0] wJumpCondition;
  wire [1:0] muxSel;
  wire wAccSrcSelect;
  wire wAccALUSrc;
  wire wReadEn;
  wire wReadFromR3;
  wire wWriteEn;
  wire [15:0] wInstrRegOut;
  
  // Instruction Decoder connections
  InstructionDecoder instrDec(
    .instrIn(wInstrRegOut[15:0]),
    .pushVal(wPushVal[14:0]),
    .regReadSelect(wRegReadSel[3:0]),
    .regReadFromR3(wReadFromR3),
    .readEn(wReadEn),
    .regWriteSelect(wRegWriteSel[3:0]),
    .writeEn(wWriteEn),
    .jumpCondition(wJumpCondition[2:0]),
    .aluOp(wALUInstr[10:8]),
    .aluArgs(wALUInstr[7:0]),
    .periphSelect(extPerSel[3:0]),
    .periphReg(extPerReg[3:0]),
    .periphMode(extPerModeAcc),
    .periphExec(extPerModeExec),
    .periph32(extPerMode32),
    .accumMuxSelect(muxSel[1:0])
  );
  assign wAccSrcSelect = muxSel[1];
  assign wAccALUSrc = muxSel[0];
  
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
  // Boot ROM
  //----------------------------------------------------------------------------
  wire [15:0] wBootROMOut;
  BootRom brom (
    .en(clockSig),
    .addr(wCounterOut[3:0]),
    .instrOut(wBootROMOut[15:0])
  );

  //----------------------------------------------------------------------------
  // Special Registers
  //----------------------------------------------------------------------------
  
  // Debug register select
  wire [15:0] wDebugOut0;
  wire [15:0] wDebugOut1;
  wire [15:0] wDebugOut2;
  wire [15:0] wDebugOut3;
  wire [15:0] wDebugOut4;
  wire [15:0] wDebugOut5;
  wire [15:0] wDebugOut6;
  wire [15:0] wDebugOut7;
  wire [15:0] wDebugOut8;
  wire [15:0] wDebugOut9;
  wire [15:0] wDebugOut10;
  wire [15:0] wDebugOut11;
  wire [15:0] wDebugOut12;
  wire [15:0] wDebugOut13;
  wire [15:0] wDebugOut14;
  wire [15:0] wDebugOut15;
  Mux16B16to1 muxDebugSelect(
    .dIn0(wDebugOut0[15:0]),
    .dIn1(wDebugOut1[15:0]),
    .dIn2(wDebugOut2[15:0]),
    .dIn3(wDebugOut3[15:0]),
    .dIn4(wDebugOut4[15:0]),
    .dIn5(wDebugOut5[15:0]),
    .dIn6(wDebugOut6[15:0]),
    .dIn7(wDebugOut7[15:0]),
    .dIn8(wDebugOut8[15:0]),
    .dIn9(wDebugOut9[15:0]),
    .dIn10(wDebugOut10[15:0]),
    .dIn11(wDebugOut11[15:0]),
    .dIn12(wDebugOut12[15:0]),
    .dIn13(wDebugOut13[15:0]),
    .dIn14(wDebugOut14[15:0]),
    .dIn15(wDebugOut15[15:0]),
    .sel(extRegSel[3:0]),
    .dOut(extDOut2[15:0])
  );
  assign wDebugOut0[15:0] = wInstrRegOut[15:0];
  
  // R0: Instruction Register
  Mux16B2to1 muxInstrReg(
    .aIn(wBootROMOut[15:0]),
    .bIn(extInstrIn[15:0]),
    .sel(1'b1),
    .dOut(wInstrRegOut[15:0])
  );
  
  // R1: Program Counter
  wire [15:0] wR3JumpAddr;
  wire [15:0] wCounterOut;
  wire wJmpEn;
  Counter16B pc (
    .clockSig(clockSig),
    .en(en),
    .valIn(wR3JumpAddr[15:0]),
    .set(wJmpEn),
    .valOut(wCounterOut[15:0]),
    .debugOut(wDebugOut1[15:0])
  );
  assign extDOut[15:0] = wCounterOut[15:0];
  
  // R2: Accumulator
  wire [15:0] wALUOut;
  wire [15:0] wAccMuxStep;
  wire [15:0] wAccumIn;
  wire [15:0] wCompIn;
  Mux16B2to1 muxAccSel(
    .aIn(wDataBus[15:0]),
    .bIn(wAccMuxStep[15:0]),
    .sel(wAccSrcSelect),
    .dOut(wAccumIn[15:0])
  );
  Mux16B2to1 muxAccOp(
    .aIn({1'b0, wPushVal[14:0]}),
    .bIn(wALUOut[15:0]),
    .sel(wAccALUSrc),
    .dOut(wAccMuxStep[15:0])
  );
  SyzFETRegister regAccum(
    .dIn(wAccumIn[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[2]),
    .write(wRegWriteExp[2]),
    .asyncReset(wRegReset[2]),
    .dOut(wDataBus[15:0]),
    .dOut2(wCompIn[15:0]),
    .debugOut(wDebugOut2[15:0])
  );
  Comparator cmp(
    .dIn(wCompIn[15:0]),
    .lt(wJumpCondition[2]),
    .eq(wJumpCondition[1]),
    .gt(wJumpCondition[0]),
    .jmpEn(wJmpEn)
  );
  
  // R3: Jump Address
  SyzFETRegister regJmpAddr(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[3] | wReadFromR3),
    .write(wRegWriteExp[3]),
    .asyncReset(wRegReset[3]),
    .dOut(wDataBus[15:0]),
    .dOut2(wR3JumpAddr[15:0]),
    .debugOut(wDebugOut3[15:0])
  );
  
  // R4: I/O LSB
  wire [31:0] wIOOut;
  SyzFETRegister regIOLSB(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[4]),
    .write(wRegWriteExp[4]),
    .asyncReset(wRegReset[4]),
    .dOut(wDataBus[15:0]),
    .dOut2(wIOOut[15:0]),
    .debugOut(wDebugOut4[15:0])
  );
  
  // R5: I/O MSB
  SyzFETRegister regIOMSB(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[5]),
    .write(wRegWriteExp[5]),
    .asyncReset(wRegReset[5]),
    .dOut(wDataBus[15:0]),
    .dOut2(wIOOut[31:16]),
    .debugOut(wDebugOut5[15:0])
  );
  assign extPerDOut[31:0] = wIOOut[31:0];
  
  // R6: ALU A
  wire [15:0] wALUAin;
  SyzFETRegister regALUA(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[6]),
    .write(wRegWriteExp[6]),
    .asyncReset(wRegReset[6]),
    .dOut(wDataBus[15:0]),
    .dOut2(wALUAin[15:0]),
    .debugOut(wDebugOut6[15:0])
  );
  
  // R7: ALU B
  wire [15:0] wALUBin;
  SyzFETRegister regALUB(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[7]),
    .write(wRegWriteExp[7]),
    .asyncReset(wRegReset[7]),
    .dOut(wDataBus[15:0]),
    .dOut2(wALUBin[15:0]),
    .debugOut(wDebugOut7[15:0])
  );
  
  //----------------------------------------------------------------------------
  // General-Purpose Registers
  //----------------------------------------------------------------------------
  
  // R8
  SyzFETRegister regR8(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[8]),
    .write(wRegWriteExp[8]),
    .asyncReset(wRegReset[8]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut8[15:0])
  );
  
  // R9
  SyzFETRegister regR9(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[9]),
    .write(wRegWriteExp[9]),
    .asyncReset(wRegReset[9]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut9[15:0])
  );
  
  // R10
  SyzFETRegister regR10(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[10]),
    .write(wRegWriteExp[10]),
    .asyncReset(wRegReset[10]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut10[15:0])
  );
  
  // R11
  SyzFETRegister regR11(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[11]),
    .write(wRegWriteExp[11]),
    .asyncReset(wRegReset[11]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut11[15:0])
  );
  
  // R12
  SyzFETRegister regR12(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[12]),
    .write(wRegWriteExp[12]),
    .asyncReset(wRegReset[12]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut12[15:0])
  );
  
  // R13
  SyzFETRegister regR13(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[13]),
    .write(wRegWriteExp[13]),
    .asyncReset(wRegReset[13]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut13[15:0])
  );
  
  // R14
  SyzFETRegister regR14(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[14]),
    .write(wRegWriteExp[14]),
    .asyncReset(wRegReset[14]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut14[15:0])
  );
  
  // R15
  SyzFETRegister regR15(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[15]),
    .write(wRegWriteExp[15]),
    .asyncReset(wRegReset[15]),
    .dOut(wDataBus[15:0]),
    .dOut2(),
    .debugOut(wDebugOut15[15:0])
  );
  
  
  //----------------------------------------------------------------------------
  // ALU
  //----------------------------------------------------------------------------
  
  // ALU connections
  wire [11:0] wALUInstr;
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
