int num = 10000
str greeting = "Welcome to sage"

def int main() {
    int pos = 105
    int neg = -5
    
    print(pos / neg)
    hello_world()
    printb(b_check())
    math_functs()
    print(gcd(24, 48))
    printfl(test_float())
    casting_check()
}

def void hello_world() {
    str location = " world!"
    prints(greeting + location)
}

def bool b_check() {
    if (num < 1) {
        return True
    }
    else if (num == 100) {
        return True
    }
    else {
        return False
    }
}

def void math_functs() {
    int x = 50 % 5
    int y = 5 - 1

    print(x + y)
}

def int gcd(int a, int b) {
  while (a != b) {
    if (b < a) a = a - b
    else b = b - a
  }
  return a
}

def float test_float() {
    float PI = 3.14159
    prints("This is pi!")
    return PI
}

def void casting_check() {
    printfl(float("2.72"))
    printfl(float(42))
}
