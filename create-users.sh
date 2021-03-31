#!/bin/sh

i=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

while [ $i -ne 200 ]
  do
  i=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
  sleep 2
done

cd /opt/jboss/keycloak/bin/
./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
./kcadm.sh create users -s username=$2 -s enabled=true -r master  -s email=$1
curl https://stedolan.github.io/jq/download/linux64/jq > jq
chmod +x jq
USER_ID=$(./kcadm.sh get users -r master -q email=$1 --fields id | ./jq -r '.[0]'.id)

# This next line is for demo purposes and shouldn't be included in the final script
./kcadm.sh update realms/master -f /tmp/realm.json

./kcadm.sh update users/$USER_ID/execute-actions-email --body '["UPDATE_PASSWORD", "CONFIGURE_TOTP"]'

# We can configure which roles are needed for users
./kcadm.sh add-roles -r master --uusername $2  --rolename admin
ADMIN_USER=$(./kcadm.sh get users -r master -q username=$KEYCLOAK_USER --fields id | ./jq -r '.[0]'.id)
rm jq

# We can control whether the admin is deleted like this with environment variables
# Or we could have a PR to comment out this line if we need to create the admin user
if [ $DELETE_ADMIN_USER == "true" ]
then
  ./kcadm.sh delete users/$ADMIN_USER -r master
fi

