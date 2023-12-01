module atomic (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [ 4:0] op,
    output reg  [31:0] result
);
  always @* begin
    case (op)
      `ATOMIC_SWAP_OP: result <= b;
      `ATOMIC_ADD_OP: result <= a + b;
      `ATOMIC_XOR_OP: result <= a ^ b;
      `ATOMIC_AND_OP: result <= a & b;
      `ATOMIC_OR_OP: result <= a | b;
      `ATOMIC_MIN_OP: result <= ($signed(a) < $signed(b)) ? a : b;
      `ATOMIC_MAX_OP: result <= ($signed(a) > $signed(b)) ? a : b;
      `ATOMIC_MINU_OP: result <= (a < b) ? a : b;
      `ATOMIC_MAXU_OP: result <= (a > b) ? a : b;
      default: result <= 0;
    endcase
  end
endmodule
