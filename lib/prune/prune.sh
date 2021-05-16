#!/bin/bash

# Entrypoint for prune script
run_prune() {

  is_set "$1" && {
    ! is_volume "$1" && error "'$1' is not a valid volume"
    log "Pruning backups for volume '$1'"
  }

  purge_backups "$*"
  prune_lts "$*"
}
