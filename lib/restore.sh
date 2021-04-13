#!/bin/bash

# This script will restore a backup
# into its corresponding volume.

COMPONENT="RESTORE"

main() {
  log "Starting restore process"

  [ -n "$STOP_CONTAINERS" ] && stop_containers

  go "$BACKUP_PATH"
    if [[ -n "$1" ]]; then
      restore_volume "$1"
    else
      log "Restoring all volumes"
      restore_all
    fi
  back

  [ -n "$STOP_CONTAINERS" ] && start_containers

  log "Finished restore process"
}

restore_all() {
  for volume_to_restore in "$VOLUME_PATH"/*; do
    local volume=$(basename "$(eval echo "$volume_to_restore")")
    restore_volume "$volume"
  done
}

restore_volume() {
  [ ! -d "$VOLUME_PATH/$1" ] && [ ! -f "$BACKUP_PATH/$1" ] && {
    error "Volume or backup '$1' not found (is it mounted?)"
  }

  local backup_name
  local volume_name
  if [[ -f "$BACKUP_PATH/$1" ]]; then
    backup_name="$BACKUP_PATH/$1"
    volume_name="$(get_volume_name "$1")"
  elif [[ -f "$1" ]]; then
    backup_name="$1"
    volume_name="$(get_volume_name "$(basename "$1")")"
  else
    backup_name="$(get_latest_backup "$1")"
    volume_name="$1"
    [ ! -f "$backup_name" ] && error "No backups for volume: $volume_name"
  fi

  logv "Found backup '$backup_name' which belongs to volume '$volume_name'"

  local target_volume="$VOLUME_PATH/$volume_name"
  [ ! -d "$target_volume" ] && error "No such volume: $volume_name"

  # Backup existing volume contents if it's not empty
  is_not_empty "$target_volume" && {
    local backup_existing_volume="y"
    [ "$ASSUME_YES" != "true" ] && {
      loga "The volume $volume_name is not empty. Do you want to back it up before replacing its contents? [Y/n]: "
      read -r backup_existing_volume
    }
    [ "$backup_existing_volume" != "n" ] && {
      prerestore_backup_filename="$BACKUP_PATH/prerestore+$1+$(datetime).$ARCHIVE_TYPE"
      log "Backing up $volume_name to $prerestore_backup_filename"
      go "$target_volume"
        pack "$prerestore_backup_filename" . || error "Could not backup existing volume contents"
      back
    }
  }

  # Restore backup
  volume_name=$(get_volume_name "$backup_name")
  log "Restoring $volume_name backup to $target_volume"
  unpack "$backup_name" "$target_volume" || error "Could not restore $backup_name backup"
}

source "$APP_PATH/common.sh"

main "$1"
