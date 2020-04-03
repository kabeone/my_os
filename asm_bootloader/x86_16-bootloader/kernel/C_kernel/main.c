int main() {
  volatile char *vidptr = (char *) 0xb8000;
  *vidptr = 'A';
  vidptr[1] = 3;
}
