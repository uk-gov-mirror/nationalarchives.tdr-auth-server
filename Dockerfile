FROM quay.io/keycloak/keycloak:18.0.0
USER root
RUN microdnf update && microdnf install python3

COPY environment-properties /tmp/environment-properties
COPY import_tdr_realm.py update_client_configuration.py update_realm_configuration.py tdr-realm-export.json /tmp/
COPY standalone-ha.xml /opt/keycloak/standalone/configuration/
COPY themes/tdr/login /opt/keycloak/themes/tdr/login
COPY themes/tdr/email /opt/keycloak/themes/tdr/email
COPY govuk-notify-spi/target/scala-2.13/govuk-notify-spi.jar /opt/keycloak/standalone/deployments/
COPY event-publisher-spi/target/scala-2.13/event-publisher-spi.jar /opt/keycloak/standalone/deployments/
RUN chown -R keycloak /tmp/environment-properties
RUN chown keycloak /tmp/tdr-realm-export.json /tmp/import_tdr_realm.py
RUN chmod +x /tmp/import_tdr_realm.py
USER 1000

ENTRYPOINT /tmp/import_tdr_realm.py
