module test_cpu (
    input wire [31:0] instruction,
    input wire clock
);

  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [31:0] immediate;
  wire alu_use_rs2;
  wire [3:0] alu_op;
  wire should_write;

  wire [31:0] rs1_data;
  wire [31:0] rs2_data;

  wire [31:0] alu_b;
  assign alu_b = alu_use_rs2 == 0 ? immediate : rs2_data;

  wire zero;
  wire [31:0] result;

  decoder decoder (
      .instruction(instruction),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .immediate(immediate),
      .alu_use_rs2(alu_use_rs2),
      .alu_op(alu_op),
      .should_write(should_write)
  );
  registers registers (
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .data(result),
      .should_write(should_write),
      .clock(clock),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data)
  );
  alu alu (
      .a(rs1_data),
      .b(alu_b),
      .op(alu_op),
      .zero(zero),
      .result(result)
  );

endmodule
