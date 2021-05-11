#!/bin/bash

pack() {
  go "$2"
    log "Creating archive at $1"
    if [[ "$ARCHIVE_TYPE" = "tgz" ]]; then
      $(sudo_if_unwritable .) tar czfv "$1" . 1>"$OUTPUT" || return 1
    elif [[ "$ARCHIVE_TYPE" = "7z" ]]; then
      $(sudo_if_unwritable .) 7zr a -r "$1" . 1>"$OUTPUT" || return 1
    elif [[ "$ARCHIVE_TYPE" = "zip" ]]; then
      $(sudo_if_unwritable .) zip -r "$1" . 1>"$OUTPUT" || return 1
    elif [[ "$ARCHIVE_TYPE" = "rar" ]]; then
      $(sudo_if_unwritable .) rar a -r "$1" . 1>"$OUTPUT" || return 1
    else
      error "Unknown archive type '$ARCHIVE_TYPE'"
    fi
    create_checksum "$1"
    encrypt "$1" "$1.enc"
  back
}

unpack() {
  local filename fileext

  volume_path="${2:?}"
  filename="$BACKUP_PATH/$(basename "$1")"
  filename_clean="${filename%*.enc}"
  decrypt "$filename" "$filename_clean"
  verify_checksum "$filename_clean"

  log "Removing contents of $volume_path"
  $(sudo_if_unwritable "$volume_path") rm -rfv "${volume_path%/}"/*

  go "$volume_path"

    log "Unpacking archive at $2"
    fileext="${filename_clean##*.}"
    if [[ "$fileext" = "tgz" ]]; then
      $(sudo_if_unwritable .) tar xzfv "$filename_clean" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "7z" ]]; then
      $(sudo_if_unwritable .) 7zr x "$filename_clean" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "zip" ]]; then
      $(sudo_if_unwritable .) unzip "$filename_clean" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "rar" ]]; then
      $(sudo_if_unwritable .) unrar x -r "$filename_clean" 1>"$OUTPUT" || return 1
    else
      error "Unknown file extension '$fileext'"
    fi

  back
}
