module branch (
    input wire [31:0] id_pc,
    input wire [31:0] ex_pc,
    input wire clock,
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
    input wire [31:0] immediate,
    input wire [3:0] branch_type,
    output reg [31:0] if_pc = 0,
    output reg should_branch = 0
);
  always @* begin
    case (branch_type)
      `BRANCH_EQ: should_branch <= (rs1_data == rs2_data);
      `BRANCH_NE: should_branch <= (rs1_data != rs2_data);
      `BRANCH_NONE: should_branch <= 0;
      `BRANCH_LT: should_branch <= ($signed(rs1_data) < $signed(rs2_data));
      `BRANCH_GE: should_branch <= ($signed(rs1_data) >= $signed(rs2_data));
      `BRANCH_LTU: should_branch <= (rs1_data < rs2_data);
      `BRANCH_GEU: should_branch <= (rs1_data >= rs2_data);
      `BRANCH_JAL: should_branch <= 1;
      `BRANCH_JALR: should_branch <= 1;
      default: should_branch <= 0;
    endcase
  end

  always @* begin
    if (should_branch) begin
      if (branch_type == `BRANCH_JALR) begin
        if_pc <= rs1_data + immediate - 4;
      end else begin
        if_pc <= ex_pc + immediate - 4;
      end
    end else begin
      if_pc <= id_pc + 4;
    end
  end
endmodule
