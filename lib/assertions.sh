#!/bin/bash

assert_file_exists() {
  [ ! -f "$1" ] && assert_fail "Expected file to exist. It does not exist: $1"
  assert_success "File exists: $1"
}

assert_file_does_not_exist() {
  [ -f "$1" ] && assert_fail "Expected file to not exist. It exists: $1"
  assert_success "File does not exist: $1"
}

assert_file_ends_with() {
  [ ! -f "$1" ] || assert_fail "Expected file to end with '$2'. It does not exist: $1"
  if [[ "$1" =~ "$2"$ ]]; then
    assert_success "File ends with '$2': $1"
  else
    assert_fail "Expected file to end with '$2'. It does not: $1"
  fi
}

assert_success() {
  log "${GREEN}Assertion successful!${EC} $*"
}

assert_fail() {
  TEST_SUCCESS="false"
  error "${RED}Assertion failed.${EC} $*"
}
