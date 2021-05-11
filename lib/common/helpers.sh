#!/bin/bash

is_not_empty() {
  ! is_directory "$1" && return 1
  [ "$(find "$1" | wc -l)" -gt 1 ]
}

is_file() { [ -f "$1" ]; }
is_directory() { [ -d "$1" ]; }
is_set() { [ -n "$1" ]; }

is_writable() {
  if is_directory "$1"; then
    [ -w "$1" ]
  else
    [ -w "$(dirname "$1")" ]
  fi
}

sudo_if_unwritable() {
  is_writable "$2" && echo "sudo"
}
