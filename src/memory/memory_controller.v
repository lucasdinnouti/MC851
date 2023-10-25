module memory_controller (
  input wire [31:0] l1i_address,
  input wire [31:0] l1d_address,
  input wire [31:0] l1d_input_data,
  input wire l1i_mem_read,
  input wire l1d_mem_write,
  input wire l1d_mem_read,
  input wire clock,
  input wire [3:0] input_peripherals,
  output wire [3:0] output_peripherals,
  output wire [31:0] output_data,
  output wire stall_l1i,
  output wire stall_l1d
);
  parameter ROM_SIZE = 32;
  parameter RAM_SIZE = 32;

  assign stall_l1d = 0;
  assign stall_l1i = (l1d_mem_read || l1d_mem_write) && l1i_mem_read;

  wire per_out;
  wire per_in;
  wire [31:0] ram_output;
  wire [31:0] rom_output;
  wire [31:0] per_output;

  wire peripheral_op;
  assign peripheral_op = l1d_address[31];

  assign output_data = peripheral_op ? per_output : ((l1d_mem_read || l1d_mem_write) ? ram_output : rom_output);

  rom #(ROM_SIZE) rom(
    .address(l1i_address),
    .clock(clock),
    .output_data(rom_output)
  );

  ram #(RAM_SIZE) ram(
    .address(l1d_address - ROM_SIZE << 2),
    .input_data(l1d_input_data),
    .should_write((~peripheral_op && l1d_mem_write)),
    .clock(clock),
    .output_data(ram_output)
  );

  peripherals peripherals(
    .address(l1d_address - ROM_SIZE << 2),
    .input_data(l1d_input_data),
    .should_write((peripheral_op && l1d_mem_write)),
    .clock(clock),
    .input_peripherals(input_peripherals),
    .output_peripherals(output_peripherals),
    .output_data(per_output)
  );
endmodule
