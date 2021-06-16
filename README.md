# TDR Auth server

All of our documentation is stored in the [tdr-dev-documentation](https://github.com/nationalarchives/tdr-dev-documentation) repository.

## Updating Keycloak version

**Important Note**

When updating Keycloak version the **tdr-entrypoint.sh** script needs to be updated to ensure it is kept up-to-date with any changes:
1. Copy latest version of the file from GitHub: https://github.com/keycloak/keycloak-containers/blob/master/server/tools/docker-entrypoint.sh
2. Copy the new version of the Keycloak provided entry point script into the *tdr-entrypoint.sh* script
3. Add the following commands to the updated *tdr-entrypoint.sh*:

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

## Docker Container

The docker container runs with the pre-defined `keycloak` user.

This user is part of the `root` group, but *does not* have root user permissions.

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

## TDR Theme

TDR has its own Keycloak theme: `tdr`

The TDR theme makes use of the standard Keycloak base theme, with specific overrides to the theme resources where required.

The TDR theme styling is a combination of [Gov.UK Design System](https://design-system.service.gov.uk/), with TDR specific overrides. 

It is based on the theme developed by the Home Office: https://github.com/UKHomeOffice/keycloak-theme-govuk 

For full documentation on Keycloak themes see: https://www.keycloak.org/docs/latest/server_development/index.html#_themes

## GovUK Notify Service

TDR Keycloak uses GovUK Notify as its default email sender provider.

Each TDR environment has a separate GovUK Notify service defined:
* TDR Intg - service for the integration environment
* TDR Staging - service for the staging environment
* Transfer Digital Records - service for the production environment

The GovUK Notify Services require two secret values that are stored as AWS SSM pararmeters:
* API Key: this is the key to access the GovUK Notify service
* Template ID: this is the id of the GovUK Notify service email template

Both these AWS SSM parameter *values* need to set manually in the AWS SSM parameter store, as it is not programmatically possible to retrieve these from GovUK Notify

See here for full details about the GovUK Notify service: https://www.notifications.service.gov.uk/

### Keycloak Email Sender Configuration

GovUK Notify is defined as the default email sender in the `standalone-ha.xml`:

  ```
  <spi name="emailSender">
    <default-provider>govuknotify</default-provider>
      <provider name="govuknotify" enabled="true">
        <properties />                        
      </provider>
  </spi>
  ```
### Requesting access to GovUK Notify Services

Contact a member of the TDR team to request access to the TDR GovUK Notify Services

## Updating TDR Realm Configuration json

A separate Jenkins job is used to update the TDR realm configuration: TDR Auth Server Update

This is because on container start up, if a realm already exists, its configuration json is ignored. So restarting the container will not update the configuration.

The TDR Auth Server Update Jenkins job updates existing realm configuration using the Keycloak REST APIs: https://www.keycloak.org/docs-api/11.0/rest-api/index.html

Two REST endpoints are used to update a Keycloak realm:
* `PUT /{realm}`: updates the top-level information of the realm.    
  * Takes the full realm representation: https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_realmrepresentation
  * Any user, roles or client information in the representation are ignored.
* `POST /{realm}/partialImport`: Partial import from a JSON file to an existing realm.
  * Takes a partial realm representation: https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_partialimportrepresentation
  * Allows importation of configuration for: `clients`, `roles`, `groups` and `identity providers` only
  * Uses a policy option that controls what behaviour occurs for existing realm resources:
    * `SKIP`: Skips any existing resources and does not update them
    * `FAIL`: Causes the whole import to fail
    * `OVERWRITE`: Overwrites the existing resource
    * **Note**: This option only applies to the partial import

**Note**: The `OVERWRITE` option is not available in the Jenkins job as it causes undesirable behaviours, such as users existing group mappings to be removed.

To update Keycloak with, for example, a new client:
1. Update the relevant Keycloak json configuration file (tdr-realm-export.json). See README for the tdr-configuration private repository on how to do this.
2. If the change to Keycloak makes use of a new secret value, for example a new client secret:
    * Add the new secret value to the parameter store using Terraform: https://github.com/nationalarchives/tdr-terraform-environments
    
    This ensures that the secret value is stored securely and is not exposed in the code.

    * Update the update_env_client_configuration.py script to replace the placeholder secret value in the relevant realm json configuration file, with the new secret value set in the Terraform.
3. Run the Jenkins build, selecting the relevant parameter options:
    * `STAGE`: the TDR environment to be updated
    * `UPDATE_POLICY`: what behaviour to apply if a resource already exists. See notes above regarding the possible options.
4. Once the Jenkins job has been completed log into the Keycloak instance that has been updated as an administrator, and check the expected changes have been made.

## Running Locally

To run, build and test locally:

1. Copy the tdr-realm-export.json from the tdr-configuration repository into the tdr-auth-server directory
2. Navigate to the cloned repository: `$ cd tdr-auth-server`
3. Build the TDR theme:
    * If npm is not installed install [nvm](https://github.com/nvm-sh/nvm) in root directory
    * Once nvm is installed run: `[root directory] $ nvm install 14.9`
    * Run the following commands in the root directory:  `[root directory] $ npm install` and `[root directory] $ npm run build-theme`
        * this will compile the theme sass and copy the static assets to the theme `resource` directory
4. Build the GovUk Notify spi jar:
    * Navigate to the `govuk-notify-spi` directory: `[root directory] $ cd govuk-notify-spi`
    * In the `govuk-notify-spi` directory run the following command: `sbt assembly`
    * This will generate the jar for the GovUK Notify service here: `govuk-notify-spi/target/scala-2.13/govuk-notify-spi.jar`
5. Change the Docker `COPY` command in the `Dockerfile` which copies the `govuk-notify-spi.jar` to the `deployments` directory, to copy the locally built jar:
  ```
  COPY govuk-notify-spi/target/scala-2.13/govuk-notify-spi.jar /opt/jboss/keycloak/standalone/deployments/
  ```
   * Do not commit this change to the `Dockerfile`
    
6. Build the docker image locally:
    * Run the docker build command: `[location of repo] $ docker build -t nationalarchives/tdr-auth-server:[your build tag] .`
6. Run the local docker image:
    ```
    [location of repo] $ docker run -d --name [some name] -p 8081:8080 \
    -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -e KEYCLOAK_IMPORT=/tmp/tdr-realm.json \
    -e REALM_ADMIN_CLIENT_SECRET=[some value] -e CLIENT_SECRET=[some value] -e BACKEND_CHECKS_CLIENT_SECRET=[some value] \
    -e REPORTING_CLIENT_SECRET=[some value] \
    -e USER_ADMIN_CLIENT_SECRET=[some value] \
    -e KEYCLOAK_CONFIGURATION_PROPERTIES=[env]_properties.json \
    -e FRONTEND_URL=[home page url] \
    -e GOVUK_NOTIFY_TEMPLATE_ID=[govuk notify service template id] \
    -e GOVUK_NOTIFY_API_KEY=[govuk notify service api key] \   
    -e DB_VENDOR=h2
    nationalarchives/tdr-auth-server:[your build tag]
    ```
    * `KEYCLOAK_USER`: root Keycloak user name
    * `KEYCLOAK_PASSWORD`: password for the root Keycloak user
    * `KEYCLOAK_IMPORT`: Location of the generated Keycloak TDR realm json file that contains the configuration for the TDR realm
    * `REALM_ADMIN_CLIENT_SECRET`: tdr realm admin client secret value
    * `CLIENT_SECRET`: tdr client secret value
    * `BACKEND_CHECKS_CLIENT_SECRET`: tdr-backend-checks client secret value
    * `USER_ADMIN_CLIENT_SECRET`: tdr user admin client secret value
    * `KEYCLOAK_CONFIGURATION_PROPERTIES`: json file containing specific Keycloak configuration to a TDR environment
    * `FRONTEND_URL`: TDR application home page URL
    * `GOVUK_NOTIFY_TEMPLATE_ID`: the GovUK Notify service template id secret value to be used
    * `GOVUK_NOTIFY_API_KEY`: the GovUK Notify service api key secret value to be used
    * `DB_VENDOR`: the type of database to use. In the dev environment, we use Keycloak's embedded H2 database
6. Navigate to http://localhost:8081/auth/admin
7. Log on using the `KEYCLOAK_PASSWORD` and `KEYCLOAK_USER` defined in the docker run command

To log into the running docker container with a bash shell: `$ docker exec -it [your container name] bash`

Make changes to the realm export json file as necessary to test new configurations.

### Update Realm Configuration Locally

To update the realm configuration on the locally running Keycloak instances:
1. Add the Keycloak configuration json file to the root of the project: tdr-realm-export.json
2. Make necessary changes to the configuration json
3. Add the following environment variables:
    * `REALM_ADMIN_CLIENT_SECRET`: tdr realm admin client secret value
    * `CLIENT_SECRET`: tdr client secret value
    * `BACKEND_CHECKS_CLIENT_SECRET`: tdr-backend-checks client secret value
    * `USER_ADMIN_CLIENT_SECRET`: tdr user admin client secret value
    * `KEYCLOAK_CONFIGURATION_PROPERTIES`: json file containing specific Keycloak configuration to a TDR environment
4. Run the following python command:

```
[location of repo] $ python update_tdr_realm.py local [update policy option: OVERWRITE/SKIP/FAIL]
```

### Update TDR Theme Locally

**Note:** The TDR theme sass is used by the TDR Transfer Frontend. When updating the sass for the theme, ensure that any changes are also implemented in the tdr-transfer-frontend repo: https://github.com/nationalarchives/tdr-transfer-frontend/tree/master/npm/css-src/sass
* This includes any changes to the `.stylelintrc.json`

1. Disable the Theme cache by changing the following in the `standalone-ha.xml` (**Note: do not merge these changes**):
    * staticMaxAge: -1
    * cacheThemes: false
    * cacheTemplates: false
    ```
    <theme>
        <staticMaxAge>-1</staticMaxAge>
        <cacheThemes>false</cacheThemes>
        <cacheTemplates>false</cacheTemplates>
        <welcomeTheme>${env.KEYCLOAK_WELCOME_THEME:keycloak}</welcomeTheme>
        <default>${env.KEYCLOAK_DEFAULT_THEME:keycloak}</default>
        <dir>${jboss.home.dir}/themes</dir>
    </theme>
    ```

2. Rebuild the image locally and run.
3. Make necessary changes to the TDR theme (freemarker templates/sass/static resources)
4. Run following command from the root directory: `[root directory] $ npm run build-local --container_name=[name of running container]`
5. Refresh the locally running Keycloak pages to see the changes.
6. Repeat steps 3 to 5 as necessary.

### Updating Emails

There are two components to consider when making changes to emails that Keycloak sends to users:
* the GovUK Notify Spi contained in the govuk-notify-spi directory
* the GovUK Notify template contained within the GovUK Notify service

Parameters from Keycloak to the GovUK template are passed using the personalisation Map in the NotifyEmailSenderProvider 

The key in the personalisation Map corresponds to the name of the personalisation variable defined in the template, for example: `((keycloakMessage))`

1. Make the necessary changes locally and build and run the Keycloak docker image locally
2. Make any necessary changes to the GovUKNotify TDR Intg service
 * this can be done by making changes to the existing keycloak template, or by creating a new test template and passing the test template's id in the docker `run` command environment variable: `GOVUK_NOTIFY_TEMPLATE_ID`
3. Deploy the new changes to Intg environment
4. Before deploying to each environment ensure any GovUK Notify template changes are made to the template in GovUK Notify service for the TDR environment:
 * TDR Intg
 * TDR Staging
 * Transfer Digital Records
 
#### Testing from the command line with sbt

The tests should be run in the `govuk-notify-spi` directory when using sbt on the command line 

## Databases

Keycloak uses a different database depending on whether it's running locally or on ECS. Local development uses the internal H2 database on the docker image. When it's running on ECS, it uses a postgresql RDS instance defined [here](https://github.com/nationalarchives/tdr-terraform-environments/blob/master/modules/keycloak/database.tf) 
 