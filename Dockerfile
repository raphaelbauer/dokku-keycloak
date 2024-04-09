FROM quay.io/keycloak/keycloak:24.0.2

COPY dokku-kc.sh /opt/keycloak/bin

ENTRYPOINT ["/opt/keycloak/bin/dokku-kc.sh"]
