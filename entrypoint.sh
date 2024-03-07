#!/bin/bash
set -e

# rackup 起動
rerun 'rackup -o "0.0.0.0"'

exec "$@"
