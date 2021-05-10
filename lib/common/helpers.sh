#!/bin/bash

is_not_empty() {
  ! is_directory "$1" && return 1
  [ "$(find "$1" | wc -l)" -gt 1 ]
}

is_file() { [ -f "$1" ]; }
is_directory() { [ -d "$1" ]; }
is_set() { [ -n "$1" ]; }
