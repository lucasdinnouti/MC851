
module peripherals (
    input wire [31:0] r1,
    output wire [4:0] led
  );

  assign led[4:0] = ~r1[4:0];

endmodule
