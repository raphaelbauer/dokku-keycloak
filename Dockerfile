FROM quay.io/keycloak/keycloak:26.0.2

COPY dokku-kc.sh /opt/keycloak/bin

ENTRYPOINT ["/opt/keycloak/bin/dokku-kc.sh"]
