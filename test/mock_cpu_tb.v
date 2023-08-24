`include "src/mock_cpu.v"
`include "test/assert.v"

`timescale 1 ns / 10 ps

module mock_cpu_tb;
  reg [31:0] instruction;
  reg clock = 1;

  localparam PERIOD = 10;

  mock_cpu mock_cpu (.clock(clock));

  initial begin
    $dumpfile("mock_cpu.vcd");
    $dumpvars(0, mock_cpu_tb);
  end

  integer i;
  initial begin
    for (i = 0; i < 10; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
      #PERIOD;
      clock = ~clock;
    end
    `assert(mock_cpu.result, 56, "cpu last result");
  end
endmodule
