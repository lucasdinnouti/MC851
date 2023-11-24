module ram (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire should_write,
  input wire clock,
  output wire [31:0] output_data
);
  parameter SIZE_WORDS = 64;
  reg [31:0] data[SIZE_WORDS - 1:0];

  integer i;
  initial begin
    for (i = 0; i < SIZE_WORDS; i = i + 1) begin
      data[i] = 0;
    end
  end

  wire [29:0] index;
  assign index = address >> 2;
  assign output_data = data[index];

  always @(negedge clock) begin
    if (should_write) begin
      data[index] <= input_data;
    end
  end
endmodule
