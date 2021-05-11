#!/bin/bash

# This script will run all test functions that start with "test__"
# and deliver a result of the tests and their assertions.

# shellcheck disable=SC1090,SC1091,SC2034,SC2153

COMPONENT="TEST"

main() {
  local test_successes test_failures failed_tests total_tests test_num

  test_successes=0
  test_failures=0
  failed_tests=()
  total_tests=0
  test_num=1
  is_set "$1" && is_test "$1" && RUN_TEST="$1"

  trigger_tests
  print_summary

  [ "$test_failures" != "0" ] && exit 1

  exit 0
}

trigger_tests() {
  if is_set "$RUN_TEST"; then
    ! function_exists "$RUN_TEST" && {
      /bin/echo -e "${RED}The test $RUN_TEST does not exist.${EC}"
      exit 1
    }
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
  function_exists "__before_all" && __before_all
  test_path="$TEST_PATH/$(uuidgen)"
  /bin/mkdir -p "$test_path" && cd "$test_path" || exit 1
  /bin/echo -e "${BLUE}[$test_num/$total_tests] Running test: $1${EC}"
  if (COMPONENT="TESTRUNNER" eval "$1"); then
    ((test_successes++))
    /bin/echo -e "${LIGHT_GREEN}Test successful!${EC}"
  else
    ((test_failures++))
    failed_tests+=("$1")
    /bin/echo -e "${RED}Test failed.${EC}"
  fi
  /bin/echo
}

print_summary() {
  /bin/echo -e "${GREEN}SUCCESSFUL TESTS: $test_successes${EC}"
  if [ "$test_failures" -gt 0 ]; then
    /bin/echo -e "${RED}FAILED TESTS: $test_failures${EC}"
    /bin/echo -e "${YELLOW}LIST OF FAILED TESTS:${EC}"
    for test in "${failed_tests[@]}"; do
      /bin/echo -e "${YELLOW}$test${EC}"
    done
  else
    /bin/echo -e "${GRAY}FAILED TESTS: $test_failures${EC}"
    /bin/echo -e "\n${LIGHT_GREEN}OK${EC}"
  fi
}

function_exists() {
  type -t "$1" >/dev/null && return 0
  return 1
}

load() {
  /bin/echo -e "${YELLOW}Loading file: $1${EC}"
  source "$1"
}

load "$APP_PATH/tests/assertions.sh"
load "$APP_PATH/tests/common.sh"
  for spec in "$APP_PATH/tests/specs/"__*.sh; do
    load "$spec"
  done
if is_spec "$RUN_SPEC"; then
  load "$APP_PATH/tests/specs/$RUN_SPEC"*
else
  for spec in "$APP_PATH/tests/specs/"*; do
    [[ "$spec" =~ ^[^_].*_spec\.sh$ ]] && load "$spec"
  done
fi
/bin/echo

main "$*"
