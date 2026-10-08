# eduhamuy-ai en DEV

Este overlay despliega el backend FastAPI de búsqueda híbrida en el namespace
`eduhamuy-dev`. El servicio carga la versión experimental publicada en
`ai-artifacts-dev/indexes/hybrid_tfidf_embeddings/<BUILD_VERSION>`. El
servicio es `ClusterIP` y no tiene una ruta pública propia.

## Secreto requerido

Los valores no se guardan en Git. Crear o actualizar el secreto en el clúster:

```bash
read -r -s AZURE_STORAGE_SAS
read -r -s AZURE_SOURCE_SAS
echo
kubectl -n eduhamuy-dev create secret generic eduhamuy-ai-azure \
  --from-literal=AZURE_STORAGE_ACCOUNT=steduhamuyshared \
  --from-literal=AZURE_STORAGE_SAS="$AZURE_STORAGE_SAS" \
  --from-literal=AZURE_SOURCE_SAS="$AZURE_SOURCE_SAS" \
  --dry-run=client -o yaml | kubectl apply -f -
unset AZURE_STORAGE_SAS
unset AZURE_SOURCE_SAS
```

`AZURE_STORAGE_SAS` debe permitir leer el contenedor privado
`ai-artifacts-dev`, incluido el prefijo de índice aprobado. `AZURE_SOURCE_SAS`
debe ser de solo lectura y estar limitado al contenedor `ai-source-dev`; se usa
solamente para transmitir un PDF solicitado mediante su identificador del
índice. El backend verifica los hashes publicados en
`artifact_manifest.json` antes de cargar TF-IDF, embeddings y la configuración
híbrida.

## Comprobación interna

Desde el namespace `eduhamuy-dev`, el backend responde en:

```text
http://eduhamuy-ai:8000/health
http://eduhamuy-ai:8000/search?q=educacion
http://eduhamuy-ai:8000/documents?limit=20&offset=0
```
