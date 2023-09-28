module memory (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire should_write,
  input wire clock,
  output reg [31:0] output_data
  // output wire ready
);
  integer i;
  parameter SIZE_WORDS = 256;
  reg [31:0] data[SIZE_WORDS - 1:0];

  wire [29:0] index;
  assign index = address >> 2;

  always @(posedge clock) begin
    output_data <= data[index];
    // ready <= 1;
  end

  always @(negedge clock) begin
    if (should_write) begin
      data[index] <= input_data;
    end

    // ready <= 0;
  end
endmodule
