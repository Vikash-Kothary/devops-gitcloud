#!/bin/bash
# file: build-devops.sh
# description: Build all Docker images

build_image () {
	SERVICE=$1

	echo "Building Service: ${SERVICE}."

	pushd services/${SERVICE}/images > /dev/null

	echo "--- Extract software metadata."
	SOFTWARE_VERSION=0.1.0

	echo "--- Building docker images."
	export DOCKER_IMAGE=gitcloud-backend-${SOFTWARE_VERSION}
	export DOCKER_VERSION="$(date +%Y.%m.%d)-$(git rev-parse --short HEAD)"
	
	echo "$DOCKER_IMAGE"
	echo "$DOCKER_VERSION"
	docker-compose build

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	build_image $(basename ${service})
done

popd > /dev/null