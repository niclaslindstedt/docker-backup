#!/bin/bash

# Entrypoint for prune script
run_prune() {
  purge_backups
  prune_lts
}
