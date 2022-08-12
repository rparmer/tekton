# tekton

## Tekton Setup

```bash
# core
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# add support for triggers
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml

# add support for operator actions (global pipeline config, pruner, etc)
kubectl apply -f https://storage.googleapis.com/tekton-releases/operator/previous/v0.60.1/release.yaml
```
