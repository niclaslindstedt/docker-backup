#!/bin/bash

# shellcheck disable=SC2162

# Encrypts a file
# Params: <unencrypted file path>, <encrypted file target path>
encrypt() {
  should_encrypt || return 0

  log2 "+ Encryption process started"

  log1 "Encrypting archive to $2"
  encrypt_file "$1" "$2" || error "Could not encrypt $1"
  verify_encryption "$2" || error "Could not verify encrypted archive $2"

  create_checksum "$2"
  verify_checksum "$2"

  log2 "Removing unencrypted archive $1"
  remove_file "$1"

  log2 "- Encryption process finished"

  return 0
}

# Decrypts a file
# Params: <encrypted file>, <unencrypted file target path>
decrypt() {
  local passphrase

  is_encrypted "$1" || return 0

  log2 "+ Decryption process started"

  [ ! -f "$1" ] && error "File does not exist: $1"

  verify_checksum "$1"

  log1 "Decrypting archive to $2"
  decrypt_file "$1" "$2" || {
    if [ "$ASSUME_YES" != "$TRUE" ]; then
      log "Could not decrypt $1 -- bad passphrase?"
      logn "Enter passphrase to try again: "
      read -s passphrase
      logn
      ENCRYPTION_PASSPHRASE="$passphrase"
      decrypt_file "$1" "$2" || error "Could not decrypt $1"
    else
      error "Could not decrypt $1"
    fi
  }

  log2 "- Decryption process finished"

  return 0
}

# Verifies an encrypted file by decrypting it and verifying the
# decrypted file's sfv checksum.
# Params: <encrypted file path>
verify_encryption() {
  local backup_name tmp_name

  is_encrypted "$1" || return 0

  log3 "+ Encryption verification process started"

  backup_name="${1%*.gpg}"
  tmp_name="$backup_name.tmp"
  copy_file "$backup_name.sfv.sig" "$tmp_name.sfv.sig"
  copy_file "$backup_name.sfv" "$tmp_name.sfv"

  log3 "Decrypting archive to temporary file $tmp_name"
  decrypt_file "$1" "$tmp_name"

  verify_checksum "$tmp_name"
  remove_file "$tmp_name.sfv" "$tmp_name.sfv.sig"

  log3 "- Encryption verification process finished"

  return 0
}

# Encrypts a file (adapter/implementation)
# Params: <unencrypted file path>, <encrypted file target path>
encrypt_file() {
  $(sudo_if_unwritable "$2") \
    gpg --verbose --batch --passphrase "$ENCRYPTION_PASSPHRASE" --output "$2" \
      -z 0 --cipher-algo "$ENCRYPTION_ALGORITHM" --symmetric "$1" 2>"$OUTPUT" || return 1
}

# Decrypts a file (adapter/implementation)
# Params: <encrypted file>, <unencrypted file target path>
decrypt_file() {
  $(sudo_if_unwritable "$2") \
    gpg --verbose --batch --passphrase "$ENCRYPTION_PASSPHRASE" --output "$2" \
      --decrypt "$1" 2>"$OUTPUT" || return 1
}

# Checks if an archive is encrypted
# Params: <archive filename/path>
is_encrypted() { [[ "$1" =~ \.gpg$ ]]; }

# Checks if archives should be encrypted
should_encrypt() { [ "$ENCRYPT_ARCHIVES" = "$TRUE" ]; }

# Checks if archives should be verified after being encrypted
should_verify_encryption() { [ "$VERIFY_ENCRYPTION" = "$TRUE" ]; }
