`define assert(signal, value, message, second_message = "") \
    if (signal != value) begin \
        $display("\033[0;31mFailed assertion %s %s: expected 0x%0h but was 0x%0h\033[0m", message, second_message, value, signal); \
    end
