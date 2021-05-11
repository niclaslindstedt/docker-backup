#!/bin/bash

run_store() {
  local volume_name backup_name

  for folder in "$VOLUME_PATH"/*; do
    volume_name="$(basename "$folder")"

    # Get the latest of each backup and store it.
    backup_name="$(get_latest_backup "$volume_name")"
    store "$backup_name"

  done
}

store() {
  local volume_name target_path target_filename

  go "$BACKUP_PATH"
    volume_name=$(get_volume_name "$1")
    target_path="$LTS_PATH/$volume_name"
    target_filename="$target_path/$1"
    ! is_file "$target_filename" && {
      copy_backup "$1" "$target_path"
      verify_checksum "$target_filename" || error "Checksum verification failed on $target_filename"
    }
  back
}

copy_backup() {
  local free_space file_size_str

  is_file "$1" && ! is_file "$2/$1" && {
    mkdir -p "$2"
    free_space=$(get_free_space_gb "$2")
    file_size_str=$(get_file_size_str "$1")
    log "Copying $1 ($file_size_str) to $2 ($free_space GB left)"
    copy_file "$1" "$2"
    copy_soft "$1.sfv" "$2"
  }
}

copy_soft() {
  is_file "$1" && copy_file "$1" "$2"
}

copy_file() {
  $(is_writable "$2" && echo "sudo") cp -n "$1" "$2" || error "Could not copy $1 to long-term storage location"
}
