#!/bin/bash
set -e

puma -C config/puma.rb


exec "$@"
