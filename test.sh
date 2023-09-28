#!/bin/sh

echo "Running ALU tests"
iverilog src/constants.v test/assert.v src/alu.v test/alu_tb.v && ./a.out

echo "Running registers tests"
iverilog test/assert.v src/registers.v test/registers_tb.v && ./a.out

echo "Running decoder tests"
iverilog src/constants.v test/assert.v src/decoder.v test/decoder_tb.v && ./a.out

echo "Running CPU mock tests"
iverilog src/constants.v src/alu.v src/branch.v src/decoder.v src/memory/mock_memory.v src/registers.v src/ex_mem_pipeline_registers.v src/id_ex_pipeline_registers.v src/if_id_pipeline_registers.v src/mem_wb_pipeline_registers.v src/forwarding.v src/cpu.v test/cpu_tb.v && ./a.out