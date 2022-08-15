# tekton

## Tekton Setup

```bash
# core
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# add support for triggers (required to enable use of webhooks)
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml

# add support for operator actions (global pipeline config, pruner, etc)
kubectl apply -f https://storage.googleapis.com/tekton-releases/operator/previous/v0.60.1/release.yaml
```

## Tasks from Tekton Hub
Tasks used for this demo that are installed from the Tekton Hub

```bash
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/kaniko/0.6/kaniko.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.8/git-clone.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/github-open-pr/0.2/github-open-pr.yaml
```
