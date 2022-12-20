#!/bin/sh

# Regression testing script for sage (derived from MicroC)
# Step through a list of files
#  Compile, run, and check the output of each expected-to-work test
#  Compile and check the error of each expected-to-fail test

# ----------Paths------------
LIBDIR="./libc/"
LIBC="./libc/stdlibc.c"
ERRPATH="./logs/tests-error.log"
LOGPATH="./logs/tests.log"
DBUILD="./_build/"
# LLVM interpreter (LLI="/usr/local/opt/llvm/bin/lli")
LLI="lli"
# LLI="/opt/homebrew/opt/llvm/bin/lli"
# LLVM compiler
LLC="llc"
# C compiler
CC="gcc"
# sage compiler
SAGE="./sage.native"
SAGECEXEC="./sagec"
#SAGE="_build/SAGE.native"

# ----------Setup------------
shopt -s nullglob
testfiles=(*/tests/*.sage)
ulimit -t 30
testnum=0
tflag=0
errcount=0
total=0

# TESTING BEGINS
make
gcc -c -o $LIBC
errorlog=$ERRPATH
globallog=$LOGPATH
rm -f $globallog
error=0
globalerror=0
keep=0

echo "\n\n=============== Running Tests... ================="
Usage() {
    echo "Usage: testall.sh [options] [.native files]"
    echo "-k    Keep intermediate files"
    echo "-h    Print this help"
    exit 1
}

SignalError() {
    if [ $error -eq 0 ] ; then
	echo "FAILED" 1>&2
	error=1
    fi
    echo "  $1"
}

# Compare <outfile> <reffile> <difffile>
# Compares the outfile with reffile.  Differences, if any, written to difffile
Compare() {
    generatedfiles="$generatedfiles $3"
    basen=`echo $3 | sed 's/.*\\///
                             s/.sage//'`
    cat diff -b $1 $2 ">" $3 1>&2
    diff -b "$1" "$2" > "$3" 2>&1 || {
    filen=$(basename ${basen})
	SignalError "$filen failed"
    echo "($filen)" >> $errorlog
    echo "Difference between test output and reference output" >> $errorlog
    echo "---------------------------------------------------" >> $errorlog
    cat diff -b $1 $2 ">" $3 >> $errorlog
	echo "FAILED $1 differs from $2" 1>&2
    }
}

# Run <args>
# Report the command, run it, and report any errors
Run() {
    bn=`echo $3 | sed 's/.*\\///
                             s/.sage//'`
    echo $* 1>&2
    eval $* || {
    fnrun=$(basename ${bn})
	SignalError "$fnrun failed on $*"
	return 1
    }
}

# RunFail <args>
# Report the command, run it, and expect an error
RunFail() {
    # generatedfiles="$generatedfiles $3"
    bnfail=`echo $3 | sed 's/.*\\///
                             s/.sage//'`
    namefail=$(basename ${bnfail})
    echo $* 1>&2
    eval $* && {
	SignalError "$namefail failed: did not report an error"
	return 1
    }
    return 0
}

Check() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.sage//'`
    reffile=`echo $1 | sed 's/.sage$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/."

    # echo "TEST $testnum $basename..."

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    generatedfiles=""

    generatedfiles="$generatedfiles ${basename}.ll ${basename}.s ${basename}.exe ${basename}.out" &&
    Run "$SAGE" "$1" ">" "${basename}.ll" &&
    Run "$LLC" "-relocation-model=pic" "${basename}.ll" ">" "${basename}.s" &&
    Run "$CC" "-o" "${basename}.exe" "${basename}.s" "${LIBDIR}stdlibc.o" &&
    Run "./${basename}.exe" > "${basename}.out" &&
    Compare ${basename}.out ${reffile}.out ${basename}.diff

    if [ $error -eq 0 ] ; then
	if [ $keep -eq 0 ] ; then
	    rm -f $generatedfiles
	fi
	# echo -n "PASSED"
	echo "###### SUCCESS" 1>&2
    else
	echo "###### FAILED" 1>&2
	globalerror=$error
    errcount=$((errcount+1))
    fi
}

CheckFailureExceptions() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.sage//'`
    reffile=`echo $1 | sed 's/.sage$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/."

    if [[ $tflag -eq 2 ]]; then
        let tflag++
        echo "\nChecking failure / exception handling.. (${#failtests[@]} tests)"
    fi
    # echo -n "TEST $testnum $basename..."

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    generatedfiles=""

    generatedfiles="$generatedfiles ${basename}.err ${basename}.diff" &&
    RunFail "$SAGE" "<" $1 "2>" "${basename}.err" ">>" $globallog &&
    Compare ${basename}.err ${reffile}.err ${basename}.diff

    if [ $error -eq 0 ] ; then
	if [ $keep -eq 0 ] ; then
	    rm -f $generatedfiles
	fi
	# echo -n "PASSED"
	echo "###### SUCCESS" 1>&2
    else
	echo "###### FAILED" 1>&2
	globalerror=$error
    errcount=$((errcount+1))
    fi
}

while getopts kdpsh c; do
    case $c in
	k) # Keep intermediate files
	    keep=1
	    ;;
	h) # Help
	    Usage
	    ;;
    esac
done

shift `expr $OPTIND - 1`

LLIFail() {
  echo "Could not find the LLVM interpreter \"$LLI\"."
  echo "Check your LLVM installation and/or modify the LLI variable in testall.sh"
  exit 1
}

which "$LLI" >> $globallog || LLIFail

if [ $# -ge 1 ]
then
    files=$@
else
    files="tests/tests/*.sage"
fi

for file in $files
do
    testnum=$((testnum+1))
    total=$((total+1))
    case $file in
	*/tests/*)
        if [[ $tflag -eq 0 ]]; then
            let tflag++
            echo "\nRunning tests.. (${#testfiles[@]} tests)"
        fi
	    Check $file 2>> $globallog
	    ;;
	*)
	    echo "unknown file type $file"
	    globalerror=1
	    ;;
    esac
done

if [[ $errcount -ge 1 ]]; then
    echo "\n================ PROGRAM TERMINATED ===============\n$errcount of $total tests failed\n\n"
    cat $errorlog 1>&2
    echo "================== END OF RESULTS ================="
else
    echo "\n========-- TEST CASES MATCH EXPECTED OUTPUT ========\nSUCCESS! Passed $total of $total tests\n\n"
fi
exit 0