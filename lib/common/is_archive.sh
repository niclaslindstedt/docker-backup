#!/bin/bash

is_archive() {
  [[ "$(basename "$1")" =~ backup\-(.+?)\-[0-9]{14}\.(tgz|zip|rar|7z)(\.enc)?$ ]];
}
