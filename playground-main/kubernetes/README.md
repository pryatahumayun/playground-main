# Kubernetes

This folder is for Kubernetes concepts, examples, and common deployment patterns that apply whether the cluster is running on AKS, EKS, or somewhere else.

If you already know Kubernetes, the goal here is not to reteach basics. It is to keep a practical reference for:

- core objects
- day-to-day deployment patterns
- debugging habits
- how managed services like AKS and EKS differ from plain Kubernetes

## Core objects

### Namespace

Namespaces logically separate workloads in a cluster.

Common uses:

- split apps by team or environment
- avoid name collisions
- apply policies and quotas

Example:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: bugz
```

### Deployment

A Deployment manages a desired number of pod replicas and handles rolling updates.

Common things you configure:

- replica count
- container image
- ports
- environment variables
- readiness and liveness probes
- resource requests and limits

Example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bugz-api
  namespace: bugz
spec:
  replicas: 2
  selector:
    matchLabels:
      app: bugz-api
  template:
    metadata:
      labels:
        app: bugz-api
    spec:
      containers:
        - name: bugz-api
          image: example.azurecr.io/bugz-api:latest
          ports:
            - containerPort: 8080
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
```

### Service

A Service gives stable access to a set of pods selected by label.

Common service types:

- `ClusterIP`
  Internal-only service inside the cluster.
- `NodePort`
  Exposes a port on each node.
- `LoadBalancer`
  Asks the cloud provider to provision a load balancer.

Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: bugz-api
  namespace: bugz
spec:
  selector:
    app: bugz-api
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

### Ingress

Ingress is a Kubernetes API for HTTP routing. In managed clouds, an ingress controller translates that intent into a real load balancer.

Typical uses:

- host-based routing
- path-based routing
- TLS termination

## Common patterns

### App rollout pattern

Typical deployment flow:

1. update image tag
2. apply manifest or Helm release
3. Deployment creates a rolling update
4. readiness probes gate traffic
5. old pods terminate after new pods become ready

### Public app pattern

- Deployment for pods
- Service for stable pod access
- Ingress or `LoadBalancer` service for external entry

### Private internal service pattern

- Deployment
- `ClusterIP` Service
- no public ingress

### Config pattern

Use:

- `ConfigMap` for non-secret config
- `Secret` for secret values

## Health probes

Two of the most important pod settings are:

- readiness probe
- liveness probe

Readiness decides whether a pod should receive traffic.
Liveness decides whether Kubernetes should restart the container.

If a rollout behaves strangely, probes are one of the first places to check.

## Scaling

Main scaling layers:

- more pod replicas
- HPA for horizontal pod autoscaling
- cluster autoscaler or cloud autoscaling for node capacity

In managed platforms:

- AKS and EKS both add cloud-specific details around node scaling and load balancers

## Debugging checklist

When an app is not working, a fast Kubernetes debugging path is usually:

1. `kubectl get pods -A`
2. `kubectl describe pod <name>`
3. `kubectl logs <pod>`
4. `kubectl get svc`
5. `kubectl get endpoints` or `kubectl get endpointslice`
6. `kubectl describe deployment <name>`
7. `kubectl get events --sort-by=.metadata.creationTimestamp`

Common failure areas:

- image pull issues
- readiness probe failures
- wrong labels between Service and pods
- resource pressure
- bad environment variables or secrets

## Managed Kubernetes note

Kubernetes concepts stay the same across clouds, but the cloud integration changes:

- AKS specifics are mostly Azure networking, identity, and surrounding services
- EKS specifics are mostly AWS networking, IAM, and load balancer/controller integration

See:

- [AKS](/C:/Users/pryat/Downloads/playground-main/playground-main/azure/aks/README.md)
- [EKS](/C:/Users/pryat/Downloads/playground-main/playground-main/aws/eks/README.md)

## Examples in this folder

- [namespace.yaml](/C:/Users/pryat/Downloads/playground-main/playground-main/kubernetes/examples/namespace.yaml)
- [deployment.yaml](/C:/Users/pryat/Downloads/playground-main/playground-main/kubernetes/examples/deployment.yaml)
- [service.yaml](/C:/Users/pryat/Downloads/playground-main/playground-main/kubernetes/examples/service.yaml)

These are simple reference manifests based on the `bugz-azure-aks` sample app.
