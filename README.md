# tekton

## TODO
- [x] add triggers for pr, branch and tag/release events
- [x] create seperate build and release pipelines 
- [x] deploy to multiple stages (different pipeline in different repo?)
    - created new EventListener with new triggers
    - deployed to new namespace, probably did not need to but did to avoid pipeline name conflicts
- [x] solve chicken/egg scenario - ***see below***
    - flux deploys tekton and pipelines
    - pipelines run on each commit
    - flux runs on a time interval
    - the pipeline may be updated and committed, but the old pipeline will still run until the next flux sync
    - this will cause a slight diff between expected pipeline configs
    - one solution would be to separate pipeline code from dev code. these usually live together so idk how the dev experiance would be 
- [x] fix error when destination branch exists (custom task, fixed by fetch before checkout and `push -f`)
- [ ] fix error if pr already exists
- [ ] fully parameterize pipelines
    - possible support for configmaps

### Chicken/egg scenario
Adding a directory filter to the EventListener helped address the chicken/egg scenario, but it did not solve it completely.  Here is an example filter used to only trigger a pipeline when content changes in the `demo` directory.
```yaml
- name: "only on 'demo' directory changes"
  ref:
  name: cel
  params:
  - name: filter
    value: >
      body.head_commit.added.exists(x, x.startsWith('demo/')) ||
      body.head_commit.removed.exists(x, x.startsWith('demo/')) ||
      body.head_commit.modified.exists(x, x.startsWith('demo/'))
```
This helps to only kick off a pipeline on relevent changes, but it does not fully prevent the chicken/egg scenario.  For example say a file is change in the demo directory and in the pipelines directory, the old pipeline would kick off before Flux had a chance to deploy the new pipeline changes.  Given the current design of both tools there is not a way to fully prevent this type of scenario.

## Tekton Setup
### Credentials
This demo is not configured to use SOPS, so update the `pipeline-auth-sample.yaml` file with a true Github API token and manually apply it to the cluster before getting started.
```bash
kubectl apply -f pipeline-auth-sample.yaml
```

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

# add support for operator actions (global pipeline config, pruner, etc) - optional
kubectl apply -f https://storage.googleapis.com/tekton-releases/operator/previous/v0.60.1/release.yaml

# tasks used for this demo that are installed from the Tekton Hub
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/kaniko/0.6/kaniko.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.8/git-clone.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/github-open-pr/0.2/github-open-pr.yaml
```
