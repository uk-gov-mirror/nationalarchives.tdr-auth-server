import requests
import json
import sys

from update_keycloak_configuration import update_keycloak_configuration

stage_to_url = dict(
    local='http://localhost:8081',
    intg='https://auth.tdr-integration.nationalarchives.gov.uk/',
    staging='https://auth.tdr-staging.nationalarchives.gov.uk/'
)

stage: str = sys.argv[1]
keycloak_user: str = sys.argv[2]
keycloak_password: str = sys.argv[3]
env_properties_file: str = sys.argv[4]
base_auth_url = stage_to_url.get(stage)
keycloak_auth_url = f'{base_auth_url}/auth/realms/master/protocol/openid-connect/token'
keycloak_tdr_partial_import_url = f'{base_auth_url}/auth/admin/realms/tdr/partialImport'
keycloak_tdr_top_level_import_url = f'{base_auth_url}/auth/admin/realms/tdr'

def get_access_token():
    payload = {'username': keycloak_user, 'password': keycloak_password, 'grant_type': 'password', 'client_id': 'admin-cli'}
    authentication_request = requests.post(keycloak_auth_url, data=payload)
    authentication_data = authentication_request.json()
    access_token = authentication_data['access_token']
    return access_token

update_keycloak_configuration('', env_properties_file)
token = get_access_token()
headers = {'Content-Type': 'application/json', 'Authorization': f'bearer {token}'}

with open('tdr-realm.json', 'r+') as tdr_realm:
    full_tdr_realm_data = json.load(tdr_realm)
    # Keys defined in the Keycloak representation for partial imports:
    # https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_partialimportrepresentation
    partial_import_keys = ["clients", "roles", "groups", "identityProviders"]
    partial_import_data = {"policy": "OVERWRITE"}

    for key in partial_import_keys:
        if key not in full_tdr_realm_data:
            continue
        else:
            partial_import_data[key] = full_tdr_realm_data[key]

# Two REST endpoints to update a Keycloak realm:
# - PUT /{realm}: updates the top-level information of the realm.
#                 Any user, roles or client information in the representation are ignored.
# - POST /{realm}/partialImport: Partial import from a JSON file to an existing realm.
#                                Allows importation of configuration of clients, roles, groups and identity providers
#                                Depending on the policy set will overwrite, skip or fail for existing resources
requests.put(keycloak_tdr_top_level_import_url, data=json.dumps(full_tdr_realm_data), headers=headers)
requests.post(keycloak_tdr_partial_import_url, data=json.dumps(partial_import_data), headers=headers)
