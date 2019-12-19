## TDR Auth server

All of our documentation is stored in the [tdr-dev-documentation](https://github.com/nationalarchives/tdr-dev-documentation) repository.

#### Dockerfile
This repository holds the Dockerfile used to build our keycloak server which we will be using for authentication and authorisation. 

#### Jenkinsfile
There is a Jenkinsfile build and push this to docker hub. The Jenkinsfile has three stages.
The first two are run in parallel. 

One clones the Home Office's govuk keycloak theme project and builds it.

The other clones a [TNA fork](https://github.com/nationalarchives/keycloak-sms-authenticator-sns) of BEIS' SMS MFA keycloak repo and builds that. The original repo is missing a dependency in the pom which I've added in the fork. 

The output from both of these are stashed and then unstashed in the third stage. They are then used to build the Dockerfile.

#### Configuration file
The standalone-ha.xml is mostly the standard configuration for keycloak with a few changes to get it to work with the load balancer. Some of these are discussed in the keycloak [documentation](https://www.keycloak.org/docs/latest/server_installation/#_setting-up-a-load-balancer-or-proxy)
