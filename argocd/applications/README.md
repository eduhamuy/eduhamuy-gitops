# Argo CD Applications

These manifests declare the Argo CD Applications currently running in AKS.
They are intentionally kept separate from the application overlays they sync.

The resources are bootstrapped once in the `argocd` namespace. After that,
changes to their `spec` must be reviewed through this repository instead of
being edited directly in the cluster.

Before applying an update, compare the live resources with these manifests:

```bash
kubectl -n argocd get application eduhamuy-web-dev -o yaml
kubectl -n argocd get application eduhamuy-web-test -o yaml
kubectl -n argocd get application eduhamuy-web-prod -o yaml
kubectl -n argocd get application eduhamuy-gateway -o yaml
```

Apply the manifests only after reviewing the diff:

```bash
kubectl apply -f argocd/applications/
```
