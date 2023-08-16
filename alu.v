`define ALU_SUM_OP 4'b0000
`define ALU_SUB_OP 4'b1000
`define ALU_SLL_OP 4'b0001
`define ALU_XOR_OP 4'b0100
`define ALU_OR_OP 4'b0110
`define ALU_AND_OP 4'b0111
`define ALU_SRL_OP 4'b0101
`define ALU_SRA_OP 4'b1101
`define ALU_SLT_OP 4'b0010
`define ALU_SLTU_OP 4'b0011

module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] op,
    output reg zero,
    output reg [31:0] result
);
  always @* begin
    case (op)
      `ALU_SUM_OP: result = a + b;
      `ALU_SUB_OP: result = a - b;
      `ALU_SLL_OP: result = a << b;
      `ALU_XOR_OP: result = a ^ b;
      `ALU_OR_OP:  result = a | b;
      `ALU_AND_OP: result = a & b;
      `ALU_SRL_OP: result = a >> b;
      `ALU_SRA_OP: result = a >>> b;
      `ALU_SLT_OP: result = $signed(a) < $signed(b) ? 1'b1 : 1'b0;
      `ALU_SLTU_OP: result = a < b ? 1'b1 : 1'b0;
    endcase
    zero = (result == 0);
  end
endmodule