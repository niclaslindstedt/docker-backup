#!/bin/bash

# shellcheck disable=SC2153,SC2174,2034,SC2086

# Creates a .gnupg folder with an automatically generated
# gpg key or with a provided one
prepare_gnupg() {
  local signing_key

  should_create_signature || return 0

  mkdir -p --mode=700 ~/.gnupg
  {
    echo use-agent
    echo pinentry-mode loopback
  } >> ~/.gnupg/gpg.conf
  echo allow-loopback-pinentry >> ~/.gnupg/gpg-agent.conf

  signing_key="$GPG_PATH/$SIGNING_KEY"

  if should_generate_key && ! is_file "$signing_key"; then
    generate_new_key
    export_key "$signing_key"
  else
    import_key "$signing_key"
  fi
}

import_key() {
  is_file "$signing_key" || error "Signing key not found: $SIGNING_KEY"

  echo "Importing GPG signing key from $1"
  gpg --batch --import "$1" || error "Could not import signing key"
}

generate_new_key() {
  echo "Generating new GPG signing key"
  rm -rf ~/.gnupg
  mkdir -p --mode=700 ~/.gnupg
  gpg2 --batch --generate-key <<EOF
Key-Type: 1
Key-Length: $GPG_KEY_LENGTH
Subkey-Type: 1
Subkey-Length: $GPG_KEY_LENGTH
Name-Real: $GPG_KEY_NAME
Name-Email: $GPG_KEY_EMAIL
Passphrase: $SIGNING_PASSPHRASE
Expire-Date: 0
EOF
}

export_key() {
  echo "Exporting GPG signing key to $1"
  gpg --batch --pinentry-mode=loopback --passphrase "$SIGNING_PASSPHRASE" --output "$1" \
    --armor --export-secret-key "$GPG_KEY_EMAIL" || error "Could not export signing key"
}

should_generate_key() { [ "$GENERATE_GPG_KEY" = "$TRUE" ]; }
