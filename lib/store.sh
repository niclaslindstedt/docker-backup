#!/bin/bash

# This script will copy files from the backup
# location to the long-term storage location.

COMPONENT="LTS"

main() {
  log "Starting long-term storage process"

  go "$BACKUP_PATH"
    for filename in $(get_reversed_backups); do
      [ -f "$filename" ] && store "$filename"
    done
  back

  log "Finished long-term storage process"
}

store() {
  volume_name=$(get_volume_name "$1")
  target_path="$LTS_PATH/$volume_name"
  target_filename="$target_path/$backup_filename"
  [ ! -f "$target_filename" ] && {
    copy_backup "$backup_filename" "$target_path"
    verify_checksum "$target_filename" || error "Checksum verification failed on $target_filename"
  }
}

copy_backup() {
  [ -f "$1" ] && [ ! -f "$2/$1" ] && {
    mkdir -p "$2"
    free_space=$(get_free_space "$2")
    file_size_str=$(get_file_size_str "$1")
    log "Copying $1 ($file_size_str) to $2 ($free_space GB left)"
    cp -n "$1" "$2" || error "Could not copy $1 to long-term storage location"
    [ -f "$1.sfv" ] && cp -n "$1.sfv" "$2"
  }
}

source "$APP_PATH/common.sh"

main "$1"
