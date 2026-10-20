import os

from fastapi import FastAPI

app = FastAPI(title="DevFlow API")

VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def root():
    return {
        "service": "devflow-api",
        "version": VERSION,
        "status": "running",
    }


@app.get("/health")
def health():
    """Keep the existing health endpoint for compatibility."""
    return {"status": "healthy"}


@app.get("/health/live")
def liveness():
    """Report whether the application process is responding."""
    return {"status": "alive"}


@app.get("/health/ready")
def readiness():
    """Report whether the application is ready to receive traffic."""
    return {"status": "ready"}


@app.get("/version")
def version():
    return {"version": VERSION}
