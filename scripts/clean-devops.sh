#!/bin/bash
# file: clean-devops.sh
# description: Clear build images and files.

clean_image () {
	SERVICE=$1

	echo "Cleaning Service: ${SERVICE}."

	pushd services/${SERVICE}/images > /dev/null

	echo "--- Extract software metadata."
	SOFTWARE_VERSION=0.1.0

	echo "--- Building docker images."
	export DOCKER_IMAGE=gitcloud-backend-${SOFTWARE_VERSION}
	export DOCKER_VERSION="$(date +%Y.%m.%d)-$(git rev-parse --short HEAD)"
	
	echo "--- Docker Image: ${DOCKER_IMAGE}"
	echo "--- Docker Version: ${DOCKER_VERSION}"
	
	echo "Remove all unused images."
	docker image prune -f

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	clean_image $(basename ${service})
	docker images
done

popd > /dev/null