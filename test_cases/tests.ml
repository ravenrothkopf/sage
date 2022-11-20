(* Note: Each test case will go in its own file.  *)

(* test-integer_assignment1 *)
int a = 1
print(a)

(* test-integer_assignment2 *)
int x = 5
int x = -x
print(x)

(* test-string_assignment1 *)
str b = "hi"
print(b)

(* test-string_assignment2 *)
str b = '5'
print(b)

(* test-float_assignment *)
float c = 3e3
print(c)

(* test-boolean_assignment1 *)
bool d = True
print(d)

(* test-boolean_assignment2 *)
bool e = False
print(e)

(* test-boolean_assignment3 *)
bool e = not True
print(e)

(* test-array_assignment1 *)
int a = [1,2,3]
print(a)
print(a[0])

(* test-array_assignment2 *)
str b = ["a","b","c"]
print(b)
print(b[1])

(* test-array_assignment3 *)
float c = [1.1,2.2,3.3]
print(c)
print(c[2])

(* test-array_assignment4 *)
bool d = [True,False,True]
print(d)
print(d[0])

(* test-array_assignment5 *)
int a = [1,2,3]
print(a)
a[0] = 4
a[1] = 5
a[2] = 6
print(a)

(* test-integer_assignment_arithmetic *)
int e = 3 + 3
print(e)

(* test-const_assignment *)
const int x = 30
print(x)

(* test-static_assignment *)
static int x = 25
print(x)

(* test-string_mutation *)
str x = "hi"
str x = "bye"
str y = x
print(x)
print(y)

(* test-int_mutation *)
int x = 23
int x = 54
int y = x
print(x)
print(y)

(* test-float_mutation *)
float x = 3.05
float x = 4.55
int x = y
print(x)
print(y)

(* test-bool_mutation *)
bool x = True
bool x = False
int x = y
print(x)
print(y)

(* test-add1 *)
int x = 10
x += 1
print(x)

(* test-sub1 *)
int y = 10
y -= 1
print(y)

(* test-type_mismatch1 *)
int a = "hi"

(* test-type_mismatch2 *)
int, str, bool a = [3,"hi",False]

(* test-type_mismatch3 *)
int a = [1,"hi",2]

(* test-tuple *)
int, float, bool b = [1,6e3,True]

(* test-add2 *)
print(1 + 1)

(* test-sub2 *)
print(2 - 2)

(* test-divide *)
print(5 / 2)

(* test-modulo *)
print(6 % 4)

(* test-multiply *)
print(3 * 8)

(* test-divide_by_0 *)
print(5 / 0)

(* test-add_floats *)
print(3.33 + 8.92)

(* test-sub_floats *)
print(5.33 - 4.58)

(* test-divide_floats *)
print(3.33 / 1.35)

(* test-multiply_floats *)
print(2.38 * 5.89)

(* test-operator_precedence *)
print(5 + 5 * 2 / 10)

(* test-invalid_operation1 *)
int a = 1
str b = "hi"
print(a + b)

(* test-invalid_operation2 *)
int a = 1
bool c = "True"
print(a + c)

(* test-invalid_operation3 *)
int a = 1
float d = 5.67
print(a + d)

(* test-invalid_operation4 *)
str b = "hi"
bool c = False
print(b + c)

(* test-type_cast *)
int x = 10
str(x)
print(x)

(* test-invalid_return_statement *)
int a = 5
return a

(* test_valid_return_statement *)
int funct main (int a, int b):
  c = a - b
  return c
print(c)

(* test-function *)
int a = 3
int b = 4
int funct main (int a, int b):
  int c = 4
  int d = [1,2,3]
  d[0] = c
  return d

main(3, 4)
print(d)

(* test-function_void *)
void funct num_of_items(int items):
  print(items)

(* test-invalid_integer_function1*)
int funct main (int a, str b):
  return a + b

(* test-invalid_integer_function2 *)
int funct main (str b, str c):
  return a + b

(* test-struct *)
struct Point:
  int x = 4
  int y = 5

(* test-break *)
int a = [1,2,3,4]
for (x in a) {
  if (x == 3) {
    break
  }
  print ("number found")
}

(* test-continue *)
int a = [2,3,4,5]
for (x in a) {
  if (x % 2 != 0) {
    print("odd")
    continue
   }
   print("even")
}

(* test-if_elif_else1 *)
int x = 3
if (x < 10) {
  print("stopped after first if statement")
}
if (x = 2) {
  print("stopped after second if statement")
}
elif (x = 10) {
  print("stopped after elif statement")
}
elif (x = 11) {
  print("stopped after second elif statement")
}
else (x = 12) {
  print("stopped after first else statement")
}
else (x > 10) {
  print("second after first else statement")
}

(* test-if_elif_else2 *)
int x = 2
if (x < 10) {
  print("stopped after first if statement")
}
if (x = 2) {
  print("stopped after second if statement")
}
elif (x = 10) {
  print("stopped after elif statement")
}
elif (x = 11) {
  print("stopped after second elif statement")
}
else (x = 12) {
  print("stopped after first else statement")
}
else (x > 10) {
  print("second after first else statement")
}

(* test-if_elif_else3 *)
int x = 10
if (x < 10) {
  print("stopped after first if statement")
}
if (x = 2) {
  print("stopped after second if statement")
}
elif (x = 10) {
  print("stopped after elif statement")
}
elif (x = 11) {
  print("stopped after second elif statement")
}
else (x = 12) {
  print("stopped after first else statement")
}
else (x > 10) {
  print("second after first else statement")
}

(* test-if_elif_else4 *)
int x = 11
if (x < 10) {
  print("stopped after first if statement")
}
if (x = 2) {
  print("stopped after second if statement")
}
elif (x = 10) {
  print("stopped after elif statement")
}
elif (x = 11) {
  print("stopped after second elif statement")
}
else (x = 12) {
  print("stopped after first else statement")
}
else (x > 10) {
  print("second after first else statement")
}

(* test-if_elif_else5 *)
int x = 12
if (x < 10) {
  print("stopped after first if statement")
}
if (x = 2) {
  print("stopped after second if statement")
}
elif (x = 10) {
  print("stopped after elif statement")
}
elif (x = 11) {
  print("stopped after second elif statement")
}
else (x = 12) {
  print("stopped after first else statement")
}
else (x > 10) {
  print("second after first else statement")
}

(* test-if_elif_else6 *)
int x = 33
if (x < 10) {
  print("stopped after first if statement")
}
if (x = 2) {
  print("stopped after second if statement")
}
elif (x = 10) {
  print("stopped after elif statement")
}
elif (x = 11) {
  print("stopped after second elif statement")
}
else (x = 12) {
  print("stopped after first else statement")
}
else (x > 10) {
  print("second after first else statement")
}

(* test-while1 *)
int x = 3
while (x < 10) {
  print(x)
  x = x + 1
}

(* test-while2 *)
int x = 3
int y = 3
while (x < 10) {
  while (y < 10) {
    print(y)
    y = y + 1
  }
  print(x)
  x = x + 1
}