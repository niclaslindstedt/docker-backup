#!/bin/bash

ONE_HOUR=10
ONE_DAY=$((ONE_HOUR * 24))
ONE_WEEK=$((ONE_DAY * 7))
ONE_MONTH=$((ONE_WEEK * 4))

log() {
  echo "[$COMPONENT] $*" | tee -a "$LOG_PATH"
}

error() {
  [ -n "$1" ] && log "ERROR: $*"
  log "Exiting script"
  exit 1
}

is_not_empty() {
  [ ! -d "$1" ] && return 1
  [ "$(find "$1" | wc -l)" -gt 1 ] && return 0
  return 1
}

get_volume_name() {
  # the backup files have the format "backup-VOLUMENAME-YYYYMMDDHHmmss.tar.gz"
  echo "$1" | sed -E "s/.+?backup\-(.+?)\-.+?$/\1/g"
}

get_free_space() {
  df -BG -P "$1" | tail -1 | awk '{print $4}' | sed -E "s/G$//"
}

get_folder_size() {
  du -BG -s "$1" | awk '{print $1}' | sed -E "s/G$//"
}

get_folder_size_str() {
  echo "$(du -BM -s "$1" | awk '{print $1}' | sed -E "s/M$//") MB"
}

get_file_size() {
  echo $(($(stat -c%s "$1") / 1024 / 1024))
}

get_file_size_str() {
  echo "$(($(stat -c%s "$1") / 1024 / 1024)) MB"
}

get_backup_count() {
  go "$BACKUP_PATH"
    files=(backup-"$1"-*)
    echo ${#files[*]} | wc -l
  back
}

get_latest_backup() {
  find . -iname "*backup-*-??????????????.tar.gz" -printf '%f\n' | sort -r -n | head -n 1
}

get_oldest_backup() {
  find . -iname "*backup-*-??????????????.tar.gz" -printf '%f\n' | sort -n | head -n 1
}

get_reversed_backups() {
  find . -iname "*backup-*-??????????????.tar.gz" -printf '%f\n' | sort -n -r
}

get_filetime() {
  # the backup files have the format "backup-VOLUMENAME-YYYYMMDDHHmmss.tar.gz"
  file_date=$(echo "$1" | grep -Eo '[[:digit:]]{12}')
  file_year=$(echo "$file_date" | cut -c1-4)
  file_month=$(echo "$file_date" | cut -c5-6)
  file_day=$(echo "$file_date" | cut -c7-8)
  file_hour=$(echo "$file_date" | cut -c9-10)
  file_minute=$(echo "$file_date" | cut -c11-12)
  file_second=$(echo "$file_date" | cut -c13-14)
  date --date "$file_year-$file_month-$file_day $file_hour:$file_minute:$file_second" +"%s"
}

create_checksum() {
  [ "$CREATE_CHECKSUMS" = "true" ] && {
    log "Creating checksum for $1"
    cksfv -q -b "$1" > "$1.sfv" || return 1
  }
  return 0
}

verify_checksum() {
  [ "$VERIFY_CHECKSUMS" = "true" ] && {
    if [[ -f "$1.sfv" ]]; then
      log "Verifying checksum for $1"
      cksfv -q -g "$1.sfv" || return 1
    else
      log "No checksum file found for $1. Skipping checksum verification."
    fi
  }
  return 0
}

stop_containers() {
  [ -n "$STOP_CONTAINERS" ] && {
    log "Stopping containers"
    IFS=',' read -ra containers <<< "$STOP_CONTAINERS"
    for container_name in "${containers[@]}"; do
      read -r -a container_ids <<< "$(docker ps -q --filter name="${PROJECT_NAME}_$(echo "$container_name" | xargs)_")"
      [ -n "${container_ids[*]}" ] && {
        docker stop --time "$DOCKER_STOP_TIMEOUT" ${container_ids[*]} || return 1
      }
    done
  }
  return 0
}

start_containers() {
  [ -n "$STOP_CONTAINERS" ] && {
    log "Starting containers"
    IFS=',' read -ra containers <<< "$STOP_CONTAINERS"
    for container_name in "${containers[@]}"; do
      read -r -a container_ids <<< "$(docker ps -aq --filter name="${PROJECT_NAME}_$(echo "$container_name" | xargs)_")"
      [ -n "${container_ids[*]}" ] && {
        docker start ${container_ids[*]} || return 1
      }
    done
  }
  return 0
}

datetime() {
  date +"%Y%m%d%H%M%S"
}

unixtime() {
  date +"%s"
}

go() {
  pushd "$1" >/dev/null || error "Could not change directory to $1"
}

back() {
  popd >/dev/null || error "Could not go back to previous path"
}
