#!/bin/bash
set -e
docker pull -q "php:$ACTION_PHP_VERSION"
dockerfile="FROM php:$ACTION_PHP_VERSION"

echo "DEBUG: GITHUB_ACTOR = ${GITHUB_ACTOR}"
echo "DEBUG: GITHUB_REPOSITORY = ${GITHUB_REPOSITORY}"
echo "DEBUG: GITHUB_SHA = ${GITHUB_SHA}"

echo "${ACTION_TOKEN}" | docker login docker.pkg.github.com -u "${GITHUB_ACTOR}" --password-stdin

dockerfile="${dockerfile}
ENV GREETER_NAME=\"${ACTION_NAME}\"
ADD greeter.php /app/greeter.php
CMD php /app/greeter.php
"

ACTION_NAME_NO_SPACES="${ACTION_NAME// /_}"
ACTION_NAME_NO_SPACES="${ACTION_NAME_NO_SPACES,,}"
# Tag the image with the name we've added, so it can be cached per-name.
docker_tag="docker.pkg.github.com/$GITHUB_REPOSITORY/example-docker-image:php${ACTION_PHP_VERSION}-${ACTION_NAME_NO_SPACES}"
docker pull "$docker_tag" || echo "Remote tag does not exist yet"

# Build the custom image and attempt to push it.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"
echo "$dockerfile" > Dockerfile
docker build --tag "$docker_tag" .
docker push "$docker_tag"
