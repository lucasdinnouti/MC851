`timescale 1 ns / 10 ps

module cpu_tb;
  reg clock = 0;
  wire [3:0] output_peripherals;

  localparam PERIOD = 10;

  cpu cpu (
      .clock(clock),
      .output_peripherals(output_peripherals)
  );

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_tb);
  end

  integer i;
  initial begin
    for (i = 0; i < 2 * 300; i = i + 1) begin
      #PERIOD;
      clock = ~clock;
    end

    `assert(output_peripherals[3], 1, "output_peripherals[3]");
  end
endmodule
