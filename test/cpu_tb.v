`timescale 1 ns / 10 ps

module cpu_tb;
  wire [5:0] led;
  reg clock = 0;

  localparam PERIOD = 10;

  cpu cpu (.clock(clock), .led(led));

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_tb);
  end

  integer i;
  initial begin
    for (i = 0; i < 160; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
      #PERIOD;
      clock = ~clock;
    end
    `assert(cpu.r1, 15, "cpu r1");
  end
endmodule
