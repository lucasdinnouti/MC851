module id_ex_pipeline_registers(
  input wire clock,
  input wire [31:0] id_rs1_data,
  input wire [31:0] id_rs2_data,
  input wire [4:0] id_alu_op,
  input wire [4:0] id_rd,
  input wire [4:0] id_rs1,
  input wire [4:0] id_rs2,
  input wire id_reg_write,
  input wire id_alu_use_rs2,
  input wire [31:0] id_immediate,
  input wire id_mem_write,
  input wire id_mem_read,
  input wire [2:0] id_mem_op_length,
  output wire [31:0] ex_rs1_data,
  output wire [31:0] ex_rs2_data,
  output wire [4:0] ex_alu_op,
  output wire [4:0] ex_rd,
  output wire [4:0] ex_rs1,
  output wire [4:0] ex_rs2,
  output wire ex_reg_write,
  output wire ex_alu_use_rs2,
  output wire [31:0] ex_immediate,
  output wire ex_mem_write,
  output wire ex_mem_read,
  output wire [2:0] ex_mem_op_length
);
  reg [31:0] rs1_data = 0;
  reg [31:0] rs2_data = 0;
  reg [4:0] alu_op = 0;
  reg [4:0] rd = 0;
  reg [4:0] rs1 = 0;
  reg [4:0] rs2 = 0;
  reg reg_write = 0;
  reg alu_use_rs2 = 0;
  reg [31:0] immediate = 0;
  reg mem_write = 0;
  reg mem_read = 0;
  reg [2:0] mem_op_length = 0;

  assign ex_rs1_data = rs1_data;
  assign ex_rs2_data = rs2_data;
  assign ex_alu_op = alu_op;
  assign ex_rd = rd;
  assign ex_rs1 = rs1;
  assign ex_rs2 = rs2;
  assign ex_reg_write = reg_write;
  assign ex_alu_use_rs2 = alu_use_rs2;
  assign ex_immediate = immediate;
  assign ex_mem_write = mem_write;
  assign ex_mem_read = mem_read;
  assign ex_mem_op_length = mem_op_length;

  always @(posedge clock) begin
    rs1_data <= id_rs1_data;
    rs2_data <= id_rs2_data;
    alu_op <= id_alu_op;
    rd <= id_rd;
    rs1 <= id_rs1;
    rs2 <= id_rs2;
    reg_write <= id_reg_write;
    alu_use_rs2 <= id_alu_use_rs2;
    immediate <= id_immediate;
    mem_write <= id_mem_write;
    mem_read <= id_mem_read;
    mem_op_length <= id_mem_op_length;
  end
endmodule