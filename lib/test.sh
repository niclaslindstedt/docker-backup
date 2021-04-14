#!/bin/bash

# This script will run all test functions that start with "testspec_"
# and deliver a result of the tests and their assertions.

# shellcheck disable=SC1090,SC2034

COMPONENT="TEST"

main() {
  local test_successes test_failures failed_tests total_tests test_num

  test_successes=0
  test_failures=0
  failed_tests=()
  total_tests=0
  test_num=1
  is_set "$1" && RUN_TEST="$1"

  trigger_tests
  print_summary
}

trigger_tests() {
  if is_set "$RUN_TEST"; then
    total_tests=1
    /bin/echo -e "${YELLOW}*** SINGLE TEST MODE ***${EC}\n"
    run_test "$RUN_TEST"
  else
    total_tests=$(get_test_functions | wc -l)
    for testfunc in $(get_test_functions); do
      run_test "$testfunc"
      ((test_num++))
    done
  fi
}

run_test() {
  /bin/echo -e "${BLUE}[$test_num/$total_tests] Running test: $1${EC}"
  if /bin/bash -c "$APP_PATH/tests/runner.sh \"$1\""; then
    ((test_successes++))
  else
    ((test_failures++))
    failed_tests+=("$1")
  fi
  /bin/echo
}

print_summary() {
  /bin/echo -e "${GREEN}SUCCESSFUL TESTS: $test_successes${EC}"
  if [ "${#test_failures[@]}" -gt 0 ]; then
    /bin/echo -e "${GRAY}FAILED TESTS: $test_failures${EC}"
  else
    /bin/echo -e "${RED}FAILED TESTS: $test_failures${EC}"
    /bin/echo -e "${YELLOW}LIST OF FAILED TESTS:${EC}"
    for test in "${failed_tests[@]}"; do
      /bin/echo -e "${YELLOW}$test${EC}"
    done
  fi
}

source "$APP_PATH/common.sh"
source "$APP_PATH/tests/assertions.sh"
source "$APP_PATH/tests/common.sh"
source "$APP_PATH/tests/spec.sh"

main "$*"

[ "$test_failures" != "0" ] && exit 1

exit 0
