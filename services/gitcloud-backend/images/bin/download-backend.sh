#!/bin/bash
# file: download-backend.sh
# description: Download gitcloud backend from GitLab.

echo "Downloading release package for gitcloud-backend"

GITCLOUD_BACKEND_PATH=${1}
GITCLOUD_BACKEND_ID=23074262
GITCLOUD_BACKEND_NAME=backend-gitcloud
GITCLOUD_BACKEND_VERSION=0.1.0
GITCLOUD_BACKEND_RELEASE=${GITCLOUD_BACKEND_NAME}-${GITCLOUD_BACKEND_VERSION}.zip
GITCLOUD_BACKEND_RELEASE_URL="https://gitlab.com/api/v4/projects/${GITCLOUD_BACKEND_ID}/packages/generic/${GITCLOUD_BACKEND_NAME}/${GITCLOUD_BACKEND_VERSION}/${GITCLOUD_BACKEND_RELEASE}"

if [[ -z "${GITCLOUD_BACKEND_RELEASE_AUTH}" ]]; then
	echo '${GITCLOUD_BACKEND_RELEASE_AUTH} is required.'
	exit 1
fi

echo "--- Creating release folder, if not exists."
mkdir -p "${GITCLOUD_BACKEND_PATH}"

pushd ${GITCLOUD_BACKEND_PATH} > /dev/null

echo "--- Checking release at ${GITCLOUD_BACKEND_RELEASE_URL}."

if [[ -f "${GITCLOUD_BACKEND_RELEASE}" ]]; then
	echo '--- Release already exists.'
	exit 0
fi


echo "--- Downloading package"
echo "${GITCLOUD_BACKEND_RELEASE_AUTH}" | xargs -I{} \
	wget --header="{}" ${GITCLOUD_BACKEND_RELEASE_URL}

# Exit with error if download fails
if [[ $? == 1 ]]; then
	exit 1
fi

echo "--- Unpacking release"
unzip ${GITCLOUD_BACKEND_RELEASE} -d .

popd > /dev/null