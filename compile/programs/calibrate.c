void main() {

    // handy addresses
    int* debug_led = 515;
    
    int* sensor_a_addr = 512;
    int* sensor_b_addr = 513;

    int* green_led_addr = 513;
    int* red_led_addr = 514;

    // program
    *debug_led = 1;

    // calibrate
    while (1) {
        *green_led_addr = *sensor_a_addr;
        *red_led_addr = *sensor_b_addr;
    }
}