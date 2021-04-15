#!/bin/bash

TEST_PATH="/tmp/0f0dddf7"
GRAY="\e[2m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
DARK_RED="\e[38;5;88m"
LIGHT_GREEN="\e[92m"
DARK_GREEN="\e[38;5;22m"
EC="\e[0m"

noop() {
  /bin/touch /dev/null
}

get_test_functions() {
  declare -F | sed -r 's/^declare \-f //g' | grep -E ^testspec_
}

set_result() {
  /bin/echo "$1" > "$TEST_PATH/test_result"
}

get_result() {
  /bin/cat "$TEST_PATH/test_result"
}

test_begin() {
  /bin/echo -e "${YELLOW}*** TEST: $* ***${EC}"
}
