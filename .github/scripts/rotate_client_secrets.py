from keycloak import KeycloakAdmin
import boto3
import sys

stage = sys.argv[1]

clients = {
    'tdr': f'/{stage}/keycloak/client/secret',
    'tdr-backend-checks': f'/{stage}/keycloak/backend_checks_client/secret',
    'tdr-realm-admin': f'/{stage}/keycloak/realm_admin_client/secret',
    'tdr-reporting': f'/{stage}/keycloak/reporting_client/secret',
    'tdr-user-admin': f'/{stage}/keycloak/user_admin_client/secret'
}

ssm_client = boto3.client("ssm")
keycloakUser = ssm_client.get_parameter(
    Name='/tktest/keycloak/username',
    WithDecryption=True
)['Parameter']['Value']
keycloakPassword = ssm_client.get_parameter(
    Name='/tktest/keycloak/password',
    WithDecryption=True
)['Parameter']['Value']

keycloak_admin_client = KeycloakAdmin(server_url="http://localhost:8081/",
                                      username=f'{keycloakUser}',
                                      password=f'{keycloakPassword}',
                                      realm_name="tdr",
                                      verify=True)
ssm_client = boto3.client("ssm")

for client, ssm_parameter in clients:
    clientId = keycloak_admin_client.get_client_id(f'{client}')
    clientRep = keycloak_admin_client.generate_client_secrets(f'{clientId}')
    new_secret_value = clientRep["value"]
    print(f'Secret For {client}: {new_secret_value}')
    ssm_client.put_parameter(
        Name=f'{ssm_parameter}',
        Value=f'{new_secret_value}',
        Type='SecureString',
        Overwrite=True
    )
