# sage Programming Language
## Description
sage is an imperative language strongly and statically typed. It will have a strict evaluation order and will incorporate higher order functions as well as partial application.

Prototyping requires the use of a language that is not too heavy in specific syntax in order to execute a proof of concept fairly quickly. However, languages like Python are slow on a system’s resources because the programmer sacrifices robustness for ease of use. Sage preserves the “stripped” feeling of Python while adding some strict implementation protocols that will give sage the strict-typing of C++.

## File Structure
.
├── src
│    ├── ast.ml
│    ├── helloWorld.mc
│    ├── helloWorld.ml
│    ├── parser.mly
│    ├── sast.ml
│    ├── scanner.mll
│    ├── semant.ml
│    ├── test.ml
│    └── test2.ml
├── test_cases
|    └── tests.ml
└── readme.md

## Method to Run and Test

Use Makefile to compile sage. Tests should pass with OK.
`make`

## Features Provided in Current Version


## Features Not Implemented at This Phase

