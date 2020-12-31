#!/usr/bin/env bash

set -euo pipefail

TARBALL_FILENAME="$(./_build_release_tarball.sh "${GIT_TAG}")"
ls -lah --color=always
export TARBALL_FILENAME
export TARBALL_FILEPATH="./${TARBALL_FILENAME}"
echo "TARBALL_FILENAME=${TARBALL_FILENAME}" >> "$GITHUB_ENV"
echo "TARBALL_FILEPATH=${TARBALL_FILEPATH}" >> "$GITHUB_ENV"
echo "::set-output name=tarball_filename::${TARBALL_FILENAME}"
echo "::set-output name=tarball_filepath::${TARBALL_FILEPATH}"
