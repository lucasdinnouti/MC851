`timescale 1 ns / 10 ps

module test_cpu_tb;
  reg [31:0] instruction;
  reg clock = 0;

  localparam PERIOD = 10;

  test_cpu test_cpu (
      .instruction(instruction),
      .clock(clock)
  );

  initial begin
    $dumpfile("test_cpu.vcd");
    $dumpvars(0, test_cpu_tb);
  end

  initial begin
    // addi x5, x5, 10
    instruction = 32'h00a28293;
    #PERIOD;
    clock = ~clock;
    #PERIOD;
    clock = ~clock;
    #PERIOD;
    clock = ~clock;
    #PERIOD;
    clock = ~clock;
    #PERIOD;
  end
endmodule
