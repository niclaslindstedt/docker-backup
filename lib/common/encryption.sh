#!/bin/bash

encrypt() {
  should_encrypt || return 0

  log "Encrypting archive to $2"
  $(sudo_if_unwritable "$2") openssl enc -e -v -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt \
    -k "$ENCRYPTION_PASSWORD" -in "$1" -out "$2" 2>"$OUTPUT" || error "Could not encrypt $1"

  create_checksum "$2"

  log "Removing unencrypted archive $1"
  $(sudo_if_unwritable "$1") rm -f "$1"
}

decrypt() {
  is_encrypted "$1" || return 0

  verify_checksum "$1"

  log "Decrypting archive $1"
  $(sudo_if_unwritable "$2") openssl enc -d -v -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt \
    -k "$ENCRYPTION_PASSWORD" -in "$1" -out "$2" 2>/"$OUTPUT" || error "Could not decrypt $1"
}

should_encrypt() { [ "$ENCRYPT_ARCHIVES" = "true" ]; }
is_encrypted() { [[ "$1" =~ \.enc$ ]]; }
