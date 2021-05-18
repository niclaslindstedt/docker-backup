#!/bin/bash

# Change working directory and error out if it's not possible
# Params: <path>
go() { pushd "$1" >/dev/null || error "Could not change directory to $1"; }

# Go back to latest working directory and error out if it's not possible
back() { popd >/dev/null || error "Could not go back to previous path"; }


# Copy file if source file exists
# Params: <source file path>, <target path>
copy_soft() {
  if is_file "$1"; then
    copy_file "$1" "$2" || return 1
  fi
  return 0
}

# Copy a file with sudo if needed
# Params: <source file path>, <target path>
copy_file() {
  if ! is_file "$2"; then # Alpine doesn't support the -n flag
    logv "Copying $1 to $2"
    $(sudo_if_unwritable "$2") cp "$1" "$2" || return 1
  fi
}

# Remove files with sudo if needed
# Params: ...<file paths>
remove_file() {
  # shellcheck disable=SC2048
  for file in $*; do
    $(sudo_if_unwritable "$file") rm -fv "$file" 1>"$OUTPUT"
  done
}

# Remove files (recursively) with sudo if needed
# Params: ...<file paths>
remove_file_recursive() {
  # shellcheck disable=SC2048
  for file in $*; do
    $(sudo_if_unwritable "$file") rm -rfv "$file" 1>"$OUTPUT"
  done
}

# Move a file to a target path with sudo if needed -- do not overwrite existing files
# Params: <source file>, <target path>
move_file_noclutter() {
  if is_file "$2" || is_file "${2%/}/$(basename "$1")"; then
    logd "File already exists at $2, not moving"
    return 1
  fi

  if is_file "$1"; then
    logv "Moving $1 to $2"
    move_file "$1" "$2"
  else
    logd "No file to move at $1"
  fi

  return 0
}

# Move a file with sudo if needed
# Params: <source file>, <target path>
move_file() {
  $(sudo_if_unwritable "$2") mv -v "$1" "$2" 1>"$OUTPUT"
}

# Get free space (in bytes) in a folder (+ variants)
# Params: <path>
get_free_space() {
  ! is_directory "$1" && { echo "0"; return 1; }
  df -P "$1" | tail -1 | awk '{print $4}'
}
get_free_space_gb() { echo "$(($(get_free_space "$1") / 1024 / 1024))"; }

# Get folder size (+ variants)
# Params: <path>
get_folder_size() {
  ! is_directory "$1" && { echo "0"; return 1; }
  du -s "$1" | awk '{print $1}'
}
get_folder_size_mb() { echo "$(($(get_folder_size "$1") / 1024))"; }
get_folder_size_gb() { echo "$(($(get_folder_size "$1") / 1024 / 1024))"; }
get_folder_size_str() { echo "$(get_folder_size_mb "$1") MB"; }

# Get file size (+ variants)
# Params: <path>
get_file_size() {
  ! is_file "$1" && { echo "0"; return 1; }
  stat -c%s "$1"
}
get_file_size_mb() { echo "$(($(get_file_size "$1") / 1024 / 1024))"; }
get_file_size_str() { echo "$(get_file_size_mb "$1") MB"; }
