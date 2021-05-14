#!/usr/bin/env bash

set -euo pipefail

_check_yaml() {
  local -r expr="$1"
  echo "${expr}" | dhall-to-yaml --omit-empty
}

_check_yaml '
  let Setup = ./nim/Setup.dhall

  in Setup.mkSteps Setup.Opts::{=}
'
