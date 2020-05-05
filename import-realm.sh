#!/bin/bash

cat /tmp/realm-export.json | jq '(.clients[] | select (.clientId == "tdr").secret) = env.CLIENT_SECRET' \
       | jq '(.clients[] | select (.clientId == "tdr-backend-checks").secret) = env.BACKEND_CHECKS_CLIENT_SECRET' > /tmp/realm.json
sed -i "s,http://localhost:9000,$FRONTEND_URL,g" /tmp/realm.json

/opt/jboss/tools/docker-entrypoint.sh
