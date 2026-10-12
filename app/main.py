from fastapi import FastAPI
import os

app = FastAPI(title="DevFlow API")

VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def root():
    return {
        "service": "devflow-api",
        "version": VERSION,
        "status": "running"
    }


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.get("/version")
def version():
    return {"version": VERSION}
