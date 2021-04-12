#!/bin/bash

COMPONENT="TESTRUNNER"

source "$APP_PATH/common.sh"
source "$APP_PATH/tests/assertions.sh"
source "$APP_PATH/tests/common.sh"
source "$APP_PATH/tests/spec.sh"

eval "$1"
