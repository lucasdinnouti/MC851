void main() {
    int* a = 256;
    int* b = 260;
    int* c = 264;

    *a = 123;
    *b = 321;
    *c = *a + *b;
    
    int* output = 515;
    if (*c == 444) {
        *output = 1;
    } else {
        output = 0;
    }
}
