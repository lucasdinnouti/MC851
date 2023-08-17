`define assert_immediate_decode(name, expected_rd, expected_rs1, expected_immediate,
                                expected_alu_op) \
    `assert(rd, expected_rd, name, "rd"); \
    `assert(rs1, expected_rs1, name, "rs1"); \
    `assert(immediate, expected_immediate, name, "immediate"); \
    `assert(alu_source, 0, name, "alu_source"); \
    `assert(alu_op, expected_alu_op, name, "alu_op"); \
    `assert(should_write, 1, name, "should_write");

`timescale 1 ns / 10 ps

module decoder_tb;
  reg [31:0] instruction;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [31:0] immediate;
  wire alu_source;
  wire [3:0] alu_op;
  wire should_write;

  localparam PERIOD = 10;

  decoder under_test (
      .instruction(instruction),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .immediate(immediate),
      .alu_source(alu_source),
      .alu_op(alu_op),
      .should_write(should_write)
  );

  initial begin
    $dumpfile("decoder.vcd");
    $dumpvars(0, decoder_tb);
  end

  initial begin
    // sub x10, x11, x12
    instruction = 32'h40c58533;
    #PERIOD;
    `assert(rs1, 11, "sub rs1");
    `assert(rs2, 12, "sub rs1");
    `assert(rd, 10, "sub rd");
    `assert(alu_source, 1, "sub alu_source");
    `assert(alu_op, `ALU_SUB_OP, "sub alu_op");
    `assert(should_write, 1, "sub should_write");

    // addi x5, x6, 7
    instruction = 32'h00730293;
    #PERIOD;
    `assert_immediate_decode("addi", 5, 6, 7, `ALU_ADD_OP);

    // slti x20, x21, -100
    instruction = 32'hf9caaa13;
    #PERIOD;
    `assert_immediate_decode("slti", 20, 21, -100, `ALU_SLT_OP);

    // sltiu x15, x15, 0
    instruction = 32'h0007b793;
    #PERIOD;
    `assert_immediate_decode("sltiu", 15, 15, 0, `ALU_SLTU_OP);

    // xori x0, x0, 10
    instruction = 32'h00a04013;
    #PERIOD;
    `assert_immediate_decode("xori", 0, 0, 10, `ALU_XOR_OP);

    // ori x31, x31, -1024
    instruction = 32'hc00fef93;
    #PERIOD;
    `assert_immediate_decode("ori", 31, 31, -1024, `ALU_OR_OP);

    // andi x19, x20, 2047
    instruction = 32'h7ffa7993;
    #PERIOD;
    `assert_immediate_decode("andi", 19, 20, 2047, `ALU_AND_OP);

    // slli x1, x2, 30
    instruction = 32'h01e11093;
    #PERIOD;
    `assert_immediate_decode("slli", 1, 2, 30, `ALU_SLL_OP);

    // srli x3, x4, 1
    instruction = 32'h00125193;
    #PERIOD;
    `assert_immediate_decode("srli", 3, 4, 1, `ALU_SRL_OP);

    // srai x5, x6, 0
    instruction = 32'h40035293;
    #PERIOD;
    `assert_immediate_decode("srai", 5, 6, 0, `ALU_SRA_OP);
  end
endmodule
