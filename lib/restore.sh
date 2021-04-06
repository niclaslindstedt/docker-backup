#!/bin/bash

# This script will restore a backup
# into its corresponding volume.

COMPONENT="RESTORE"

main() {
  log "Starting restore process"

  stop_containers

  go "$BACKUP_PATH"

  if [[ -n "$1" ]]; then
    restore_volume "$1"
  else
    log "Restoring all volumes"
    restore_all
  fi

  back

  start_containers

  log "Finished restore process"
}

restore_all() {
  for volume_to_restore in "$VOLUME_PATH"/*; do
    volume=$(basename "$(eval echo "$volume_to_restore")")
    restore_volume "$volume"
  done
}

restore_volume() {
  [ ! -d "$VOLUME_PATH/$1" ] && [ ! -f "$BACKUP_PATH/$1" ] && {
    error "Volume or backup '$1' not found (is it mounted?)"
  }

  if [[ -f "$BACKUP_PATH/$1" ]]; then
    latest_backup="$BACKUP_PATH/$1"
    volume_name="$(get_volume_name "$1")"
  else
    latest_backup="$(get_latest_backup "$1")"
    volume_name="$1"
    [ ! -f "$latest_backup" ] && error "No backups for volume: $volume_name"
  fi

  target_volume="$VOLUME_PATH/$volume_name"
  [ ! -d "$target_volume" ] && error "No such volume: $volume_name"

  # Backup existing volume contents if it's not empty
  is_not_empty "$target_volume" && {
    printf "Volume '%s' is not empty. Do you want to back it up before replacing its contents? [Y/n]: " "$volume_name"
    read -r backup_existing_volume
    [ "$backup_existing_volume" != "n" ] && {
      log "Backing up $volume_name before restoring"
      prerestore_backup_filename="$BACKUP_PATH/prerestore+$1+$(date +"%Y%m%d%H%M").tar.gz"
      go "$target_volume"
      tar czf "$prerestore_backup_filename" . || error "Could not backup existing volume contents"
      create_checksum "$prerestore_backup_filename"
      back
    }
  }

  verify_checksum "$latest_backup" || error "Checksum verification failed on $latest_backup"

  # Remove contents of volume before restoring backup
  [ "$(ls -A "$target_volume")" ] && {
    log "Removing current volume contents"
    rm -r "${target_volume:?}"/* || error "Could not remove volume contents"
  }

  # Restore backup
  volume_name=$(get_volume_name "$latest_backup")
  log "Restoring $volume_name backup to $target_volume"
  tar xzf "$latest_backup" --directory "$target_volume" || error "Could not restore $latest_backup backup"
}

source "$APP_PATH/common.sh"

main "$1"
