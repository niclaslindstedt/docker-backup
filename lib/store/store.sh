#!/bin/bash

# Entrypoint for store script
run_store() {
  if is_set "$1"; then
    logv "Storing volume '$1'"
    store_volume "$1"
  else
    logv "Storing all volumes"
    store_all
  fi
}

# Copy the latest backups of each volume to long-term storage
store_all() {
  for folder in "$VOLUME_PATH"/*; do
    store_volume "$(basename "$folder")"
  done
}

# Copy the latest backups of a specific volume to long-term storage
# Params: <backup filename>
store_volume() {
  local backup_name volume_name target_path target_filename

  backup_name=$(get_latest_backup "$1")
  volume_name=$(get_volume_name "$backup_name")

  [ ! -d "$VOLUME_PATH/$1" ] || ! is_set "$volume_name" && error "Could not find volume '$1'"

  target_path="$LTS_PATH/$volume_name"
  target_filename="$target_path/$backup_name"
  if ! is_file "$target_filename"; then
    copy_backup "$BACKUP_PATH/$backup_name" "$target_path"
    verify_checksum "$target_filename" || error "Checksum verification failed on $target_filename"
  else
    log "Backup '$backup_name' has already been copied to long-term storage"
  fi
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
  if ! is_file "$2"; then # Alpine doesn't support the -n flag
    $(sudo_if_unwritable "$2") cp "$1" "$2" || return 1
  fi
}
