#!/usr/bin/python3
import subprocess
import os

from update_realm_configuration import update_realm_configuration

env_properties_file = os.environ['KEYCLOAK_CONFIGURATION_PROPERTIES']

update_realm_configuration('/tmp/', env_properties_file)
subprocess.call(['/opt/jboss/tools/docker-entrypoint.sh'])
