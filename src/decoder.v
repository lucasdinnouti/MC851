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
    output reg [2:0] branch_type
);

  wire [2:0] funct3;
  assign funct3 = instruction[14:12];

  wire [6:0] opcode;
  assign opcode = instruction[6:0];

  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd = instruction[11:7];

  assign mem_op_length = funct3;
  assign reg_write = (opcode == `LOAD_OP || opcode == `REG_OP || opcode == `IMM_OP);
  assign mem_read = (opcode == `LOAD_OP);
  assign mem_write = (opcode == `STORE_OP);
  assign alu_use_rs2 = (opcode == `REG_OP);

  always @* begin
    if (opcode == `LOAD_OP || opcode == `STORE_OP) begin
      // Load and store will add address with offset
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
    end else begin
      immediate = $signed(instruction[31:20]);
    end

    if (opcode == `BRANCH_OP) begin
      branch_type = funct3;
    end else begin
      branch_type = `BRANCH_NONE;
    end
  end
endmodule
