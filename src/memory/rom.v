module rom (
  input wire [31:0] address,
  input wire clock,
  output wire [31:0] output_data
);
  parameter SIZE_WORDS = 64;
  reg [31:0] data[SIZE_WORDS - 1:0];

  initial begin
    $readmemh({"resources/", `PROGRAM}, data);
  end

  assign output_data = data[address >> 2];
endmodule
