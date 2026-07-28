FROM quay.io/keycloak/keycloak:26.6.4 as builder
FROM registry.access.redhat.com/ubi9-minimal
COPY --from=builder /opt/keycloak/ /opt/keycloak/
USER root
RUN microdnf update -y && \
    microdnf -y install python3 java-21-openjdk-headless shadow-utils
RUN useradd -U keycloak
WORKDIR /opt/keycloak
RUN mkdir /keycloak-configuration
COPY quarkus.properties conf/
COPY environment-properties /keycloak-configuration/environment-properties
COPY build.conf import_tdr_realm.py update_client_configuration.py update_realm_configuration.py tdr-realm-export.json /keycloak-configuration/
COPY themes/tdr/login themes/tdr/login
COPY themes/tdr/email themes/tdr/email
COPY target/out/jvm/scala-2.13.18/govuk-notify-spi/govuk-notify-spi* providers/
COPY target/out/jvm/scala-2.13.18/credentials-provider/credentials-provider.jar providers/
COPY target/out/jvm/scala-2.13.18/event-publisher-spi/event-publisher-spi.jar providers/
COPY target/out/jvm/scala-2.13.18/custom-response-provider/custom-response-provider.jar providers/
COPY keycloak.conf conf/
RUN bin/kc.sh -cf /keycloak-configuration/build.conf build
RUN chown -R 1000:1000 /opt/keycloak/data
RUN chown -R keycloak /keycloak-configuration
RUN chmod +x /keycloak-configuration/import_tdr_realm.py
USER 1000
RUN mkdir -p data/import

ENTRYPOINT /keycloak-configuration/import_tdr_realm.py
