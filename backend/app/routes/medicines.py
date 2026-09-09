from fastapi import APIRouter, Query
from typing import List, Optional
from app.models.schemas import Medicine
from app.services.db_service import DataService

router = APIRouter()

@router.get("/medicines", response_model=List[Medicine])
async def search_medicines(q: Optional[str] = Query(None, description="Search term for medicine name or common uses")):
    return await DataService.search_medicines(query=q or "")
