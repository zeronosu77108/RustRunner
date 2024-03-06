#!/bin/bash
set -e

# rackup 起動
rackup -o "0.0.0.0"

exec "$@"
