import re
from typing import Dict, Any, List

EMERGENCY_KEYWORDS = {
    "chest pain": {
        "title": "Severe Chest Pain / Possible Cardiac Emergency",
        "first_aid": [
            "Call local emergency services immediately.",
            "Keep the person calm, seated, and in a comfortable position.",
            "Loosen tight clothing around the neck and chest.",
            "If prescribed nitroglycerin by a physician for a known heart condition, assist them in taking it.",
            "Be prepared to perform CPR if the person becomes unresponsive and stops breathing normally."
        ],
        "warning_signs": [
            "Pain radiating to jaw, neck, back, or left arm",
            "Shortness of breath, cold sweat, dizziness",
            "Nausea or lightheadedness"
        ]
    },
    "breathing difficulty": {
        "title": "Severe Respiratory Distress / Breathing Difficulty",
        "first_aid": [
            "Call emergency services immediately.",
            "Sit the person upright to help open airway.",
            "Loosen any restrictive clothing around neck and chest.",
            "Help them use their prescribed rescue inhaler (if asthmatic).",
            "Stay calm and reassure the person; avoid overcrowding."
        ],
        "warning_signs": [
            "Bluish color on lips, tongue, or face",
            "Inability to speak full sentences",
            "Gasping or chest wall pulling inward while breathing"
        ]
    },
    "shortness of breath": {
        "title": "Severe Respiratory Distress",
        "first_aid": [
            "Call emergency services immediately.",
            "Sit the person upright.",
            "Loosen tight necklines or belts.",
            "Assist with asthma inhaler if available."
        ],
        "warning_signs": [
            "Lips or fingernails turning blue",
            "Confusion or extreme lethargy"
        ]
    },
    "unconscious": {
        "title": "Unconsciousness / Loss of Consciousness",
        "first_aid": [
            "Call emergency services immediately.",
            "Check for breathing and pulse.",
            "If breathing normally, place in the recovery position (on their side).",
            "Do NOT give food, water, or medication by mouth.",
            "Keep airway clear and monitor breathing continuously until help arrives."
        ],
        "warning_signs": [
            "No response to verbal or physical stimuli",
            "Irregular or missing breathing"
        ]
    },
    "fainting": {
        "title": "Loss of Consciousness / Syncope",
        "first_aid": [
            "Lay the person flat on their back and elevate legs 12 inches if no spine injury is suspected.",
            "Loosen tight clothing.",
            "If they do not regain consciousness within 1 minute, call emergency services immediately."
        ],
        "warning_signs": [
            "Head injury sustained during fall",
            "Chest pain or rapid heartbeat before fainting"
        ]
    },
    "severe bleeding": {
        "title": "Severe Bleeding / Hemorrhage Emergency",
        "first_aid": [
            "Call emergency services immediately.",
            "Apply direct, firm pressure on the wound using a clean cloth or sterile bandage.",
            "Do NOT remove the cloth if soaked; place additional layers over it.",
            "Elevate the injured area above the heart level if possible and safe.",
            "Keep the victim warm and quiet to prevent shock."
        ],
        "warning_signs": [
            "Blood spurting from wound",
            "Bleeding does not slow after 10 minutes of direct pressure",
            "Pale, cold, clammy skin or rapid pulse"
        ]
    },
    "choking": {
        "title": "Airway Obstruction / Choking Emergency",
        "first_aid": [
            "If the person CANNOT speak, cough, or breathe, perform Heimlich maneuver (abdominal thrusts) immediately.",
            "Give 5 sharp back blows between shoulder blades followed by 5 abdominal thrusts.",
            "Call emergency services immediately if obstruction is not cleared.",
            "If person becomes unconscious, lower to ground and begin CPR starting with chest compressions."
        ],
        "warning_signs": [
            "Clutching neck with hands (universal choking sign)",
            "Inability to speak, cough, or breathe",
            "Skin, lips, or nails turning blue"
        ]
    },
    "stroke": {
        "title": "Possible Stroke Emergency (FAST Signs)",
        "first_aid": [
            "Call emergency services immediately. Note the exact time symptoms started.",
            "Keep the person lying down on their side with head slightly elevated.",
            "Do NOT give anything to eat or drink.",
            "Perform FAST check: Face drooping, Arm weakness, Speech difficulty, Time to call emergency."
        ],
        "warning_signs": [
            "Sudden numbness or weakness in face, arm, or leg (especially one side)",
            "Sudden confusion, trouble speaking or understanding",
            "Sudden severe headache with no known cause"
        ]
    },
    "anaphylaxis": {
        "title": "Severe Allergic Reaction / Anaphylaxis",
        "first_aid": [
            "Call emergency services immediately.",
            "Administer EpiPen (epinephrine auto-injector) into outer mid-thigh if available.",
            "Have person lie flat with legs elevated unless breathing is difficult (then sit upright).",
            "Do not give oral fluids if breathing is compromised."
        ],
        "warning_signs": [
            "Swelling of lips, tongue, or throat",
            "Hives or rash across body",
            "Wheezing, gasping, or feeling of tightness in throat"
        ]
    },
    "seizure": {
        "title": "Active Seizure Emergency",
        "first_aid": [
            "Clear immediate area of hard or sharp objects.",
            "Cushion person's head with something soft.",
            "Turn person gently onto one side to help keep airway clear.",
            "Do NOT put anything in their mouth.",
            "Do NOT attempt to restrain movement.",
            "Time the seizure; call emergency services if it lasts longer than 5 minutes."
        ],
        "warning_signs": [
            "Seizure lasting > 5 minutes",
            "Repeated seizures without regaining consciousness",
            "Seizure occurring in water or during pregnancy"
        ]
    }
}

