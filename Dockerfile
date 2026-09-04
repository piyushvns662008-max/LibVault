FROM tomcat:9-jdk11

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY WebContent/ /usr/local/tomcat/webapps/ROOT/
COPY src/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]