#!/usr/bin/env bash

set -euo pipefail

readonly owner="$1"
readonly action="$2"
readonly tag="$3"

echo "
let fmt = ./$(dirname "$0")/fmtPackage.dhall

in  fmt \"${owner}\" \"${action}\" \"${tag}\"
" | dhall text
