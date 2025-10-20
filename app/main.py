import os
from fastapi import FastAPI
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """
    Application settings loaded from environment variables.
    """
    ENVIRONMENT: str = "unknown"

settings = Settings()
app = FastAPI()

@app.get("/")
def read_root():
    """
    Root endpoint for health checks.
    """
    return {"status": "ok"}

@app.get("/status")
def read_status():
    """
    Returns the current operating environment.
    """
    return {"environment": settings.ENVIRONMENT}