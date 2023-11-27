module decoder (
    input wire [31:0] instruction,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [31:0] immediate,
    output reg alu_use_rs2,
    output reg [4:0] alu_op,
    output reg reg_write,
    output reg mem_write,
    output reg mem_read,
    output reg [2:0] mem_op_length,
    output reg [3:0] branch_type,
    output reg [4:0] atomic_op,
    output wire is_compact
);
  wire [2:0] funct3;
  wire [3:0] funct4;
  wire [6:0] opcode;
  wire [4:0] compact_opcode;

  assign funct3 = instruction[14:12];
  assign funct4 = instruction[15:12];
  assign opcode = instruction[6:0];

  assign is_compact = (opcode[1:0] != 2'b11 && instruction != 32'b0);
  assign compact_opcode = {instruction[15:13], instruction[1:0]};

  always @* begin
    if (!is_compact) begin  // Decoding for normal instructions (32 bits)
      rs1 <= (opcode == `LUI_OP) ? 0 : instruction[19:15];
      rs2 <= instruction[24:20];
      rd <= instruction[11:7];
      reg_write <= (opcode == `LOAD_OP || opcode == `REG_OP || opcode == `IMM_OP || opcode == `ATOMIC_OP || opcode == `JALR_OP || opcode == `JAL_OP || opcode == `LUI_OP);
      mem_read <= (opcode == `LOAD_OP || opcode == `ATOMIC_OP);
      mem_write <= (opcode == `STORE_OP || opcode == `ATOMIC_OP);
      alu_use_rs2 <= (opcode == `REG_OP);
      mem_op_length <= funct3;

      if (opcode == `LOAD_OP || opcode == `STORE_OP || opcode == `ATOMIC_OP || opcode == `LUI_OP) begin
        // Load, store and atomic will add address with offset
        alu_op <= `ALU_ADD_OP;
      end else if (opcode == `IMM_OP && funct3 != 3'b101) begin
        // Immediate instructions except for SRLI and SRAI
        alu_op <= {2'b00, funct3};
      end else begin
        alu_op <= {instruction[25], instruction[30], funct3};
      end

      if (opcode == `IMM_OP && funct3 == 3'b101) begin
        // SRLI and SRAI shamt immediate
        immediate <= instruction[24:20];
      end else if (opcode == `STORE_OP) begin
        immediate <= $signed({instruction[31:25], instruction[11:7]});
      end else if (opcode == `BRANCH_OP) begin
        immediate <= $signed({instruction[31:31], instruction[7:7], instruction[30:25],
                              instruction[11:8], 1'b0});
      end else if (opcode == `ATOMIC_OP) begin
        immediate <= 0;
      end else if (opcode == `JAL_OP) begin
        immediate <= $signed({instruction[31:31], instruction[19:12], instruction[20:20],
                              instruction[30:21], 1'b0});
      end else if (opcode == `LUI_OP) begin
        immediate <= instruction[31:12] << 12;
      end else begin
        immediate <= $signed(instruction[31:20]);
      end

      if (opcode == `BRANCH_OP) begin
        branch_type <= {1'b0, funct3};
      end else if (opcode == `JAL_OP) begin
        branch_type <= `BRANCH_JAL;
      end else if (opcode == `JALR_OP) begin
        branch_type <= `BRANCH_JALR;
      end else begin
        branch_type <= `BRANCH_NONE;
      end

      if (opcode == `ATOMIC_OP) begin
        atomic_op <= instruction[31:27];
      end else begin
        atomic_op <= `ATOMIC_NO_OP;
      end
    end else begin  // Decoding for compact instructions (16 bits)
      if (compact_opcode == `ADDI_COMPACT_OP || compact_opcode == `SLLI_COMPACT_OP) begin
        rs1 <= instruction[11:7];
      end else if (compact_opcode == `LW_COMPACT_OP || compact_opcode == `SW_COMPACT_OP || compact_opcode == `BEQZ_COMPACT_OP || compact_opcode == `BNEZ_COMPACT_OP || compact_opcode == `ALU_OPS_COMPACT_OP) begin
        rs1 <= {2'b01, instruction[9:7]};
      end else if (compact_opcode == `LWSP_COMPACT_OP || compact_opcode == `SWSP_COMPACT_OP || compact_opcode == `ADDI_4SPN_COMPACT_OP) begin
        rs1 <= 2;  // sp
      end else if (compact_opcode == `ADDI_16SP_LUI_COMPACT_OP) begin
        rs1 <= (instruction[11:7] == 2) ? 2 : 0;
      end else if (compact_opcode == `JALR_ADD_COMPACT_OP) begin
        rs1 <= (instruction[12] == 0 && instruction[6:2] != 0) ? 0 : instruction[11:7];
      end else begin
        rs1 <= 0;
      end

      if (compact_opcode == `SW_COMPACT_OP || compact_opcode == `ALU_OPS_COMPACT_OP) begin
        rs2 <= {2'b01, instruction[4:2]};
      end else if (compact_opcode == `SWSP_COMPACT_OP || compact_opcode == `JALR_ADD_COMPACT_OP) begin
        rs2 <= instruction[6:2];
      end else begin
        rs2 <= 0;
      end

      if (compact_opcode == `ADDI_COMPACT_OP || compact_opcode == `LWSP_COMPACT_OP || compact_opcode == `LI_COMPACT_OP || compact_opcode == `SLLI_COMPACT_OP || compact_opcode == `ADDI_16SP_LUI_COMPACT_OP) begin
        rd <= instruction[11:7];
      end else if (compact_opcode == `LW_COMPACT_OP || compact_opcode == `ADDI_4SPN_COMPACT_OP) begin
        rd <= {2'b01, instruction[4:2]};
      end else if (compact_opcode == `JALR_ADD_COMPACT_OP) begin
        rd <= (instruction[6:2] == 0) ? instruction[12] : instruction[11:7];
      end else if (compact_opcode == `JAL_COMPACT_OP) begin
        rd <= 1;
      end else if (compact_opcode == `ALU_OPS_COMPACT_OP) begin
        rd <= {2'b01, instruction[9:7]};
      end else begin
        rd <= 0;
      end

      reg_write <= (compact_opcode == `ADDI_COMPACT_OP || compact_opcode == `LI_COMPACT_OP || compact_opcode == `LW_COMPACT_OP || compact_opcode == `LWSP_COMPACT_OP || compact_opcode == `ADDI_16SP_LUI_COMPACT_OP || compact_opcode == `J_COMPACT_OP || compact_opcode == `ADDI_4SPN_COMPACT_OP || compact_opcode == `JALR_ADD_COMPACT_OP || compact_opcode == `JAL_COMPACT_OP || compact_opcode == `ALU_OPS_COMPACT_OP || compact_opcode == `SLLI_COMPACT_OP);
      mem_read <= (compact_opcode == `LW_COMPACT_OP || compact_opcode == `LWSP_COMPACT_OP);
      mem_write <= (compact_opcode == `SW_COMPACT_OP || compact_opcode == `SWSP_COMPACT_OP);
      alu_use_rs2 <= (compact_opcode == `JALR_ADD_COMPACT_OP && instruction[6:2] != 0) || (compact_opcode == `ALU_OPS_COMPACT_OP && instruction[10] && instruction[11]);

      mem_op_length <= `MEM_WORD;

      if (compact_opcode == `ALU_OPS_COMPACT_OP) begin
        if (instruction[11:10] == 2'b11) begin
          if (instruction[6:5] == 2'b00) begin
            alu_op <= `ALU_SUB_OP;
          end else if (instruction[6:5] == 2'b01) begin
            alu_op <= `ALU_XOR_OP;
          end else if (instruction[6:5] == 2'b10) begin
            alu_op <= `ALU_OR_OP;
          end else begin
            alu_op <= `ALU_AND_OP;
          end
        end else begin
          if (instruction[11:10] == 2'b00) begin
            alu_op <= `ALU_SRL_OP;
          end else if (instruction[11:10] == 2'b01) begin
            alu_op <= `ALU_SRA_OP;
          end else begin
            alu_op <= `ALU_AND_OP;
          end
        end
      end else if (compact_opcode == `SLLI_COMPACT_OP) begin
        alu_op <= `ALU_SLL_OP;
      end else begin
        alu_op <= `ALU_ADD_OP;
      end

      if (compact_opcode == `ADDI_COMPACT_OP || compact_opcode == `LI_COMPACT_OP || compact_opcode == `ALU_OPS_COMPACT_OP) begin
        immediate <= $signed({instruction[12], instruction[6:2]});
      end else if (compact_opcode == `SLLI_COMPACT_OP) begin
        immediate <= {instruction[12], instruction[6:2]};
      end else if (compact_opcode == `LW_COMPACT_OP || compact_opcode == `SW_COMPACT_OP) begin
        immediate <= {instruction[5], instruction[12:10], instruction[6], 2'b00};
      end else if (compact_opcode == `LWSP_COMPACT_OP) begin
        immediate <= {instruction[3:2], instruction[12], instruction[6:4], 2'b00};
      end else if (compact_opcode == `SWSP_COMPACT_OP) begin
        immediate <= {instruction[8:7], instruction[12:9], 2'b00};
      end else if (compact_opcode == `ADDI_16SP_LUI_COMPACT_OP) begin
        immediate <= instruction[11:7] == 2 ?
            $signed({instruction[4:3], instruction[5], instruction[2], instruction[6], 4'b0000}) :
            $signed({instruction[12], instruction[6:2], 12'h0});
      end else if (compact_opcode == `J_COMPACT_OP || compact_opcode == `JAL_COMPACT_OP) begin
        immediate <= $signed(
            {
              instruction[12],
              instruction[8],
              instruction[10:9],
              instruction[6],
              instruction[7],
              instruction[2],
              instruction[11],
              instruction[5:3],
              1'b0
            }
        );
      end else if (compact_opcode == `ADDI_4SPN_COMPACT_OP) begin
        immediate <= {instruction[10:7], instruction[12:11], instruction[5], instruction[6], 2'b00};
      end else if (compact_opcode == `BEQZ_COMPACT_OP || compact_opcode == `BNEZ_COMPACT_OP) begin
        immediate <= {
          instruction[12],
          instruction[6:5],
          instruction[2],
          instruction[11:10],
          instruction[4:3],
          1'b0
        };
      end else begin
        immediate <= 0;
      end

      if (compact_opcode == `J_COMPACT_OP || compact_opcode == `JAL_COMPACT_OP) begin
        branch_type <= `BRANCH_JAL;
      end else if (compact_opcode == `JALR_ADD_COMPACT_OP) begin
        branch_type <= instruction[6:2] == 0 ? `BRANCH_JALR : `BRANCH_NONE;
      end else if (compact_opcode == `BEQZ_COMPACT_OP) begin
        branch_type <= `BRANCH_EQ;
      end else if (compact_opcode == `BNEZ_COMPACT_OP) begin
        branch_type <= `BRANCH_NE;
      end else begin
        branch_type <= `BRANCH_NONE;
      end

      atomic_op <= `ATOMIC_NO_OP;
    end
  end
endmodule
