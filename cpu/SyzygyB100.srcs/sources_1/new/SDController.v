`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2017 03:47:42 AM
// Design Name: 
// Module Name: SDController
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


module SDController(
    input ctrlClk,
    input [31:0] addr,
    input [15:0] dIn,
    input [15:0] op,
    input exec,
    input reset,
    input miso,
    output reg serialClockOut = 1'b0,
    output reg [2:0] status = 3'b001,
    output reg updateStatus = 1'b0,
    output reg clkR1 = 1'b0,
    output reg [15:0] dOut = 16'h0000,
    output reg updateDataOut = 1'b0,
    output reg clkR3 = 1'b0,
    output reg chipSelect = 1'b1,
    output mosi,
    output [15:0] debugOut,
    output [7:0] debugOut2
  );
  
  // ** Controller Commands **
  //  0: Start Block Read - Prepares a block read command, and sets R1 to STATUS_DATA_FETCHED.
  //  1: Start Block Write - Prepares a block write command, and sets R1 to STATUS_DATA_FETCHED.
  //  2: Continue - Transfers 16 bits. The controller's data register will be updated after
  //     the transfer. R1 will be set to STATUS_BUSY_BLKRD or STATUS_BUSY_BLKWR depending on the
  //     command issued. After two bytes have been transferred, R1 will be set to
  //     STATUS_DATA_FETCHED. This repeats 256 times until all 4096 bits in a block have been
  //     transferred. After this, R1 will return to STATUS_READY.
  //  3: Cancel - Continues the block read while ignoring the rest of the data, or the block
  //     write while writing all zeroes to the SD card. During this process R1 will be set to
  //     STATUS_BUSY_BLKRD or STATUS_BUSY_BLKWR, depending on the command that was issued.
  //     R1 will return to STATUS_READY after this command is issued. 
  
  // Single-bit values
  parameter LO = 1'b0;
  parameter HI = 1'b1;
  
  // Status register constants
  parameter STATUS_READY = 0;
  parameter STATUS_BUSY_INIT = 1;
  parameter STATUS_BUSY_BLKRD = 2;
  parameter STATUS_BUSY_BLKWR = 3;
  parameter STATUS_ERR_INIT = 4;
  parameter STATUS_ERR_BLKRD = 5;
  parameter STATUS_ERR_BLKWR = 6;
  parameter STATUS_DATA_FETCHED = 7;
  
  // Data lengths
  parameter TIMEOUT_COUNT = 128;
  parameter CMD_LENGTH = 48;
  parameter RESP_R1_LEN = 8;
  parameter RESP_R7_LEN = 40;
  parameter FLUSH_COUNT = 100;
  parameter DESELECT_COUNT = 4;
  parameter BLOCK_BIT_COUNT = 4096;
  parameter CLOCK_REDUCE_AMT = 65535;
  
  // MOSI / MISO source selections (drives multiplexers)
  parameter MUX_CONST_HI = 2'b00;
  parameter MUX_CMD_MSB = 2'b10;
  parameter MUX_DAT_MSB = 2'b11;
  parameter MUX_BM_CONST = 1'b0;
  parameter MUX_BM_MISO = 1'b1;
  
  // Data Tokens
  parameter TOKEN_DATA_START = 8'hfe;
  parameter TOKEN_DATA_LEN = 8;
  parameter TOKEN_CMD0_RESP = 8'h01;
  parameter TOKEN_R1_RESP = 8'h00;
  parameter TOKEN_DATA_ACC = 5'b00101;
  parameter TOKEN_DATA_CRC_ERR = 5'b01011;
  parameter TOKEN_DATA_WRITE_ERR = 5'b01101;
  
  // SD opcodes
  parameter CMD_CMD0 = 8'h40;
  parameter CMD_CMD8 = 8'h48;
  parameter CMD_CMD55 = 8'h77;
  parameter CMD_CMD41 = 8'h69;
  parameter CMD_CMD17 = 8'h51;
  parameter CMD_CMD24 = 8'h58;
  
  // SD CRC Bytes
  parameter CRC_CMD0 = 8'h95;
  parameter CRC_CMD8 = 8'h87;
  parameter CRC_DUMMY = 8'hff;
  
  // SD Command arguments
  parameter ARG_CMD8 = 32'h000001aa;
  parameter ARG_EMPTY = 32'h00000000;
  
  // Controller initialization states
  parameter STATE_FLUSH_INIT = 0;
  parameter STATE_READY_CMD0 = 1;
  parameter STATE_SEND_CMD = 2;
  parameter STATE_AWAIT_RESPONSE = 3;
  parameter STATE_GET_RESPONSE = 4;
  parameter STATE_CHECK_R1_RESPONSE = 5;
  parameter STATE_CHECK_R7_RESPONSE = 6;
  parameter STATE_DESELECT = 7;
  parameter STATE_READY_CMD8 = 8;
  parameter STATE_READY_CMD55 = 9;
  parameter STATE_READY_CMD41 = 10;
  parameter STATE_FINISH_INIT = 11;
  
  // Controller block read/write states
  parameter STATE_WAIT_FOR_HOST = 12;
  parameter STATE_READY_CMD17 = 13;
  parameter STATE_READY_CMD24 = 14;
  parameter STATE_AWAIT_DATA_TOKEN = 15;
  parameter STATE_GET_DATA_TOKEN = 16;
  parameter STATE_CHECK_DATA_TOKEN = 17;
  parameter STATE_SEND_DATA_TOKEN = 18;
  parameter STATE_READY_DATA_TOKEN = 19;
  parameter STATE_READY_BLOCK_READ = 20;
  parameter STATE_READY_BLOCK_WRITE = 21;
  parameter STATE_READ_BLOCK = 22;
  parameter STATE_WRITE_BLOCK = 23;
  parameter STATE_FINISH_BLOCK_IO = 24;
  parameter STATE_WAIT_FOR_CONTINUE = 25;
  
  // Controller misc states
  parameter STATE_CLOCK_COUNTDOWN = 31;
  
  // Controller registers
  reg [4:0] state = STATE_FLUSH_INIT;       // The current state the controller is in
  
  reg [4:0] returnState = STATE_FLUSH_INIT; // The state to return to when the serial clock can
                                            //  toggle again, after counting down
                                            
  reg [4:0] nextState = STATE_READY_CMD0;   // The next state to proceed to when the current
                                            //  operation completes
                                            
  reg [4:0] errState = STATE_READY_CMD0;    // The state to proceed to when something
                                            //  unexpected happens
                                            
  reg [7:0] count = FLUSH_COUNT;            // The serial clock pulse counter
  
  reg [15:0] clockCount = 0;                 // The CPU clock pulse counter. The serial clock will
                                            //  not toggle until this value hits zero. This is to
                                            //  prevent the serial clock from running at too high
                                            //  a frequency during the SD card's initialization
                                            //  routine (sclk must be < 400khz)
                                            
  reg [39:0] response = 0;                  // The SD card's response
  
  reg [47:0] command = 0;                   // The command to send to the SD card
  
  reg [1:0] mosiSrc = MUX_CONST_HI;         // Where to get the MISO signal from. Is either a
                                            //  constant 1, or the MSB of the command register
  
  reg [7:0] responseLen = 0;                // The expected response length from the SD card. R1
                                            //  responses are 8 bits, R7 responses are 40 bits.
                                              
  reg [7:0] expectedResp = 0;               // The expected response from the SD card that signals
                                            //  that everything went well.
  
  reg blockMode = 0;                        // Flag determining if we've initialized. This is set
                                            //  to 0 during initialization, and 1 only when the
                                            //  controller is ready to accept a block read/write
                                            //  command.
                                            
  reg [15:0] data = 0;                      // Holds two bytes of data until a serial transfer
                                            //  completes.
  
  // SD signals (to prevent constraint collision)
  reg misoVal = 0;
  reg mosiVal = 0;
  
  // Debug signals, always active
  assign debugOut[7:0] = count[7:0];
  assign debugOut[15] = serialClockOut;
  assign debugOut[14] = chipSelect;
  assign debugOut[13] = mosiVal;
  assign debugOut[12] = misoVal;
  assign debugOut2[7:0] = {3'b000, state[4:0]};
  
  // Select between 1, command[MSB], and dataIn[MSB] to use as the MOSI value
  wire wMuxTemp;
  Mux2to1 muxMOSISel0(
    .aIn(command[47]),
    .bIn(data[15]),
    .sel(mosiSrc[0]),
    .out(wMuxTemp)
  );
  Mux2to1 muxMOSISel1(
    .aIn(HI),
    .bIn(wMuxTemp),
    .sel(mosiSrc[1]),
    .out(mosi)
  );
  
  // Do stuff according to the current state on the falling clock edge
  always @ (negedge ctrlClk) begin
    
    case(state[4:0])
      
      // State 0x00 - Send 0xFF for about 100 clock pulses
      STATE_FLUSH_INIT: begin
      
        if(count > 0) begin
          if(serialClockOut == HI) begin
            count <= count - 1;
          end
          
          // Toggle the serial clock and start counting
          serialClockOut <= ~serialClockOut;
          returnState <= STATE_FLUSH_INIT;
          clockCount <= CLOCK_REDUCE_AMT;
          state <= STATE_CLOCK_COUNTDOWN;
          
        end else begin
          state <= STATE_READY_CMD0;
        end
        
      end
      
      // State 0x01 - Set up data needed for transmitting CMD0
      STATE_READY_CMD0: begin
        command = {CMD_CMD0, ARG_EMPTY, CRC_CMD0};
        state = STATE_SEND_CMD;
        nextState = STATE_READY_CMD8;
        errState = STATE_READY_CMD0;
        responseLen = RESP_R1_LEN;
        expectedResp = TOKEN_CMD0_RESP;
        count = CMD_LENGTH;
        mosiSrc = MUX_CMD_MSB;
        chipSelect <= LO;
      end
      
      // State 0x02 - Send the command
      STATE_SEND_CMD: begin
        
        if(count > 0) begin
        
          // Toggle the serial clock and start countdown
          serialClockOut <= ~serialClockOut;
          returnState <= STATE_SEND_CMD;
          clockCount <= CLOCK_REDUCE_AMT;
          state <= STATE_CLOCK_COUNTDOWN;
        
          if(serialClockOut == LO) begin
            command[47:0] <= {command[46:0], LO};
            count <= count - 1;
          end
          
        end else begin
          mosiSrc <= MUX_CONST_HI;
          state <= STATE_AWAIT_RESPONSE;
          count <= TIMEOUT_COUNT;
          returnState <= STATE_AWAIT_RESPONSE;
        end
        
      end
      
      // State 0x03 - Wait for a zero (beginning of response token) from SD card
      //   If no 0 has been received, set the state to the return state
      STATE_AWAIT_RESPONSE: begin
      
        if(serialClockOut == HI) begin
        
          if(miso == LO) begin
            response[39:0] <= {response[38:0], miso};
            returnState <= STATE_GET_RESPONSE;
            count <= responseLen - 1;
          end else if(count == 0) begin
            returnState <= STATE_GET_RESPONSE;
            nextState <= errState;
            count <= DESELECT_COUNT;
            chipSelect = HI;
          end else begin
            count <= count - 1;
          end
        end
      
        // Toggle the serial clock and start countdown
        serialClockOut <= ~serialClockOut;
        clockCount <= CLOCK_REDUCE_AMT;
        state <= STATE_CLOCK_COUNTDOWN;
        
      end
    
    // State 0x04 - Get the response token
    STATE_GET_RESPONSE: begin
    
      if(count > 0) begin
        if(serialClockOut == LO) begin
          response[39:0] <= {response[38:0], miso};
          count <= count - 1;
        end
        
        // Toggle the serial clock and start countdown
        serialClockOut <= ~serialClockOut;
        clockCount <= CLOCK_REDUCE_AMT;
        state <= STATE_CLOCK_COUNTDOWN;
        
      end else begin
        if(responseLen == RESP_R7_LEN) begin
          state <= STATE_CHECK_R7_RESPONSE;
          returnState <= STATE_CHECK_R7_RESPONSE;
        end else begin
          state <= STATE_CHECK_R1_RESPONSE;
          returnState <= STATE_CHECK_R1_RESPONSE;        
        end
      end
            
    end
    
    // State 0x05 - Sets the return state to the error state if the response is incorrect
    STATE_CHECK_R1_RESPONSE: begin
      if(response[7:0] != expectedResp[7:0]) begin
        nextState <= errState;
      end
      state <= STATE_DESELECT;
      count <= DESELECT_COUNT;
      chipSelect <= HI;
    end
    
    // State 0x06 - Does the same thing as State 5, but checks bits 32-39 instead of 0-7 to fit
    //   the R7 response length
    STATE_CHECK_R7_RESPONSE: begin
      if(response[39:32] != expectedResp[7:0]) begin
        nextState <= errState;
      end
      state <= STATE_DESELECT;
      count <= DESELECT_COUNT;
      chipSelect <= HI;
    end
    
    // State 0x07 - Deselects the SD card before sending another command
    STATE_DESELECT: begin
      if(count > 0) begin
        if(serialClockOut == HI) begin
          count <= count - 1;
        end
        
        // Toggle the serial clock and start countdown
        serialClockOut <= ~serialClockOut;
        returnState <= STATE_DESELECT;
        clockCount <= CLOCK_REDUCE_AMT;
        state <= STATE_CLOCK_COUNTDOWN;
        
      end else begin
        state <= nextState;
      end
    end
    
    // State 0x08 - Set up data needed for transmitting CMD8
    STATE_READY_CMD8: begin
      command = {CMD_CMD8, ARG_CMD8, CRC_CMD8};
      state = STATE_SEND_CMD;
      nextState = STATE_READY_CMD55;
      errState = STATE_READY_CMD8;
      responseLen = RESP_R7_LEN;
      expectedResp = TOKEN_CMD0_RESP;
      count = CMD_LENGTH;
      mosiSrc = MUX_CMD_MSB;
      chipSelect <= LO;
    end
    
    // State 0x09 - Set up data needed for transmitting CMD55
    STATE_READY_CMD55: begin
      command = {CMD_CMD55, ARG_EMPTY, CRC_DUMMY};
      state = STATE_SEND_CMD;
      nextState = STATE_READY_CMD41;
      errState = STATE_READY_CMD55;
      responseLen = RESP_R1_LEN;
      expectedResp = TOKEN_CMD0_RESP;
      count = CMD_LENGTH;
      mosiSrc = MUX_CMD_MSB;
      chipSelect <= LO;
    end
    
    // State 0x0A - Set up data needed for transmitting CMD41
    STATE_READY_CMD41: begin
      command = {CMD_CMD41, ARG_EMPTY, CRC_DUMMY};
      state = STATE_SEND_CMD;
      nextState = STATE_FINISH_INIT;
      errState = STATE_READY_CMD55;
      responseLen = RESP_R1_LEN;
      expectedResp = TOKEN_CMD0_RESP;
      count = CMD_LENGTH;
      mosiSrc = MUX_CMD_MSB;
      chipSelect <= LO;
    end
    
    // State 0x0B - Finish up initialization, set SD interface's R1 to Ready.
    STATE_FINISH_INIT: begin
      if(updateStatus == HI) begin
        updateStatus = LO;
        state <= STATE_WAIT_FOR_HOST;
      end else begin
        status <= STATUS_READY;
        errState = STATE_WAIT_FOR_HOST;
        response = 0;
        blockMode = HI;
        updateStatus <= HI;
      end
    end
    
    // State 0x0C - Wait for host to give read/write block instruction
    STATE_WAIT_FOR_HOST: begin
      if(exec) begin
        
      end
    end
    
    // State 0x0D - Load command to read a single block from the SD card
    STATE_READY_CMD17: begin
      command = {CMD_CMD17, addr[31:0], CRC_DUMMY};
      state = STATE_SEND_CMD;
      nextState = STATE_AWAIT_DATA_TOKEN;
      errState = STATE_WAIT_FOR_HOST;
      responseLen = RESP_R1_LEN;
      expectedResp = TOKEN_R1_RESP;
      count = CMD_LENGTH;
      mosiSrc = MUX_CMD_MSB;
      chipSelect <= LO;
    end
    
    // State 0x0E - Load command to write a single block to the SD card
    STATE_READY_CMD24: begin
      command = {CMD_CMD24, addr[31:0], CRC_DUMMY};
      state = STATE_SEND_CMD;
      nextState = STATE_SEND_DATA_TOKEN;
      errState = STATE_WAIT_FOR_HOST;
      responseLen = RESP_R1_LEN;
      expectedResp = TOKEN_R1_RESP;
      count = CMD_LENGTH;
      mosiSrc = MUX_CMD_MSB;
      chipSelect <= LO;
    end
    
    // State 0x0F - Wait for the SD card to send the start data token
    STATE_AWAIT_DATA_TOKEN: begin
      if(serialClockOut == HI && miso == LO) begin
        
        response[39:0] <= {response[38:0], miso};
        state <= STATE_GET_DATA_TOKEN;
        count <= TOKEN_DATA_LEN - 1;
      end
    
      // Toggle the serial clock and start countdown
      serialClockOut <= ~serialClockOut;
      returnState <= STATE_AWAIT_RESPONSE;
      clockCount <= CLOCK_REDUCE_AMT;
      state <= STATE_CLOCK_COUNTDOWN;
    end
    
    // State 0x10 - Get the data token before a block read
    STATE_GET_DATA_TOKEN: begin
      if(count > 0) begin
        if(serialClockOut == HI) begin
          response[39:0] <= {response[38:0], miso};
          count <= count - 1;
        end
        
        // Toggle the serial clock and start countdown
        serialClockOut <= ~serialClockOut;
        returnState <= STATE_GET_DATA_TOKEN;
        clockCount <= CLOCK_REDUCE_AMT;
        state <= STATE_CLOCK_COUNTDOWN;
                
      end else begin
        state <= STATE_CHECK_DATA_TOKEN;
      end
    end
    
    // State 0x11 - Check the data token we've received
    STATE_CHECK_DATA_TOKEN: begin
      if(response[7:0] != TOKEN_DATA_START) begin
        state <= errState;
      end else begin
        state <= STATE_READY_BLOCK_READ;
      end
    end
    
    // State 0x12 - Load the data token so the card knows we're sending data
    STATE_READY_DATA_TOKEN: begin
      command = {TOKEN_DATA_START, 40'h0000000000};
      state = STATE_SEND_DATA_TOKEN;
      nextState = STATE_WAIT_FOR_HOST;
      errState = STATE_WAIT_FOR_HOST;
      count = TOKEN_DATA_LEN;
    end
    
    // State 0x13 - Send the data token before a block write
    STATE_SEND_DATA_TOKEN: begin
      if(count > 0) begin
      
        // Toggle the serial clock and start countdown
        serialClockOut <= ~serialClockOut;
        returnState <= STATE_SEND_DATA_TOKEN;
        clockCount <= CLOCK_REDUCE_AMT;
        state <= STATE_CLOCK_COUNTDOWN;
      
        if(serialClockOut == HI) begin
          command[47:0] <= {command[46:0], LO};
          count <= count - 1;
        end
        
      end else begin
        state <= STATE_READY_BLOCK_WRITE;
      end
    end
    
    // State 0x14 - Ready block read
    STATE_READY_BLOCK_READ: begin
      count = BLOCK_BIT_COUNT;
    end
    
    // State 0x15 - Ready block write
    STATE_READY_BLOCK_WRITE: begin
      count = BLOCK_BIT_COUNT;
    end
    
    // State 0x16 - Read 512 bytes from the SD card into block memory
    STATE_READ_BLOCK: begin                                 // TODO: This
      
    end
    
    // State 0x17 - Write 512 bytes to the SD card from block memory
    STATE_WRITE_BLOCK: begin                                // TODO: This
      
    end
    
    // State 0x18 - Close block read/write connections
    STATE_FINISH_BLOCK_IO: begin
      
    end
    
    // State - 0x1F - Decrement the main clock until it's alright to pulse the
    //  serial clock
    STATE_CLOCK_COUNTDOWN: begin
      if(clockCount == 0) begin
        state = returnState;
      end else begin
        clockCount = clockCount - 1;
      end
    end
    
    // Unknown State - Throw an error if we ever get here for some reason
    default: begin
      state = STATUS_ERR_INIT;
      nextState = STATUS_ERR_INIT;
      errState = STATUS_ERR_INIT;
      chipSelect = HI;
      response = 0;
      count = 0;
      command = 0;
      mosiSrc = MUX_CONST_HI;
      responseLen = 0;
      expectedResp = 0;
      blockMode = HI;
    end
    
    endcase
    
    mosiVal <= mosi;
    misoVal <= miso;
    
  end
  
endmodule
