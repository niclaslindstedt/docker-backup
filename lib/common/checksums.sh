#!/bin/bash

# shellcheck disable=SC2046,SC2094

create_checksum() {
  should_create_checksum || return 0

  is_file "$1" && {
    logv "Creating checksum at $1.sfv"
    $(sudo_if_unwritable "$1.sfv") cksfv -q -b "$1" > "$1.sfv" || error "Could not create checksum for $1"
  }
}

verify_checksum() {
  should_verify_checksum || return 0

  is_file "$1" && is_file "$1.sfv" && {
    logv "Verifying checksum for $1"
    cksfv -q -g "$1.sfv" || error "Could not verify checksum for $1"
  }
}

should_create_checksum() { [ "$CREATE_CHECKSUMS" = "true" ]; }
should_verify_checksum() { [ "$VERIFY_CHECKSUMS" = "true" ]; }
