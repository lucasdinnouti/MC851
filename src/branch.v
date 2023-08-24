module branch (
    inout wire [31:0] pc,
    input wire clock
);
  reg [31:0] pc_reg;
  assign pc = pc_reg;
  initial begin
    pc_reg = -4;
  end
  always @(posedge clock) begin
    pc_reg = pc_reg + 4;
  end
endmodule
