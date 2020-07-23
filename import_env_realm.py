#!/usr/bin/python3
import subprocess
import json
import os

from update_env_client_configuration import update_client_configuration

env_properties = os.environ['KEYCLOAK_CONFIGURATION_PROPERTIES']

with open('/tmp/tdr-realm-export.json', 'r+') as tdr_realm:
    tdr_realm_data = json.load(tdr_realm)
with open(f'/tmp/environment-properties/{env_properties}', 'r+') as env_props:
    env_props_data = json.load(env_props)

    tdr_clients = tdr_realm_data['clients']
    tdr_client_props = env_props_data['clients']

    update_client_configuration(tdr_clients, tdr_client_props)

with open('/tmp/tdr-realm.json', 'w') as tdr_realm:
    json.dump(tdr_realm_data, tdr_realm)

subprocess.call(['/opt/jboss/tools/docker-entrypoint.sh'])
