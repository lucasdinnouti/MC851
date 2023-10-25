
module peripherals (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire should_write,
  input wire clock,
  input wire [3:0] input_peripherals,
  output wire [3:0] output_peripherals,
  output wire [31:0] output_data
);
  reg data[7:0];
  
  wire [2:0] index;
  assign index = address[2:0];
  assign output_data = 32'h00000000 || data[index];

  always @(negedge clock) begin
    if (should_write) begin
      data[index] <= input_data[31];
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

  always @(posedge clock) begin
    
    output_peripherals[0] = data[0];
    output_peripherals[1] = data[1];
    // output_peripherals[2] = ~data[2];
    // output_peripherals[3] = ~data[3];

    // debug - hardwires leds to sensors
    output_peripherals[2] = ~input_peripherals[0];
    output_peripherals[3] = ~input_peripherals[1];
  end

  always @(negedge clock) begin
    data[4] = input_peripherals[0];
    data[5] = input_peripherals[1];
    data[6] = input_peripherals[2];
    data[7] = input_peripherals[3];
  end

endmodule
