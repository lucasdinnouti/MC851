#!/bin/sh

echo "-> Running ALU tests"
iverilog src/constants.v test/assert.v src/divider.v src/alu.v test/alu_tb.v && ./a.out
echo

echo "-> Running registers tests"
iverilog test/assert.v src/registers.v test/registers_tb.v && ./a.out
echo

echo "-> Running decoder tests"
iverilog src/constants.v test/assert.v src/decoder.v test/decoder_tb.v && ./a.out
echo

rm a.out

echo "-> Running CPU test"
cd src
iverilog -DSIMULATOR -DPROGRAM='`"full-instruction-set.riscv`"' constants.v alu.v branch.v decoder.v memory/memory_controller.v memory/ram.v memory/rom.v memory/l1.v memory/peripherals.v registers.v ex_mem_pipeline_registers.v id_ex_pipeline_registers.v if_id_pipeline_registers.v mem_wb_pipeline_registers.v forwarding.v atomic.v divider.v cpu.v ../test/assert.v ../test/cpu_tb.v && ./a.out
rm a.out
cd ..