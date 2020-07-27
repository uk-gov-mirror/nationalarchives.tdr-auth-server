import requests
import json
import sys

from update_keycloak_configuration import update_keycloak_configuration

stage_to_url = dict(
    intg='https://auth.tdr-integration.nationalarchives.gov.uk/',
    staging='https://auth.tdr-staging.nationalarchives.gov.uk/'
)

stage: str = sys.argv[1]
keycloak_user: str = sys.argv[2]
keycloak_password: str = sys.argv[3]
base_auth_url = stage_to_url.get(stage)
keycloak_auth_url = f'{base_auth_url}/auth/realms/master/protocol/openid-connect/token'
keycloak_tdr_partial_import_url = f'{base_auth_url}/auth/admin/realms/tdr/partialImport'

def get_access_token():
    payload = {'username': keycloak_user, 'password': keycloak_password, 'grant_type': 'password', 'client_id': 'admin-cli'}
    authentication_request = requests.post(keycloak_auth_url, data=payload)
    authentication_data = authentication_request.json()
    access_token = authentication_data['access_token']
    return access_token


update_keycloak_configuration('')
token = get_access_token()
headers = {'Content-Type': 'application/json', 'Authorization': f'bearer {token}'}

with open('/tmp/tdr-realm.json', 'r+') as tdr_realm:
    tdr_realm_data = json.load(tdr_realm)

requests.post(keycloak_tdr_partial_import_url, data=json.dumps(tdr_realm_data), headers=headers)
