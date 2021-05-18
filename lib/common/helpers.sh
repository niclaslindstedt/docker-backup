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

# Adds a 'sudo' before a command if the destination path
# is not writable by the caller
# Example: $(sudo_if_unwritable "$path") rm -rf $path
# Params: <path>
sudo_if_unwritable() {
  if [ -d "$1" ] && [ ! -w "$1" ] || [ ! -w "$(dirname "$1")" ]; then
    echo "sudo"
  fi
}

# Checks if a file is a backup
# Params: <filename|path>
is_backup() {
  [[ "$(basename "$1")" =~ backup\-(.+?)\-[0-9]{14}\.(tgz|zip|rar|7z)(\.enc)?$ ]];
}

# Checks if a file is a backup
# Params: <filename|path>
is_prerestore_backup() {
  [[ "$(basename "$1")" =~ prerestore\+.+?\+[0-9]{14}\.(tgz|zip|rar|7z)(\.enc)?$ ]];
}

# Checks if a given value is a volume name
# Params: <string>
is_volume() { is_directory "$VOLUME_PATH/$1"; }
