void main() {
    int a = 30;
    int b = -40;

    int c = (a * b) / 55;
    int d = (a * b) % 55;
    int e = ((unsigned int) b / (unsigned int) a) / 1000;
    int f = (unsigned int) b % (unsigned int) a;

    int* output = 515;
    if (c == -21 && d == -45 && e == 143165 && f == 6) {
        *output = 1;
    } else {
        *output = 0;
    }
}
