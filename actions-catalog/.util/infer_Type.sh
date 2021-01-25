#!/usr/bin/env bash

set -euo pipefail

readonly tmp_dir="$1"
readonly action_parsed="${2:-"${tmp_dir}/action_parsed.dhall"}"

readonly tmp_type_default="${tmp_dir}/default_type.dhall"
readonly tmp_type_required="${tmp_dir}/required_inputs_type.dhall"

# NOTE: This looks a little weird, but it more or less works...
echo "./.util/fmtInputsType.dhall (${action_parsed}).inputs" \
  | dhall-to-yaml --preserve-null \
  | yaml-to-dhall type \
  > "${tmp_type_required}"

dhall <<< "${tmp_type_required} ⩓ ${tmp_type_default}"
