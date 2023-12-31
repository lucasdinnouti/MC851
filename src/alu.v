`include "constants.v"

module alu (
    input wire clock,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [4:0] op,
    output reg [31:0] result,
    output wire busy
);
  wire [31:0] div_result;
  wire [31:0] div_remainder;

  divider divider (
      .clock(clock),
      .start(op == `ALU_DIV_OP || op == `ALU_DIVU_OP || op == `ALU_REM_OP || op == `ALU_REMU_OP),
      .is_signed(op == `ALU_DIV_OP || op == `ALU_REM_OP),
      .a(a),
      .b(b),
      .result(div_result),
      .remainder(div_remainder),
      .busy(busy)
  );

  always @* begin
    case (op)
      `ALU_ADD_OP: result <= a + b;
      `ALU_SUB_OP: result <= a + (~b + 1);
      `ALU_SLL_OP: result <= a << b[4:0];
      `ALU_XOR_OP: result <= a ^ b;
      `ALU_OR_OP: result <= a | b;
      `ALU_AND_OP: result <= a & b;
      `ALU_SRL_OP: result <= a >> b[4:0];
      `ALU_SRA_OP: result <= $signed(a) >>> b[4:0];
      `ALU_SLT_OP: result <= $signed(a) < $signed(b) ? 1 : 0;
      `ALU_SLTU_OP: result <= a < b ? 1 : 0;
      `ALU_MUL_OP: result <= a * b;
      // Multiply a 64 bits number to force a 64 bits multiplication result
      `ALU_MULH_OP: result <= (64'b1 * $signed(a) * $signed(b)) >> 32;
      `ALU_MULHSU_OP: result <= (64'b1 * $signed(a) * b) >> 32;
      `ALU_MULHU_OP: result <= (64'b1 * a * b) >> 32;
      `ALU_DIV_OP: result <= div_result;
      `ALU_DIVU_OP: result <= div_result;
      `ALU_REM_OP: result <= div_remainder;
      `ALU_REMU_OP: result <= div_remainder;
      default: result <= 0;
    endcase
  end
endmodule
