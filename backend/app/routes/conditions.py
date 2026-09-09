from fastapi import APIRouter, HTTPException
from typing import List
from app.models.schemas import MedicalCondition
from app.services.db_service import DataService

router = APIRouter()

@router.get("/conditions", response_model=List[MedicalCondition])
async def get_conditions():
    return await DataService.get_all_conditions()

@router.get("/conditions/{name}", response_model=MedicalCondition)
async def get_condition(name: str):
    condition = await DataService.get_condition_by_name(name)
    if not condition:
        raise HTTPException(status_code=404, detail=f"Medical condition '{name}' not found.")
    return condition
