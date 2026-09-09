# MediRescue AI – Emergency First-Aid Assistant

**Tagline:** *Immediate Guidance. Safer Decisions.*

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100%2B-009688.svg)](https://fastapi.tiangolo.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B.svg)](https://flutter.dev/)
[![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-ML-F7931E.svg)](https://scikit-learn.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-Database-47A248.svg)](https://www.mongodb.com/)

An AI-powered emergency first-aid mobile application and decision support platform engineered for situations where a hospital or doctor is not immediately reachable.

---

## 🚨 Critical Medical Disclaimer

> **IMPORTANT:** MediRescue AI is an **emergency information and first-aid guidance tool**, NOT a doctor or replacement for professional medical care. Never claim that a medicine will "cure" a disease. For serious, severe, or uncertain cases, immediately contact local emergency services (112 / 108 / 911) or seek professional emergency medical care.

---

## 🌟 Main Features & Screens

1. **Splash Screen:** Branding, MediRescue logo, and tagline (*"Immediate Guidance. Safer Decisions."*) with automatic navigation.
2. **Emergency Dashboard:** Modern medical UI with prominent red life-threatening emergency warning banner and 6 quick-action cards.
3. **🚨 Emergency Assistance:** High-readability emergency mode with 12+ categories (Bleeding, Burns, Choking, Fractures, Chest Pain, Breathing Issues, Fainting, Seizures, Poisoning, Bites, Allergies, High Fever) featuring numbered immediate steps, DOs, DON'Ts, and one-touch dialer.
4. **🩺 AI Symptom Checker:** Natural language symptom input + multi-symptom chip selectors + age/gender/duration options. Evaluates safety layer for life-threatening keywords and calls scikit-learn ML backend for condition predictions, confidence %, severity rating, first-aid, and warning signs.
5. **🩹 First-Aid Knowledge Base:** Searchable and categorized guide library (Injuries, Burns, Bleeding, Breathing, Heat, Allergic, Bites/Stings, Common Illnesses) with interactive accordions.
6. **💊 Medicine Information Database:** Searchable medicine directory (Paracetamol, Ibuprofen, ORS, Cetirizine, Antacids, Calamine) detailing purpose, common uses, warnings, contraindications, and mandatory doctor consultation disclaimers.
7. **📍 Nearby Hospital Finder:** Geolocator integration searching nearby Hospitals, Emergency Rooms, Clinics, and Pharmacies with distance in km, address, direct phone call, and map navigation. Graceful offline/denied-permission fallback directory included.
8. **📞 Emergency Contacts:** One-touch national emergency dialer (112 / 108 / 911), local storage via `SharedPreferences`, configurable hotline number, and custom contact manager.
9. **🛡️ Safety Rule Engine:** Immediate client & backend safety layer intercepting severe emergency symptoms (severe chest pain, choking, severe bleeding, unconsciousness, stroke) to prioritize emergency callouts over standard predictions.
10. **⚡ 100% Offline Capability:** Bundled offline JSON datasets ensuring full first-aid guides and emergency contacts work even without internet or backend connection.

---

## 🏗️ Architecture & Technology Stack

```
                          +-------------------------------------------------+
                          |             Flutter Mobile App                  |
                          |  - Material Design UI (Light Medical Theme)     |
                          |  - 5 Main Tabs + Emergency Dashboard Banner     |
                          |  - Offline First-Aid & Emergency Storage        |
                          |  - Geolocator & Emergency Dialer Integration    |
                          +------------------------+------------------------+
                                                   |
                                       HTTP REST   |   Local Fallback
                                         APIs      v   (Offline JSON/Cache)
                          +-------------------------------------------------+
                          |               FastAPI Backend                   |
                          |  - Health & Diagnostic Endpoints                |
                          |  - Emergency Safety Layer Rule Engine           |
                          |  - ML Prediction Engine (Scikit-Learn Model)    |
                          |  - Medical & Medicine API Endpoints             |
                          +-------------------+-----------------------------+
                                              |
                          +-------------------+-----------------------------+
                          |                   |                             |
                          v                   v                             v
               +--------------------+ +-------------------+       +--------------------+
               |  MongoDB Database  | |  ML Trained Model |       | Python Test Suite  |
               |  - Conditions      | |  - TF-IDF Vector. |       | - API Tests        |
               |  - First-Aid Guides| |  - Classifier PKL|       | - ML Prediction    |
               |  - Medicines       | +-------------------+       | - Safety Layer     |
               +--------------------+                             +--------------------+
```

---

## 📁 Project Directory Structure

```text
MediRescueAI/
│
├── mobile/                            # Flutter Android Application
│   ├── lib/
│   │   ├── main.dart                  # App Entry Point & Medical Theme
│   │   ├── models/                    # Data Models (Condition, FirstAid, Medicine, etc.)
│   │   ├── services/                  # ApiService, OfflineStorageService, LocationService, SafetyService
│   │   ├── screens/                   # 9 Main Application Screens
│   │   └── widgets/                   # Custom UI Components (EmergencyBanner, DisclaimerCard, etc.)
│   ├── assets/json/                   # Bundled Offline Datasets
│   ├── android/                       # Android Manifest & Native Build Configuration
│   └── pubspec.yaml                   # Flutter Dependencies
│
├── backend/                           # Python FastAPI REST API Backend
│   ├── app/
│   │   ├── main.py                    # FastAPI Entry & CORS
│   │   ├── config.py                  # Environment Settings
│   │   ├── database/mongo.py          # MongoDB Driver with Local Embedded Fallback
│   │   ├── models/schemas.py          # Pydantic Schemas
│   │   ├── routes/                    # API Endpoints (health, conditions, first_aid, medicines, symptom_check)
│   │   └── services/                  # SafetyService, MLService, DataService
│   ├── ml/                            # Machine Learning Pipeline
│   │   ├── dataset.csv                # Training Dataset
│   │   ├── train.py                   # Model Training Script
│   │   ├── predict.py                 # Standalone Prediction Script
│   │   └── model/                     # Trained .pkl Artifacts
│   ├── tests/
│   │   └── test_api.py                # Unittest API & Safety Layer Test Suite
│   ├── requirements.txt               # Backend Dependencies
│   └── .env.example                   # Environment Template
│
├── database/
│   ├── seed_data.py                   # MongoDB Database Seeder
│   └── initial_data.json              # Master Seed Dataset
│
├── README.md                          # Complete Project Documentation
└── .gitignore                         # Version Control Exclusions
```

---

## 🚀 Quick Setup & Installation

### Prerequisites
- Python 3.10+
- Flutter SDK 3.0+
- MongoDB Community Server / MongoDB Atlas (Optional; system includes embedded database fallback)

---

### Step 1: Set Up & Start Python Backend

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Copy environment file:
   ```bash
   cp .env.example .env
   ```
4. Train the ML model:
   ```bash
   python ml/train.py
   ```
5. Run unit & integration tests:
   ```bash
   python tests/test_api.py
   ```
6. Start the FastAPI server:
   ```bash
   python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
   ```
   *FastAPI Interactive Docs will be accessible at: [http://localhost:8000/docs](http://localhost:8000/docs)*

---

### Step 2: Seed MongoDB Database (Optional)

If running a local MongoDB daemon at `mongodb://localhost:27017`:
```bash
python database/seed_data.py
```
*(If MongoDB is not running, backend automatically uses the embedded JSON dataset driver.)*

---

### Step 3: Run Flutter Mobile App

1. Navigate to the mobile folder:
   ```bash
   cd mobile
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Launch on Android Emulator or connected physical device:
   ```bash
   flutter run
   ```

---

## 📱 Building Production Android APK

To generate a production-ready Android APK:

```bash
cd mobile
flutter build apk --release
```

The compiled release APK will be located at:
```text
mobile/build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔗 Key API Endpoints Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/health` | Check API, MongoDB & ML status |
| `GET` | `/api/conditions` | List all medical conditions |
| `GET` | `/api/conditions/{name}` | Fetch condition details by name |
| `GET` | `/api/first-aid` | List categorized first-aid guides |
| `GET` | `/api/medicines?q=...` | Search medicine database with warnings |
| `POST` | `/api/symptom-check` | Submit symptoms for ML assessment & safety check |

---

### Sample Symptom Checker API Request & Response

**POST `/api/symptom-check`**
```json
{
  "symptoms_text": "I have high fever, headache and body pain",
  "selected_symptoms": ["Fever", "Headache"],
  "age": 24,
  "gender": "Male",
  "duration": "2 days"
}
```

**Response:**
```json
{
  "is_emergency": false,
  "emergency_warning": null,
  "possible_conditions": [
    {
      "name": "Viral Fever",
      "confidence": 0.85,
      "severity": "Moderate"
    }
  ],
  "severity": "Moderate",
  "first_aid": [
    "Rest in a comfortable, well-ventilated room.",
    "Drink plenty of fluids (water, clear broths, oral rehydration solution).",
    "Use a cool damp cloth on forehead for comfort."
  ],
  "do_not": [
    "Do NOT take antibiotics without explicit prescription from a registered physician.",
    "Do NOT give aspirin to children or teenagers."
  ],
  "warning_signs": [
    "Fever exceeds 103°F (39.4°C) or lasts more than 3 days",
    "Difficulty breathing or persistent chest discomfort"
  ],
  "recommendation": "Follow first-aid guidance below. If symptoms intensify, consult a healthcare provider.",
  "disclaimer": "IMPORTANT: This AI tool provides general information and emergency guidance only. It is NOT a substitute for professional medical advice."
}
```

---

## 🧪 Safety System & Rule Engine

If symptoms contain life-threatening emergency keywords (e.g., *"severe chest pain"*, *"shortness of breath"*, *"unconscious"*, *"severe bleeding"*, *"choking"*, *"stroke"*), the application immediately returns:

```json
{
  "is_emergency": true,
  "emergency_warning": "POSSIBLE MEDICAL EMERGENCY DETECTED: Severe Chest Pain / Possible Cardiac Emergency. Seek emergency medical assistance immediately!",
  "severity": "CRITICAL EMERGENCY",
  "recommendation": "IMMEDIATE EMERGENCY ACTION REQUIRED: Call local emergency services (112 / 108 / 911) or proceed immediately to nearest hospital emergency department."
}
```

---

## 🎓 College Project & Viva Presentation Highlights

- **Clean Multi-Tier Architecture:** Decoupled Flutter UI, FastAPI Service Layer, Scikit-learn Classifier Pipeline, and MongoDB Storage.
- **Fail-Safe Offline Resiliency:** Bundled local JSON fallback for complete offline operation during connectivity loss.
- **Safety First AI Design:** Integrated Safety Rule Engine overriding ML predictions when life-threatening emergency symptoms are reported.
- **Full Compliance:** Strict adherence to medical disclaimer protocols, emergency callout priorities, and non-prescription medication guardrails.
