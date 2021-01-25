#!/usr/bin/env bash

# NOTE: Meant to be called from the root of `actions-catalog/`, _not_ from
#       inside `.util/` itself

set -euo pipefail

readonly owner="$1"
readonly action="$2"
readonly tag="$3"

readonly name="${owner}/${action}"

mkdir -v -p "${name}"
cp -v -R .util/template/* "${name}"

.util/fmt_package.sh "${owner}" "${action}" "${tag}" > "${name}/package.dhall"

readonly tmp_dir="$(mktemp -d)"
readonly tmp_action_yml="${tmp_dir}/action.yml"
readonly action_parsed="${tmp_dir}/action_parsed.dhall"

### Fetch action.yml

readonly action_yml_url="$(
  echo "(./.util/mkLinks.dhall \"${name}\" \"${tag}\").links.actionRaw" \
    | dhall text
)"

curl -s "${action_yml_url}" > "${tmp_action_yml}"

### Parse action.yml

yaml-to-dhall ./.util/action.yml.dhall --records-loose < "${tmp_action_yml}" \
  > "${action_parsed}"

_render_links() {
  echo -e "{-\n" \
      && dhall-to-yaml  <<< "./.util/mkLinks.dhall \"${name}\" \"${tag}\"" \
      && echo -e "\n-} -----"
}

### Infer default.dhall

( _render_links \
    && ./.util/infer_default.sh "${tmp_dir}"

) > "./${name}/Inputs/default.dhall"

### Infer Type.dhall

( _render_links \
    && ./.util/infer_Type.sh "${tmp_dir}"

)> "./${name}/Inputs/Type.dhall"
