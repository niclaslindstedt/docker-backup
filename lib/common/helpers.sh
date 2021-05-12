#!/bin/bash

# Checks if a directory is empty
# Params: <path>
is_not_empty() {
  ! is_directory "$1" && return 1
  [ "$(find "$1" | wc -l)" -gt 1 ]
}

# Checks if a path is a file
# Params: <path>
is_file() { [ -f "$1" ]; }

# Checks if a path is a directory
# Params: <path>
is_directory() { [ -d "$1" ]; }

# Checks if a variable has a value
# Params: <string>
is_set() { [ -n "$1" ]; }

# Checks if a path is writable to the caller
# Params: <path>
is_writable() {
  if is_directory "$1"; then
    [ -w "$1" ]
  else
    [ -w "$(dirname "$1")" ]
  fi
}

# Adds a 'sudo' before a command if
# Example: $(sudo_if_unwritable "$path") rm -rf $path
# Params: <path>
sudo_if_unwritable() {
  is_writable "$2" && echo "sudo"
}

# Checks if a file is a backup
# Params: <filename|path>
is_backup() {
  [[ "$(basename "$1")" =~ backup\-(.+?)\-[0-9]{14}\.(tgz|zip|rar|7z)(\.enc)?$ ]];
}

# Checks if a given value is a volume name
# Params: <string>
is_volume() { is_directory "$VOLUME_PATH/$1"; }
