#!/usr/bin/env bash

# NOTE: Meant to be called from the root of `actions-catalog/`, _not_ from
#       inside `.util/` itself

readonly action_yaml='
  inputs:
    reqd:
      required: true
    optl-natural:
      required: false
      default: 5
    optl-implicit-bool:
      default: true
    optl-any:
      required: false
  unrelated: {}
'

_test_default() {
  echo "Checking 'default' inference..."

  # shellcheck disable=SC2016
  local -r expected='
    { optl-any = None <>
    , optl-implicit-bool = None Bool
    , optl-natural = None Natural

    -- note that `reqd` is not present; it should not be included in the inferred
    -- default record

    }
  '
  local -r actual="$(./.util/infer_default.sh "${tmp_dir}")"

  echo "assert : ${expected} === ${actual}" \
    | dhall lint \
    | dhall
}

_test_type() {
  echo "Checking 'Type' inference..."

  # shellcheck disable=SC2016
  local -r valid_instance='
    { optl-any = None <>
    , optl-implicit-bool = None Bool
    , optl-natural = None Natural
    , reqd = ""
    }
  '

  local -r inferred_type="$(./.util/infer_Type.sh "${tmp_dir}")"

  echo "${valid_instance} : ${inferred_type}" \
    | dhall lint \
    | dhall type
}

### Setup

readonly tmp_dir="$(mktemp -d)"
readonly tmp_action_parsed="${tmp_dir}/action_parsed.dhall"

echo "${action_yaml}" \
  | yaml-to-dhall ./.util/action.yml.dhall --records-loose \
  > "${tmp_action_parsed}"

### ---

_test_default
_test_type
