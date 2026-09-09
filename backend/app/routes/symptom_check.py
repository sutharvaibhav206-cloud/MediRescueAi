from fastapi import APIRouter
from app.models.schemas import SymptomCheckRequest, SymptomCheckResponse, PossibleCondition, MedicineInfo
from app.services.safety_service import SafetyService
from app.services.ml_service import ml_service
from app.services.db_service import DataService

router = APIRouter()

# Default medicine suggestions mapping for common conditions
CONDITION_MEDICINES = {
    "Viral Fever": [
        MedicineInfo(
            name="Paracetamol (Crocin / Dolo 650 / Calpol)",
            purpose="General fever reduction and body pain relief",
            warning="Take after food. Do not exceed 4000mg total daily limit. Consult doctor if fever lasts > 3 days."
        )
    ],
    "Tension Headache / Migraine": [
        MedicineInfo(
            name="Paracetamol / Ibuprofen (Combiflam)",
            purpose="Symptomatic headache and tension pain relief",
            warning="Take strictly as instructed. Seek doctor advice for frequent severe headaches."
        )
    ],
    "Minor Cut / Wound": [
        MedicineInfo(
            name="Povidone-Iodine (Betadine) / Neosporin Ointment",
            purpose="Topical antiseptic ointment to prevent skin infection",
            warning="Clean wound bed with water before applying ointment. For external skin use only."
        )
    ],
    "Thermal Burn (Minor)": [
        MedicineInfo(
            name="Aloe Vera Gel / Silver Sulfadiazine (Burnol)",
            purpose="Cooling burn relief and infection prevention for minor 1st degree burns",
            warning="Flush under cool water first. Seek emergency care for large or deep burns."
        )
    ],
    "Dehydration / Heat Exhaustion": [
        MedicineInfo(
            name="Oral Rehydration Salts (ORS / Electral)",
            purpose="Restores lost fluids and essential electrolytes",
            warning="Mix packet strictly in clean drinking water according to package instructions."
        )
    ],
    "Gastroenteritis / Food Poisoning": [
        MedicineInfo(
            name="Oral Rehydration Salts (ORS) / Antacid",
            purpose="Rehydration solution and stomach acid balancing",
            warning="Crucial for preventing dehydration. Seek medical evaluation for persistent vomiting or bloody stool."
        )
    ],
    "Joint Sprain / Ligament Injury": [
        MedicineInfo(
            name="Diclofenac Gel (Volini / Omnigel) / Ibuprofen",
            purpose="Topical pain relief gel to reduce swelling and muscular soreness",
            warning="Apply topically on intact unbroken skin only. Do not apply near eyes or open wounds."
        )
    ],
    "Minor Allergic Reaction": [
        MedicineInfo(
            name="Cetirizine (Cetzine / Okacet 10mg)",
            purpose="Antihistamine for relief of allergic itching, sneezing, and rash",
            warning="May cause mild drowsiness. Avoid driving or operating machinery if affected."
        )
    ],
    "Nosebleed (Epistaxis)": [
        MedicineInfo(
            name="Saline Nasal Drops / Spray",
            purpose="Moisturizes dry nasal tissue to prevent nosebleed recurrence",
            warning="Pinch soft part of nose leaning forward for 10 minutes. Seek emergency help if bleeding exceeds 20 minutes."
        )
    ],
    "Insect Bite / Sting": [
        MedicineInfo(
            name="Calamine Lotion / Hydrocortisone Cream",
            purpose="Soothes localized itching, sting redness, and swelling",
            warning="Topical external use only. Seek emergency care if throat swelling or breathing difficulty occurs."
        )
    ]
}

@router.post("/symptom-check", response_model=SymptomCheckResponse)
async def check_symptoms(request: SymptomCheckRequest):
    # Step 1: Safety Layer Check for immediate emergencies
    safety_eval = SafetyService.evaluate_symptoms(
        symptoms_text=request.symptoms_text,
        selected_symptoms=request.selected_symptoms or []
    )
    if safety_eval:
        return SymptomCheckResponse(**safety_eval)

    # Step 2: ML Prediction Engine
    predictions = ml_service.predict(
        symptoms_text=request.symptoms_text,
        selected_symptoms=request.selected_symptoms or []
    )

    possible_conditions = [
        PossibleCondition(
            name=p["name"],
            confidence=p["confidence"],
            severity=p["severity"]
        )
        for p in predictions
    ]

    # Fetch first-aid steps, details, and medicines for predicted conditions
    first_aid_steps = []
    do_nots = []
    warning_signs = []
    suggested_medicines = []
    
    if possible_conditions:
        top_name = possible_conditions[0].name
        cond_details = await DataService.get_condition_by_name(top_name)
        if cond_details:
            first_aid_steps = cond_details.get("first_aid", [])
            do_nots = cond_details.get("do_not", [])
            warning_signs = cond_details.get("warning_signs", [])
            raw_meds = cond_details.get("medicine_information", [])
            suggested_medicines = [MedicineInfo(**m) for m in raw_meds]

        if not suggested_medicines and top_name in CONDITION_MEDICINES:
            suggested_medicines = CONDITION_MEDICINES[top_name]

    if not suggested_medicines:
        suggested_medicines = [
            MedicineInfo(
                name="Paracetamol 500mg / ORS Solution",
                purpose="General symptomatic comfort for fever, body ache, or mild dehydration",
                warning="Informational OTC guidance only. Consult a doctor before taking any medication."
            )
        ]

    if not first_aid_steps:
        first_aid_steps = [
            "Rest in a quiet, well-ventilated room.",
            "Stay adequately hydrated with clean water or electrolyte fluids.",
            "Monitor body temperature and vitals closely.",
            "Seek medical attention if symptoms persist beyond 24-48 hours."
        ]

    if not warning_signs:
        warning_signs = [
            "High fever above 102°F (38.9°C)",
            "Difficulty breathing or persistent chest discomfort",
            "Severe unmanageable pain"
        ]

    top_severity = possible_conditions[0].severity if possible_conditions else "Moderate"
    recommendation_text = (
        f"Based on reported symptoms, possible associated condition is {possible_conditions[0].name}. "
        "Follow first-aid and OTC guidance below. Consult a medical doctor if symptoms worsen."
        if possible_conditions else "Rest, stay hydrated, and consult a doctor if symptoms deteriorate."
    )

    return SymptomCheckResponse(
        is_emergency=False,
        emergency_warning=None,
        possible_conditions=possible_conditions,
        severity=top_severity,
        first_aid=first_aid_steps,
        do_not=do_nots,
        warning_signs=warning_signs,
        medicine_information=suggested_medicines,
        recommendation=recommendation_text
    )
