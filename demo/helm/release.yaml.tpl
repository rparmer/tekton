---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: demo
spec:
  interval: 5m
  chart:
    spec:
      chart: demo-chart
      version: ${CHART_VERSION}
      sourceRef:
        kind: HelmRepository
        name: rparmer-tekton
      interval: 1m
    values:
      resources:
        requests:
          cpu: 100m
          memory: 64Mi
        limits:
          cpu: 100m
          memory: 64Mi
