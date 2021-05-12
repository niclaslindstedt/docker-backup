#!/bin/bash

# Write current environment variables to /.env
write_environment() {
  env | sed -r 's/=/="/' | tr '\n' ';' | sed -r 's/;/"\n/g' | sudo tee .env >/dev/null

  echo "Environment written to /.env"
}
