module flash_memory (
  input wire [31:0] pc,
  output wire [31:0] instruction,
  input wire clock,
  output reg flashClk = 0,
  input flashMiso,
  output reg flashMosi = 0,
  output reg flashCs = 1
);
  // reg [31:0] instructions[31:0];

  // integer i;
  // integer j;
  // initial begin
  //   for (i = 0; i < 16; i = i + 1) instructions[i] = 0;
  // end

  localparam STATE_INIT = 2'd0;
  localparam STATE_SEND = 2'd1;
  localparam STATE_READ_DATA = 2'd2;
  localparam STATE_DONE = 2'd3;

  reg [23:0] dataToSend = 0;
  reg [8:0] bitsToSend = 0;

  reg [32:0] counter = 0;
  reg [2:0] state = 0;
  reg [2:0] returnState = 0;
  reg commandSent = 0;

  // readAddress[31:6]
  // reg [23:0] readAddress = 0;
  reg [7:0] command = 8'h03;
  reg [7:0] currentByteOut = 0;
  reg [7:0] currentByteNum = 0;
  reg [511:0] dataIn = 0;

  reg dataReady = 0;

  // assign instruction = instructions[pc >> 2];
  // assign instruction = dataIn[(((pc >> 2) << 5) + 31)-:32];
  assign instruction[31:24] = dataIn[(((pc >> 2) << 5) + 7)-:8];
  assign instruction[23:16] = dataIn[(((pc >> 2) << 5) + 15)-:8];
  assign instruction[15:8] = dataIn[(((pc >> 2) << 5) + 23)-:8];
  assign instruction[7:0] = dataIn[(((pc >> 2) << 5) + 31)-:8];

  always @(posedge clock) begin
    case (state)
      STATE_INIT: begin
        counter <= 32'b0;
        currentByteNum <= 0;
        currentByteOut <= 0;

        flashCs <= 0;
        dataToSend[23-:8] <= command;
        bitsToSend <= 8;
        state <= STATE_SEND;
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
          if (bitsToSend == 0) begin
            if (commandSent == 0) begin
              // dataToSend <= readAddress;
              bitsToSend <= 24;
              currentByteNum <= 0;
              commandSent <= 1;
            end
            else begin
              state <= STATE_READ_DATA;
            end
          end
        end
      end

      STATE_READ_DATA: begin
        if (counter[0] == 1'd0) begin
          flashClk <= 0;
          counter <= counter + 1;
          if (counter[3:0] == 0 && counter > 0) begin
            dataIn[(currentByteNum << 3)+:8] <= currentByteOut;
            currentByteNum <= currentByteNum + 1;
            if (currentByteNum == 31) begin
              state <= STATE_DONE;
            end
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
      end

      default: dataReady <= 0;
    endcase
  end
endmodule
