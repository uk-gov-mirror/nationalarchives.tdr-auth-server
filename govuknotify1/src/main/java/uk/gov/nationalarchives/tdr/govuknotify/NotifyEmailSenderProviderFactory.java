package uk.gov.nationalarchives.tdr.govuknotify;

import org.keycloak.email.EmailSenderProviderFactory;
import org.keycloak.Config.Scope;
import org.keycloak.email.EmailSenderProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import uk.gov.service.notify.NotificationClient;

public class NotifyEmailSenderProviderFactory implements EmailSenderProviderFactory {
    @Override
    public EmailSenderProvider create(KeycloakSession session) {

        final String apiKey = "[api_key_value]";

        NotificationClient client = new NotificationClient(apiKey);

        return new NotifyEmailSenderProvider(client);
    }

    @Override
    public void init(Scope config) { }

    @Override
    public void postInit(KeycloakSessionFactory factory) { }

    @Override
    public void close() { }

    @Override
    public String getId() {

        return "govuknotify";
    }
}
