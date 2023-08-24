module post_ex_pipeline_registers(
  input wire clock,
  input wire [31:0] ex_alu_result,
  input wire [4:0] ex_rd,
  input wire ex_reg_write,
  output wire [31:0] wb_alu_result,
  output wire [4:0] wb_rd,
  output wire wb_reg_write
);
  reg [31:0] alu_result = 0;
  reg [4:0] rd = 0;
  reg reg_write = 0;

  assign wb_alu_result = alu_result;
  assign wb_rd = rd;
  assign wb_reg_write = reg_write;

  always @(posedge clock) begin
    alu_result <= ex_alu_result;
    rd <= ex_rd;
    reg_write <= ex_reg_write;
  end
endmodule