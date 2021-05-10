#!/bin/bash

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
