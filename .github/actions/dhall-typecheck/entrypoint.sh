#!/usr/bin/env bash

set -euo pipefail

temp_file="$(mktemp)"

collect_errors() {
  find . -type f -name '*.dhall' | while read -r fpath; do
    set +e
    dhall --no-cache <<< "${fpath}" > /dev/null
    set -e
  done
}

collect_errors 2> "${temp_file}"

if [ $(( $(wc -l < "${temp_file}") )) != 0 ]; then
  cat "${temp_file}"
  exit 1
fi


