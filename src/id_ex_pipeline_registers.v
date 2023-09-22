module id_ex_pipeline_registers(
  input wire clock,
  input wire [31:0] id_a,
  input wire [31:0] id_b,
  input wire [3:0] id_op,
  input wire [4:0] id_rd,
  input wire [4:0] id_rs1,
  input wire [4:0] id_rs2,
  input wire id_reg_write,
  input wire id_alu_use_rs2,
  output wire [31:0] ex_a,
  output wire [31:0] ex_b,
  output wire [3:0] ex_op,
  output wire [4:0] ex_rd,
  output wire [4:0] ex_rs1,
  output wire [4:0] ex_rs2,
  output wire ex_reg_write,
  output wire ex_alu_use_rs2
);
  reg [31:0] a = 0;
  reg [31:0] b = 0;
  reg [3:0] op = 0;
  reg [4:0] rd = 0;
  reg [4:0] rs1 = 0;
  reg [4:0] rs2 = 0;
  reg reg_write = 0;
  reg alu_use_rs2 = 0;

  assign ex_a = a;
  assign ex_b = b;
  assign ex_op = op;
  assign ex_rd = rd;
  assign ex_rs1 = rs1;
  assign ex_rs2 = rs2;
  assign ex_reg_write = reg_write;
  assign ex_alu_use_rs2 = alu_use_rs2;

  always @(posedge clock) begin
    a <= id_a;
    b <= id_b;
    op <= id_op;
    rd <= id_rd;
    rs1 <= id_rs1;
    rs2 <= id_rs2;
    reg_write <= id_reg_write;
    alu_use_rs2 <= alu_use_rs2;
  end
endmodule