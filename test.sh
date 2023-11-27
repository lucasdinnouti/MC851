#!/bin/bash

run_test() {
    echo
    iverilog ${@:2} 1> stdout.txt 2> stderr.txt
    ./a.out 1>> stdout.txt 2>> stderr.txt
    if [ -s stderr.txt ]; then
        echo -e "\e[31m> Test $1 failed!\e[0m"
        cat stdout.txt
        cat stderr.txt
    else 
        echo -e "\e[32m> Test $1 passed!\e[0m"
    fi
    rm stdout.txt stderr.txt
    rm a.out
}

cd src

run_test "ALU" constants.v ../test/assert.v divider.v alu.v ../test/alu_tb.v
run_test "registers" ../test/assert.v registers.v ../test/registers_tb.v
run_test "decoder" constants.v ../test/assert.v decoder.v ../test/decoder_tb.v

TEST_PROGRAMS="led-compiled function-compiled arithmetic-compiled arithmetic-2-compiled memory-compiled"

for PROGRAM in $TEST_PROGRAMS; do
    PROGRAM_ENV="\`\"$PROGRAM.riscv\`\""
    run_test "CPU ($PROGRAM)" -DSIMULATOR -DPROGRAM=$PROGRAM_ENV constants.v alu.v branch.v decoder.v memory/memory_controller.v memory/ram.v memory/rom.v memory/l1.v memory/peripherals.v registers.v ex_mem_pipeline_registers.v id_ex_pipeline_registers.v if_id_pipeline_registers.v mem_wb_pipeline_registers.v forwarding.v atomic.v divider.v cpu.v fetch.v ../test/assert.v ../test/cpu_tb.v
done

cd ..
