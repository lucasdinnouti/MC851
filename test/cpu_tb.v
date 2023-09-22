`include "test/cpu.v"
`include "test/assert.v"

`timescale 1 ns / 10 ps

module cpu_tb;
  wire [5:0] led;
  reg clock = 1;

  localparam PERIOD = 10;

  cpu cpu (.clock(clock), .led(led));

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_tb);
  end

  integer i;
  initial begin
    for (i = 0; i < 20; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
      #PERIOD;
      clock = ~clock;
    end
    //`assert(cpu.result, 6, "cpu last result");
  end
endmodule
