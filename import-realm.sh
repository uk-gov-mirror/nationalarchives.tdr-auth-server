#!/bin/bash

# retrieves secret values for each TDR realm client and replaces placeholder secret values
# adds environment specific properties to each TDR realm client
# creates a json file containing both top level realm and TDR realm configuration in an array
# allows all TDR realms to be imported as single json configuration file

python3 /tmp/update-env-realm-configuration.py

#combine to single realm configuration json
{
  echo '['
  cat /tmp/master-realm.json
  echo ','
  cat /tmp/tdr-realm.json
  echo ']'
} >> /tmp/realm.json

/opt/jboss/tdr-entrypoint.sh

#/opt/jboss/tools/docker-entrypoint.sh
