import requests
import json
import sys

from update_realm_configuration import update_realm_configuration

stage_to_url = dict(
    local='http://localhost:8081',
    intg='https://auth.tdr-integration.nationalarchives.gov.uk',
    staging='https://auth.tdr-staging.nationalarchives.gov.uk'
)

stage: str = sys.argv[1]
keycloak_user: str = sys.argv[2]
keycloak_password: str = sys.argv[3]
update_policy: str = sys.argv[4]
env_properties_file: str = f'{stage}_properties.json'
base_auth_url = stage_to_url.get(stage)

def get_access_token():
    payload = {
        'username': keycloak_user,
        'password': keycloak_password,
        'grant_type': 'password',
        'client_id': 'admin-cli'
    }
    authentication_request = requests.post(
        f'{base_auth_url}/auth/realms/master/protocol/openid-connect/token',
        data=payload
    )
    authentication_data = authentication_request.json()
    access_token = authentication_data['access_token']
    return access_token

def get_realm_data():
    update_realm_configuration('', env_properties_file)
    with open('tdr-realm.json', 'r+') as realm:
        realm_data = json.load(realm)
    return realm_data

def generate_partial_import_data(full_realm_data):
    # Keys defined in the Keycloak representation for partial imports:
    # https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_partialimportrepresentation
    partial_import_keys = ["clients", "roles", "groups", "identityProviders", "users"]
    partial_import_data = {"policy": f"{update_policy}"}

    for key in partial_import_keys:
        if key not in full_realm_data:
            continue
        else:
            partial_import_data[key] = full_realm_data[key]
    return partial_import_data

def update_realm():
    full_realm_data = get_realm_data()
    partial_import_data = generate_partial_import_data(full_realm_data)
    token = get_access_token()
    headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': f'bearer {token}'
    }

    # Two REST endpoints to update a Keycloak realm:
    # - PUT /{realm}: updates the top-level information of the realm.
    #                 Any user, roles or client information in the representation are ignored.
    #                 Takes the full realm representation
    # - POST /{realm}/partialImport: Partial import from a JSON file to an existing realm.
    #                 Allows importation of configuration of clients, roles, groups and identity providers
    #                 Depending on the policy set will overwrite, skip or fail for existing resources
    #                 Takes a partial realm representation
    top_level_result = requests.put(
        f'{base_auth_url}/auth/admin/realms/tdr',
        data=json.dumps(full_realm_data),
        headers=headers
    )
    print(f"Top Level Import Response Status: {top_level_result.status_code}")

    partial_result = requests.post(
        f'{base_auth_url}/auth/admin/realms/tdr/partialImport',
        data=json.dumps(partial_import_data),
        headers=headers
    )
    print(f"Partial Import Response Status: {partial_result.status_code}")

update_realm()
