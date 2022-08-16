# tekton

## TODO
- [ ] add triggers for pr, branch and tag/release events
- [ ] create seperate build and release pipelines
- [ ] deploy to multiple stages (different pipeline in different repo?)
- [ ] solve chicken/egg scenario
    - flux deploys tekton and pipelines
    - pipelines run on each commit
    - flux runs on a time interval
    - the pipeline may be updated and committed, but the old pipeline will still run until the next flux sync
    - this will cause a slight diff between expected pipeline configs
    - one solution would be to separate pipeline code from dev code. these usually live together so idk how the dev experiance would be 
- [ ] fix error when destination branch exists
- [ ] fix error if pr already exists

## Tekton Setup
### Flux
```bash
kubectl apply -f flux.yaml
```

### Manual
```bash
# core
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.38.3/release.yaml

# add support for triggers (required to enable use of webhooks)
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.20.2/release.yaml
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.20.2/interceptors.yaml

# add support for operator actions (global pipeline config, pruner, etc)
kubectl apply -f https://storage.googleapis.com/tekton-releases/operator/previous/v0.60.1/release.yaml

# tasks used for this demo that are installed from the Tekton Hub
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/kaniko/0.6/kaniko.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.8/git-clone.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/github-open-pr/0.2/github-open-pr.yaml
```
