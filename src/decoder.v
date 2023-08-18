module decoder (
    input wire [31:0] instruction,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,
    output reg [31:0] immediate,
    output reg alu_use_rs2,
    output reg [3:0] alu_op,
    output reg reg_write,
    output reg mem_write,
    output reg mem_read,
    output wire [2:0] mem_op_length
);

  wire [2:0] funct3;
  assign funct3 = instruction[14:12];

  wire [6:0] opcode;
  assign opcode = instruction[6:0];

  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd = instruction[11:7];

  assign mem_op_length = funct3;

  always @* begin
    if (opcode == `LOAD_OP || opcode == `STORE_OP) begin
      // Load and store will add address with offset
      alu_op = `ALU_ADD_OP;
    end else if (opcode == `IMM_OP && funct3 != 3'b101) begin
      // Immediate instructions except for SRLI and SRAI
      alu_op = {1'b0, funct3};
    end else begin
      alu_op = {instruction[30], funct3};
    end

    if (opcode == `IMM_OP && funct3 == 3'b101) begin
      // SRLI and SRAI shamt immediate
      immediate = instruction[24:20];
    end else if (opcode == `STORE_OP) begin
      immediate = $signed({instruction[31:25], instruction[11:7]});
    end else begin
      immediate = $signed(instruction[31:20]);
    end

    if (opcode == `LOAD_OP || opcode == `REG_OP || opcode == `IMM_OP) begin
      reg_write = 1;
    end else begin
      reg_write = 0;
    end

    if (opcode == `LOAD_OP) begin
      mem_read = 1;
    end else begin
      mem_read = 0;
    end

    if (opcode == `STORE_OP) begin
      mem_write = 1;
    end else begin
      mem_write = 0;
    end

    if (opcode == `REG_OP) begin
      alu_use_rs2 = 1;
    end else begin
      alu_use_rs2 = 0;
    end

  end

endmodule
