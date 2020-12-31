#!/usr/bin/env bash

set -euo pipefail

export GIT_TAG="${GITHUB_REF/refs\/tags\//}"
echo "GIT_TAG=${GIT_TAG}" >> "$GITHUB_ENV"
echo "::set-output name=git_tag::${GIT_TAG}"
