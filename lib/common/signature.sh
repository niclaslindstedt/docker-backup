#!/bin/bash

# shellcheck disable=SC2162

# Creates a signature of a file
# Params: <file path>
create_signature() {
  should_create_signature || return 0

  is_file "$1" && {
    log3 "Creating file signature at $1.sig"
    create_signature_file "$1" || error "Could not create signature for $1 -- bad passphrase?"
  }

  return 0
}

# Verifies a file signature
# Params: <file path>
verify_signature() {
  should_verify_signature || return 0

  is_file "$1.sig" && {
    log3 "Verifying signature for $1"
    verify_signature_file "$1" || error "Could not verify signature for $1"
  }

  return 0
}

# Creates a signature of a file (adapter/implementation)
# Params: <file path>
create_signature_file() {
  $(sudo_if_unwritable "$1.sig") \
    gpg --yes --passphrase "$GPG_KEY_PASSPHRASE" --output "$1.sig" \
      --detach-sig "$1" 2>"$OUTPUT" || return 1
}

# Verifies a file signature (adapter/implementation)
# Params: <file path>
verify_signature_file() {
  gpg --verify "$1.sig" "$1" 2>"$OUTPUT" || return 1
}

# Checks if signatures should be created
should_create_signature() { [ "$CREATE_SIGNATURES" = "$TRUE" ]; }

# Checks if signatures should be verified
should_verify_signature() { [ "$VERIFY_SIGNATURES" = "$TRUE" ]; }
