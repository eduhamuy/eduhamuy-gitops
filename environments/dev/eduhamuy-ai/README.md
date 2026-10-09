# eduhamuy-ai en DEV

Este overlay despliega el backend FastAPI de búsqueda híbrida en el namespace
`eduhamuy-dev`. El servicio carga una versión aprobada publicada en
`ai-artifacts-dev/indexes/hybrid_tfidf_embeddings/<BUILD_VERSION>`. El
servicio es `ClusterIP` y no tiene una ruta pública propia.

## Secreto requerido

Los valores no se guardan en Git. Crear o actualizar el secreto en el clúster:

```bash
read -r -s AZURE_STORAGE_SAS
echo
kubectl -n eduhamuy-dev create secret generic eduhamuy-ai-azure \
  --from-literal=AZURE_STORAGE_ACCOUNT=steduhamuyshared \
  --from-literal=AZURE_STORAGE_SAS="$AZURE_STORAGE_SAS" \
  --dry-run=client -o yaml | kubectl apply -f -
unset AZURE_STORAGE_SAS
```

`AZURE_STORAGE_SAS` debe permitir leer el contenedor privado
`ai-artifacts-dev`, incluido el prefijo de índice aprobado. Para la vista
previa debe incluir además lectura de `ai-source-dev`. Se puede configurar un
`AZURE_SOURCE_SAS` separado, de solo lectura y limitado a ese contenedor, como
mejora posterior; mientras no exista, el backend usa `AZURE_STORAGE_SAS`.
El backend verifica los hashes publicados en `artifact_manifest.json` antes de
cargar TF-IDF, embeddings y la configuración híbrida.

## Comprobación interna

Desde el namespace `eduhamuy-dev`, el backend responde en:

```text
http://eduhamuy-ai:8000/health
http://eduhamuy-ai:8000/search?q=educacion
http://eduhamuy-ai:8000/documents?limit=20&offset=0
```
