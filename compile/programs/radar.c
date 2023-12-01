void main() {

    // handy addresses
    int* debug_led = 515;
    
    int* sensor_a_addr = 512;
    int* sensor_b_addr = 513;

    int* green_led_addr = 513;
    int* red_led_addr = 514;

    // program
    *debug_led = 1;

    // // calibrate
    // int timer = 60;
    // while (timer > 0) {
    //     timer -= 1;
    //     *green_led_addr = *sensor_a_addr;
    //     *red_led_addr = *sensor_b_addr;
    // }

    *green_led_addr = 0;
    *red_led_addr = 0;
    *debug_led = 0;

    // int sensor_value = 1;
    int counter = 0;
    
    while (*sensor_a_addr) {

    }

    *debug_led = 1;
    // sensor_value = 1;

    while (*sensor_b_addr) {
        counter += 1;
    }

    *debug_led = 0;

    if (counter > 50) {
        *green_led_addr = 1;
        *red_led_addr = 0;
    } else {
        *green_led_addr = 0;
        *red_led_addr = 1;
    }

    *debug_led = 1;

    int outro_timer = 1000;
    while (outro_timer > 0) {
        outro_timer -= 1;
    }

    *debug_led = 0;
}