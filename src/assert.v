`define assert(signal, value, message, second_message = "") \
    if (signal != value) begin \
        $display("Failed assertion %s %s: expected 0x%0h but was 0x%0h", message, second_message, value, signal); \
    end
