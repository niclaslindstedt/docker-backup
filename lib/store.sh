#!/bin/bash

# This script will copy files from the backup
# location to the long-term storage location.

# shellcheck disable=SC1090,SC1091,SC2034

COMPONENT="LTS"

main() {
  log "Starting long-term storage process"

  go "$BACKUP_PATH"
    for filename in $(get_reversed_backups); do
      is_file "$filename" && store "$filename"
    done
  back

  log "Finished long-term storage process"
}

store() {
  local volume_name target_path target_filename

  volume_name=$(get_volume_name "$1")
  target_path="$LTS_PATH/$volume_name"
  target_filename="$target_path/$1"
  ! is_file "$target_filename" && {
    copy_backup "$1" "$target_path"
    verify_checksum "$target_filename" || error "Checksum verification failed on $target_filename"
  }
}

copy_backup() {
  local free_space file_size_str

  is_file "$1" && ! is_file "$2/$1" && {
    mkdir -p "$2"
    free_space=$(get_free_space "$2")
    file_size_str=$(get_file_size_str "$1")
    logv "Copying $1 ($file_size_str) to $2 ($free_space GB left)"
    cp -n "$1" "$2" || error "Could not copy $1 to long-term storage location"
    is_file "$1.sfv" && cp -n "$1.sfv" "$2"
  }
}

for f in "$APP_PATH"/common/*; do . "$f"; done

main "$1"
