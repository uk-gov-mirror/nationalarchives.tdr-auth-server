FROM quay.io/keycloak/keycloak:18.0.0
USER root
RUN microdnf update && microdnf install python3

COPY environment-properties /tmp/environment-properties
COPY build.conf import_tdr_realm.py update_client_configuration.py update_realm_configuration.py tdr-realm-export.json /tmp/
COPY themes/tdr/login /opt/keycloak/themes/tdr/login
COPY themes/tdr/email /opt/keycloak/themes/tdr/email
COPY govuk-notify-spi/target/scala-2.13/govuk-notify-spi* /opt/keycloak/providers/
COPY event-publisher-spi/target/scala-2.13/event-publisher-spi.jar /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh -cf build /tmp/build.conf
RUN chown -R keycloak /tmp/environment-properties
RUN chown keycloak /tmp/tdr-realm-export.json /tmp/import_tdr_realm.py
RUN chmod +x /tmp/import_tdr_realm.py
USER 1000
RUN mkdir -p /opt/keycloak/data/import

ENTRYPOINT /tmp/import_tdr_realm.py
