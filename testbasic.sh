#!/bin/sh

# Regression testing script for sage (derived from MicroC)
# Step through a list of files
#  Compile, run, and check the output of each expected-to-work test
#  Compile and check the error of each expected-to-fail test

# ----------Paths------------
LIBDIR="./libc/"
LIBC="./libc/stdlibc.c"
ERRPATH="./logs/testbasic-error.log"
LOGPATH="./logs/testbasic.log"
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
basictests=(*/basic/*.sage)
testfiles=(*/tests/*.sage)
failtests=(*/checkfail/*.sage)
# Set time limit for all operations
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

echo "\n\n===================== Running Basic Tests... ====================="

Usage() {
    echo "Usage: testall.sh [options] [.native files]"
    echo "-k    Keep intermediate files"
    echo "-h    Print this help"
    exit 1
}

SignalError() {
    if [ $error -eq 0 ] ; then
	echo "FAILED"
	error=1
    fi
    echo "  $1"
}

# Compare <outfile> <reffile> <difffile>
# Compares the outfile with reffile.  Differences, if any, written to difffile
Compare() {
    generatedfiles="$generatedfiles $3"
    echo diff -b $1 $2 ">" $3 1>&2
    diff -b "$1" "$2" > "$3" 2>&1 || {
	SignalError "$1 output differs"
	echo "FAILED $1 differs from $2" 1>&2
    }
}

# Run <args>
# Report the command, run it, and report any errors
Run() {
    echo $* 1>&2
    eval $* || {
	SignalError "$1 failed on $*"
	return 1
    }
}

# RunFail <args>
# Report the command, run it, and expect an error
RunFail() {
    echo $* 1>&2
    eval $* && {
	SignalError "failed: $* did not report an error"
	return 1
    }
    return 0
}

CheckBasic() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.sage//'`
    reffile=`echo $1 | sed 's/.sage$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/."

    echo "TEST $testnum $basename..."

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
	echo -n "PASSED"
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
    files="tests/basic/*.sage"
fi

for file in $files
do
    testnum=$((testnum+1))
    total=$((total+1))
    case $file in
    */basic/*)
        if [[ $tflag -eq 0 ]]; then
            let tflag++
            echo "Running basic tests.. (${#basictests[@]} tests)\n"
        fi
        Check $file 2>> $globallog
        ;;
	*)
	    echo "unknown file type $file"
	    globalerror=1
	    ;;
    esac
done

if [[ $errcount -ge 0 ]]; then
    echo "\n==================== PROGRAM TERMINATED ====================\n\t$errcount of $total tests failed"
else
    echo "\n==================== SUCCESS! ALL BASIC TESTS PASSED ===================="
fi
exit 0