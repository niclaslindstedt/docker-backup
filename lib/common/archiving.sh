#!/bin/bash

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

  filename="${1%*.enc}"
  is_encrypted "$1" && decrypt "$1" "$filename"
  verify_checksum "$filename"

  log "Removing contents of $2"
  sudo rm -rfv "${2:?}/*" 1>"$OUTPUT"

  go "$2"

    log "Unpacking archive at $2"
    fileext="${filename##*.}"
    if [[ "$fileext" = "tgz" ]]; then
      sudo tar xzfv "$filename" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "7z" ]]; then
      sudo 7zr x "$filename" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "zip" ]]; then
      sudo unzip "$filename" 1>"$OUTPUT" || return 1
    elif [[ "$fileext" = "rar" ]]; then
      sudo unrar x -r "$filename" 1>"$OUTPUT" || return 1
    else
      error "Unknown file extension '$fileext'"
    fi
  back
}

is_encrypted() { [[ "$1" =~ \.enc$ ]]; }
