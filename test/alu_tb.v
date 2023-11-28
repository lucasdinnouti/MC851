`timescale 1 ns / 10 ps

`define assert_alu_result(name, expected_result) \
    `assert(result, expected_result, name, "result");

module alu_tb;
  reg [31:0] a, b;
  reg  [ 4:0] op;
  wire [31:0] result;
  reg clock = 0;

  localparam PERIOD = 10;

  alu under_test (
      .clock(clock),
      .a(a),
      .b(b),
      .op(op),
      .result(result)
  );

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);
  end

  integer i;
  initial begin
    a  = 10;
    b  = 10;
    op = `ALU_ADD_OP;
    #PERIOD;
    `assert_alu_result("add", 20);

    a  = 10;
    b  = 20;
    op = `ALU_SUB_OP;
    #PERIOD;
    `assert_alu_result("sub", -10);

    a  = 4'b0010;
    b  = 2;
    op = `ALU_SLL_OP;
    #PERIOD;
    `assert_alu_result("sll", 4'b1000);

    a  = 5'b11111;
    b  = 5'b01010;
    op = `ALU_XOR_OP;
    #PERIOD;
    `assert_alu_result("xor", 5'b10101);

    a  = 5'b01010;
    b  = 5'b10101;
    op = `ALU_OR_OP;
    #PERIOD;
    `assert_alu_result("or", 5'b11111);

    a  = 5'b01010;
    b  = 5'b10101;
    op = `ALU_AND_OP;
    #PERIOD;
    `assert_alu_result("and", 0);

    a  = 32'hfffffff0;
    b  = 4;
    op = `ALU_SRL_OP;
    #PERIOD;
    `assert_alu_result("srl", 32'h0fffffff);

    a  = 32'hfffffff0;
    b  = 4;
    op = `ALU_SRA_OP;
    #PERIOD;
    `assert_alu_result("sra", 32'hffffffff);

    a  = 20;
    b  = 30;
    op = `ALU_SLT_OP;
    #PERIOD;
    `assert_alu_result("slt 1", 1);

    a  = 30;
    b  = 20;
    op = `ALU_SLT_OP;
    #PERIOD;
    `assert_alu_result("slt 2", 0);

    a  = -30;
    b  = 20;
    op = `ALU_SLTU_OP;
    #PERIOD;
    `assert_alu_result("sltu 1", 0);

    a  = 20;
    b  = 30;
    op = `ALU_SLTU_OP;
    #PERIOD;
    `assert_alu_result("sltu 2", 1);

    a  = 10;
    b  = 7;
    op = `ALU_MUL_OP;
    #PERIOD;
    `assert_alu_result("mul", 70);

    a  = 1000000000;
    b  = 1000000000;
    op = `ALU_MULH_OP;
    #PERIOD;
    `assert_alu_result("mulh", 232830643);

    a  = -30;
    b  = 3;
    op = `ALU_DIV_OP;
    for (i = 0; i < 69; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
    end
    `assert_alu_result("div", -10);

    a  = 31;
    b  = 3;
    op = `ALU_DIVU_OP;
    for (i = 0; i < 68; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
    end
    `assert_alu_result("divu", 10);

    a  = 31;
    b  = 3;
    op = `ALU_REM_OP;
    for (i = 0; i < 68; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
    end
    `assert_alu_result("rem", 1);
  end
endmodule
