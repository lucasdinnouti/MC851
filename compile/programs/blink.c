void main() {
    int* output = 515;
    int n = 0;
    int current = 0;
    while (1) {
        n += 1;
        if (n == 3) {
            n = 0;
            current = !current;
            *output = current;
        }
    }
}