# TDR Auth server

All of our documentation is stored in the [tdr-dev-documentation](https://github.com/nationalarchives/tdr-dev-documentation) repository.

## Updating Keycloak version

**Important Note**

When updating Keycloak version the **tdr-entrypoint.sh** script needs to be updated to ensure it is kept up-to-date with any changes:
1. Pull the Keycloak docker image version required locally
2. Start the new Keycloak docker image locally
3. Log onto the running Keycloak docker image
4. On the docker image navigate to the provided Keycloak entry point script: */opt/jboss/tools/docker-entrypoint.sh*
5. Copy the new version of the Keycloak provided entry point script: */opt/jboss/tools/docker-entrypoint.sh* into the *tdr-entrypoint.sh* script
6. Add the following commands to the updated *tdr-entrypoint.sh*:

```
if [[ -n ${TDR_KEYCLOAK_IMPORT:-} ]]; then
  SYS_PROPS+=" -Dkeycloak.migration.action=import"
  SYS_PROPS+=" -Dkeycloak.migration.provider=singleFile"
  SYS_PROPS+=" -Dkeycloak.migration.file=$TDR_KEYCLOAK_IMPORT"
  SYS_PROPS+=" -Dkeycloak.migration.strategy=OVERWRITE_EXISTING"
fi

```

## Dockerfile
This repository holds the Dockerfile used to build our keycloak server which we will be using for authentication and authorisation. 

## Jenkinsfile
There is a Jenkinsfile build and push this to docker hub. The Jenkinsfile has three stages.
The first two are run in parallel. 

One clones the Home Office's govuk keycloak theme project and builds it.

The other clones a [TNA fork](https://github.com/nationalarchives/keycloak-sms-authenticator-sns) of BEIS' SMS MFA keycloak repo and builds that. The original repo is missing a dependency in the pom which I've added in the fork. 

The output from both of these are stashed and then unstashed in the third stage. They are then used to build the Dockerfile.

## import_env_realm.py script

The import_env_realm.py runs scripts to update the Keycloak json configuration files (which are held in a private repository) with TDR environment specific properties and combines the individual realm json into a single json configuration file for import into Keycloak at start up.

## update_env_client_configuration.py script

The update_env_client_configuration.py script provides functions for updating Keycloak realm client json. 

Primarily it:
 * injects secret values which cannot be safely stored in the configuration file.
 * updates specific json elements based on the environment properties json file provided.
 
## tdr-entrypoint.sh script

The tdr-entrypoint.sh script provides the entry point on start up of the Keycloak docker container.

It has specific TDR commands around realm import, and is copied from the default entrypoint script provided in the keycloak image (/opt/jboss/tools/docker-entrypoint.sh)

## Configuration file

The standalone-ha.xml is mostly the standard configuration for keycloak with a few changes to get it to work with the load balancer. Some of these are discussed in the keycloak [documentation](https://www.keycloak.org/docs/latest/server_installation/#_setting-up-a-load-balancer-or-proxy)

## Updating Keycloak Configuration json

To update Keycloak with, for example, a new client:
1. Update the relevant Keycloak json configuration file (tdr-realm-export.json or master-realm-export.json). See README for the tdr-configuration private repository on how to do this.
2. If the change to Keycloak makes use of a new secret value, for example a new client secret:
  * Add the new secret value to the parameter store using Terraform: https://github.com/nationalarchives/tdr-terraform-environments
    
    This ensures that the secret value is stored securely and is not exposed in the code.
  
  * Update the update_env_client_configuration.py script to replace the placeholder secret value in the relevant realm json configuration file, with the new secret value set in the Terraform.
3. Run the Jenkins build

## Running Locally

To run, build and test locally:
1. Copy the master-realm-export.json and tdr-realm-export.json from the tdr-configuration repository into the tdr-auth-server directory
2. Build the docker image locally: 
  * Navigate to the cloned repository: `$ cd tdr-auth-server`
  * Run the docker build command: `$ docker build -t nationalarchives/tdr-auth-server:[your build tag] .`
3. Run the local docker image: `$ docker run -d --name [some name] -p 8081:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -e TDR_KEYCLOAK_IMPORT=/tmp/realm.json -e CLIENT_SECRET=[some value] -e BACKEND_CHECKS_CLIENT_SECRET=[some value] -e KEYCLOAK_CONFIGURATION_PROPERTIES=[env]_properties.json nationalarchives/tdr-auth-server:[your build tag]`
  * `KEYCLOAK_USER`: root Keycloak user name
  * `KEYCLOAK_PASSWORD`: password for the root Keycloak user
  * `KEYCLOAK_IMPORT`: Location of the generated Keycloak realm json file that contains the configuration for all TDR realms
  * `CLIENT_SECRET`: tdr client secret value
  * `BACKEND_CHECKS_CLIENT_SECRET`: tdr-backend-checks client secret value
  * `KEYCLOAK_CONFIGURATION_PROPERTIES`: json file containing specific Keycloak configuration to a TDR environment
4. Navigate to http://http://localhost:8081/auth/admin
5. Log on using the `KEYCLOAK_PASSWORD` and `KEYCLOAK_USER` defined in the docker run command

To log into the running docker container with a bash shell: `$ docker exec -it [your container name] bash`

Make changes to the realm export json files in the tmp directory as necessary to test new configurations.
