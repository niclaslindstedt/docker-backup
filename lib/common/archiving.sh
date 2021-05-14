#!/bin/bash

# Creates an archive from source folder contents
# Params: <archive target path>, <source folder>
pack() {
  go "$2"

    log "Creating archive at $1"
    if [[ "$ARCHIVE_TYPE" = "tgz" ]]; then
      pack_tar "$1" . || return 1
    elif [[ "$ARCHIVE_TYPE" = "7z" ]]; then
      pack_7zip "$1" . || return 1
    elif [[ "$ARCHIVE_TYPE" = "zip" ]]; then
      pack_zip "$1" . || return 1
    elif [[ "$ARCHIVE_TYPE" = "rar" ]]; then
      pack_rar "$1" . || return 1
    else
      error "Unknown archive type '$ARCHIVE_TYPE'"
    fi

    create_checksum "$1"
    verify_checksum "$1"

    encrypt "$1" "$1.enc"

  back
}

# Extracts an archive to a target path
# Params: <archive path>, <target path>
unpack() {
  local filename fileext

  target_path="${2:?}"
  filename="$BACKUP_PATH/$(basename "$1")"
  filename_clean="${filename%*.enc}"
  decrypt "$filename" "$filename_clean"
  verify_checksum "$filename_clean"

  log "Removing contents of $target_path"
  remove_file_recursive "${target_path%/}"/*

  log "Unpacking archive at $target_path"
  fileext="${filename_clean##*.}"
  if [[ "$fileext" = "tgz" ]]; then
    unpack_tar "$filename_clean" "$target_path" || return 1
  elif [[ "$fileext" = "7z" ]]; then
    unpack_7zip "$filename_clean" "$target_path" || return 1
  elif [[ "$fileext" = "zip" ]]; then
    unpack_zip "$filename_clean" "$target_path" || return 1
  elif [[ "$fileext" = "rar" ]]; then
    unpack_rar "$filename_clean" "$target_path" || return 1
  else
    error "Unknown file extension '$fileext'"
  fi
}

# Helper functions
pack_tar() { $(sudo_if_unwritable "$2") tar czfv "$1" "$2" 1>"$OUTPUT" || return 1; }
pack_7zip() { $(sudo_if_unwritable "$2") 7zr a -r "$1" "$2" 1>"$OUTPUT" || return 1; }
pack_zip() { $(sudo_if_unwritable "$2") zip -r "$1" "$2" 1>"$OUTPUT" || return 1; }
pack_rar() { $(sudo_if_unwritable "$2") rar a -r "$1" "$2" 1>"$OUTPUT" || return 1; }
unpack_tar() { $(sudo_if_unwritable "$2") tar xzfv "$1" -C "$2" 1>"$OUTPUT" || return 1; }
unpack_7zip() { $(sudo_if_unwritable "$2") 7zr x "$1" -o"$2" 1>"$OUTPUT" || return 1; }
unpack_zip() { $(sudo_if_unwritable "$2") unzip "$1" -d "$2" 1>"$OUTPUT" || return 1; }
unpack_rar() { $(sudo_if_unwritable "$2") unrar x -r "$1" "$2" 1>"$OUTPUT" || return 1; }
