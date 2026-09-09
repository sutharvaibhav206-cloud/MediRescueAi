from fastapi import APIRouter
from typing import List, Optional
from app.models.schemas import FirstAidGuide
from app.services.db_service import DataService

router = APIRouter()

@router.get("/first-aid", response_model=List[FirstAidGuide])
async def get_first_aid(category: Optional[str] = None):
    if category:
        return await DataService.get_first_aid_by_category(category)
    return await DataService.get_all_first_aid()
