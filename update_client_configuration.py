import os

def update_client_configuration(clients, env_client_props):
    for client in clients:
        client_id = client['clientId']
        update_client_secrets(client, client_id)

        if client_id not in env_client_props:
            continue
        else:
            update_client(client, client_id, env_client_props)

def update_client_secrets(client, client_id):
    if client_id == "tdr":
        client['secret'] = os.environ['CLIENT_SECRET']
    if client_id == "tdr-backend-checks":
        client['secret'] = os.environ['BACKEND_CHECKS_CLIENT_SECRET']
    if client_id == "tdr-realm-admin":
        client['secret'] = os.environ['REALM_ADMIN_CLIENT_SECRET']
    if client_id == "tdr-user-admin":
        client['secret'] = os.environ['USER_ADMIN_CLIENT_SECRET']
    if client_id == "tdr-reporting":
        client['secret'] = os.environ['REPORTING_CLIENT_SECRET']

def update_client(client, client_id, client_env_props):
    client_props = client_env_props[client_id]
    for key in client_props.keys():
        client[key] = client_props[key]
