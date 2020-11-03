FROM jboss/keycloak:11.0.2
USER root
RUN microdnf update && microdnf install python3

COPY environment-properties /tmp/environment-properties
COPY import_tdr_realm.py update_client_configuration.py update_realm_configuration.py tdr-realm-export.json /tmp/
COPY standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/
COPY themes/tdr/login /opt/jboss/keycloak/themes/tdr/login
COPY govuknotify1/target/govuknotify1-1.0-SNAPSHOT.jar /opt/jboss/keycloak/standalone/deployments/
RUN chown -R jboss /tmp/environment-properties
RUN chown jboss /tmp/tdr-realm-export.json /tmp/import_tdr_realm.py
RUN chmod +x /tmp/import_tdr_realm.py
USER 1000

ENTRYPOINT /tmp/import_tdr_realm.py
