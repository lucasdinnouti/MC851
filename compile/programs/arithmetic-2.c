#include <stdio.h>

void main() {
    int a = 30;
    int b = 40;

    int c = (a * b) / 55;
    int d = (a * b) % 55;

    int* output = 515;
    if (c == 21 && d == 45) {
        *output = 1;
    } else {
        *output = 0;
    }
}
