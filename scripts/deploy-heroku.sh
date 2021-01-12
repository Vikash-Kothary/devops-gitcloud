#!/bin/bash
# file: deploy-heroku.sh
# description: Deploy Docker image to Heroku

# WARNING: Heroku requires the APP to be accessible on ${PORT}.
# Apps that do not, will still deploy but will not be accessible.

# install heroku on MacOS
# brew tap heroku/brew && brew install heroku


if [[ -z "${SERVICE}" ]]; then
	echo 'Error: Heroku Deploy requires a $SERVICE to be set.'
	exit 1
fi

echo "[Deploy] Deploying ${SERVICE} to Heroku."

## Heroku
### Used for deployment
HEROKU_REGISTRY=registry.heroku.com
HEROKU_USERNAME=_
HEROKU_PASSWORD=$(heroku auth:token)

## Docker
### Used for building
DOCKER_IMAGE=${HEROKU_REGISTRY}/${SERVICE}/web

PATH_TO_DOCKER_COMPOSE=services/${SERVICE}/images/docker-compose.yml
echo "${PATH_TO_DOCKER_COMPOSE}"
if [[ ! -f "${PATH_TO_DOCKER_COMPOSE}" ]]; then
	echo 'Docker Compose Image could not be found. Exiting.'
	exit 1
fi

echo "--- Found: ${PATH_TO_DOCKER_COMPOSE}"

cd $(dirname ${PATH_TO_DOCKER_COMPOSE})
# TODO: Just tag existing image.
docker-compose build
docker-compose push

echo "--- Login into Heroku."
heroku login

echo "--- Deploying to Heroku Container Registry."
heroku container:login
heroku container:push web --app ${SERVICE}
heroku container:release web --app ${SERVICE}
heroku ps:scale web=1 --app ${SERVICE}
