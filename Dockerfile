FROM quay.io/keycloak/keycloak:22.0.1

COPY dokku-kc.sh /opt/keycloak/bin

ENTRYPOINT ["/opt/keycloak/bin/dokku-kc.sh"]