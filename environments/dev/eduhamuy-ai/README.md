# eduhamuy-ai en DEV

Este overlay despliega el backend FastAPI de búsqueda TF-IDF en el namespace
`eduhamuy-dev`. El servicio es `ClusterIP` y no tiene una ruta pública propia.

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

El SAS debe permitir leer el contenedor privado `ai-artifacts`, donde deben
existir `tfidf_vectorizer.joblib`, `X_tfidf.npz` y
`processed_documents.csv`.

## Comprobación interna

Desde el namespace `eduhamuy-dev`, el backend responde en:

```text
http://eduhamuy-ai:8000/health
http://eduhamuy-ai:8000/search?q=educacion
```
