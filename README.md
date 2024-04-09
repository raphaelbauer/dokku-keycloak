# Deploy Keycloak to Dokku

This works for
- dokku version 0.34.2
- keycloak 24.0.2

## Intro

This repository allows to deploy the [Keycloak](https://www.keycloak.org) Identity and Access Management Solution to Dokku. It provides a wrapper around the official Keycloak Docker image with some tiny modifications to make it work on Dokku (see dokku-kc.sh).

Based on work from
- https://github.com/cowofevil/keycloak-dokku
- https://github.com/davidpodhola/keycloak-dokku
- https://github.com/mieckert/keycloak-heroku

Kudos to them!

## Basic setup on Dokku

There is no magic here 
- Create the new application
- Create a postgres database and link it
- Set some parameters (admin password, hostname, ...) to make keycloak work
- Push keycloak

In CLI commands this will look roughly that way

```
# On your dokku server:
dokku apps:create keycloak
dokku config:set keycloak KC_HOSTNAME=keycloak.example.com
dokku config:set keycloak KEYCLOAK_ADMIN=admin KEYCLOAK_ADMIN_PASSWORD=YOUR_VERY_SECRET_AND_LONG_PASSWORD
dokku config:set keycloak KC_PROXY=edge # Nginx manages SSL. No encryption between keycloak and nginx.
dokku postgres:create keycloakdb
dokku postgres:link keycloakdb keycloak
dokku domains:add keycloak keycloak.example.com
dokku ports:add keycloak https:443:8443 http:80:8080

# Then let's get the keycloak docker repo
git clone git@github.com:raphaelbauer/dokku-keycloak.git
cd dokku-keycloak
git remote add dokku dokku@example.com:keycloak  # replace example.com with your dokku server name
git push dokku

# Back on your dokku server remove the admin password from the 
# env variables - they are only needed for the initial startup
dokku config:unset keycloak KEYCLOAK_ADMIN KEYCLOAK_ADMIN_PASSWORD

# Finally, let's configure SSL:
dokku letsencrypt:enable keycloak
```
