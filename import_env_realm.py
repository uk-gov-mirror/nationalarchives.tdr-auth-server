#!/usr/bin/python3
import subprocess

from update_keycloak_configuration import update_keycloak_configuration

update_keycloak_configuration('/tmp/')

subprocess.call(['/opt/jboss/tools/docker-entrypoint.sh'])
