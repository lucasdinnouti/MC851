void main() {

    // handy addresses
    int* debug_led = 515;
    
    int* sensor_a_addr = 512;
    int* sensor_b_addr = 513;

    int* green_led_addr = 513;
    int* red_led_addr = 514;
    int counter;

    while (1) {

        // program
        *green_led_addr = 0;
        *red_led_addr = 0;
        *debug_led = 0;
        counter = 0;
        
        while (*sensor_a_addr) {}

        *debug_led = 1;

        while (*sensor_b_addr) {
            counter += 1;
        }

        if (counter > 3) {
            *green_led_addr = 1;
            *red_led_addr = 0;
        } else {
            *green_led_addr = 0;
            *red_led_addr = 1;
        }

        int outro_timer = 20;

        while (outro_timer > 0) {
            outro_timer -= 1;
        }
    }
}