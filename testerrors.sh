#!/bin/sh

# ----------Paths------------
LIBDIR="./libc/"
LIBC="./libc/stdlibc.c"
ERRPATH="./logs/testbasic-error.log"
LOGPATH="./logs/testbasic.log"
DBUILD="./_build/"
LLI="lli"
LLC="llc"
CC="gcc"
SAGE="./sage.native"
SAGECEXEC="./sagec"

# ----------Setup------------
shopt -s nullglob
basictests=(*/basic/*.sage)
testfiles=(*/tests/*.sage)
failtests=(*/checkfail/*.sage)
ulimit -t 30
testnum=0
tflag=0
errcount=0
total=0

errorlog=$ERRPATH
globallog=$LOGPATH
rm -f $globallog
error=0
globalerror=0
keep=0

make
gcc -c -o $LIBC

echo "\n\n===================== Running Fail / Exception Handling Tests... ====================="

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
    # generatedfiles="$generatedfiles $3"
    fn=`echo $3 | sed 's/.*\\///
                             s/.sage//'`
    echo $* 1>&2
    eval $* && {
	SignalError "${fn} failed: did not report an error"
	return 1
    }
    return 0
}

CheckFailureExceptions() {
    error=0
    basename=`echo $1 | sed 's/.*\\///
                             s/.sage//'`
    reffile=`echo $1 | sed 's/.sage$//'`
    basedir="`echo $1 | sed 's/\/[^\/]*$//'`/."

    if [[ $tflag -eq 0 ]]; then
        let tflag++
        echo "Checking failure / exception handling.. (${#failtests[@]} tests)\n"
    fi
    # echo -n "TEST $testnum $basename..."

    echo "###### Testing $basename" 1>&2

    generatedfiles=""

    generatedfiles="$generatedfiles ${basename}.err ${basename}.diff" &&
    RunFail "$SAGE" "<" $1 "2>" "${basename}.err" ">>" $globallog &&
    Compare ${basename}.err ${reffile}.err ${basename}.diff

    if [ $error -eq 0 ] ; then
	if [ $keep -eq 0 ] ; then
        echo " " 1>&2
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
    files="tests/checkfail/*.sage"
fi

for file in $files
do
    testnum=$((testnum+1))
    total=$((total+1))
    case $file in
    */checkfail/*)
        CheckFailureExceptions $file 2>> $globallog
        ;;
	*)
	    echo "unknown file type $file"
	    globalerror=1
	    ;;
    esac
done

if [[ $errcount -ge 1 ]]; then
    echo "\n==================== PROGRAM TERMINATED ====================\n\t$errcount of $total tests failed\n\n"
else
    echo "\n==================== ALL ERROR MESSAGES MATCH EXPECTED OUTPUT ====================\nSUCCESS! Passed ${#failtests[@]} of ${#failtests[@]} tests\n\n"
fi
exit 0