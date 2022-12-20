def int gcd(int a, int b) {
  while (a != b) {
    if (b < a) a = a - b
    else b = b - a
  }
  return a
}

def int main() {
    int x = 2
    int y = 14
    int a = 18
    int b = 9
    print(gcd(3, 15))
    print(gcd(x, y))
    print(gcd(99, 121))
    print(gcd(a, b))
}
