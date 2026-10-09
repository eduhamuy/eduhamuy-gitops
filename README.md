# eduhamuy-gitops

Configuración declarativa de los despliegues de EduHamuy en Kubernetes. Argo CD
reconcilia los manifiestos aprobados de este repositorio con cada entorno.

## Componentes y entornos

Los overlays se encuentran en [`environments/`](environments/):

- `aio/`: componentes compartidos de desarrollo local/integrado;
- `dev/`: `eduhamuy-web`, `eduhamuy-ai` y Keycloak;
- `test/`, `stage/` y `prod/`: overlays existentes de web y autenticación.

Las aplicaciones Argo CD se declaran en
[`argocd/applications/`](argocd/applications/). El backend AI tiene por ahora
un overlay operativo en DEV; los entornos adicionales se habilitarán cuando
dispongan de corpus, evaluación, artefactos y secretos propios.

## Flujo de entrega

1. `eduhamuy-web` o `eduhamuy-ai` construye una imagen en GHCR con un SHA de
   Git como etiqueta.
2. El workflow de promoción abre un Pull Request en este repositorio y cambia
   `newTag` en el `kustomization.yaml` del entorno objetivo.
3. Al aprobar y fusionar el cambio, Argo CD aplica la versión declarada.

El índice AI sigue un flujo independiente: **Build AI Index** publica una
construcción evaluada, **Promote AI Index** la copia a `indexes/` tras verificar
sus hashes y **Deploy AI Index** abre un PR que actualiza `ARTIFACT_PREFIX`.
Así, una imagen y un índice se pueden aprobar y revertir por separado.

## Azure Blob Storage y artefactos AI

Azure Storage es privado y no forma parte de Git. En DEV la organización es:

```text
steduhamuyshared/
├── ai-source-dev/corpora/<CORPUS_VERSION>/pdfs/
├── ai-evaluation-dev/suites/<SUITE_VERSION>/evaluation_queries.csv
└── ai-artifacts-dev/
    ├── builds/hybrid_tfidf_embeddings/<BUILD_VERSION>/
    └── indexes/hybrid_tfidf_embeddings/<BUILD_VERSION>/
```

El manifiesto del backend AI selecciona un prefijo bajo `indexes/`; los PDFs,
las suites y los secretos SAS no se versionan aquí. El secreto
`eduhamuy-ai-azure` se crea directamente en el clúster y el detalle del overlay
DEV está en [`environments/dev/eduhamuy-ai/README.md`](environments/dev/eduhamuy-ai/README.md).

Quienes no tengan acceso a Azure pueden consultar información de referencia en
la [carpeta compartida de Google Drive](https://drive.google.com/drive/folders/1OPa6n57k_e7YeXuRJWVDL779GUC747dJ?usp=sharing).
No es un origen de despliegue ni reemplaza los manifiestos auditables de Azure.

## Seguridad

No confirmar SAS, connection strings, contraseñas, tokens de GitHub ni secretos
de Keycloak. Los valores sensibles se gestionan como secretos de GitHub,
Kubernetes o Azure, según el flujo que los consume.

Las imágenes se publican en GitHub Container Registry, por ejemplo:

```text
ghcr.io/eduhamuy/eduhamuy-web:<git-sha>
```
