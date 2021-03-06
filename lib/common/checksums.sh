#!/bin/bash

# shellcheck disable=SC2046,SC2094

# Creates a checksum for a file
# Params: <filename>
create_checksum() {
  should_create_checksum || return 0

  log3 "+ Checksum creation process started"

  is_file "$1" && {
    log2 "Creating checksum at $1.sfv"
    create_sfv "$1" || error "Could not create checksum for $1"
    create_signature "$1.sfv"
  }

  log3 "- Checksum creation process finished"
}

# Verifies a file's checksum if an sfv file exists
# Params: <filename>
verify_checksum() {
  should_verify_checksum || return 0

  log3 "+ Checksum verification process started"

  is_file "$1" && is_file "$1.sfv" && {
    verify_signature "$1.sfv"
    log3 "Verifying checksum for $1"
    verify_sfv "$1" || error "Could not verify checksum for $1"
  }

  log3 "- Checksum verification process finished"
}

# Creates an sfv file (adapter/implementation)
# Params: <filename>
create_sfv() { $(sudo_if_unwritable "$1.sfv") cksfv -q -b "$1" > "$1.sfv" || return 1; }

# Verifies an sfv file (adapter/implementation)
# Params: <filename>
verify_sfv() { cksfv -q -g "$1.sfv" || return 1; }

# Checks if checksums should be created
should_create_checksum() { [ "$CREATE_CHECKSUMS" = "$TRUE" ]; }

# Checks if checksums should be verified
should_verify_checksum() { [ "$VERIFY_CHECKSUMS" = "$TRUE" ]; }
