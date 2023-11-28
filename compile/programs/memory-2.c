void main() {
    unsigned char* unsigned_byte = 256;
    unsigned short* unsigned_half = 256;
    int* word = 256;
    short* half = 256;
    signed char* byte = 256;

    *word = 0xfafbfcfd;

    int* output = 515;
    if (*unsigned_byte == 0xfd && *unsigned_half == 0xfcfd && *word == 0xfafbfcfd && *half == 0xfffffcfd && *byte == 0xfffffffd) {
        *output = 1;
    } else {
        output = 0;
    }
}
