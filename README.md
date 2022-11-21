<!-- omit in toc -->
# sage Programming Language

<!-- omit in toc -->
## Table of Contents
- [File Structure](#file-structure)
- [Method to Run and Test](#method-to-run-and-test)
- [Features Provided in Current Version](#features-provided-in-current-version)
- [Features Not Implemented at This Phase](#features-not-implemented-at-this-phase)
- [Guidance We Are Seeking](#guidance-we-are-seeking)


- [Team Member Contributions](#team-member-contributions)

## File Structure
```
sage
├── Makefile
├── README.md
├── ast.ml
├── helloWorld.ml
├── parser.mly
├── sage.out
├── sage.tb
├── sast.ml
├── scanner.mll
├── semant.ml
├── test.ml
├── test2.ml
└── test_cases
    ├── test-assign1.ml
    └── test-function1.ml
```

## Method to Run and Test

Run Makefile ('/sage') to compile sage. Test using test cases ('/sage/test_cases').  
`make`

## Features Provided in Current Version

* Parsing of assignment statements and function declarations
  
## Features Not Implemented at This Phase

* None related to hello world front end

## Guidance We Are Seeking
* 

## Team Member Contributions

* Raven (11/13) - Wrote the foundation for the scanner, parser, and ast for Hello World (comments, string literals, str data types, concatenation, function definitions)
* Raven (11/14) - Debugged scanner and parser building
* Gabriela (11/14) - Review codebase and compile list of bugs to address in office hours for test.ml
* Gabriela (11/15) - Attempt to debug, attended Gregory's OH for guidance, comitted first steps of implementation to address ^D parsing issues 
* Jenny & Raven (11/16) - met and planned on what needs to be done, within what time frame, what the best steps to proceed are, and how to get full participation
* Jenny (11/16) - Combed through the examples from class, debugged and tried to get Hello World to work, fixed the parsing of string literals, debugged .mly and ast files
* Gabriela (11/16) - Combed through examples from class and quality assurance testing for test.ml, attempt to address locally bugs
* Gabriela (11/17) - Combed through examples from class and quality assurance testing for test.ml, attempt to address locally bugs
* Jenny (11/18) - Debugged for hours, figured out the main issues preventing parsing, like newlines and tabs
* Lauren (11/18) - Began implementing functionality to parse additional type declarations (int, float, bool)
* All (11/19) - Meeting to plan out the rest of this part
* Mely (11/19) - Worked on the sast and semant.ml
* Lauren (11/19) - Finished implementing parsing of int, float, and bool types and began updating the LRM
* Lauren (11/20) - Added test cases
* Raven (11/20) - Wrote Makefile
* Gabriela (11/20) - Collaborate with Mely to address semant.ml bugs and attempting to adjust ast.ml file accordingly for test2.ml
* Gabriela (11/20) - Rebase codebase after commit to address binding criticially compromised exsisting code
* Gabriela (11/21) - Quality assurance testing and compile a list of bugs to address in Hao's office hours, specifically addressing test cases file
