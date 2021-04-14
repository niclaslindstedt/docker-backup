#!/bin/bash

# shellcheck disable=SC2034

ONE_HOUR=3600
ONE_DAY=$((ONE_HOUR * 24))
ONE_WEEK=$((ONE_DAY * 7))
ONE_MONTH=$((ONE_WEEK * 4))
GRAY="\e[2m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
EC="\e[0m"

log() {
  echo -e "[$COMPONENT] $*" | tee -a "$LOG_PATH"
}

loga() {
  echo -n "[$COMPONENT] $*" | tee -a "$LOG_PATH"
}

logv() {
  [ "$VERBOSE" = "true" ] && log "$*"
}

logd() {
  [ "$DEBUG" = "true" ] && log "$*"
}

error() {
  is_set "$1" && log "ERROR: $*"
  is_set "$STOP_CONTAINERS" && start_containers
  log "Exiting script"
  exit 1
}

is_not_empty() {
  is_not_directory "$1" && return 1
  [ "$(find "$1" | wc -l)" -gt 1 ] && return 0
  return 1
}

is_archive() {
  local filename

  filename=$(basename "$1")
  [[ "$filename" =~ backup\-(.+?)\-[0-9]{14}\.(tgz|zip|rar|7z|sfv)(\.sfv|\.enc)?$ ]] && return 0
  return 1
}

get_volume_name() {
  is_archive "$1" || return 1
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
  get_backups | wc -l
}

get_latest_backup() {
  go "$BACKUP_PATH"
    find . -iname "*backup-${1:-*}-??????????????.*" -not -iname "*.sfv" -printf '%f\n' | sort -r -n | head -n 1
  back
}

get_oldest_backup() {
  go "$BACKUP_PATH"
    find . -iname "*backup-${1:-*}-??????????????.*" -not -iname "*.sfv" -printf '%f\n' | sort -n | head -n 1
  back
}

get_backups() {
  go "$BACKUP_PATH"
    find . -iname "*backup-${1:-*}-??????????????.*" -not -iname "*.sfv" -printf '%f\n'
  back
}

get_reversed_backups() {
  get_backups "$1" | sort -n -r
}

get_filetime() {
  local file_date file_year file_month file_day file_hour file_minute file_second

  file_date=$(echo "$1" | grep -Eo '[[:digit:]]{14}')
  file_year=$(echo "$file_date" | cut -c1-4)
  file_month=$(echo "$file_date" | cut -c5-6)
  file_day=$(echo "$file_date" | cut -c7-8)
  file_hour=$(echo "$file_date" | cut -c9-10)
  file_minute=$(echo "$file_date" | cut -c11-12)
  file_second=$(echo "$file_date" | cut -c13-14)
  date --date "$file_year-$file_month-$file_day $file_hour:$file_minute:$file_second" +"%s"
}

create_checksum() {
  local filename

  filename="$1"
  [ "$CREATE_CHECKSUMS" = "true" ] && {
    logv "Creating checksum at $filename.sfv"
    cksfv -q -b "$filename" > "$filename.sfv" || error "Could not create checksum for $filename"
  }
}

verify_checksum() {
  local filename

  filename="$1.sfv"
  [ "$VERIFY_CHECKSUMS" = "true" ] && {
    is_not_file "$filename" && return 1
    logv "Verifying checksum $filename"
    cksfv -q -g "$filename" || error "Could not verify checksum for $1"
  }
  return 0
}

stop_containers() {
  log "Stopping containers: $STOP_CONTAINERS (timeout: $DOCKER_STOP_TIMEOUT seconds)"
  IFS=',' read -ra containers <<< "$STOP_CONTAINERS"
  for container_name in "${containers[@]}"; do
    read -r -a container_ids <<< "$(docker ps -q --filter name="${PROJECT_NAME}_$(echo "$container_name" | xargs)_")"
    is_set "${container_ids[*]}" && {
      docker stop --time "$DOCKER_STOP_TIMEOUT" ${container_ids[*]} || return 1
    }
  done
  return 0
}

