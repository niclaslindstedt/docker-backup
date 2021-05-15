#!/bin/bash

# shellcheck disable=SC2015,SC2046

# Write current environment variables to /.env
write_environment() {
  local env_file

  env_file="/.env"

  env | sed -r 's/=/="/' | tr '\n' ';' | sed -r 's/;/"\n/g' | sudo tee "$env_file" >/dev/null

  # Make sure we only use Docker-related settings if Docker is
  docker 2>/dev/null && {
    echo "Docker detected"
    export "DOCKER_INSTALLED=$TRUE"
    echo "DOCKER_INSTALLED=$TRUE" | sudo tee -a "$env_file" >/dev/null
  } || {
    export "DOCKER_INSTALLED=$FALSE"
    echo "DOCKER_INSTALLED=$FALSE" | sudo tee -a "$env_file" >/dev/null
    sed '/^PROJECT_NAME=.*$/d' "$env_file" | sudo tee "$env_file" >/dev/null
    sed '/^PAUSE_CONTAINERS=.*$/d' "$env_file" | sudo tee "$env_file" >/dev/null
  }

  echo "Environment written to $env_file"
}
