#!/usr/bin/env bash

set -euo pipefail

readonly tmp_dir="$1"
readonly action_parsed="${2:-"${tmp_dir}/action_parsed.dhall"}"

readonly tmp_type_default="${tmp_dir}/default_type.dhall"

# NOTE: This is a little bonkers, and probably pretty brittle, but it more
#       or less works...
echo "./.util/fmtInputsDefault.dhall (${action_parsed}).inputs" \
  | dhall-to-yaml --preserve-null \
  | yaml-to-dhall type \
  | tail -n+2 \
  | dhall \
  > "${tmp_type_default}"

echo "./.util/fmtInputsDefault2.dhall (${action_parsed}).inputs" \
  | dhall-to-yaml --preserve-null \
  | yaml-to-dhall "${tmp_type_default}"
