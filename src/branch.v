module branch (
    inout wire [31:0] pc,
    input wire clock,
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
    input wire [31:0] immediate,
    input wire [3:0] branch_type,
    output wire should_branch
);
  reg [31:0] pc_reg = -4;
  reg should_branch_reg = 0;
  
  assign pc = pc_reg;
  assign should_branch = should_branch_reg;

  always @* begin
    case (branch_type)
      `BRANCH_EQ: should_branch_reg = (rs1_data == rs2_data);
      `BRANCH_NE: should_branch_reg = (rs1_data != rs2_data);
      `BRANCH_NONE: should_branch_reg = 0;
      `BRANCH_LT: should_branch_reg = ($signed(rs1_data) < $signed(rs2_data));
      `BRANCH_GE: should_branch_reg = ($signed(rs1_data) >= $signed(rs2_data));
      `BRANCH_LTU: should_branch_reg = (rs1_data < rs2_data);
      `BRANCH_GEU: should_branch_reg = (rs1_data >= rs2_data);
      `BRANCH_JAL: should_branch_reg = 1;
      `BRANCH_JALR: should_branch_reg = 1;
      default: should_branch_reg = 0;
    endcase
  end

  always @(posedge clock) begin
    if (should_branch_reg) begin
      // Subtract 4 because the current branch instruction is on the second stage
      // Add rs1 data if the instruction is a jalr
      pc_reg = pc_reg + immediate - 4 + (branch_type == `BRANCH_JALR ? rs1_data : 0);
    end else begin
      pc_reg = pc_reg + 4;
    end
  end
endmodule
