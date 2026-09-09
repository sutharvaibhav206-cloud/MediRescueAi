from fastapi import APIRouter
from datetime import datetime, timezone
from app.models.schemas import HealthResponse
from app.database.mongo import db_manager
from app.services.ml_service import ml_service

router = APIRouter()

@router.get("/health", response_model=HealthResponse)
async def health_check():
    return HealthResponse(
        status="healthy",
        database_connected=db_manager.is_connected,
        ml_model_loaded=ml_service.model is not None,
        timestamp=datetime.now(timezone.utc).isoformat()
    )
