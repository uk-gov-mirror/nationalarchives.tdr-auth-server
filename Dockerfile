FROM jboss/keycloak:9.0.0
USER root
RUN microdnf update && microdnf install python3
COPY tdr-entrypoint.sh /opt/jboss
COPY environment-properties /tmp/environment-properties
COPY import_env_realm.py import_env_realm.py update_env_client_configuration.py master-realm-export.json tdr-realm-export.json /tmp/
COPY standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/
COPY govuk/ /opt/jboss/keycloak/themes/govuk/
RUN chown -R jboss /tmp/environment-properties
RUN chown jboss /opt/jboss/tdr-entrypoint.sh /tmp/master-realm-export.json /tmp/tdr-realm-export.json /tmp/import_env_realm.py
RUN chmod +x /tmp/import_env_realm.py && chmod +x /opt/jboss/tdr-entrypoint.sh
USER 1000

ENTRYPOINT /tmp/import_env_realm.py
