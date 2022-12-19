def void iftrue(str msg) {
    prints(msg)
}

def int main() {
    int pos = 5
    int neg = -2

    if (pos > 0) {
        iftrue("hey")
    }
    else {
        prints("else case")
    }
}
