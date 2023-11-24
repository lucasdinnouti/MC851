int operation(int n) {
    int temp = n;
    for (int i = 0; i < 5; i++) {
        temp += i;
    }
    return temp;
}

void main() {
    int* output = 512;
    int result = operation(50);
    if (result == 60) {
        *output = 1;
    } else {
        *output = 0;
    }
}