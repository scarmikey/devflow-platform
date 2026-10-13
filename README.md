# DevFlow Platform

A containerized FastAPI service demonstrating CI/CD automation, container image publishing, and Kubernetes deployment.

## Architecture

- **Application:** Python 3.12, FastAPI, Uvicorn
- **Quality checks:** Ruff and pytest
- **CI/CD:** GitHub Actions and Jenkins
- **Container registry:** GitHub Container Registry (GHCR)
- **Orchestration:** Kubernetes on a local k3d cluster
- **Deployment safety:** Resource requests and limits, liveness and readiness probes

## CI Pipeline

The GitHub Actions workflow runs on pushes to `main` and pull requests targeting `main`. It installs dependencies, runs linting and tests, and builds the Docker image. Pushes to `main` publish versioned-by-commit and `latest` image tags to GHCR.

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
- `/health` — health check
- `/version` — application version

## Kubernetes Verification

Check deployment status:

```bash
kubectl rollout status deployment/devflow-api -n devflow
kubectl get deployment devflow-api -n devflow
kubectl get pods -n devflow
```

Test through a local port-forward:

```bash
kubectl port-forward service/devflow-api 8000:8000 -n devflow
```

Then access `http://127.0.0.1:8000/health`, `/version`, and `/`.

## Container Image

The published image is available at:

`ghcr.io/scarmikey/devflow-api`

For reproducible deployments, prefer a commit-specific image tag rather than `latest`.

## Project Status

The CI workflow and GHCR publishing have succeeded. The Kubernetes deployment has rolled out successfully with two healthy replicas, and the root, health, and version endpoints have been verified.
