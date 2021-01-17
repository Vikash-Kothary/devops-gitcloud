#!/bin/bash
# file: release-devops.sh
# description: Tag images and push to Registry.

release_image () {
	SERVICE=$1

	echo "[RELEASE] Building Service: ${SERVICE}."

	pushd services/${SERVICE}/images > /dev/null

	BUILD_DOCKER_IMAGE=${SERVICE}:latest
	docker pull ${BUILD_DOCKER_IMAGE}
	
	# With Software Version
	SOFTWARE_VERSION=0.1.0
	export DOCKER_IMAGE=${DOCKER_REGISTRY}/${SERVICE}-${SOFTWARE_VERSION}
	export DOCKER_VERSION=latest
	echo "--- Tag 1: ${DOCKER_IMAGE}:${DOCKER_VERSION}"
	docker tag "${BUILD_DOCKER_IMAGE}" "${DOCKER_IMAGE}:${DOCKER_VERSION}"
	docker push "${DOCKER_IMAGE}:${DOCKER_VERSION}"

	# Exit with error if push fails
	if [[ $? == 1 ]]; then
		exit 1
	fi

	# With Software Version and Docker Version
	GIT_COMMIT_SHORT_SHA=$(git rev-parse --short HEAD)
	export DOCKER_VERSION="$(date +%Y.%m)-${GIT_COMMIT_SHORT_SHA}"
	echo "--- Tag 2: ${DOCKER_IMAGE}:${DOCKER_VERSION}"
	docker tag "${BUILD_DOCKER_IMAGE}" "${DOCKER_IMAGE}:${DOCKER_VERSION}"
	docker push "${DOCKER_IMAGE}:${DOCKER_VERSION}"

	# Exit with error if push fails
	if [[ $? == 1 ]]; then
		exit 1
	fi

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.} > /dev/null

for service in services/${SERVICE:=*}/ ; do
	release_image $(basename ${service})
done

popd > /dev/null