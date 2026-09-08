#!/usr/bin/env bash
# Ejecutar en la VM AIO; no imprime ni guarda credenciales en Git.
set -euo pipefail
sudo kubectl get node vm-eduhamuy-aio >/dev/null
if sudo kubectl -n eduhamuy-aio get secret eduhamuy-auth >/dev/null 2>&1; then
  echo 'eduhamuy-auth ya existe; no se reemplazará.'
  exit 1
fi
umask 077
auth_tmp_dir=$(mktemp -d)
trap 'rm -rf "$auth_tmp_dir"; unset keycloak_client_secret' EXIT
read -r -s -p 'Client secret de eduhamuy-web en Keycloak: ' keycloak_client_secret </dev/tty
printf '\n'
if [[ -z "$keycloak_client_secret" ]]; then
  echo 'El secreto no puede estar vacío.' >&2
  exit 1
fi
printf '%s' "$keycloak_client_secret" > "$auth_tmp_dir/AUTH_KEYCLOAK_SECRET"
unset keycloak_client_secret
openssl rand -hex 32 | tr -d '\n' > "$auth_tmp_dir/AUTH_SECRET"
sudo kubectl -n eduhamuy-aio create secret generic eduhamuy-auth \
  --from-file=AUTH_SECRET="$auth_tmp_dir/AUTH_SECRET" \
  --from-file=AUTH_KEYCLOAK_SECRET="$auth_tmp_dir/AUTH_KEYCLOAK_SECRET"
