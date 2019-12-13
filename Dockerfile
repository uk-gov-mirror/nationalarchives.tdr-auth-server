FROM jboss/keycloak
COPY standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/
COPY govuk/ /opt/jboss/keycloak/themes/
COPY sms-validation* /opt/jboss/keycloak/themes/base/login/
COPY messages_en.properties /tmp/
COPY keycloak-sms-authenticator-sns-2.0.0.jar /opt/jboss/keycloak/standalone/deployments/
RUN cat /tmp/messages_en.properties >> /opt/jboss/keycloak/themes/base/login/messages/messages_en.properties