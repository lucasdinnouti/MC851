module l1 (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire should_write,
  input wire clock,
  input wire reset,
  output reg [31:0] output_data,
  output wire ready
);
  parameter CACHE_BLOCK_SIZE_BYTES = 4;
  parameter CACHE_LINES = 16;
  localparam INDEX_BITS = $clog2(CACHE_LINES);

  reg valid[CACHE_LINES - 1:0];
  reg [31 - INDEX_BITS:0] tags[CACHE_LINES - 1:0];
  reg [(CACHE_BLOCK_SIZE_BYTES << 3) - 1:0] lines[CACHE_LINES - 1:0];
  // reg waiting_main_memory = 0;

  wire [INDEX_BITS - 1:0] current_index;
  assign current_index = address[INDEX_BITS + 1:2];

  wire [29 - INDEX_BITS:0] current_tag;
  assign current_tag = address[31:INDEX_BITS + 2];

  // wire main_memory_ready;
  wire [31:0] main_memory_output;

  wire cache_hit;
  assign cache_hit = current_tag == tags[current_index] && valid[current_index];
  assign output_data = cache_hit ? lines[current_index] : main_memory_output;
  // assign ready = cache_hit && ~should_write ? 1 : main_memory_ready;
  assign ready = 1;
  integer i;

  memory #(256) memory(
    .address(address),
    .input_data(input_data),
    .should_write(should_write),
    .clock(clock),
    .reset(reset),
    .output_data(main_memory_output)
  );

  always @(posedge reset) begin
    for (i = 0; i < CACHE_LINES; i++) begin
      valid[i] = 32'h00000000;
      lines[i] = 32'h00000000;
    end
  end

  always @(negedge clock) begin
    // if (~reset) begin
      if (should_write) begin
        lines[current_index] <= input_data;
        tags[current_index] <= current_tag;
        valid[current_index] <= 1;
      end else if (~cache_hit) begin
        lines[current_index] <= main_memory_output;
        tags[current_index] <= current_tag;
        valid[current_index] <= 1;
      end
    end
  // end
endmodule
