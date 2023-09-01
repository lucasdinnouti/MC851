module branch (
    inout wire [31:0] pc,
    input wire clock,
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
    input wire [31:0] immediate,
    input wire [2:0] branch_type
);
  reg [31:0] pc_reg;
  reg should_branch;
  assign pc = pc_reg;
  initial begin
    pc_reg = -4;
  end
  always @(posedge clock) begin
    case (branch_type)
      `BRANCH_EQ: should_branch = (rs1_data == rs2_data);
      `BRANCH_NE: should_branch = (rs1_data != rs2_data);
      `BRANCH_NONE: should_branch = 0;
      `BRANCH_LT: should_branch = ($signed(rs1_data) < $signed(rs2_data));
      `BRANCH_GE: should_branch = ($signed(rs1_data) >= $signed(rs2_data));
      `BRANCH_LTU: should_branch = (rs1_data < rs2_data);
      `BRANCH_GEU: should_branch = (rs1_data >= rs2_data);
      default: should_branch = 0;
    endcase

    if (should_branch) begin
      pc_reg = pc_reg + immediate;
    end else begin
      pc_reg = pc_reg + 4;
    end
  end
endmodule
