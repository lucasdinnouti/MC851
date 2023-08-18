module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] op,
    output reg zero,
    output reg [31:0] result
);
  always @* begin
    case (op)
      `ALU_ADD_OP:  result = a + b;
      `ALU_SUB_OP:  result = a - b;
      `ALU_SLL_OP:  result = a << b;
      `ALU_XOR_OP:  result = a ^ b;
      `ALU_OR_OP:   result = a | b;
      `ALU_AND_OP:  result = a & b;
      `ALU_SRL_OP:  result = a >> b;
      `ALU_SRA_OP:  result = a >>> b;
      `ALU_SLT_OP:  result = $signed(a) < $signed(b) ? 1 : 0;
      `ALU_SLTU_OP: result = a < b ? 1 : 0;
    endcase
    zero = (result == 0);
  end
endmodule