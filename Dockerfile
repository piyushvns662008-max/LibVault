FROM tomcat:9-jdk17

RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/
COPY src/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes-src/

RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes && \
    find /usr/local/tomcat/webapps/ROOT/WEB-INF/classes-src -name "*.java" > /tmp/sources.txt && \
    javac -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes @/tmp/sources.txt && \
    rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/classes-src

EXPOSE 8080
CMD ["catalina.sh", "run"]