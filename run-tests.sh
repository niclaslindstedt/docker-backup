#!/bin/sh

docker-compose -f docker-compose.test.yml run --rm --name backup-test backup-test
