module divider (
    input wire clock,
    input wire start,
    input wire is_signed,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] result = 0,
    output reg [31:0] remainder = 0,
    output reg busy = 0
);

  reg [31:0] divisor = 0;
  reg [31:0] aux = 0;
  reg [5:0] i = 0;
  reg sign = 0;

  always @(negedge clock) begin
    if (start && !busy) begin
      busy <= 1'b1;
      result <= 32'b0;
      remainder <= 32'b0;
      i <= 6'b0;
      aux <= (is_signed && a[31]) ? -a : a;
      divisor <= (is_signed && b[31]) ? -b : b;
      sign <= (is_signed && (a[31] ^ b[31])) ? `SIGN_NEGATIVE : `SIGN_POSITIVE;
    end else if (i < 32) begin
      remainder = remainder << 1;
      remainder[0] = aux[31];
      aux = aux << 1;
      result = result << 1;

      if (remainder >= divisor) begin
          remainder = remainder - divisor;
          result[0] = 1'b1;
      end

      i = i + 1'b1;
    end else if (i >= 32) begin
      if (sign == `SIGN_NEGATIVE) begin
        result <= -result;
        remainder <= -remainder;
      end

      busy <= 1'b0;
    end
  end
endmodule
