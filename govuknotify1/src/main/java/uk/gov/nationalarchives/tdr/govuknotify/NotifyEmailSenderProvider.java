package uk.gov.nationalarchives.tdr.govuknotify;

import org.keycloak.email.EmailSenderProvider;
import org.keycloak.models.UserModel;
import uk.gov.service.notify.NotificationClient;
import uk.gov.service.notify.NotificationClientException;

import java.util.AbstractMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class NotifyEmailSenderProvider implements EmailSenderProvider {

    private NotificationClient notifyClient;

    public NotifyEmailSenderProvider(NotificationClient notifyClient) {
        this.notifyClient = notifyClient;
    }

    @Override
    public void send(Map<String, String> config, UserModel user, String subject, String textBody,
                     String htmlBody) {

        Map<String, ?> personalisation = Stream.of(
                new AbstractMap.SimpleImmutableEntry<>("keycloakMessage", textBody))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

        try {
            notifyClient.sendEmail(
                    "[notify_template_id]",
                    "[some_email_address]",
                    personalisation,
                    "[email_reference]");
        } catch (NotificationClientException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void close() {
    }
}
