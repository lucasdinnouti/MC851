module l1 (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire should_write,
  input wire clock,
  input wire [31:0] memory_controller_output_data,
  input wire memory_controller_ready,
  output wire [31:0] output_data,
  output wire hit,
  output wire ready
);
  parameter CACHE_BLOCK_SIZE_BYTES = 4;
  parameter CACHE_LINES = 16;
  localparam INDEX_BITS = $clog2(CACHE_LINES);

  reg valid[CACHE_LINES - 1:0];
  reg [29 - INDEX_BITS:0] tags[CACHE_LINES - 1:0];
  reg [(CACHE_BLOCK_SIZE_BYTES << 3) - 1:0] lines[CACHE_LINES - 1:0];

  reg [INDEX_BITS - 1:0] current_index = 0;
  // assign current_index = address[INDEX_BITS + 1:2];

  reg [29 - INDEX_BITS:0] current_tag = 0;
  // assign current_tag = address[31:INDEX_BITS + 2];

  reg cache_hit = 0;
  // assign cache_hit = current_tag == tags[current_index] && valid[current_index];
  assign output_data = cache_hit ? lines[current_index] : memory_controller_output_data;
  assign ready = cache_hit && ~should_write ? 1 : memory_controller_ready;
  assign hit = cache_hit;

  integer i;
  initial begin
    for (i = 0; i < CACHE_LINES; i++) begin
      valid[i] <= 0;
      tags[i] <= 0;
      lines[i] <= 0;
    end
  end

  always @(posedge clock) begin
    current_index = address[INDEX_BITS + 1:2];
    current_tag = address[31:INDEX_BITS + 2];
    cache_hit = current_tag == tags[current_index] && valid[current_index];
  end

  always @(negedge clock) begin
    // valid[current_index] <= should_write || (~cache_hit && memory_controller_ready);

    if (should_write) begin
      lines[current_index] <= input_data;
      tags[current_index] <= current_tag;
      valid[current_index] <= 1;
    end else if (~cache_hit) begin
      lines[current_index] <= memory_controller_output_data;
      tags[current_index] <= current_tag;
      valid[current_index] <= memory_controller_ready;
    end
  end
endmodule
