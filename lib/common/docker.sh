#!/bin/bash

get_container_filter() {
  echo "$(echo "${PROJECT_NAME}" | xargs)_$(echo "$1" | xargs)_"
}

get_container_ids() {
  docker ps -q --filter name="$(get_container_filter "$1")"
}

get_all_container_ids() {
  docker ps -aq --filter name="$(get_container_filter "$1")"
}

pause_containers() {
  log "Pausing containers: $1"
  IFS=',' read -ra containers <<< "$1"
  for container_name in "${containers[@]}"; do
    read -ra container_ids <<< "$(get_container_ids "$container_name")"
    is_set "${container_ids[*]}" && {
      # shellcheck disable=SC2086
      docker pause ${container_ids[*]} || return 1
    }
  done
}

unpause_containers() {
  log "Unpausing containers: $1"
  IFS=',' read -ra containers <<< "$1"
  for container_name in "${containers[@]}"; do
    read -ra container_ids <<< "$(get_all_container_ids "$container_name")"
    is_set "${container_ids[*]}" && {
      # shellcheck disable=SC2086
      docker unpause ${container_ids[*]} || return 1
    }
  done
}
