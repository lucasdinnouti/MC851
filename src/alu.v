module alu (
    input wire clock,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [4:0] op,
    output reg [31:0] result,
    output wire busy
);
  assign busy = 0;

  always @* begin
    case (op)
      `ALU_ADD_OP: result <= a + b;
      `ALU_SUB_OP: result <= a + (~b + 1);
      `ALU_SLL_OP: result <= a << b;
      `ALU_XOR_OP: result <= a ^ b;
      `ALU_OR_OP: result <= a | b;
      `ALU_AND_OP: result <= a & b;
      `ALU_SRL_OP: result <= a >> b;
      `ALU_SRA_OP: result <= $signed(a) >>> b;
      `ALU_SLT_OP: result <= $signed(a) < $signed(b) ? 1 : 0;
      `ALU_SLTU_OP: result <= a < b ? 1 : 0;
      //`ALU_MUL_OP: result <= a * b;
      // Multiply a 64 bits number to force a 64 bits multiplication result
      //`ALU_MULH_OP: result <= (64'b1 * $signed(a) * $signed(b)) >> 32;
      //`ALU_MULHSU_OP: result <= (64'b1 * $signed(a) * b) >> 32;
      //`ALU_MULHU_OP: result <= (64'b1 * a * b) >> 32;
      //`ALU_DIV_OP: result <= $signed(a) / $signed(b);
      //`ALU_DIVU_OP: result <= a / b;
      //`ALU_REM_OP: result <= $signed(a) % $signed(b);
      //`ALU_REMU_OP: result <= a % b;
      default: result <= 0;
    endcase
  end
endmodule
