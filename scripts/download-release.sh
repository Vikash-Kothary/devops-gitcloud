#!/bin/bash
# file: download-release.sh
# description: Download release packages from Gitlab.

download_release () {
	SERVICE=$1
	echo "Downloading release package for: ${SERVICE}"

	[[ ! -z "${GITLAB_API_V4_URL}" ]] || GITLAB_API_V4_URL=${CI_API_V4_URL}
	[[ ! -z "${GITLAB_PROJECT_ID}" ]] || GITLAB_PROJECT_ID=${CI_PROJECT_ID}
	[[ ! -z "${GITLAB_AUTH_TOKEN}" ]] || GITLAB_AUTH_TOKEN=${CI_JOB_TOKEN}
	[[ ! -z "${GITLAB_AUTH_TYPE}" ]] || GITLAB_AUTH_TYPE=JOB-TOKEN

	pushd services/${SERVICE}/images > /dev/null

	PACKAGE_FOLDER=release
	PACKAGE_NAME=backend-gitcloud
	PACKAGE_VERSION=0.1.0
	PACKAGE_FILENAME=${PACKAGE_NAME}-${PACKAGE_VERSION}.zip
	PACKAGE_URL="${GITLAB_API_V4_URL}/projects/${GITLAB_PROJECT_ID}/packages/generic/${PACKAGE_NAME}/${PACKAGE_VERSION}/${PACKAGE_FILENAME}"
	
	echo "--- Checking release at ${PACKAGE_URL}"

	echo "--- Creating release folder, if not exists."
	mkdir -p "${PACKAGE_FOLDER}"

	if [[ -f "${PACKAGE_FOLDER}/${PACKAGE_FILENAME}" ]]; then
		echo "--- Release package exist. Deleting."
		rm "${PACKAGE_FOLDER}/${PACKAGE_FILENAME}"
	fi

	echo "--- Downloading package"
	wget \
	--header="${GITLAB_AUTH_TYPE}: ${GITLAB_AUTH_TOKEN}" \
	${PACKAGE_URL} \
	-P ${PACKAGE_FOLDER}

	echo "--- Unpacking release"
	unzip ${PACKAGE_FOLDER}/${PACKAGE_FILENAME} -d ${PACKAGE_FOLDER}/. -o

	popd > /dev/null
}

pushd ${GITCLOUD_DEVOPS_PATH:=.}

for service in services/${SERVICE:=*}/ ; do
	download_release $(basename ${service})
done

popd > /dev/null