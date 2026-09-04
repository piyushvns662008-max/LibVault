FROM eclipse-temurin:17-jdk AS build

WORKDIR /build
COPY src/ ./src/
COPY WebContent/ ./WebContent/

RUN mkdir -p WebContent/WEB-INF/classes && \
    find src -name "*.java" > sources.txt && \
    javac -d WebContent/WEB-INF/classes @sources.txt

FROM tomcat:9-jdk17

RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /build/WebContent/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
CMD ["catalina.sh", "run"]