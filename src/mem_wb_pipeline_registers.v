module mem_wb_pipeline_registers (
    input wire clock,
    input wire [31:0] mem_result,
    input wire [31:0] mem_mem_data,
    input wire [4:0] mem_rd,
    input wire mem_reg_write,
    input wire mem_mem_read,
    input wire reset,
    output wire [31:0] wb_result,
    output wire [31:0] wb_mem_data,
    output wire [4:0] wb_rd,
    output wire wb_reg_write,
    output wire wb_mem_read
);
  reg [31:0] result = 0;
  reg [31:0] mem_data = 0;
  reg [4:0] rd = 0;
  reg reg_write = 0;
  reg mem_read = 0;

  assign wb_result = result;
  assign wb_mem_data = mem_data;
  assign wb_rd = rd;
  assign wb_reg_write = reg_write;
  assign wb_mem_read = mem_read;

  always @(posedge clock) begin
    if (reset) begin
      result <= 0;
      mem_data <= 0;
      rd <= 0;
      reg_write <= 0;
      mem_read <= 0;
    end else begin
      result <= mem_result;
      mem_data <= mem_mem_data;
      rd <= mem_rd;
      reg_write <= mem_reg_write;
      mem_read <= mem_mem_read;
    end
  end
endmodule
