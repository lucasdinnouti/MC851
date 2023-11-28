void main() {

    // handy addresses
    int* debug_led = (int*) 515;
    
    int* sensor_a_addr = (int*) 512;
    int* sensor_b_addr = (int*) 513;

    int* green_led_addr = (int*) 512;
    int* red_led_addr = (int*) 513;

    int sensor_value;
    int speed_counter;

    // program
    while (1) {
        *debug_led = 1;

        sensor_value = 0;
        speed_counter = 0;

        do {
            sensor_value = *sensor_a_addr;
        } while (sensor_value != 1);

        *debug_led = 0;

        do {
            speed_counter += 1;
            sensor_value = *sensor_b_addr;
        } while (sensor_value != 1);

        *debug_led = 1;

        if (speed_counter > 10) {
            // slow
            *green_led_addr = 0;
            *red_led_addr = 1;
        } else {
            // fast
            *green_led_addr = 1;
            *red_led_addr = 0;
        }
    }
}