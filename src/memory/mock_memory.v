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

    // addi x2, x0, 1
    // addi x3, x0, 2
    // add x1, x2, x3
    // add x10, x0, x1
    // sub x1, x1, x2
    // add x10, x0, x1
    // xori x1, x1, 63
    // add x10, x0, x1
    // addi x1, x1, -5
    // add x10, x0, x1
    // x10 == 56
    rom[0] = 32'h00100113;
    rom[1] = 32'h00200193;
    rom[2] = 32'h003100b3;
    rom[3] = 32'h00100533;
    rom[4] = 32'h402080b3;
    rom[5] = 32'h00100533;
    rom[6] = 32'h03f0c093;
    rom[7] = 32'h00100533;
    rom[8] = 32'hffb08093;
    rom[9] = 32'h00100533;

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