start_containers() {
  log "Starting containers: $STOP_CONTAINERS"
  IFS=',' read -ra containers <<< "$STOP_CONTAINERS"
  for container_name in "${containers[@]}"; do
    read -r -a container_ids <<< "$(docker ps -aq --filter name="${PROJECT_NAME}_$(echo "$container_name" | xargs)_")"
    is_set "${container_ids[*]}" && {
      docker start ${container_ids[*]} || return 1
    }
  done
  return 0
}

pack() {
  go "$2"
    log "Creating archive at $1"
    if [[ "$ARCHIVE_TYPE" = "tgz" ]]; then
      tar czfv "$1" . 1>"$OUTPUT" || return 1
    elif [[ "$ARCHIVE_TYPE" = "7z" ]]; then
      7zr a -r "$1" . 1>"$OUTPUT" || return 1
    elif [[ "$ARCHIVE_TYPE" = "zip" ]]; then
      zip -r "$1" . 1>"$OUTPUT" || return 1
    elif [[ "$ARCHIVE_TYPE" = "rar" ]]; then
      rar a -r "$1" . 1>"$OUTPUT" || return 1
    else
      error "Unknown archive type '$ARCHIVE_TYPE'"
    fi
    create_checksum "$1"
    [ "$ENCRYPT_ARCHIVES" = "true" ] && encrypt "$1" "$1.enc"
  back
}

unpack() {
  local filename fileext

  go "$2"
    filename="${1%*.enc}"
    is_encrypted "$1" && decrypt "$1" "$filename"
    verify_checksum "$filename"

    log "Removing contents of $2"
    rm -rfv "${2:?}/*" 1>"$OUTPUT"

    log "Unpacking archive at $2"
    fileext="${filename##*.}"
    if [[ "$fileext" = "tgz" ]]; then
      tar xzfv "$filename" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "7z" ]]; then
      7zr x "$filename" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "zip" ]]; then
      unzip "$filename" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "rar" ]]; then
      unrar x -r "$filename" 1>"$OUTPUT" || return 1
    else
      error "Unknown file extension '$fileext'"
    fi
  back
}

is_encrypted() {
  local filename

  filename="$1"
  [ "${filename##*.}" = "enc" ] && {
    logv "Container is encrypted: $filename"
    return 0
  }
  return 1
}

encrypt() {
  log "Encrypting archive to $2"
  openssl enc -e -v -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt \
    -k "$ENCRYPTION_PASSWORD" -in "$1" -out "$2" 2>"$OUTPUT" || error "Could not encrypt $1"

  create_checksum "$2"

  log "Removing unencrypted archive $1"
  rm -f "$1"
}

decrypt() {
  verify_checksum "$1"

  log "Decrypting archive $1"
  openssl enc -d -v -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt \
    -k "$ENCRYPTION_PASSWORD" -in "$1" -out "$2" 2>/"$OUTPUT" || error "Could not decrypt $1"
}

datetime() {
  date +"%Y%m%d%H%M%S"
}

unixtime() {
  date +"%s"
}

go() {
  pushd "$1" 1>"$OUTPUT" || error "Could not change directory to $1"
}

back() {
  popd 1>"$OUTPUT" || error "Could not go back to previous path"
}

get_output() {
  if [[ "$DEBUG" = "true" ]]; then
    echo "/dev/stdout"
  else
    echo "/dev/null"
  fi
}

is_file() {
  [ -f "$1" ] && return 0
  return 1
}

is_not_file() {
  [ ! -f "$1" ] && return 0
  return 1
}

is_directory() {
  [ -d "$1" ] && return 0
  return 1
}

is_not_directory() {
  [ ! -d "$1" ] && return 0
  return 1
}

is_set() {
  [ -n "$1" ] && return 0
  return 1
}

is_not_set() {
  [ -z "$1" ] && return 0
  return 1
}

OUTPUT="$(get_output)"
