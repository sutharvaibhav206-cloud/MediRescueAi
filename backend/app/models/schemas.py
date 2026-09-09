from pydantic import BaseModel
from typing import List, Optional

# Medical Condition Schemas
class MedicineInfo(BaseModel):
    name: str
    purpose: str
    warning: str

class MedicalCondition(BaseModel):
    id: Optional[str] = None
    name: str
    symptoms: List[str]
    severity: str
    first_aid: List[str]
    do_not: List[str] = []
    warning_signs: List[str] = []
    medicine_information: List[MedicineInfo] = []

# First-Aid Guide Schemas
class FirstAidGuide(BaseModel):
    id: Optional[str] = None
    category: str
    title: str
    what_happened: str
    immediate_first_aid: List[str]
    do_list: List[str]
    dont_list: List[str]
    when_to_seek_help: List[str]
    icon: Optional[str] = "medical_services"

# Medicine Schemas
class Medicine(BaseModel):
    id: Optional[str] = None
    name: str
    purpose: str
    common_uses: List[str]
    important_warnings: List[str]
    contraindications: List[str] = []
    disclaimer: str = "Consult a qualified doctor or pharmacist before taking any medication."

# Symptom Checker Schemas
class SymptomCheckRequest(BaseModel):
    symptoms_text: str
    selected_symptoms: Optional[List[str]] = []
    age: Optional[int] = None
    gender: Optional[str] = None
    duration: Optional[str] = None

class PossibleCondition(BaseModel):
    name: str
    confidence: float
    severity: str = "Moderate"

class SymptomCheckResponse(BaseModel):
    is_emergency: bool = False
    emergency_warning: Optional[str] = None
    possible_conditions: List[PossibleCondition] = []
    severity: str = "Moderate"
    first_aid: List[str] = []
    do_not: List[str] = []
    warning_signs: List[str] = []
    medicine_information: List[MedicineInfo] = []
    recommendation: str
    disclaimer: str = "IMPORTANT: General information and emergency guidance only. NOT a substitute for professional medical advice or prescription."

# Health Schemas
class HealthResponse(BaseModel):
    status: str
    database_connected: bool
    ml_model_loaded: bool
    timestamp: str
