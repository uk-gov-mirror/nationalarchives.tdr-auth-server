FROM jboss/keycloak:9.0.0
USER root
RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 > /usr/local/bin/jq \
    && chmod +x /usr/local/bin/jq
USER 1000
COPY realm-export.json /tmp
COPY import-realm.sh /tmp
COPY standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/
COPY govuk/ /opt/jboss/keycloak/themes/govuk/
ENTRYPOINT /tmp/import-realm.sh
