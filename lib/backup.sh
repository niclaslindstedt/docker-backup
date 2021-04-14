#!/bin/bash

# This script will create tarball gzips of all
# mounted volumes in the volume location.

# shellcheck disable=SC1090,SC2034

COMPONENT="BACKUP"

main() {
  log "Starting backup process"

  is_set "$STOP_CONTAINERS" && stop_containers

  if is_not_set "$1"; then
    backup_all
  else
    is_not_directory "$VOLUME_PATH/$1" && error "Volume '$1' not found (is it mounted?)"
    backup_volume "$1"
  fi

  is_set "$STOP_CONTAINERS" && start_containers

  log "Finished backup process"
}

backup_all() {
  go "$VOLUME_PATH"
    for path_to_backup in *; do
      is_directory "$path_to_backup" && backup_volume "$path_to_backup"
    done
  back
}

backup_volume() {
  local backup_filename backup_path volume_name free_space folder_size folder_size_str backup_count backup_to_remove free_space

  backup_filename="backup-$1-$(datetime).$ARCHIVE_TYPE"
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
        rm -f "${backup_to_remove:?}"
      back
    }

    # If we still have too little storage left, exit
    free_space="$(get_free_space_gb "$BACKUP_PATH")"
    [ "$((free_space - folder_size))" -lt "$MINIMUM_FREE_SPACE" ] && {
      error "Not enough free space (have $free_space GB, need $((MINIMUM_FREE_SPACE + folder_size)) GB). Adjust prune settings or free space requirements."
    }
  }

  log "Backing up $volume_name ($folder_size_str) to $BACKUP_PATH ($free_space GB left)"
  pack "$backup_path" "$1" || error "Could not backup $backup_filename"
}

source "$APP_PATH/common.sh"

main "$1"
