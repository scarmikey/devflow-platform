# DevFlow Platform

A containerized FastAPI service demonstrating CI/CD automation, container image publishing, and Kubernetes deployment using Kustomize.

## Architecture

- **Application:** Python 3.12, FastAPI, Uvicorn
- **Quality checks:** Ruff and pytest
- **CI/CD:** GitHub Actions and Jenkins with a reusable shared library
- **Container registry:** GitHub Container Registry (GHCR)
- **Orchestration:** Kubernetes on a local k3d cluster
- **Configuration management:** Kustomize base and environment-specific overlay
- **Deployment safety:** Resource requests and limits, liveness and readiness probes

## Deployment Architecture

The Kubernetes manifests use a Kustomize base with a GHCR-specific overlay.

```text
kubernetes/devflow/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    └── ghcr/
        ├── deployment-patch.yaml
        └── kustomization.yaml
```

The base defines the namespace, Deployment, Service, two replicas, resource limits, and health probes. It uses the locally built `devflow-api:1.0.0` image.

The GHCR overlay reuses the base and patches the Deployment to use an immutable GHCR image digest. This separates local development configuration from registry-based deployment configuration.

## CI Pipeline

The GitHub Actions workflow runs on pushes to `main` and pull requests targeting `main`. It installs dependencies, runs linting and tests, and builds the Docker image. Pushes to `main` publish commit-specific and `latest` image tags to GHCR.

Jenkins also runs the Python lint and test stages through the `devflow` shared library.

## Run Locally

Install dependencies:

```bash
python -m pip install -r requirements-dev.txt
```

Run checks:

```bash
python -m ruff check app tests
python -m pytest -q
```

Build and run the API:

```bash
docker build -t devflow-api:local .
docker run --rm -p 8000:8000 devflow-api:local
```

Endpoints:

- `/` — service status
- `/health` — general health check
- `/health/live` — liveness probe
- `/health/ready` — readiness probe
- `/version` — application version

## Kubernetes Deployment

### Local k3d deployment

Render the base configuration:

```bash
kubectl kustomize kubernetes/devflow/base
```

Apply it to the cluster:

```bash
kubectl apply -k kubernetes/devflow/base
```

The base expects the local image `devflow-api:1.0.0` to be available to the k3d cluster. Build and import that image before applying the base if necessary.

### GHCR deployment

Render the GHCR overlay:

```bash
kubectl kustomize kubernetes/devflow/overlays/ghcr
```

Deploy the GHCR image:

```bash
kubectl apply -k kubernetes/devflow/overlays/ghcr
```

The overlay references an immutable image digest. Update the digest in `overlays/ghcr/deployment-patch.yaml` when deploying a different published image.

### Verify the deployment

Check rollout status and replica health:

```bash
kubectl rollout status deployment/devflow-api -n devflow
kubectl get deployment devflow-api -n devflow
kubectl get pods -n devflow
```

Test through a local port-forward:

```bash
kubectl port-forward service/devflow-api 8000:8000 -n devflow
```

In another terminal, test the health endpoints:

```bash
curl http://127.0.0.1:8000/health
curl http://127.0.0.1:8000/health/live
curl http://127.0.0.1:8000/health/ready
```

You can also access `/`, `/version`, and the health endpoints through the forwarded port.

## Container Image

The published image is available at:

`ghcr.io/scarmikey/devflow-api`

GitHub Actions publishes commit-specific tags and `latest`. For reproducible deployments, prefer an immutable image digest or a commit-specific tag over `latest`.

## Project Status

The GitHub Actions CI workflow and GHCR publishing have succeeded. The GHCR image was deployed to the local k3d cluster using the Kustomize overlay. The Deployment rolled out successfully with two healthy replicas, and `/health`, `/health/live`, and `/health/ready` returned their expected statuses.

Jenkins provides a separate lint-and-test pipeline using the `devflow` shared library.
