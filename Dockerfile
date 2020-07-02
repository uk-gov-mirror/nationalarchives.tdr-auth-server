FROM jboss/keycloak:9.0.0
COPY tdr-entrypoint.sh /opt/jboss
USER root
RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 > /usr/local/bin/jq \
    && chmod +x /usr/local/bin/jq
RUN microdnf update && microdnf install python3
RUN chown jboss /opt/jboss/tdr-entrypoint.sh && chmod +x /opt/jboss/tdr-entrypoint.sh
COPY environment-properties /tmp/environment-properties
COPY update-env-realm-configuration.py /tmp
COPY master-realm-export.json /tmp
COPY tdr-realm-export.json /tmp
COPY import-realm.sh /tmp
COPY standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/
COPY govuk/ /opt/jboss/keycloak/themes/govuk/
RUN chown jboss /tmp/environment-properties/intg_properties.json && chown jboss /tmp/environment-properties/staging_properties.json
RUN chown jboss /tmp/master-realm-export.json && chown jboss /tmp/tdr-realm-export.json
USER 1000

ENTRYPOINT /tmp/import-realm.sh
