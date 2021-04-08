#!/bin/bash

# This script will create tarball gzips of all
# mounted volumes in the volume location.

COMPONENT="BACKUP"

main() {
  log "Starting backup process"

  stop_containers

  if [[ -z "$1" ]]; then
    backup_all
  else
    [ ! -d "$VOLUME_PATH/$1" ] && error "Volume '$1' not found (is it mounted?)"
    backup_volume "$1"
  fi

  start_containers

  log "Finished backup process"
}

backup_all() {
  go "$VOLUME_PATH"
    for path_to_backup in *; do
      [ -d "$path_to_backup" ] && backup_volume "$path_to_backup"
    done
  back
}

backup_volume() {
  backup_filename="backup-$1-$(datetime).tar.gz"
  backup_path="$BACKUP_PATH/$backup_filename"
  volume_name="$(get_volume_name "$backup_filename")"

  # Make sure we have enough free space before backing up
  free_space="$(get_free_space "$BACKUP_PATH")"
  folder_size="$(get_folder_size "$VOLUME_PATH/$1")"
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
    free_space="$(get_free_space "$BACKUP_PATH")"
    [ "$((free_space - folder_size))" -lt "$MINIMUM_FREE_SPACE" ] && {
      error "Not enough free space (have $free_space GB, need $((MINIMUM_FREE_SPACE + folder_size)) GB). Adjust purge settings or free space requirements."
    }
  }

  # Create a tarball gzip at the backup location
  log "Backing up $volume_name ($folder_size_str) to $backup_path ($free_space GB left)"
  tar czf "$backup_path" "$1" || error "Could not backup $backup_filename"

  create_checksum "$backup_path" || "Could not create checksum for $backup_filename"
}

source "$APP_PATH/common.sh"

main "$1"
