# Keycloak — AIO

Keycloak 26.7.3 gestionado por el Operator oficial, con una instancia y conexión
al PostgreSQL compartido mediante el Secret externo `keycloak-db`.
Ingress Traefik para `https://keycloak-aio.eduhamuy.com`, publicado por el túnel
Cloudflare existente. Despliegue y publicación pendientes de validación en la VM.

Sincronizar primero `keycloak-operator-aio`, crear el Secret y después sincronizar
`keycloak-aio`. Procedimiento operativo en la [Bitácora de EduHamuy](https://app.notion.com/p/3cfadb48638b80f19ad5d34c23970fad).
