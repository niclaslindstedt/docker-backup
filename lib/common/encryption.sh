#!/bin/bash

# Encrypts a file
# Params: <unencrypted file path>, <encrypted file target path>
encrypt() {
  should_encrypt || return 0

  log "Encrypting archive to $2"
  encrypt_file "$1" "$2" || error "Could not encrypt $1"

  create_checksum "$2"
  verify_checksum "$2"

  log "Removing unencrypted archive $1"
  remove_file "$1" "$1.sfv"
}

# Decrypts a file
# Params: <encrypted file>, <unencrypted file target path>
decrypt() {
  is_encrypted "$1" || return 0

  verify_checksum "$1"

  log "Decrypting archive $1"
  decrypt_file "$1" "$2" || error "Could not decrypt $1"
}

# Encrypts a file (adapter/implementation)
# Params: <unencrypted file path>, <encrypted file target path>
encrypt_file() {
  $(sudo_if_unwritable "$2") \
    gpg --verbose --batch --passphrase "$ENCRYPTION_PASSWORD" --output "$2" \
      -z 0 --cipher-algo "$ENCRYPTION_ALGORITHM" --symmetric "$1" 2>"$OUTPUT" || return 1
}

# Decrypts a file (adapter/implementation)
# Params: <encrypted file>, <unencrypted file target path>
decrypt_file() {
  $(sudo_if_unwritable "$2") \
    gpg --verbose --batch --passphrase "$ENCRYPTION_PASSWORD" --output "$2" \
      --decrypt "$1" 2>"$OUTPUT" || return 1
}

# Checks if an archive is encrypted
# Params: <archive filename/path>
is_encrypted() { [[ "$1" =~ \.enc$ ]]; }

# Checks if archives should be encrypted
should_encrypt() { [ "$ENCRYPT_ARCHIVES" = "$TRUE" ]; }
