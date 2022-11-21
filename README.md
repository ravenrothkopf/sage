# sage Programming Language
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

* Parsing of assignment statements and function declarations
## Features Not Implemented at This Phase

* None related to Hello World

## Team Member Contributions

* Raven (11/13) - Wrote the foundation for the scanner, parser, and ast for Hello World (comments, string literals, str data types, concatenation, function definitions)
* Raven (11/14) - Debugged scanner and parser building
* Jenny & Raven (11/16) - met and planned on what needs to be done, within what time frame, what the best steps to proceed are, and how to get full participation
* Jenny (11/16) - Combed through the examples from class, debugged and tried to get Hello World to work, fixed the parsing of string literals, debugged .mly and ast files
* Jenny (11/18) - Debugged for hours, figured out the main issues preventing parsing, like newlines and tabs
* Lauren (11/18) - Began implementing functionality to parse additional type declarations (int, float, bool)
* All (11/19) - Meeting to plan out the rest of this part
* Mely (11/19) - Worked on the sast and semant.ml
* Lauren (11/19) - Finished implementing parsing of int, float, and bool types and began updating the LRM
* Lauren (11/20) - Added test cases
* Raven (11/20) - Wrote Makefile