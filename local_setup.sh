#!/usr/bin/env bash

curl -o tdr-realm-export.json https://github.com/nationalarchives/tdr-configurations/blob/master/keycloak/tdr-realm-export.json &&
npm install &&
npm run build-theme && # This will compile the theme sass, copy the static assets to the theme `resource` directory and compile the typescript for WebAuthn.
sbt assemblyPackageDependency assembly # This will generate the jar for the GovUK Notify service, the Event Publisher service and the credential provider service
