module forwarding (
    input wire [31:0] ex_rs1_data,
    input wire [31:0] ex_rs2_data,
    input wire [31:0] ex_immediate,
    input wire [4:0] ex_rs1,
    input wire [4:0] ex_rs2,
    input wire ex_alu_use_rs2,
    input wire mem_reg_write,
    input wire mem_mem_read,
    input wire [4:0] mem_rd,
    input wire [31:0] mem_alu_result,
    input wire [31:0] mem_mem_data,
    input wire [4:0] wb_rd,
    input wire [31:0] wb_rd_data,
    input wire wb_reg_write,
    output reg [31:0] alu_a,
    output reg [31:0] alu_b
);
  wire should_bypass_wb_a;
  wire should_bypass_wb_b;
  wire should_bypass_mem_a;
  wire should_bypass_mem_b;
  wire should_bypass_mem_read_a;
  wire should_bypass_mem_read_b;

  assign should_bypass_wb_a = wb_reg_write && (wb_rd == ex_rs1);
  assign should_bypass_wb_b = wb_reg_write && (wb_rd == ex_rs2);
  assign should_bypass_mem_a = mem_reg_write && (mem_rd == ex_rs1) && !mem_mem_read;
  assign should_bypass_mem_b = mem_reg_write && (mem_rd == ex_rs2) && !mem_mem_read;
  assign should_bypass_mem_read_a = mem_reg_write && (mem_rd == ex_rs1) && mem_mem_read;
  assign should_bypass_mem_read_b = mem_reg_write && (mem_rd == ex_rs2) && mem_mem_read;

  always @* begin
    if (should_bypass_mem_a) begin
        alu_a = mem_alu_result;
    end else if (should_bypass_mem_read_a) begin
        alu_a = mem_mem_data;
    end else if (should_bypass_wb_a) begin
        alu_a = wb_rd_data;
    end else begin
        alu_a = ex_rs1_data;
    end

    if (ex_alu_use_rs2 == 0) begin
        alu_b = ex_immediate;
    end else if (should_bypass_mem_b) begin
        alu_b = mem_alu_result;
    end else if (should_bypass_mem_read_b) begin
        alu_b = mem_mem_data;
    end else if (should_bypass_wb_b) begin
        alu_b = wb_rd_data;
    end else begin
        alu_b = ex_rs2_data;
    end
  end
endmodule