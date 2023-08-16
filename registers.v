module registers (
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] data,
    input wire should_write,
    input wire clock,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);
    reg [31:0] registers [31:0];

    assign rs1_data = registers[rs1];
    assign rs2_data = registers[rs2];

    always @(posedge clock) begin
        if (should_write) begin
            registers[rd] = data;
        end
    end
endmodule