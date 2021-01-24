#!/usr/bin/env bash

# NOTE: Meant to be called from the root of `actions-catalog/`, _not_ while
# inside `.util/` itself

set -euo pipefail

readonly owner="$1"
readonly action="$2"
readonly tag="$3"

readonly name="${owner}/${action}"

mkdir -v -p "${name}"

cp -v -R .util/template/* "${name}"

.util/fmt_package.sh "${owner}" "${action}" "${tag}" > "${name}/package.dhall"

readonly tmp_dir="$(mktemp -d)"

readonly action_yml_url="https://raw.githubusercontent.com/${name}/${tag}/action.yml"

readonly tmp_action_yml="${tmp_dir}/action.yml"
readonly tmp_action_dhall="${tmp_dir}/action_parsed.dhall"

curl -s "${action_yml_url}" > "${tmp_action_yml}"

yaml-to-dhall ./.util/action.yml.dhall --records-loose < "${tmp_action_yml}" \
  > "${tmp_action_dhall}"

readonly tmp_default_type="${tmp_dir}/default_type.dhall"

# NOTE: This is a little bonkers, and probably pretty brittle, but it more
#       or less works...
echo "./.util/fmtInputsDefault.dhall (${tmp_action_dhall}).inputs" \
  | dhall-to-yaml --preserve-null \
  | yaml-to-dhall type \
  | tail -n+2 \
  | dhall \
  > "${tmp_default_type}"

# >&2 cat "${tmp_default_type}"

( echo -e "{-\n" \
    && dhall-to-yaml  <<< "./.util/mkLinks.dhall \"${name}\" \"${tag}\"" \
    && echo -e "\n-} -----"

  echo "./.util/fmtInputsDefault2.dhall (${tmp_action_dhall}).inputs" \
    | dhall-to-yaml --preserve-null \
    | yaml-to-dhall "${tmp_default_type}"

) > "./${name}/Inputs/default.dhall"

( echo -e "{-\n" \
    && dhall-to-yaml  <<< "./.util/mkLinks.dhall \"${name}\" \"${tag}\"" \
    && echo -e "\n-} -----"

  readonly tmp_required_inputs_type="${tmp_dir}/required_inputs_type.dhall"

  # NOTE: This looks a little weird, but it more or less works...
  echo "./.util/fmtInputsType.dhall (${tmp_action_dhall}).inputs" \
    | dhall-to-yaml --preserve-null \
    | yaml-to-dhall type \
    > "${tmp_required_inputs_type}"

  dhall <<< "${tmp_required_inputs_type} ⩓ ${tmp_default_type}"

)> "./${name}/Inputs/Type.dhall"
