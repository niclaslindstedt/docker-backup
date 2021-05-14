#!/bin/bash

# Entrypoint for store script
run_store() {
  local volume_name backup_name

  for folder in "$VOLUME_PATH"/*; do
    volume_name="$(basename "$folder")"

    # Get the latest of each backup and store it.
    backup_name="$(get_latest_backup "$volume_name")"
    store "$backup_name"
  done
}

# Copy the latest backups of each volume to long-term storage
# Params: <backup filename>
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

# Copy a specific backup to a target path. Take care not to violate free space requirements.
# Params: <backup path>, <target path>
copy_backup() {
  local free_space file_size_str

  is_file "$1" && ! is_file "$2/$1" && {
    mkdir -p "$2"
    free_space=$(get_free_space_gb "$2")
    file_size_str=$(get_file_size_str "$1")
    log "Copying $1 ($file_size_str) to $2 ($free_space GB left)"
    copy_file "$1" "$2" || error "Could not copy $1 to long-term storage location"
    copy_soft "$1.sfv" "$2"
  }
}

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
  $(sudo_if_unwritable "$2") cp -n "$1" "$2" || return 1
}
