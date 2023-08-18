module instruction_memory (
  input wire [31:0] pc,
  output wire [31:0] instruction,
  input wire clock,
  output reg flashClk = 0,
  input flashMiso,
  output reg flashMosi = 0,
  output reg flashCs = 1,
  output reg [5:0] led
);
  reg [31:0] instructions[INSTRUCTION_MEMORY_SIZE - 1:0];
  integer i;
  initial begin
    for (i = 0; i < 8; i = i + 1) instructions[i] = 32'b0;
  end

  localparam STATE_INIT = 8'd0;
  localparam STATE_SEND = 8'd1;
  localparam STATE_LOAD_ADDRESS_TO_SEND = 8'd2;
  localparam STATE_READ_DATA = 8'd3;
  localparam STATE_DONE = 8'd4;

  reg [23:0] dataToSend = 0;
  reg [8:0] bitsToSend = 0;

  reg [32:0] counter = 0;
  reg [2:0] state = 0;
  reg [2:0] returnState = 0;

  // readAddress[31:6]
  reg [23:0] readAddress = 0;
  reg [7:0] command = 8'h03;
  reg [7:0] currentByteOut = 0;
  reg [7:0] currentByteNum = 0;
  reg [255:0] dataIn = 0;
  reg [255:0] dataInBuffer = 0;

  reg dataReady = 0;

  always @(posedge clock) begin
    instruction <= instructions[pc];

    case (state)
      STATE_INIT: begin
        counter <= 32'b0;
        currentByteNum <= 0;
        currentByteOut <= 0;

        flashCs <= 0;
        dataToSend[23-:8] <= command;
        bitsToSend <= 8;
        state <= STATE_SEND;
        returnState <= STATE_LOAD_ADDRESS_TO_SEND;
      end

      STATE_SEND: begin
        if (counter == 32'd0) begin
          flashClk <= 0;
          flashMosi <= dataToSend[23];
          dataToSend <= {dataToSend[22:0],1'b0};
          bitsToSend <= bitsToSend - 1;
          counter <= 1;
        end
        else begin
          counter <= 32'd0;
          flashClk <= 1;
          if (bitsToSend == 0)
              state <= returnState;
        end
      end

      STATE_LOAD_ADDRESS_TO_SEND: begin
        dataToSend <= readAddress;
        bitsToSend <= 24;
        state <= STATE_SEND;
        returnState <= STATE_READ_DATA;
        currentByteNum <= 0;
      end

      STATE_READ_DATA: begin
        if (counter[0] == 1'd0) begin
          flashClk <= 0;
          counter <= counter + 1;
          if (counter[3:0] == 0 && counter > 0) begin
            dataIn[(currentByteNum << 3)+:8] <= currentByteOut;
            currentByteNum <= currentByteNum + 1;
            if (currentByteNum == 31)
              state <= STATE_DONE;
          end
        end
        else begin
          flashClk <= 1;
          currentByteOut <= {currentByteOut[6:0], flashMiso};
          counter <= counter + 1;
        end
      end

      STATE_DONE: begin
        dataReady <= 1;
        flashCs <= 1;
        dataInBuffer <= dataIn;
        
        for (i = 0; i < 8; i = i + 1) begin
          instructions[i][31:0] <= dataInBuffer[(i << 5)+:32];
        end

        led[5:0] <= ~instructions[0][5:0];
      end
    endcase
  end
endmodule
