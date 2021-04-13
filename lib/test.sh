#!/bin/bash

COMPONENT="TEST"
test_successes=0
test_failures=0

main() {
  test_num=1
  [ -n "$1" ] && RUN_TEST="$1"
  if [[ -n "$RUN_TEST" ]]; then
    /bin/echo -e "Single test mode"
    run_test "$RUN_TEST"
  else
    for testfunc in $(get_test_functions); do
      run_test "$testfunc"
      ((test_num++))
    done
  fi
  /bin/echo -e "SUCCESSFUL TESTS: $test_successes"
  /bin/echo -e "FAILED TESTS: $test_failures"
}

run_test() {
  /bin/echo -e "${BLUE}[$test_num] Running test: $1${EC}"
  bash -c "$APP_PATH/tests/runner.sh \"$1\""
  if [[ "$?" != "0" ]]; then
    ((test_failures++))
  else
    ((test_successes++))
  fi
}

source "$APP_PATH/common.sh"
source "$APP_PATH/tests/assertions.sh"
source "$APP_PATH/tests/common.sh"
source "$APP_PATH/tests/spec.sh"

main "$*"

[ "$test_failures" != "0" ] && exit 1

exit 0
