#!/bin/bash

# Set database config from Dokku's DATABASE_URL
# Idea from https://github.com/cowofevil/keycloak-dokku/blob/master/docker-entrypoint.sh
# Parameters documented at https://www.keycloak.org/server/all-config?q=db
if [ "$DATABASE_URL" != "" ]; 
then
    echo "[INFO] Found database configuration in DATABASE_URL=$DATABASE_URL"

    regex='^postgres://([a-zA-Z0-9_-]+):([a-zA-Z0-9]+)@([a-z0-9.-]+):([[:digit:]]+)/([a-zA-Z0-9_-]+)$'
    if [[ $DATABASE_URL =~ $regex ]]; 
    then
        export KC_DB_URL_HOST=${BASH_REMATCH[3]}
        export KC_DB_URL_PORT=${BASH_REMATCH[4]}
        export KC_DB_URL_DATABASE=${BASH_REMATCH[5]}
        export KC_DB_USERNAME=${BASH_REMATCH[1]}
        export KC_DB_PASSWORD=${BASH_REMATCH[2]}

        echo "[INFO] KC_DB_URL_HOST=$KC_DB_URL_HOST, KC_DB_URL_PORT=$KC_DB_URL_PORT, KC_DB_URL_DATABASE=$KC_DB_URL_DATABASE, KC_DB_USERNAME=$KC_DB_USERNAME, KC_DB_PASSWORD=$KC_DB_PASSWORD"
        
        export KC_DB=postgres
        export KC_PROXY=edge # Nginx manages SSL. No encryption between keycloak and nginx.
    fi

else
    echo "[ERROR] Could not find database configuration in DATABASE_URL variable. Did you properly setup and link postgres?"
fi

# Simply continue with the original entrypoint script
/opt/keycloak/bin/kc.sh start