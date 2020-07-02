import os

tdr_client_secret = os.environ['CLIENT_SECRET']
backend_checks_client_secret = os.environ['BACKEND_CHECKS_CLIENT_SECRET']


def update_client_secrets(client, client_id):
    if client_id == "tdr":
        client['secret'] = os.environ['CLIENT_SECRET']
    if client_id == "tdr-backend-checks":
        client['secret'] = os.environ['BACKEND_CHECKS_CLIENT_SECRET']


def update_client(client, client_id, client_env_props):
    client_props = client_env_props[client_id]
    for key in client_props.keys():
        client[key] = client_props[key]
