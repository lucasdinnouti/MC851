`define assert(signal, expected, message) \
    if (signal != expected) begin \
        $display("Failed assertion: %s", message); \
    end
