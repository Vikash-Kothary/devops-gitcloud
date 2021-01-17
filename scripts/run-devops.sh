#!/bin/bash
# file: run-devops.sh
# description:


run_example () {
	SERVICE=$1
	echo "Building Service: ${SERVICE}."

	pushd services/${SERVICE}/examples > /dev/null

	echo "--- Extract software metadata."
	SOFTWARE_VERSION=0.1.0

	echo "--- Building docker images."
	export DOCKER_IMAGE=gitcloud-backend-${SOFTWARE_VERSION}
	
	echo "--- Docker Image: ${DOCKER_IMAGE}"
	docker-compose up ${CONTAINER}

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	run_example $(basename ${service})
done

popd > /dev/null
