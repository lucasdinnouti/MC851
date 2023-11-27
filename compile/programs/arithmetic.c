#include <stdio.h>

void main() {
    int a = 1;
    int b = 2;
    int c = 3;
    int d = 10000;

    if (a != 0) {
        a = c - a - c;
        a = a & b | c ^ a;
        a = a & 10;
        a = a >> 2;
        a = a << 2;
        a = (unsigned int) a >> 2;
        a = a + d;
    }

    int* output = 515;
    if (a == 10002) {
        *output = 1;
    } else {
        *output = 0;
    }
}
