module decoder (
    input wire [31:0] instruction,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,
    output reg [31:0] immediate,
    output wire alu_use_rs2,
    output reg [4:0] alu_op,
    output wire reg_write,
    output wire mem_write,
    output wire mem_read,
    output wire [2:0] mem_op_length,
    output reg [3:0] branch_type,
    output reg [4:0] atomic_op
);

  wire [2:0] funct3;
  assign funct3 = instruction[14:12];

  wire [6:0] opcode;
  assign opcode = instruction[6:0];

  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd = instruction[11:7];

  assign mem_op_length = funct3;
  assign reg_write = (opcode == `LOAD_OP || opcode == `REG_OP || opcode == `IMM_OP || opcode == `ATOMIC_OP || opcode == `JALR_OP || opcode == `JAL_OP);
  assign mem_read = (opcode == `LOAD_OP || opcode == `ATOMIC_OP);
  assign mem_write = (opcode == `STORE_OP || opcode == `ATOMIC_OP);
  assign alu_use_rs2 = (opcode == `REG_OP);

  always @* begin
    if (opcode == `LOAD_OP || opcode == `STORE_OP || opcode == `ATOMIC_OP) begin
      // Load, store and atomic will add address with offset
      alu_op = `ALU_ADD_OP;
    end else if (opcode == `IMM_OP && funct3 != 3'b101) begin
      // Immediate instructions except for SRLI and SRAI
      alu_op = {2'b00, funct3};
    end else begin
      alu_op = {instruction[25], instruction[30], funct3};
    end

    if (opcode == `IMM_OP && funct3 == 3'b101) begin
      // SRLI and SRAI shamt immediate
      immediate = instruction[24:20];
    end else if (opcode == `STORE_OP) begin
      immediate = $signed({instruction[31:25], instruction[11:7]});
    end else if (opcode == `BRANCH_OP) begin
      immediate = $signed({instruction[31:31], instruction[7:7], instruction[30:25],
                           instruction[11:8], 1'b0});
    end else if (opcode == `ATOMIC_OP) begin
      immediate = 0;
    end else if (opcode == `JAL_OP) begin
      immediate = $signed({instruction[31:31], instruction[19:12], instruction[20:20],
                           instruction[30:21], 1'b0});
    end else begin
      immediate = $signed(instruction[31:20]);
    end

    if (opcode == `BRANCH_OP) begin
      branch_type = {1'b0, funct3};
    end else if (opcode == `JAL_OP) begin
      branch_type = `BRANCH_JAL;
    end else if (opcode == `JALR_OP) begin
      branch_type = `BRANCH_JALR;
    end else begin
      branch_type = `BRANCH_NONE;
    end

    if (opcode == `ATOMIC_OP) begin
      atomic_op = instruction[31:27];
    end else begin
      atomic_op = `ATOMIC_NO_OP;
    end
  end
endmodule
