module divider (
    input wire clock,
    input wire start,
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

      if ($signed(a) > 0) begin
        if ($signed(b) > 0) begin
          aux <= a;
          divisor <= b;
          sign <= `SIGN_POSITIVE;
        end else begin
          aux <= a;
          divisor <= -b;
          sign <= `SIGN_NEGATIVE;
        end
      end else begin
        if ($signed(b) < 0) begin
          aux <= -a;
          divisor <= -b;
          sign <= `SIGN_POSITIVE;
        end else begin
          aux <= -a;
          divisor <= b;
          sign <= `SIGN_NEGATIVE;
        end
      end
    end else if (i >= 32) begin
      if (sign == `SIGN_NEGATIVE) begin
        result <= -result;
      end

      busy <= 1'b0;
    end
  end

  always @(posedge clock) begin
    if (i < 32) begin
      // FIXME: This is broken on GoWIN synthesis
      // remainder = remainder << 1;
      // remainder[0] = aux[31];
      // aux = aux << 1;
      // result = result << 1;

      // if (remainder >= divisor) begin
      //   remainder = remainder - divisor;
      //   result[0] = 1'b1;
      // end

      // i = i + 1'b1;
    end
  end
endmodule
