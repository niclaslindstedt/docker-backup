#!/bin/bash

# shellcheck disable=SC2153

# Entrypoint for backup script
# Params: [volume name]
run_backup() {
  pause_containers "$PAUSE_CONTAINERS"

  # Backups will always be run from the volume directory
  go "$VOLUME_PATH"

    if is_set "$1"; then
      ! is_directory "$VOLUME_PATH/$1" && error "Volume '$1' not found (is it mounted?)"
      backup_volume "$1"
    else
      backup_all
    fi

  back

  unpause_containers "$PAUSE_CONTAINERS"
}

# Backup all volumes
backup_all() {
  for path_to_backup in *; do
    is_directory "$VOLUME_PATH/$path_to_backup" && backup_volume "$path_to_backup"
  done
}

# Backup a specific volume
# Params: <volume name>
backup_volume() {
  local backup_filename backup_path volume_name free_space folder_size folder_size_str backup_count backup_to_remove free_space tmp_folder tmp_backup

  ! is_directory "$VOLUME_PATH/$1"

  backup_filename="$(generate_backup_filename "$1")"
  backup_path="$BACKUP_PATH/$backup_filename"
  volume_name="$(get_volume_name "$backup_filename")"

  # Make sure we have enough free space before backing up
  free_space="$(get_free_space_gb "$BACKUP_PATH")"
  folder_size="$(get_folder_size_gb "$VOLUME_PATH/$1")"
  folder_size_str="$(get_folder_size_str "$VOLUME_PATH/$1")"
  [ "$((free_space - folder_size))" -lt "$MINIMUM_FREE_SPACE" ] && {
    log "Running out of space ($free_space GB left). Backup size is $folder_size_str."

    # Only remove older backups if there are more than 1 backup available
    backup_count="$(get_backup_count "$volume_name")"
    [ "$backup_count" -gt 1 ] && {
      # Remove oldest backup if we're running out of space
      go "$BACKUP_PATH"
        backup_to_remove="$(get_oldest_backup "$volume_name")"
        log "Removing oldest $volume_name backup before continuing ($((backup_count - 1)) left)"
        remove_file "${backup_to_remove:?}" "${backup_to_remove:?}.sfv"
      back
    }

    # If we still have too little storage left, exit
    free_space="$(get_free_space_gb "$BACKUP_PATH")"
    [ "$((free_space - folder_size))" -lt "$MINIMUM_FREE_SPACE" ] && {
      error "Not enough free space (have $free_space GB, need $((MINIMUM_FREE_SPACE + folder_size)) GB). Adjust prune settings or free space requirements."
    }
  }

  go "$VOLUME_PATH"

    tmp_folder="$(get_tmp_folder)"
    tmp_backup="$tmp_folder/$(basename "$backup_path")"
    log "Backing up $volume_name ($folder_size_str) to $BACKUP_PATH ($free_space GB left)"
    pack "$tmp_backup" "$1" || error "Could not backup $backup_filename"
    move_backup "$tmp_backup" "$BACKUP_PATH"
    rm -rfv "$tmp_folder" 1>"$OUTPUT"

  back

  should_encrypt && backup_filename+=".gpg"
  log "=> Backup finished: $backup_filename"
}
