`define MEM_ROM 1'b0

module memory_controller (
  input wire [31:0] l1i_address,
  input wire [31:0] l1d_address,
  input wire [31:0] l1d_input_data,
  input wire l1d_mem_write,
  input wire l1d_mem_read,
  input wire clock,
  output wire [31:0] l1i_output_data,
  output wire [31:0] l1d_output_data,
  output wire stall_l1i,
  output wire stall_l1d
);
  assign stall_l1d = 0;
  assign stall_l1i = l1d_mem_read || l1d_mem_write;

  ram ram(
    .address(l1d_address),
    .input_data(l1d_input_data),
    .should_write(l1d_mem_write),
    .clock(clock),
    .output_data(l1d_output_data)
  );

  rom rom(
    .address(l1i_address),
    .clock(clock),
    .output_data(l1i_output_data)
  );
endmodule
