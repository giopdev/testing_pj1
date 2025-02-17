#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# remove old diffs
rm -rf ./testing/failed_diffs/*

# run main.bin with each file in ./testing/tests/
#   compare the output with each matching file in ./testing/diffs/
#       if matching, print pass
#       else fail and print diff to ./testing/failed_diffs/
for test_file in ./testing/tests/*; do
    filename=$(basename "$test_file")

    expected_file="./testing/diffs/${filename}"

    diff_output=$(./main.bin < "$test_file" | diff -Bw --color=always - "$expected_file")

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}PASSED${NC}: $filename"
    else
        echo -e "${RED}FAILED${NC}: $filename"

        ./main.bin < "$test_file" | diff -Bw - "$expected_file" > "./testing/failed_diffs/failed_diff_${filename}.txt"
    fi
done
