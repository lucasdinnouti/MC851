
module peripherals (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire should_write,
  input wire clock,
  input wire [3:0] input_peripherals,
  output reg [3:0] output_peripherals = 0,
  output wire [31:0] output_data
);
  wire [2:0] index;
  assign index = address[2:0];
  assign output_data = { 31'h0, input_peripherals[index] };

  always @(negedge clock) begin
    if (should_write) begin
      output_peripherals[index] = input_data[0];
    end
  end

  // PERIPHERALS CONVENTION
  // input_peripherals[0] - analog port 25;
  // input_peripherals[1] - analog port 26;
  // input_peripherals[2] - button 1;
  // input_peripherals[3] - button 2;
  // output_peripherals[0] - analog port 27;
  // output_peripherals[1] - analog port 28;
  // output_peripherals[2] - led 1;
  // output_peripherals[3] - led 2;
endmodule
