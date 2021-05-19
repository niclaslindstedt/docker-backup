#!/bin/bash

# shellcheck disable=SC2153

# Entrypoint for restore script
# Params: [volume]
run_restore() {
  pause_containers "$PAUSE_CONTAINERS"

  go "$BACKUP_PATH"
    if is_set "$1"; then
      restore_volume "$1"
    else
      log "Restoring all volumes"
      restore_all
    fi
  back

  unpause_containers "$PAUSE_CONTAINERS"
}

# Restore all volumes to their latest backup
restore_all() {
  local volume
  for volume_to_restore in "$VOLUME_PATH"/*; do
    volume=$(basename "$(eval echo "$volume_to_restore")")
    restore_volume "$volume"
  done
}

# Restore a specific volume to its latest backup or to a specific backup
# Params: [volume|backup filename]
restore_volume() {
  local backup_path volume_name target_volume backup_existing_volume tmp_folder tmp_backup

  ! is_set "$1" && error "You have to provide a volume name or backup filename"

  volume_name="$(get_volume_name "$1")"

  if [ -d "$VOLUME_PATH/$1" ]; then

    logd "Restoring latest backup of volume '$1'"
    backup_path="$BACKUP_PATH/$(get_latest_backup "$1")"
    volume_name="$1"
    [ ! -f "$backup_path" ] && error "No backups for volume: $volume_name"

  elif [ -f "$BACKUP_PATH/$1" ]; then

    logd "Restoring specific backup '$1'"
    backup_path="$BACKUP_PATH/$1"

  elif [ -f "$LTS_PATH/$volume_name/$1" ]; then

    logd "Restoring specific long-term backup '$1'"
    backup_path="$LTS_PATH/$volume_name/$1"

  else error "Volume or backup '$1' not found (is it mounted?)"
  fi

  log1 "Found backup '$backup_path' which belongs to volume '$volume_name'"

  target_volume="$VOLUME_PATH/$volume_name"
  [ ! -d "$target_volume" ] && error "No such volume: $volume_name"

  # Backup existing volume contents if it's not empty
  is_not_empty "$target_volume" && {
    backup_existing_volume="y"
    [ "$ASSUME_YES" != "$TRUE" ] && {
      logn "The volume '$volume_name' is not empty. Do you want to back it up before replacing its contents? [Y/n]: "
      read -r backup_existing_volume
    }
    [ "$backup_existing_volume" != "n" ] && {
      folder_size_str="$(get_folder_size_str "$VOLUME_PATH/$volume_name")"
      prerestore_backup_filename="prerestore+$1+$(datetime).$ARCHIVE_TYPE"
      tmp_folder="$(get_tmp_folder)"
      tmp_backup="$tmp_folder/$prerestore_backup_filename"
      log1 "Backing up $volume_name ($folder_size_str) to $prerestore_backup_filename"
      pack "$tmp_backup" "$target_volume" || error "Could not backup existing volume contents"
      move_backup "$tmp_backup" "$BACKUP_PATH"
      rm -rfv "$tmp_folder" 1>"$OUTPUT"
    }
  }

  # Restore backup
  volume_name="$(get_volume_name "$backup_path")"
  tmp_folder="$(get_tmp_folder)"
  tmp_backup="$tmp_folder/$(basename "$backup_path")"
  log "Restoring backup of volume '$volume_name' to $target_volume"
  copy_backup "$backup_path" "$tmp_folder"
  unpack "$tmp_backup" "$target_volume" || error "Could not restore $backup_path"
  rm -rfv "$tmp_folder" 1>"$OUTPUT"
}
