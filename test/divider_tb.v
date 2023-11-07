`timescale 1 ns / 10 ps

module divider_tb;
  reg clock = 0;
  reg start = 0;
  reg [31:0] a, b;
  wire [31:0] result, remainder;
  wire done;

  localparam PERIOD = 10;

  divider divider (.clock(clock), .start(start), .a(a), .b(b), .result(result), .remainder(remainder));

  initial begin
    $dumpfile("divider.vcd");
    $dumpvars(0, divider_tb);
  end

  integer i;
  initial begin
    start = 1;
    a = -1000;
    b = 20;
    for (i = 0; i < 40; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
      #PERIOD;
      clock = ~clock;
      start = 0;
    end
  end
endmodule
