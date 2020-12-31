#!/usr/bin/env bash

set -euo pipefail

TARBALL_CHECKSUM="$(shasum -a 256 "${TARBALL_FILENAME}" | cut -d ' ' -f1)"
export TARBALL_CHECKSUM
echo "TARBALL_CHECKSUM=${TARBALL_CHECKSUM}" >> "GITHUB_ENV"
echo "::set-output name=tarball_checksum::${TARBALL_CHECKSUM}"
