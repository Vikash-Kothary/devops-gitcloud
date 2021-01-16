#!/bin/bash
# file: build-devops.sh
# description: Build all Docker images

build_image () {
	SERVICE=$1

	echo "Building Service: ${SERVICE}."

	pushd services/${SERVICE}/images > /dev/null

	# Check if relese exists.
	if [[ ! -d "release" ]]; then
		echo "--- Release folder not found."
		exit 1
	fi

	echo "--- Extract software metadata."
	SOFTWARE_VERSION=0.1.0

	echo "--- Building docker images."
	export DOCKER_IMAGE=gitcloud-backend-${SOFTWARE_VERSION}
	export DOCKER_VERSION="$(date +%Y.%m.%d)-$(git rev-parse --short HEAD)"
	
	echo "--- Docker Image: ${DOCKER_IMAGE}"
	echo "--- Docker Version: ${DOCKER_VERSION}"
	docker-compose build

	# Exit with error if build fails
	if [[ $? == 1 ]]; then
		exit 1
	fi

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	build_image $(basename ${service})
done

popd > /dev/null