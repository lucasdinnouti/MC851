
module peripherals (
    input wire [31:0] peripheral_bus,
    input wire btn,
    input wire [1:0] photores,
    output wire [4:0] led,
    output wire [31:0] wb_peripheral_bus
  );
  assign led[4:0] = ~peripheral_bus[4:0];

  // assign wb_peripheral_bus = peripheral_bus;
  assign wb_peripheral_bus[3] = ~btn;
  assign wb_peripheral_bus[0] = photores[0];
  assign wb_peripheral_bus[1] = photores[1];

endmodule
