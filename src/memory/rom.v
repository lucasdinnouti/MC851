module rom (
  input wire [31:0] address,
  input wire clock,
  output wire [31:0] output_data
);
  parameter SIZE_WORDS = 32;
  reg [31:0] data[SIZE_WORDS - 1:0];

  integer i = 0;
  initial begin
    // for (i = 0; i < SIZE_WORDS; i++) begin
    //   data[i] = 0;
    // end

    data[0] = 32'h00b00093;
  end

  assign output_data = data[address >> 2];
  always @(posedge clock) begin
    data[0] <= data[0];
  end
endmodule
