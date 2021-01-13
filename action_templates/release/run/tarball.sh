#!/usr/bin/env bash

set -euo pipefail

TARBALL_FILENAME="$( ./_build_release_tarball.sh "${GIT_TAG}" "$( tr '[:upper:]' '[:lower:]' <<< "${PLATFORM_NAME}" )" )"
ls -lah
export TARBALL_FILENAME
export TARBALL_FILEPATH="./${TARBALL_FILENAME}"
echo "TARBALL_FILENAME=${TARBALL_FILENAME}" | tee -a "$GITHUB_ENV"
echo "TARBALL_FILEPATH=${TARBALL_FILEPATH}" | tee -a "$GITHUB_ENV"
echo "::set-output name=tarball_filename::${TARBALL_FILENAME}"
echo "::set-output name=tarball_filepath::${TARBALL_FILEPATH}"
