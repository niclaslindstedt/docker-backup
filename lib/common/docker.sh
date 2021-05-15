#!/bin/bash

# Pauses containers associated to a list of service names
# Params: <service names (comma-separated>
pause_containers() {
  should_pause_containers || return 0

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

# Unpauses containers associated to a list of service names
# Params: <service names (comma-separated>
unpause_containers() {
  should_pause_containers || return 0

  log "Unpausing containers: $1"
  IFS=',' read -ra containers <<< "$1"
  for container_name in "${containers[@]}"; do
    read -ra container_ids <<< "$(get_paused_container_ids "$container_name")"
    is_set "${container_ids[*]}" && {
      # shellcheck disable=SC2086
      docker unpause ${container_ids[*]} || return 1
    }
  done
}

# Returns a container filter to find containers associated to a service
# Params: <service name>
get_container_filter() {
  echo "$(echo "${PROJECT_NAME}" | xargs)_$(echo "$1" | xargs)_"
}

# Returns a list of associated running container ids
# Params: <service name>
get_container_ids() {
  docker ps -q --filter name="$(get_container_filter "$1")"
}

# Returns a list of associated container ids (stopped containers too)
# Params: <service name>
get_paused_container_ids() {
  docker ps -q --filter status=paused --filter name="$(get_container_filter "$1")"
}

# Checks if containers should be paused
should_pause_containers() {
  is_set "$PAUSE_CONTAINERS"
}
