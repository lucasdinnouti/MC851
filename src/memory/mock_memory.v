module memory (
    input wire [31:0] address,
    input wire [31:0] input_data,
    //input wire [31:0] wb_peripheral_bus,
    input wire mem_write,
    input wire mem_read,
    input wire mem_type,
    input wire clock,
    output reg [31:0] output_data = 0
    //output wire [31:0] peripheral_bus
);

  reg [31:0] ram[63:0];
  reg [31:0] rom[63:0];

  integer i;
  initial begin
    for (i = 0; i < 64; i = i + 1) begin
      ram[i] = 0;
      rom[i] = 0;
    end

    // 5:  00011
    // 7:  00010
    // 9:  11101
    // 11: 11000

    // addi x1, x0, 3
    // addi x2, x0, 0
    // loop:
    // add x2, x2, x1
    // addi x1, x1, -1
    // bne x1, x0, loop
    // add x2, x2, 1
    // add x2, x2, x0
    // x2 == 7
    rom[0] = 32'h00300093;
    rom[1] = 32'h00000113;
    rom[2] = 32'h00110133;
    rom[3] = 32'hfff08093;
    rom[4] = 32'hfe009ce3;
    rom[5] = 32'h00110113;
    rom[6] = 32'h00010133;

    //ram[63] = 32'b00000000000000000000000000000001;
  end

  always @(posedge clock) begin
    if (mem_write) begin
      case (mem_type)
        `MEM_ROM: rom[address] = input_data;
        `MEM_RAM: ram[address] = input_data;
      endcase
    end
   // ram[63] = wb_peripheral_bus;

  end
  always @(negedge clock) begin
    if (mem_read) begin
      case (mem_type)
        `MEM_ROM: output_data = rom[address];
        `MEM_RAM: output_data = ram[address];
      endcase
    end
    //peripheral_bus[31:0] = ram[63];
  end
endmodule
