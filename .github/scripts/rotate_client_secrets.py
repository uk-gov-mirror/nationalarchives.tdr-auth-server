from keycloak import KeycloakAdmin
import boto3
import sys

stage = sys.argv[1]

clients = {
    'tdr': f'/{stage}/keycloak/client/secret',
    'tdr-backend-checks': f'/{stage}/keycloak/backend_checks_client/secret',
    'tdr-realm-admin': f'/{stage}/keycloak/realm_admin_client/secret',
    'tdr-reporting': f'/{stage}/keycloak/reporting_client/secret',
    'tdr-rotate-secrets': f'/{stage}/keycloak/rotate_secrets_client/secret',
    'tdr-user-admin': f'/{stage}/keycloak/user_admin_client/secret'
}

ssm_client = boto3.client("ssm")

rotate_secrets_client_current_secret = ssm_client.get_parameter(
    Name='path_to_stored_rotate_secrets_client_secret',
    WithDecryption=True
)['Parameter']['Value']

keycloak_admin_client = KeycloakAdmin(server_url="http://localhost:8081/",
                                      client_id="tdr-rotate-secrets",
                                      client_secret_key=f"{rotate_secrets_client_current_secret}",
                                      realm_name="tdr")

for tdr_client, ssm_parameter_value in clients:
    clientId = keycloak_admin_client.get_client_id(f'{tdr_client}')
    clientRep = keycloak_admin_client.generate_client_secrets(f'{clientId}')
    new_secret_value = clientRep["value"]
    # Shouldn't be printing to console for real secrets!!!
    print(f'Secret For {tdr_client}: {new_secret_value}')
    ssm_client.put_parameter(
        Name=f'{ssm_parameter_value}',
        Value=f'{new_secret_value}',
        Type='SecureString',
        Overwrite=True
    )
