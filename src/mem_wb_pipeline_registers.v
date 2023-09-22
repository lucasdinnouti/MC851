module mem_wb_pipeline_registers(
  input wire clock,
  input wire [31:0] mem_alu_result,
  input wire [31:0] mem_mem_data,
  input wire [4:0] mem_rd,
  input wire mem_reg_write,
  input wire mem_mem_read,
  output wire [31:0] wb_alu_result,
  output wire [31:0] wb_mem_data,
  output wire [4:0] wb_rd,
  output wire wb_reg_write,
  output wire wb_mem_read
);
  reg [31:0] alu_result;
  reg [31:0] mem_data;
  reg [4:0] rd;
  reg reg_write;
  reg mem_read;

  assign wb_alu_result = alu_result;
  assign wb_mem_data = mem_data;
  assign wb_rd = rd;
  assign wb_reg_write = reg_write;
  assign wb_mem_read = mem_read;

  always @(posedge clock) begin
    alu_result <= mem_alu_result;
    mem_data <= mem_mem_data;
    rd <= mem_rd;
    reg_write <= mem_reg_write;
    mem_read <= mem_mem_read;
  end
endmodule