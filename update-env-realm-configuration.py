import json
import os

env_properties = os.environ['KEYCLOAK_CONFIGURATION_PROPERTIES']

with open('/tmp/master-realm-export.json', 'r+') as master_realm:
    master_realm_data = json.load(master_realm)
with open('/tmp/tdr-realm-export.json', 'r+') as tdr_realm:
    tdr_realm_data = json.load(tdr_realm)
with open(f'/tmp/environment-properties/{env_properties}', 'r+') as env_props:
    env_props_data = json.load(env_props)

    tdr_clients = tdr_realm_data['clients']
    tdr_client_props = env_props_data['clients']

    for client in tdr_clients:
        client_id = client['clientId']

        if client_id == "tdr":
            client['secret'] = os.environ['CLIENT_SECRET']
        if client_id == "tdr-backend-checks":
            client['secret'] = os.environ['BACKEND_CHECKS_CLIENT_SECRET']

        if client_id not in tdr_client_props:
            continue
        else:
            client_props = tdr_client_props[client_id]
            for key in client_props.keys():
                client[key] = client_props[key]

with open("/tmp/master-realm.json", "w") as jsonFile:
    json.dump(master_realm_data, jsonFile)

with open("/tmp/tdr-realm.json", "w") as jsonFile:
    json.dump(tdr_realm_data, jsonFile)
