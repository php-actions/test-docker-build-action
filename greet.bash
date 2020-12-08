#!/bin/bash
set -e
ACTION_NAME_NO_SPACES="${ACTION_NAME// /_}"
ACTION_NAME_NO_SPACES="${ACTION_NAME_NO_SPACES,,}"
docker_tag="docker.pkg.github.com/$GITHUB_REPOSITORY/example-docker-image:php${ACTION_PHP_VERSION}-${ACTION_NAME_NO_SPACES}"
docker run --rm "$docker_tag"
