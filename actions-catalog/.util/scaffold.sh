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

readonly tmp_action_yml="$(mktemp)"
readonly type_file="${name}/Inputs/Type.dhall"

(
  echo '{-' \
    && curl "https://raw.githubusercontent.com/${name}/${tag}/action.yml" -s \
    && echo '-}' \
    && echo '--' \
    && cat "${type_file}"
) > "${tmp_action_yml}"

mv -vf "${tmp_action_yml}" "${type_file}"

echo git add -N "${name}"
