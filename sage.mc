"""
sage.tb currently tests (only for semantic analysis):
- single/multi-line comments
- void function calls
- boolean statments + declaration
- string literal statements + declaration
- global variable declaration and local use within functions
- string concatenation
- if else statements (currently only works with one line stmts)
- multiple function declarations
"""

# test single-line comment

str hello = "hello"
bool t = True

def void voidTest() {
    str test = "test"
    prints("void test")
}

def int main (str greeting) {
    str location = "world"
    voidTest()
    print(1 + 2)
    prints("hello")
    prints(location)
    int i = 0
    for (i=0; i < 5; i = i + 1) {      
        print(i) 
    }
}
