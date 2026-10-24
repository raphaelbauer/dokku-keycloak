FROM quay.io/keycloak/keycloak:26.8.1

COPY dokku-kc.sh /opt/keycloak/bin

ENTRYPOINT ["/opt/keycloak/bin/dokku-kc.sh"]
