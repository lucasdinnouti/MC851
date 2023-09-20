module memory_test (
  input wire clock,
  input wire btn,
  output wire [5:0] led
);
  wire [31:0] output_data;
  wire ready;

  l1 #(4, 32) l1(
    .address(0),
    .input_data(0),
    .should_write(0),
    .clock(clock),
    .output_data(output_data),
    .ready(ready)
  );
endmodule
