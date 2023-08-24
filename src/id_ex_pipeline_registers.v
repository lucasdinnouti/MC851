module id_ex_pipeline_registers(
  input wire clock,
  input wire [31:0] id_a,
  input wire [31:0] id_b,
  input wire [3:0] id_op,
  input wire [4:0] id_rd,
  input wire id_reg_write,
  output wire [31:0] ex_a,
  output wire [31:0] ex_b,
  output wire [3:0] ex_op,
  output wire [4:0] ex_rd,
  output wire ex_reg_write,
);
  reg [31:0] a = 0;
  reg [31:0] b = 0;
  reg [3:0] op = 0;
  reg [4:0] rd = 0;
  reg reg_write = 0;

  assign ex_a = a;
  assign ex_b = b;
  assign ex_op = op;
  assign ex_rd = rd;
  assign ex_reg_write = reg_write;

  always @(posedge clock) begin
    a <= id_a;
    b <= id_b;
    op <= id_op;
    rd <= id_rd;
    reg_write <= id_reg_write;
  end
endmodule