class SafetyService:
    @staticmethod
    def evaluate_symptoms(symptoms_text: str, selected_symptoms: List[str] = []) -> Dict[str, Any]:
        """
        Scans input symptoms against critical emergency keywords.
        Returns emergency structure if detected, otherwise None.
        """
        combined_text = (symptoms_text + " " + " ".join(selected_symptoms or [])).lower()
        
        detected_emergencies = []
        for keyword, details in EMERGENCY_KEYWORDS.items():
            if re.search(r'\b' + re.escape(keyword) + r'\b', combined_text):
                detected_emergencies.append((keyword, details))
                
        if detected_emergencies:
            # Pick primary emergency
            primary_kw, primary_details = detected_emergencies[0]
            
            all_first_aid = []
            all_warnings = []
            for _, det in detected_emergencies:
                all_first_aid.extend(det["first_aid"])
                all_warnings.extend(det["warning_signs"])
                
            # Deduplicate
            all_first_aid = list(dict.fromkeys(all_first_aid))
            all_warnings = list(dict.fromkeys(all_warnings))
            
            return {
                "is_emergency": True,
                "emergency_warning": f"POSSIBLE MEDICAL EMERGENCY DETECTED: {primary_details['title']}. Seek emergency medical assistance immediately!",
                "severity": "CRITICAL EMERGENCY",
                "possible_conditions": [
                    {
                        "name": primary_details["title"],
                        "confidence": 0.95,
                        "severity": "CRITICAL EMERGENCY"
                    }
                ],
                "first_aid": all_first_aid,
                "do_not": [
                    "Do NOT delay contacting emergency services.",
                    "Do NOT administer unprescribed medication.",
                    "Do NOT give oral fluids to an unconscious or choking person.",
                    "Do NOT leave the person unattended."
                ],
                "warning_signs": all_warnings,
                "recommendation": "IMMEDIATE EMERGENCY ACTION REQUIRED: Call local emergency services (112 / 108 / 911) or proceed immediately to the nearest hospital emergency department."
            }
            
        return None
