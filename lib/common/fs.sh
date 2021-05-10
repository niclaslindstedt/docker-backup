#!/bin/bash

go() { pushd "$1" 1>"$OUTPUT" || error "Could not change directory to $1"; }
back() { popd 1>"$OUTPUT" || error "Could not go back to previous path"; }

get_free_space() {
  ! is_directory "$1" && { echo "0"; return 1; }
  df -P "$1" | tail -1 | awk '{print $4}'
}

get_free_space_gb() { echo "$(($(get_free_space "$1") / 1024 / 1024))"; }

get_folder_size() {
  ! is_directory "$1" && { echo "0"; return 1; }
  du -s "$1" | awk '{print $1}'
}

get_folder_size_mb() { echo "$(($(get_folder_size "$1") / 1024))"; }
get_folder_size_gb() { echo "$(($(get_folder_size "$1") / 1024 / 1024))"; }
get_folder_size_str() { echo "$(get_folder_size_mb "$1") MB"; }

get_file_size() {
  ! is_file "$1" && { echo "0"; return 1; }
  stat -c%s "$1"
}

get_file_size_mb() { echo "$(($(get_file_size "$1") / 1024 / 1024))"; }
get_file_size_str() { echo "$(get_file_size_mb "$1") MB"; }
