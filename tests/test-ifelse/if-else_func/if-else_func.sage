def void iftrue() {
    prints("if case")
}

def int main() {
    int pos = 5
    int neg = -2
    if (pos > 0) {
        iftrue()
    } 
    else {
        prints("else case")
    }
}
