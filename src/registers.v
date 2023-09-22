module registers (
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] data,
    input wire reg_write,
    input wire clock,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,
    output wire [4:0] led
);
  reg [31:0] registers[31:0];

  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) registers[i] = 32'd0;
  end

  assign rs1_data = registers[rs1];
  assign rs2_data = registers[rs2];
  assign led[4:0] = ~registers[1][4:0];

  always @(negedge clock) begin
<<<<<<< Updated upstream
    // led[4:0] <= ~registers[1][4:0];
=======
>>>>>>> Stashed changes
    if (reg_write) begin
      registers[rd] <= data;
    end
  end
endmodule
