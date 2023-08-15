`timescale 1 ns/10 ps

module alu_tb;
    reg [31:0] a, b;
    reg [3:0] op;
    wire zero;
    wire [31:0] result;

    localparam PERIOD = 10;

    alu under_test(.a(a), .b(b), .op(op), .zero(zero), .result(result));
    
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
    end

    initial begin
        a = 10;
        b = 10;
        op = `ALU_SUM_OP;
        #PERIOD;
        `assert(result, 20, "sum result");
        `assert(zero, 0, "sum zero");

        a = 5'b01010;
        b = 5'b10101;
        op = `ALU_OR_OP;
        #PERIOD;
        `assert(result, 5'b11111, "or result");
        `assert(zero, 0, "or zero");

        a = 5'b01010;
        b = 5'b10101;
        op = `ALU_AND_OP;
        #PERIOD;
        `assert(result, 0, "and result");
        `assert(zero, 1, "and zero");

        a = 20;
        b = 30;
        op = `ALU_SLT_OP;
        #PERIOD;
        `assert(result, 1, "slt 1 result");
        `assert(zero, 0, "slt 1 zero");

        a = 30;
        b = 20;
        op = `ALU_SLT_OP;
        #PERIOD;
        `assert(result, 0, "slt 2 result");
        `assert(zero, 1, "slt 2 zero");

        a = -30;
        b = 20;
        op = `ALU_SLTU_OP;
        #PERIOD;
        `assert(result, 0, "sltu 1 result");
        `assert(zero, 1, "sltu 1 zero");

        a = 20;
        b = 30;
        op = `ALU_SLTU_OP;
        #PERIOD;
        `assert(result, 1, "sltu 2 result");
        `assert(zero, 0, "sltu 2 zero");
    end
endmodule