module branch (
    input wire [31:0] id_pc,
    input wire clock,
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
    input wire [31:0] immediate,
    input wire [3:0] branch_type,
    output reg [31:0] if_pc = 0,
    output wire should_branch
);
  reg should_branch_reg = 0;
  
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

  always @* begin
    if (should_branch_reg) begin
      if (branch_type == `BRANCH_JALR) begin
        if_pc = rs1_data + immediate;
      end else begin
        // Subtract 8 because the current branch instruction is on the third stage
        if_pc = (id_pc - 4) + immediate;
      end
    end else begin
      if_pc = id_pc + 4;
    end
  end
endmodule
