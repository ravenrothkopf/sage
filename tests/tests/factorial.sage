def void factorial (int n, int factorial) {
    int i = 1
         
    while(i <= n) {
        factorial = factorial * i
        i = i + 1
    }
    prints("factorial")
    print(factorial)
}

def int main () {
    int x = 6
    int fac = 1
    factorial(x, fac)
}
