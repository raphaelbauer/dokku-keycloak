FROM quay.io/keycloak/keycloak:26.5.6

COPY dokku-kc.sh /opt/keycloak/bin

ENTRYPOINT ["/opt/keycloak/bin/dokku-kc.sh"]
