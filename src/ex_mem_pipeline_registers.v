module ex_mem_pipeline_registers(
  input wire clock,
  input wire [31:0] ex_alu_result,
  input wire [31:0] ex_rs2_data,
  input wire [4:0] ex_rd,
  input wire ex_reg_write,
  input wire ex_mem_write,
  input wire ex_mem_read,
  input wire [2:0] ex_mem_op_length,
  output wire [31:0] mem_alu_result,
  output wire [31:0] mem_rs2_data,
  output wire [4:0] mem_rd,
  output wire mem_reg_write,
  output wire mem_mem_write,
  output wire mem_mem_read,
  output wire [2:0] mem_mem_op_length
);
  reg [31:0] alu_result = 0;
  reg [31:0] rs2_data = 0;
  reg [4:0] rd = 0;
  reg reg_write = 0;
  reg mem_write = 0;
  reg mem_read = 0;
  reg [2:0] mem_op_length = 0;

  assign mem_alu_result = alu_result;
  assign mem_rs2_data = rs2_data;
  assign mem_rd = rd;
  assign mem_reg_write = reg_write;
  assign mem_mem_write = mem_write;
  assign mem_mem_read = mem_read;
  assign mem_mem_op_length = mem_op_length;

  always @(posedge clock) begin
    alu_result <= ex_alu_result;
    rs2_data <= ex_rs2_data;
    rd <= ex_rd;
    reg_write <= ex_reg_write;
    mem_write <= ex_mem_write;
    mem_read <= ex_mem_read;
    mem_op_length <= ex_mem_op_length;
  end
endmodule