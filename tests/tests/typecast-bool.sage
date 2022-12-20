# testing type casting to bools

def int main() {
    printb(bool("10"))
    printb(bool(30))
    printb(bool(2.4))

    printb(bool("0"))
    printb(bool(0))
    printb(bool(0.0))
}