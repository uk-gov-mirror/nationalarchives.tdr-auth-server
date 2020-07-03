#!/usr/bin/python3
import subprocess
import json
import os

from update_env_client_configuration import update_client_configuration

env_properties = os.environ['KEYCLOAK_CONFIGURATION_PROPERTIES']

with open('/tmp/master-realm-export.json', 'r+') as master_realm:
    master_realm_data = json.load(master_realm)
with open('/tmp/tdr-realm-export.json', 'r+') as tdr_realm:
    tdr_realm_data = json.load(tdr_realm)
with open(f'/tmp/environment-properties/{env_properties}', 'r+') as env_props:
    env_props_data = json.load(env_props)

    tdr_clients = tdr_realm_data['clients']
    tdr_client_props = env_props_data['clients']

    update_client_configuration(tdr_clients, tdr_client_props)

# combine master and tdr realm json to single json file

# create and initialize realm json with array
with open('/tmp/realm.json', 'w') as initialize_realm:
    json.dump([], initialize_realm)

# read realm json to json data
with open('/tmp/realm.json', 'r+') as realm_load:
    realm_data = json.load(realm_load)

# append realms to realm data and write to file
with open('/tmp/realm.json', 'w') as realm:
    realm_data.append(master_realm_data)
    realm_data.append(tdr_realm_data)
    json.dump(realm_data, realm)

subprocess.call(['/opt/jboss/tdr-entrypoint.sh'])
