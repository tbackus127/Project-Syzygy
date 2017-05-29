`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 05:29:26 PM
// Design Name: 
// Module Name: InstructionDecoder
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

module InstructionDecoder(
    input [15:0] instrIn,
    output reg [14:0] pushVal,
    output reg [3:0] regReadSelect,
    output reg readEn,
    output reg [3:0] regWriteSelect,
    output reg writeEn,
    output reg [2:0] jumpCondition,
    output reg [2:0] aluOp,
    output reg [7:0] aluArgs,
    output reg [3:0] periphSelect,
    output reg [3:0] periphReg,
    output reg periphMode,
    output reg periphExec,
    output reg periph32,
    output reg [1:0] accumMuxSelect
  );
  
  // Instruction decoder behavior description
  // All outputs explicitly declared to prevent latching
  always @ (instrIn) begin
    
    // If it's a push instruction
    if(instrIn[15]) begin
      
      pushVal[14:0] <= instrIn[14:0];
      regReadSelect[3:0] <= 4'b0000;
      readEn <= 1'b0;
      regWriteSelect[3:0] <= 4'b0010;
      writeEn <= 1'b1;
      jumpCondition[2:0] <= 2'b00;
      aluOp[2:0] <= 2'b00;
      aluArgs[7:0] <= 7'b0000000;
      periphSelect[3:0] <= 4'b0000;
      periphReg[3:0] <= 4'b0000;
      periphMode <= 1'b0;
      periphExec <= 1'b0;
      periph32 <= 1'b0;
      accumMuxSelect[1:0] <= 2'b10;
      
    // If it's a standard instruction
    end else begin
    
      // Decode normal operations
      case (instrIn[14:12])
          
        // System (TBD)
        3'b000: begin
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0000;
          writeEn <= 1'b0;
          jumpCondition[2:0] <= 2'b00;
          aluOp[2:0] <= 2'b00;
          aluArgs[7:0] <= 7'b0000000;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphMode <= 1'b0;
          periphExec <= 1'b0;
          periph32 <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // Copy
        3'b001: begin
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= instrIn[11:8];
          regWriteSelect[3:0] <= instrIn[7:4];
          readEn <= 1'b1;
          writeEn <= 1'b1;
          jumpCondition[2:0] <= 2'b00;
          aluOp[2:0] <= 2'b00;
          aluArgs[7:0] <= 7'b0000000;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphMode <= 1'b0;
          periphExec <= 1'b0;
          periph32 <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // Jump
        3'b010: begin
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0001;
          writeEn <= 1'b1;
          jumpCondition[2:0] <= instrIn[11:9];
          aluOp[2:0] <= 2'b00;
          aluArgs[7:0] <= 7'b0000000;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphMode <= 1'b0;
          periphExec <= 1'b0;
          periph32 <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // ALU
        3'b011: begin
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0010;
          writeEn <= 1'b1;
          jumpCondition[2:0] <= 2'b00;
          aluOp[2:0] <= instrIn[10:8];
          aluArgs[7:0] <= instrIn[7:1];
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphMode <= 1'b0;
          periphExec <= 1'b0;
          periph32 <= 1'b0;
          accumMuxSelect[1:0] <= 2'b11;
        end
        
        // I/O
        3'b100: begin
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0100;
          readEn <= 1'b1;
          regWriteSelect[3:0] <= 4'b0000;
          writeEn <= 1'b0;
          jumpCondition[2:0] <= 2'b00;
          aluOp[2:0] <= 2'b00;
          aluArgs[7:0] <= 7'b0000000;
          periphSelect[3:0] <= instrIn[11:8];
          periphReg[3:0] <= instrIn[7:4];
          periphMode <= instrIn[2];
          periphExec <= instrIn[3];
          periph32 <= instrIn[1];
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // UNUSED
        3'b101: begin 
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0000;
          writeEn <= 1'b0;
          jumpCondition[2:0] <= 2'b00;
          aluOp[2:0] <= 2'b00;
          aluArgs[7:0] <= 7'b0000000;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphMode <= 1'b0;
          periphExec <= 1'b0;
          periph32 <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // UNUSED
        3'b110: begin 
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0000;
          writeEn <= 1'b0;
          jumpCondition[2:0] <= 2'b00;
          aluOp[2:0] <= 2'b00;
          aluArgs[7:0] <= 7'b0000000;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphMode <= 1'b0;
          periphExec <= 1'b0;
          periph32 <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // UNUSED
        3'b111: begin
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0000;
          writeEn <= 1'b0;
          jumpCondition[2:0] <= 2'b00;
          aluOp[2:0] <= 2'b00;
          aluArgs[7:0] <= 7'b0000000;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphMode <= 1'b0;
          periphExec <= 1'b0;
          periph32 <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
      endcase
    end
  end
  
endmodule
