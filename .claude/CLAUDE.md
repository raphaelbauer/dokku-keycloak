# dokku-keycloak

A thin wrapper around the official Keycloak image so it runs on Dokku.

- `Dockerfile` pins the Keycloak version (`quay.io/keycloak/keycloak:<version>`).
- `dokku-kc.sh` is the entrypoint. It translates Dokku's `DATABASE_URL` into Keycloak's `KC_DB_*` variables and then runs `kc.sh start`.
- `README.md` lists the tested Dokku version and Keycloak minor version (e.g. `26.8`).

## Upgrading Keycloak

1. Find the latest release: https://github.com/keycloak/keycloak/releases/latest (tags are on quay.io/keycloak/keycloak).
2. Change the tag in `Dockerfile`.
3. If the minor version changed, update the "This works for" list in `README.md` and read the Keycloak upgrading guide for breaking changes.
4. Smoke-test locally before committing:

```
docker build -t dokku-keycloak-smoke .
docker network create kc-smoke-net
docker run -d --name kc-smoke-db --network kc-smoke-net \
  -e POSTGRES_USER=keycloak -e POSTGRES_PASSWORD=secret123 -e POSTGRES_DB=keycloakdb postgres:17-alpine
docker run -d --name kc-smoke-app --network kc-smoke-net -p 18080:8080 \
  -e DATABASE_URL=postgres://keycloak:secret123@kc-smoke-db:5432/keycloakdb \
  -e KC_HOSTNAME=localhost dokku-keycloak-smoke
# wait for "Keycloak <version> ... started" in `docker logs kc-smoke-app`, then:
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:18080/realms/master   # expect 200
docker rm -f kc-smoke-app kc-smoke-db && docker network rm kc-smoke-net
```

## Gotchas

- The `DATABASE_URL` regex in `dokku-kc.sh` only accepts alphanumeric passwords. Dokku's postgres plugin generates those, but a hand-made URL with special characters will silently skip the DB setup.
- Commit messages follow the style `Bump Keycloak to <version>`.
