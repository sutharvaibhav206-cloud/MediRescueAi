import os
import pickle
from typing import List, Dict, Any

MODEL_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "ml", "model")
MODEL_PATH = os.path.join(MODEL_DIR, "symptom_model.pkl")
VECTORIZER_PATH = os.path.join(MODEL_DIR, "vectorizer.pkl")

class MLService:
    def __init__(self):
        self.model = None
        self.vectorizer = None
        self.load_model()

    def load_model(self):
        try:
            if os.path.exists(MODEL_PATH) and os.path.exists(VECTORIZER_PATH):
                with open(MODEL_PATH, "rb") as f:
                    self.model = pickle.load(f)
                with open(VECTORIZER_PATH, "rb") as f:
                    self.vectorizer = pickle.load(f)
                print("ML Model and Vectorizer loaded successfully.")
            else:
                print("ML Model or Vectorizer file not found. Will use heuristic matcher until trained.")
        except Exception as e:
            print(f"Error loading ML Model: {e}")

    def predict(self, symptoms_text: str, selected_symptoms: List[str] = None) -> List[Dict[str, Any]]:
        """
        Predicts top matching conditions given user symptoms text and chip selection.
        """
        combined_symptoms = symptoms_text.strip()
        if selected_symptoms:
            combined_symptoms += " " + " ".join(selected_symptoms)
        
        if not combined_symptoms.strip():
            return []

        # If trained model is available
        if self.model and self.vectorizer:
            try:
                X_vec = self.vectorizer.transform([combined_symptoms.lower()])
                probs = self.model.predict_proba(X_vec)[0]
                classes = self.model.classes_
                
                # Zip classes with probabilities and sort
                ranked = sorted(zip(classes, probs), key=lambda x: x[1], reverse=True)
                
                results = []
                for label, prob in ranked[:3]:
                    if prob > 0.05:  # threshold
                        results.append({
                            "name": label,
                            "confidence": round(float(prob), 2),
                            "severity": self._estimate_severity(label)
                        })
                if results:
                    return results
            except Exception as e:
                print(f"Prediction error using ML model: {e}")

        # Rule-based fallback matcher if ML model is unavailable or returned low score
        return self._heuristic_predict(combined_symptoms)

    def _estimate_severity(self, condition_name: str) -> str:
        condition = condition_name.lower()
        if any(w in condition for w in ["heart", "stroke", "bleeding", "choking", "anaphylaxis", "severe"]):
            return "Severe"
        elif any(w in condition for w in ["fever", "dehydration", "sprain", "poisoning", "exhaustion"]):
            return "Moderate"
        else:
            return "Mild"

    def _heuristic_predict(self, text: str) -> List[Dict[str, Any]]:
        text_lower = text.lower()
        candidates = [
            {
                "keywords": ["fever", "headache", "body pain", "body ache", "chills", "temperature"],
                "name": "Viral Fever",
                "severity": "Moderate",
                "score": 0
            },
            {
                "keywords": ["headache", "migraine", "head throbbing", "dizziness"],
                "name": "Tension Headache / Migraine",
                "severity": "Mild",
                "score": 0
            },
            {
                "keywords": ["cut", "wound", "bleeding", "scratch", "laceration"],
                "name": "Minor Cut / Wound",
                "severity": "Mild",
                "score": 0
            },
            {
                "keywords": ["burn", "scald", "blister", "hot water", "fire"],
                "name": "Thermal Burn (Minor)",
                "severity": "Moderate",
                "score": 0
            },
            {
                "keywords": ["dehydration", "dry mouth", "extreme thirst", "dark urine", "dizzy"],
                "name": "Dehydration / Heat Exhaustion",
                "severity": "Moderate",
                "score": 0
            },
            {
                "keywords": ["stomach pain", "nausea", "vomiting", "diarrhea", "food"],
                "name": "Gastroenteritis / Food Poisoning",
                "severity": "Moderate",
                "score": 0
            },
            {
                "keywords": ["sprain", "swelling", "ankle pain", "twist", "joint pain"],
                "name": "Joint Sprain / Ligament Injury",
                "severity": "Mild",
                "score": 0
            },
            {
                "keywords": ["sneezing", "runny nose", "itching", "rash", "hives", "allergy"],
                "name": "Minor Allergic Reaction",
                "severity": "Mild",
                "score": 0
            },
            {
                "keywords": ["nosebleed", "blood from nose", "epistaxis"],
                "name": "Nosebleed (Epistaxis)",
                "severity": "Mild",
                "score": 0
            },
            {
                "keywords": ["bee sting", "insect bite", "mosquito", "swelling", "itching"],
                "name": "Insect Bite / Sting",
                "severity": "Mild",
                "score": 0
            }
        ]

        results = []
        for cand in candidates:
            matches = sum(1 for kw in cand["keywords"] if kw in text_lower)
            if matches > 0:
                score = min(0.40 + (matches * 0.20), 0.88)
                results.append({
                    "name": cand["name"],
                    "confidence": round(score, 2),
                    "severity": cand["severity"]
                })

        results = sorted(results, key=lambda x: x["confidence"], reverse=True)
        if not results:
            results.append({
                "name": "General Physical Discomfort / Non-specific Symptoms",
                "confidence": 0.50,
                "severity": "Mild to Moderate"
            })
        return results[:3]

ml_service = MLService()
