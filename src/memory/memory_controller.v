module memory_controller (
  input wire [31:0] address,
  input wire [31:0] input_data,
  input wire mem_write,
  input wire mem_type,
  input wire clock,
  output reg [31:0] output_data,
  output wire should_stall
);
  always @(posedge clock) begin
    output_data <= data[address];
  end

  always @(negedge clock) begin
    if (mem_write && mem_type == `MEM_RAM) begin
      data[address] <= input_data;
    end
  end
endmodule
