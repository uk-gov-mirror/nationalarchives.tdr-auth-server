#!/bin/bash

# retrieves secret values for the TDR realm and replaces placeholder secret values
# creates a json file containing both top level realm and TDR realm configuration in an array
# allows all TDR realms to be imported as single json configuration file

cat /tmp/tdr-realm-export.json | jq '(.clients[] | select (.clientId == "tdr").secret) = env.CLIENT_SECRET' \
      | jq '(.clients[] | select (.clientId == "tdr-backend-checks").secret) = env.BACKEND_CHECKS_CLIENT_SECRET' > /tmp/tdr-realm.json
sed -i "s,http://localhost:9000,$FRONTEND_URL,g" /tmp/tdr-realm.json

{
  echo '['
  cat /tmp/master-realm-export.json
  echo ','
  cat /tmp/tdr-realm.json
  echo ']'
} >> /tmp/realm.json

/opt/jboss/tdr-entrypoint.sh
