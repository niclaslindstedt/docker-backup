#!/bin/bash

# This script will copy files from the backup
# location to the long term storage location.

COMPONENT="LTS"

main() {
  log "Starting long-term storage process"

  for file_to_store in $(find $BACKUP_PATH -type f -iname "*.tar.gz"); do
    [ -f "$file_to_store" ] && store "$file_to_store"
  done

  log "Finished long-term storage process"
}

store() {
  volume_name=$(get_volume_name "$1")
  target_path="$LTS_PATH/$volume_name"
  backup_filename=$(get_latest_backup "$volume_name")
  target_filename="$target_path/$backup_filename"
  [ ! -f "$target_filename" ] && {
    copy_backup "$backup_filename" "$target_path"
    copy_backup "$backup_filename.sfv" "$target_path"
    verify_checksum "$target_filename" || error "Checksum verification failed on $target_filename"
  }
}

copy_backup() {
  go "$BACKUP_PATH"
  [ -f "$1" ] && [ ! -f "$2/$1" ] && {
    mkdir -p "$2"
    free_space=$(get_free_space "$2")
    file_size_str=$(get_file_size_str "$1")
    log "Copying $1 ($file_size_str) to $target_path ($free_space GB left)"
    cp -n "$1" "$2" || error "Could not copy $1 to long-term storage location"
  }
  back
}

source "$APP_PATH/common.sh"

main "$1"
