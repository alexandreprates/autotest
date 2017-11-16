#!/usr/bin/env sh

# Everytime that you save your code _Autotest_ run the tests for you
# by Alexandre Prates <ajfprates@gmail.com>
# nov/2017

# set -x

TESTABLE_EXT=py
TEST_ROOT=./tests
TEST_FILE_SULFIX=_test.py
TEST_COMMAND="python -m unittest"

function _runtest() {
    echo -e "\nchanged:\t$1\nrun test:\t$2" \
    && $TEST_COMMAND $2
}

inotifywait -r -m -e modify . |
    while read path _ file; do
        if [[ ${file##*.} == $TESTABLE_EXT ]]; then
            FILENAME=${path:2}$file
            if [ -z "${path##*$TEST_ROOT*}" ]; then
                _runtest $FILENAME $FILENAME
            else
                find $TEST_ROOT -type d -maxdepth 1 | while read dirname; do
                    BASENAME=$dirname/${FILENAME%.*}$TEST_FILE_SULFIX
                    [ -e $BASENAME ] && _runtest $FILENAME $BASENAME
                done
            fi
        fi
    done
