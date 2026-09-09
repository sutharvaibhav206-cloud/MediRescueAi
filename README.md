# MediRescue AI – Emergency First-Aid Assistant

**Tagline:** *Immediate Guidance. Safer Decisions.*

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100%2B-009688.svg)](https://fastapi.tiangolo.com/)
[![Vercel](https://img.shields.io/badge/Vercel-Deployed-black.svg)](https://medi-rescue-ai-1.vercel.app)
[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B.svg)](https://flutter.dev/)
[![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-ML-F7931E.svg)](https://scikit-learn.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-Database-47A248.svg)](https://www.mongodb.com/)

An AI-powered emergency first-aid mobile application and decision support web platform engineered for situations where a hospital or doctor is not immediately reachable.

---

## 🌐 Live Web Application (Vercel)
👉 **[https://medi-rescue-ai-1.vercel.app](https://medi-rescue-ai-1.vercel.app)**

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
                          |  - RESTful Endpoints (/api/symptom-check)       |
                          |  - Safety Interceptor Filter                    |
                          |  - ML Prediction Engine (Scikit-Learn)          |
                          |  - MongoDB Async Driver (Motor)                 |
                          +------------------------+------------------------+
                                                   |
                                                   v
                          +-------------------------------------------------+
                          |             MongoDB Database                    |
                          |  - Collections: medical_conditions, first_aid   |
                          +-------------------------------------------------+
```

---

## 📁 Repository Directory Structure

```text
MediRescueAI/
├── api/
│   └── index.py               # Vercel Serverless Entrypoint (/api/*)
├── css/
│   └── style.css              # Root Stylesheet
├── js/
│   ├── app.js                 # Web UI Logic & Hospital Geolocator
│   ├── api.js                 # API REST Client
│   └── data.js                # Embedded Master Datasets
├── index.html                 # Root Single Page Application (Vercel Edge CDN)
├── web/                       # Web Application Static Bundle
├── backend/                   # Python FastAPI Backend
│   ├── app/                   # API Code (main.py, routes, services, models)
│   ├── ml/                    # Scikit-Learn Model & Vectorizer (.pkl)
│   └── requirements.txt
├── database/                  # Embedded Datasets & Seed Script
└── mobile/                    # Flutter Cross-Platform App
```

---

## 🚀 Local Quickstart & Testing

### 1. Python FastAPI Backend Server
```bash
cd backend
pip install -r requirements.txt
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```
API Documentation will be live at: `http://127.0.0.1:8000/docs`

### 2. Web Application Preview
Open **[http://localhost:8000](http://localhost:8000)** in any browser.

---

## 🧪 Testing

Run automated API test suite:
```bash
pytest backend/tests/test_api.py
```

---

## 📄 License
This project is licensed under the MIT License.
