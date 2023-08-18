`timescale 1 ns / 10 ps

module registers_tb;
  reg [4:0] rs1;
  reg [4:0] rs2;
  reg [4:0] rd;
  reg [31:0] data;
  reg should_write;
  reg clock = 0;
  wire [31:0] rs1_data;
  wire [31:0] rs2_data;

  localparam PERIOD = 10;

  registers under_test (
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .data(data),
      .should_write(should_write),
      .clock(clock),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data)
  );

  initial begin
    $dumpfile("registers.vcd");
    $dumpvars(0, registers_tb);
  end

  initial begin
    rs1  = 0;
    rs2  = 31;
    rd = 0;
    data = 0;
    should_write = 0;
    clock = ~clock;
    #PERIOD;
    clock = ~clock;
    #PERIOD;
    `assert(rs1_data, 0, "x0 initial value");
    `assert(rs2_data, 0, "x31 initial value");

    rs1 = 10;
    rd = 10;
    data = 999;
    should_write = 1;
    clock = ~clock;
    #PERIOD;
    clock = ~clock;
    #PERIOD;
    `assert(rs1_data, 999, "x10 after write");
  end
endmodule
