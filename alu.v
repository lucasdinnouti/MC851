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
    output wire zero,
    output wire [31:0] result
);
  // Internal regs which are assigned to wire outputs
  reg _zero;
  reg [31:0] _result;

  assign zero   = _zero;
  assign result = _result;

  always @* begin
    case (op)
      `ALU_SUM_OP: _result = a + b;
      `ALU_SUB_OP: _result = a - b;
      `ALU_SLL_OP: _result = a << b;
      `ALU_XOR_OP: _result = a ^ b;
      `ALU_OR_OP:  _result = a | b;
      `ALU_AND_OP: _result = a & b;
      `ALU_SRL_OP: _result = a >> b;
      `ALU_SRA_OP: _result = a >>> b;
      `ALU_SLT_OP: _result = $signed(a) < $signed(b) ? 1'b1 : 1'b0;
      `ALU_SLTU_OP: _result = a < b ? 1'b1 : 1'b0;
    endcase
    _zero = (_result == 0);
  end
endmodule