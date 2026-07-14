from fastapi import APIRouter, HTTPException

from app.models.ingestion import IngestionRequest, IngestionSummary
from app.services.ingestion_service import IngestionService

router = APIRouter()


@router.post("/api/v1/ingestion/run", response_model=IngestionSummary)
async def run_ingestion(request: IngestionRequest) -> IngestionSummary:
    service = IngestionService(chunking_service=None)  # type: ignore[arg-type]
    raise HTTPException(status_code=501, detail="Implementation pending")
