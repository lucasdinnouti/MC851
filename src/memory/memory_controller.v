module memory_controller (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire mem_write,
  input wire mem_type,
  input wire clock,
  input wire reset,
  output reg [31:0] output_data,
  output wire should_stall
);
  wire is_l1_ready;
  wire should_write;

  assign should_stall = ~is_l1_ready;
  assign should_write = mem_type != `MEM_ROM && mem_write;

  l1 #(4, 32) l1(
    .address(address),
    .input_data(input_data),
    .should_write(should_write),
    .clock(clock),
    .reset(reset),
    .output_data(main_memory_output),
    .ready(is_l1_ready)
  );
endmodule
