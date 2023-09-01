module memory (
    input wire [31:0] address,
    input wire [31:0] input_data,
    input wire mem_write,
    input wire mem_read,
    input wire mem_type,
    input wire clock,
    output reg [31:0] output_data
);

  reg [31:0] ram[63:0];
  reg [31:0] rom[63:0];

  integer i;
  initial begin
    for (i = 0; i < 64; i = i + 1) begin
      ram[i] = 0;
      rom[i] = 0;
    end

    // addi x1, x0, 3
    // addi x2, x0, 0
    // loop:
    // add x2, x2, x1
    // addi x1, x1, -1
    // bne x1, x0, loop
    // add x2, x2, x0
    // x2 == 6
    rom[0] = 32'h00300093;
    rom[1] = 32'h00000113;
    rom[2] = 32'h00110133;
    rom[3] = 32'hfff08093;
    rom[4] = 32'hfe009ce3;
    rom[5] = 32'h00010133;
  end

  always @(posedge clock) begin
    if (mem_write) begin
      case (mem_type)
        `MEM_ROM: rom[address] = input_data;
        `MEM_RAM: ram[address] = input_data;
      endcase
    end
  end
  always @(negedge clock) begin
    if (mem_read) begin
      case (mem_type)
        `MEM_ROM: output_data = rom[address];
        `MEM_RAM: output_data = ram[address];
      endcase
    end
  end
endmodule
