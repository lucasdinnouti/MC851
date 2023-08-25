`include "src/constants.v"
`include "src/branch.v"
`include "test/mock_memory.v"
`include "src/registers.v"
`include "src/decoder.v"
`include "src/alu.v"

module mock_cpu (
    input wire clock
);

  wire [31:0] pc;
  wire [31:0] instruction;

  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [31:0] immediate;
  wire alu_use_rs2;
  wire [3:0] alu_op;
  wire reg_write;
  wire mem_write;
  wire mem_read;
  wire [2:0] mem_op_length;

  wire [31:0] rs1_data;
  wire [31:0] rs2_data;

  wire [31:0] alu_b;
  assign alu_b = alu_use_rs2 == 0 ? immediate : rs2_data;

  wire zero;
  wire [31:0] result;

  branch branch (
      .pc(pc),
      .clock(clock)
  );

  memory instruction_memory (
      .address(pc >> 2),
      .input_data(0),
      .mem_write(1'b0),
      .mem_read(1'b1),
      .mem_type(`MEM_ROM),
      .clock(clock),
      .output_data(instruction)
  );

  decoder decoder (
      .instruction(instruction),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .immediate(immediate),
      .alu_use_rs2(alu_use_rs2),
      .alu_op(alu_op),
      .reg_write(reg_write),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .mem_op_length(mem_op_length)
  );

  registers registers (
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .data(result),
      .reg_write(reg_write),
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
