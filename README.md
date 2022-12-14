# sage<! -- omit in toc -->

#### *a beautiful intersection of your favorite modern, imperative programming languages `<!-- omit in toc -->`*

sage is an imperative programming language inspired by the elegant simplicity of Python, enhanced with features from Java and C/C++. sage is a strongly and statically typed language, with strict evaluation. order and incorporates higher order functions in addition to partial applications.

Efficient prototyping requires the use of a language that is not too heavy in specific syntax in order to quickly translate ideas into working proof-of-concept models. Unfortunately, modern languages of choice like Python, offers ease of use at the expense of significant trade-offs; compiling and running Python programs are often slow and consume a substantial amount of system resources.

sage preserves the “stripped” feeling of Python while adding some strict implementation protocols that will give sage the strict-typing of C++.


## Table of Contents `<!-- omit in toc -->`

1. [File Structure](#file-structure)
2. [Compiling sage programs](#compiling-sage-programs)
3. [Features provided in this current release (v1.0.0)](#features-provided-in-this-current-release-v100)
4. [Features planned for the next (upcoming) release (v2.0.0)](#features-planned-for-the-next-upcoming-release-v200)
5. [Guidance we are seeking](#guidance-we-are-seeking)
6. [Team member contributions](#team-member-contributions)
7. [References](#references)

## File Structure

```

**sage**
├── ast.ml
├── codegen.ml
├── demo
    └── demo.sage
├── libc
    ├── stdlibc.c
    └── stdlibc.h
├── logs
├── Makefile
├── parser.mly
├── README.md
├── rundemo.sh
├── sast.ml
├── scanner.mll
├── semant.ml
├── testall.sh
├── testbasic.sh
├── testerrors.sh
└── tests
    ├── basic
    ├── checkfail
    └── tests

```

## Compiling sage programs

From your terminal, navigate to the root directory (referred to as `home` from this point onwards):

`cd ../sage`

Run the Makefile via the `make` command to build the `sage` compiler:

`make`

#### Test suite

The complete `sage` test suite is comprised of three test types: `basic` (unit tests), `tests` (standard tests), and `checkfail` (error handling). 
**All commands in this section assume you are in the `home` directory.**

_Note: you may need to change permissions of each of the shell scripts in order to properly run the commands outlined in this section (Test suite)_
> `cd ../sage`
> `chmod u+x [*.sh]`

You can run the entire test suite by running:
> `make testall`

To run every test case of a particular test category, run:
> `make basic` # basic tests
> `make tests` # standard tests
> `make testfail` # error handling

To test an individual `*.sage` file, run the following from the `home` directory:
> `make native`
> ./sage.native < [FILENAME.sage] > [FILENAME.out]

## Features provided in this current release (v2.0.0)

**tbd**

##### Basic `string` assignment statements

From the terminal, run the following line to compile the front-end and produce the executable, `test.native:`

```bash
ocamlbuild -use-ocamlfind test.native
```

Execute `./test.native` and run the two following lines of code, **one line at a time** followed by `<ENTER>` (ensures that each line is terminated with a `newline` character)

```bash
str s1 = "hello "	# + <ENTER>
str s2 = "world"	# + <ENTER>

# <CTRL + D> to send the END OF TRANSMISSION (0x4) 
# control character to the shell
```

After the program termination, the terminal should read:

```
str s1 = hello
str s2 = world
^D
```

Indicating that both s1 and s2 were successfully parsed by the compiler :)

## Features planned for the next (upcoming) release (v2.0.0)

Many features are almost implemented in some branches. They are:
* indents like the Python language in /jenny branch
* arrays in /jenny-new branch
* tuples in /jenny-tuples branch

* A complete, full-fledged front-end compiler for the sage PL (i.e., a functionally complete scanner, parser, semantic checker, and IR code generator/LLVM IR)
* Implement the remainder of sage's language features (types such as floating-point implementation, per IEEE 754 standards, functions, operators and binary operations [e.g., associativity, precedence, type equality checking], composite type [i.e., tuples, `struct`s], reference counting / automatic garbage collecting, and other memory safety features)

  * Full testing suite to highlight the aforementioned language features
  * `stdlib` written in sage or C for quality of life features (i.e., `println`)
  * Robust error handling with detailed error messages to facilitate 
  ging
* An AST or a semantically-checked AST generated from compiling our front-end
* Docker image to enhance access to testing and trying the sage PL without having to download and install the language to your local machine
* Additional special features (TBD)

## Guidance we are seeking

* `make all` gives us a dangling terminal error that we have attempted to fix but with no luck
* Attempting to build `../test-cases/test-assign1` gives parsing errors likely related to binding. We have wanted to fix how we bind, but changes have not been pushed since they do not work.
* How do we make sure everyone has the same codebase? We all `git pull`, but stashing some changes has made it to where pulling does not modify current code state
* Should we be throwing specific errors when variable names are not valid?

## Team member contributions (Agreed Protocol to Track Progress)

* Raven (11/13) - Wrote the foundation for the scanner, parser, and ast for Hello World (comments, string literals, str data types, concatenation, function definitions)
* Raven (11/14) - Debugged scanner and parser building
* Gabriela (11/15) - Review codebase and compile list of bugs to address in office hours for test.ml
* Gabriela (11/16) - Debug codebase for scanner and parser, attended Gregory's OH for guidance, committed implementation to address ^D parsing issues
* Jenny & Raven (11/16) - met and planned on what needs to be done, within what time frame, what the best steps to proceed are, and how to get full participation
* Jenny (11/16) - Combed through the examples from class, debugged and tried to get Hello World to work, fixed the parsing of string literals, debugged .mly and ast files
* Gabriela (11/16) - Performed quality assurance testing for test.ml, addressed bugs in scanner and parser code base
* Gabriela (11/17) - Continued quality assurance testing for test.ml, addressing bugs in scanner and parser code base
* Jenny (11/18) - Debugged for hours, figured out the main issues preventing parsing, like newlines and tabs
* Lauren (11/18) - Began implementing functionality to parse additional type declarations (int, float, bool)
* All (11/19) - Meeting to plan out the rest of hello world deliverable
* Mely (11/19) - Created and worked on the sast.ml, semant.ml and test2.ml files
* Lauren (11/19) - Finished implementing parsing of int, float, and bool types and began updating the LRM
* Lauren (11/20) - Added test cases
* Raven (11/20) - Wrote Makefile
* Mely (11/20) - Worked on debugging semant.ml and sast.ml
* Gabriela (11/20) - Collaborate with Mely to address semant.ml bugs and prepare ast.ml file for test2.ml initial testing phase
* Gabriela (11/20) - Rebase codebase after commit to address binding critically compromised code
* Gabriela (11/21) - Quality assurance testing and compile a list of bugs to address in Hao's office hours, specifically addressing testing suite
* Gabriela (11/21) - Attended Hao's OH and push debugging suggestions for binding
* Mely (11/21) - Attended Hao's OH to ask about printing functionality and worked on implementing the print feature in semant.ml
* Lauren (11/21) - Attended Hao's OH and fixed string concatenation, updated the README and finished updating the LRM (e.g., added a complete list of indices of all current features, fixed + enhanced syntax highlighting specifically for sage, updated/edited each section of the LRM). Worked on the test shell script, although currently incomplete
* Raven (11/21) - Worked on debugging parser ast, and semantic checking to integrate binding
* Gabriela (11/28) - Created branches for feature management and proposed new merging protocol moving forward
* Gabriela (11/28) - Begin initial code for code generation component
* Gabriela (11/29) - Continue adding code generation components for existing language features
* Gabriela (11/30) - Review LLVM documentation, quality assurance testing: open issues for future features based on testing results
* Gabriela (12/1) - Merge Lauren's fixes to 37 shift/reduce conflicts, initial commit for code generation component
* Gabriela (12/1) - Fix merging conflicts, IR generation testing
* Gabriela (12/5) - Address LLVM installation issues for lli path not creating symbolic link in terminal to test llvm
* Gabriela (12/10) - Resolve CodeGen bugs across codebase, add math operations, merge Raven's conditional block statements and address merge conflicts
* Gabriela, Raven, Jenny, Lauren (12/13) - Code gen meeting to discuss merge conflicts
* Gabriela (12/18) - Update branches with current changes & address merge conflicts, read documentation to address lli cannot find command
* Gabriela (12/18) - Implement return statements on ast, scanner, parser, sast, semantics, irgen
* Gabriela (12/19) - Implement floats in ast, scanner, parser, sast, semant, and codegen files & printfl function for printing floats
* All (12/19) - Meet for game plan for final deliverables
* Gabriela & Jenny (12/19) - Meet to discuss strategy and implementation of arrays and codegen
* Gabriela (12/19) - Continued iteration on codegen file for implementing arrays
* All (12/19) - Meet to discuss presentation and final language implementation
* Gabriela (12/20) - Debug for loop index increment, commit first iteration of code for live demo & finalize demo by addressing casting bugs
* Gabriela (12/20) - Create and finalize final presentation
* All (12/20) - Make adjustments to demo and presentation; debug for loops; first recording of presentation
* Gabriela (12/20) - Cut video recording & upload to YouTube x2 for two runthroughs
* Gabriela (12/20) - Debug LaTeX file, update changes onto master, write and finalize holiday demo for proof of concept functionality with more cohesiveness
* Gabriela (12/20) - Language Tutorial and Architectural Design for Final Report, Introduction rewording, add print statement functions to LRM

## Release history notes

### Version 1.0.0

* Basic scanner, parser, AST, and semantic checker implementations
  * Able to parse basic assignment statements (i.e., binding of primitive types) as well as binding of identifiers to types, binary operations, and miscellaneous `string` operations (i.e., concatenation, tokenizing, and binding)
* Basic error checking
* "hello world"

## References

1. [Rusty Language Reference Manual](http://www.cs.columbia.edu/~sedwards/classes/2016/4115-fall/lrms/rusty.pdf)
2. [Python Reference Manual](https://docs.python.org/3/reference/)
3. [Java Reference Manual](https://docs.oracle.com/javase/specs/jls/se7/html/index.html)
4. [C Language Reference Manual](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjSmfW_0cD7AhWQEFkFHYUjD10QFnoECBMQAQ&url=http%3A%2F%2Fwww.cs.columbia.edu%2F~sedwards%2Fpapers%2Fsgi1999c.pdf&usg=AOvVaw2CW2iJl-QTyHQS8sWDWGTZ)
