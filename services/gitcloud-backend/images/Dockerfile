# file: Dockerfile
# description: Docker image for gitcloud-backend.

FROM adoptopenjdk:11-jre-hotspot

ARG JAR_FILE=release/*.jar

COPY ${JAR_FILE} gitcloud.jar

ENV PORT=${PORT}
EXPOSE ${PORT}

ENTRYPOINT ["java"]
CMD ["-jar", "gitcloud.jar", "--server.port=${PORT}"]