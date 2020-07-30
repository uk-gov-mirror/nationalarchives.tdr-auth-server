FROM jboss/keycloak:9.0.0
USER root
RUN microdnf update && microdnf install python3

COPY environment-properties /tmp/environment-properties
COPY build_env_realm.py update_client_configuration.py update_realm_configuration.py tdr-realm-export.json /tmp/
COPY standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/
COPY govuk/ /opt/jboss/keycloak/themes/govuk/
RUN chown -R jboss /tmp/environment-properties
RUN chown jboss /tmp/tdr-realm-export.json /tmp/build_env_realm.py
RUN chmod +x /tmp/build_env_realm.py
USER 1000

ENTRYPOINT /tmp/build_env_realm.py
