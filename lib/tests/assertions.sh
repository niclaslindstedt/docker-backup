#!/bin/bash

assert_file_exists() {
  [ ! -f "$1" ] && assert_fail "Expected file to exist. It does not exist: $1"
  assert_success "File exists: $1"
}

assert_file_does_not_exist() {
  [ -f "$1" ] && assert_fail "Expected file to not exist. It exists: $1"
  assert_success "File does not exist: $1"
}

# param 1: file, param 2: string
assert_file_ends_with() {
  [ ! -f "$1" ] || assert_fail "Expected file to end with '$2'. It does not exist: $1"
  if [[ "$1" =~ "$2"$ ]]; then
    assert_success "File ends with '$2': $1"
  else
    assert_fail "Expected file to end with '$2'. It does not: $1"
  fi
}

# param 1: filename, param 2: string
assert_file_starts_with() {
  [ ! -f "$1" ] || assert_fail "Expected file to start with '$2'. It does not exist: $1"
  if [[ "$1" =~ ^"$2" ]]; then
    assert_success "File starts with '$2': $1"
  else
    assert_fail "Expected file to start with '$2'. It does not: $1"
  fi
}

# param 1: full string, param 2: substring
assert_string_starts_with() {
  if [[ "$1" =~ ^$2 ]]; then
    assert_success "String starts with '$2': $1"
  else
    assert_fail "Expected string to start with '$2'. It does not: $1"
  fi
}

# param 1: full string, param 2: substring
assert_string_ends_with() {
  if [[ "$1" =~ $2$ ]]; then
    assert_success "String ends with '$2': $1"
  else
    assert_fail "Expected string to end with '$2'. It does not: $1"
  fi
}

# param 1: full string, param 2: substring
assert_string_contains() {
  if [[ "$1" =~ .*$2.* ]]; then
    assert_success "String contains '$2': $1"
  else
    assert_fail "Expected string to contain '$2'. It does not: $1"
  fi
}

assert_false() {
  assert_equals "false" "$1"
}

assert_true() {
  assert_equals "true" "$1"
}

# param 1: expected string, param 2: actual string
assert_equals() {
  if [[ "$2" = "$1" ]]; then
    assert_success "Values are equal. Expected: $1 -- Actual: $2"
  else
    assert_fail "Values are not equal. Expected: $1 -- Actual: $2"
  fi
}

assert_success() {
  /bin/echo -e "${GREEN}Assertion successful!${EC} $*"
}

assert_fail() {
  /bin/echo -e "${RED}Assertion failed.${EC} $*"
  exit 1
}
