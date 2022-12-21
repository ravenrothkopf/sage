int elf_count = 10
str greeting = "Welcome to the Sage Holiday Special! What can I get for you?"

def int main() {
    int pos = 105
    int neg = -5
    print(pos / neg)
    return 1
}
 
def str hello_world() {
    str location = "world!"
    prints(greeting + location)
    return location
}
 
def bool b_check() {
    if (num < 1) {
        return true
    }
    else {
        return false
    }
}

def void math_functs() {
    int x = 50 % 5
    int y = 5 - 1
    # cast
}

def int gcd() {
    int first_num = 24
    int second_num = 48
    while(second_num!=0) {
      int rem = first_num % second_num
      first_num = second_num
      second_num = rem
      # output = str(first_num)
   }
   prints("GCD of two numbers is " + first_num)
   return 0
}

def float test_float() {
    float PI = 3.14159
    prints("This is pi!)
    return PI
}

def float casting_check() {
    printfl(float("2.72"))
    printfl(float(42))
    return 0.0
}