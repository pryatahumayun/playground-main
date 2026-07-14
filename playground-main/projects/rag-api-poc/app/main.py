from fastapi import FastAPI

from app.api.routes.health import router as health_router
from app.api.routes.ingestion import router as ingestion_router
from app.api.routes.query import router as query_router
from app.core.config import get_settings
from app.core.logging import configure_logging

configure_logging(get_settings().log_level)

app = FastAPI(title="RAG API POC")
app.include_router(health_router)
app.include_router(ingestion_router)
app.include_router(query_router)
