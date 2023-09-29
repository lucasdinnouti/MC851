module memory_test (
  input wire clock,
  input wire btn,
  input wire [31:0] l1i_address,
  input wire [31:0] l1d_address,
  input wire [31:0] l1d_input_data,
  input wire l1d_mem_read,
  input wire l1d_mem_write,
  output wire [31:0] l1i_output_data,
  output wire [31:0] l1d_output_data,
  output wire l1i_hit,
  output wire l1d_hit,
  output wire l1i_ready,
  output wire l1d_ready
);
  wire [31:0] memory_controller_output_data;
  wire stall_l1i, stall_l1d;

  // reg [3:0] i = 0;
  // reg cpu_clock;

  // assign led[5] = ~i[2];
  // assign led[4:0] = ~output_data[4:0];

  memory_controller memory_controller (
    .l1i_address(l1i_address),
    .l1d_address(l1d_address),
    .l1d_input_data(l1d_input_data),
    .l1i_mem_read(~l1i_hit),
    .l1d_mem_write(l1d_mem_write),
    .l1d_mem_read(~l1d_hit && l1d_mem_read),
    .clock(clock),
    .output_data(memory_controller_output_data),
    .stall_l1i(stall_l1i),
    .stall_l1d(stall_l1d)
  );

  l1 l1i (
    .address(l1i_address),
    .input_data(0),
    .should_write(0),
    .memory_controller_output_data(memory_controller_output_data),
    .memory_controller_ready(~stall_l1i),
    .clock(clock),
    .output_data(l1i_output_data),
    .hit(l1i_hit),
    .ready(l1i_ready)
  );

  l1 l1d (
    .address(l1d_address),
    .input_data(l1d_input_data),
    .should_write(l1d_mem_write),
    .memory_controller_output_data(memory_controller_output_data),
    .memory_controller_ready(~stall_l1d),
    .clock(clock),
    .output_data(l1d_output_data),
    .hit(l1d_hit),
    .ready(l1d_ready)
  );

  // reg [23:0] x = 0;
  // always @(posedge clock) begin
  //   if (x == 0) begin
  //     i <= i + 1;
  //     cpu_clock <= 1;
  //   end else if (x[23] == 1) begin
  //     cpu_clock <= 0;
  //   end

  //   x <= x + 1;
  // end
endmodule
