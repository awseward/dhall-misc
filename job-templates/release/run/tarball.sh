#!/usr/bin/env bash

set -euo pipefail

_build="${BUILD_RELEASE_TARBALL:-./_build_release_tarball.sh}"

TARBALL_FILENAME="$( "${_build}" "${GIT_TAG}" "$( tr '[:upper:]' '[:lower:]' <<< "${PLATFORM_NAME}" )" )"
ls -lah
export TARBALL_FILENAME
export TARBALL_FILEPATH="./${TARBALL_FILENAME}"
echo "TARBALL_FILENAME=${TARBALL_FILENAME}" | tee -a "$GITHUB_ENV"
echo "TARBALL_FILEPATH=${TARBALL_FILEPATH}" | tee -a "$GITHUB_ENV"
echo "::set-output name=tarball_filename::${TARBALL_FILENAME}"
echo "::set-output name=tarball_filepath::${TARBALL_FILEPATH}"
