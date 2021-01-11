#!/bin/bash
# file: run-devops.sh
# description:


run_example () {
	SERVICE=$1
	echo "Building Service: ${SERVICE}."

	pushd services/${SERVICE}/images > /dev/null

	echo "--- Extract software metadata."
	SOFTWARE_VERSION=0.1.0

	echo "--- Building docker images."
	export DOCKER_IMAGE=gitcloud-backend-${SOFTWARE_VERSION}
	export DOCKER_VERSION="$(date +%Y.%m.%d)-$(git rev-parse --short HEAD)"
	
	echo "--- Docker Image: ${DOCKER_IMAGE}"
	echo "--- Docker Version: ${DOCKER_VERSION}"
	docker-compose up ${CONTAINER}

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	run_example $(basename ${service})
done

popd > /dev/null