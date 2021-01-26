#!/usr/bin/env bash

set -euo pipefail

# NOTE: Meant to be called from the root of `actions-catalog/`, _not_ from
#       inside `.util/` itself


# | required | default_specified | type             | default_record_value | case |
# |---------:|------------------:|------------------|----------------------|-----:|
# |          |                   |                  |                      |      |
# | ~~ General ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ |
# | -- (F)   | T                 | Optional a       | None a               | 1    |
# | -- (F)   | F                 | Optional <>      | None <>              | 2    |
# | T        | T                 | --               | --                   | --   |
# | T        | F                 | Text             | --                   | 3    |
# | F        | T                 | Optional a       | None a               | 4    |
# | F        | F                 | Optional <>      | None <>              | 5    |
# |          |                   |                  |                      |      |
# | ~~ Specifics ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ |
# | F        | T                 | Optional Bool    | None Bool            | 6    |
# | F        | T                 | Optional Text    | None Text            | 7    |
# | F        | T                 | Optional Natural | None Natural         | 8    |
# | F        | T                 | Optional Integer | None Integer         | 9    |
# |          |                   |                  |                      |      |

readonly action_yaml="
  inputs:
    case_1:
      default: true
    case_2: {}
    case_3:
      required: true
    case_4:
      required: false
      default: 42
    case_5:
      required: false
    case_6:
      required: false
      default: true
    case_7:
      required: false
      default: foobar
    case_8:
      required: false
      default: 123
    case_9:
      required: false
      default: -8
  other: {}
"

_test_default() {
  echo "Checking 'default' inference..."

  # shellcheck disable=SC2016
  local -r expected='
    { case_1 = None Bool
    , case_2 = None <>

    -- note that `case_3` is not present; it should not be included in the
    -- inferred default record

    , case_4 = None Natural
    , case_5 = None <>
    , case_6 = None Bool
    , case_7 = None Text
    , case_8 = None Natural
    , case_9 = None Integer
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
    { case_1 = None Bool
    , case_2 = None <>
    , case_3 = ""
    , case_4 = None Natural
    , case_5 = None <>
    , case_6 = None Bool
    , case_7 = None Text
    , case_8 = None Natural
    , case_9 = None Integer
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
