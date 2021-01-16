#!/bin/bash
# file: init-devops.sh
# description: Download required docker images.

## Support multi-repo projects
pushd ${GITCLOUD_DEVOPS_PATH:=.}

## Fail if values are not provided
if [[ -z "${DOCKER_REGISTRY}" ]]; then
	echo '${DOCKER_REGISTRY} is required.'
	exit 1
fi

if [[ -z "${DOCKER_USERNAME}" ]]; then
	echo '${DOCKER_USERNAME} is required.'
	exit 1
fi

if [[ -z "${DOCKER_PASSWORD}" ]]; then
	echo '${DOCKER_PASSWORD} is required.'
	exit 1
fi

## Login
echo "--- Logging in to Docker Registry: ${DOCKER_REGISTRY}"
echo "--- As user: ${DOCKER_USERNAME}."

echo "${DOCKER_PASSWORD}" | ${DOCKER} login --username=${DOCKER_USERNAME} --password-stdin ${DOCKER_REGISTRY}

popd > /dev/null