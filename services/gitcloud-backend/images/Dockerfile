# file: Dockerfile
# description: Docker image for gitcloud-backend.

FROM adoptopenjdk:11-jre-hotspot as builder

RUN apt update && apt install -y bash wget unzip

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ARG RELEASE_FOLDER=/usr/src/app/release \
	GITCLOUD_BACKEND_RELEASE_AUTH

## Speed up builds
# COPY release ${RELEASE_FOLDER}

## Copy download script
## TODO: Download and run from backend repo.
COPY bin ./bin
RUN bash ./bin/download-backend.sh ${RELEASE_FOLDER}

FROM adoptopenjdk:11-jre-hotspot

ARG RELEASE_FOLDER=/usr/src/app/release \
	GITCLOUD_BACKEND_RELEASE_AUTH \
	PORT=48080

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY --from=builder ${RELEASE_FOLDER}/*.jar ./gitcloud.jar

ENV GITCLOUD_BACKEND_PORT=${PORT}
EXPOSE ${GITCLOUD_BACKEND_PORT}

## TODO: 
CMD ["java", "-jar", "gitcloud.jar", "--server.port=${GITCLOUD_BACKEND_PORT}"]