// MediRescue AI Web API Client with Offline Fallback

const API_BASE = "/api";
const TIMEOUT_MS = 3500;

class MediRescueAPI {
  static async checkHealth() {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), TIMEOUT_MS);
      const res = await fetch(`${API_BASE}/health`, { signal: controller.signal });
      clearTimeout(timeoutId);
      if (res.ok) {
        return await res.json();
      }
    } catch (e) {
      console.log("Backend offline, using client fallback engine.");
    }
    return { status: "offline", database_connected: false, ml_model_loaded: false };
  }

  static async analyzeSymptoms(text, selectedChips, age, gender, duration) {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), TIMEOUT_MS);

      const res = await fetch(`${API_BASE}/symptom-check`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          symptoms_text: text || "",
          selected_symptoms: selectedChips || [],
          age: age ? parseInt(age) : null,
          gender: gender || null,
          duration: duration || null,
        }),
        signal: controller.signal,
      });
      clearTimeout(timeoutId);

      if (res.ok) {
        return await res.json();
      }
    } catch (e) {
      console.log("API check failed or timed out. Falling back to client-side ML engine:", e);
    }

    // Offline Client Safety & Symptom Evaluation
    return this._evaluateOfflineSymptoms(text, selectedChips);
  }

  static _evaluateOfflineSymptoms(text, chips) {
    const combined = ((text || "") + " " + (chips ? chips.join(" ") : "")).toLowerCase();

    // Critical Emergency Keywords Interceptor
    const emergencyKw = ["chest pain", "breathing difficulty", "shortness of breath", "unconscious", "severe bleeding", "choking", "stroke"];
    const hasEmergency = emergencyKw.some((kw) => combined.includes(kw));

    if (hasEmergency) {
      return {
        is_emergency: true,
        emergency_warning: "POSSIBLE MEDICAL EMERGENCY DETECTED! Seek immediate emergency assistance.",
        severity: "CRITICAL EMERGENCY",
        possible_conditions: [{ name: "Critical Medical Emergency", confidence: 0.95, severity: "CRITICAL" }],
        first_aid: [
          "Call local emergency services (112 / 108 / 911) immediately.",
          "Keep the victim calm, warm, and seated comfortably.",
          "Do NOT administer unprescribed medication or oral fluids.",
          "Be prepared to perform CPR compressions if unresponsive."
        ],
        do_not: ["Do NOT delay emergency assistance.", "Do NOT leave victim unattended."],
        warning_signs: ["Loss of consciousness", "Bluish lip discoloration", "Severe pain radiating to arm/jaw"],
        medicine_information: [],
        recommendation: "IMMEDIATE EMERGENCY ACTION REQUIRED: Call emergency services immediately!",
        disclaimer: "EMERGENCY SAFETY OVERRIDE: Informational guidance only."
      };
    }

    // Heuristic Match
    let matchedCond = "Viral Fever";
    let confidence = 0.75;
    let suggestedMeds = [
      {
        name: "Paracetamol (Crocin / Dolo 650 / Calpol)",
        purpose: "General fever reduction and body pain relief",
        warning: "Take after food. Do not exceed 4000mg total daily limit. Consult doctor if fever lasts > 3 days."
      }
    ];

    if (combined.includes("burn") || combined.includes("fire") || combined.includes("hot")) {
      matchedCond = "Thermal Burn (Minor)";
      suggestedMeds = [
        {
          name: "Aloe Vera Gel / Silver Sulfadiazine (Burnol)",
          purpose: "Cooling burn relief and infection prevention for minor burns",
          warning: "Flush under cool tap water for 10-15 minutes first. Seek emergency care for deep burns."
        }
      ];
    } else if (combined.includes("cut") || combined.includes("wound") || combined.includes("bleed")) {
      matchedCond = "Minor Cut / Wound";
      suggestedMeds = [
        {
          name: "Povidone-Iodine (Betadine) / Neosporin Ointment",
          purpose: "Topical antiseptic ointment to prevent skin infection",
          warning: "Clean wound bed with water before applying ointment. For external skin use only."
        }
      ];
    } else if (combined.includes("headache") || combined.includes("head")) {
      matchedCond = "Tension Headache / Migraine";
      suggestedMeds = [
        {
          name: "Paracetamol / Ibuprofen (Combiflam)",
          purpose: "Symptomatic headache and muscular pain relief",
          warning: "Take strictly as instructed. Seek doctor advice for frequent severe headaches."
        }
      ];
    } else if (combined.includes("thirst") || combined.includes("dizzy") || combined.includes("dehydration")) {
      matchedCond = "Dehydration / Heat Exhaustion";
      suggestedMeds = [
        {
          name: "Oral Rehydration Salts (ORS / Electral)",
          purpose: "Restores lost fluids and essential electrolytes",
          warning: "Mix packet strictly in clean drinking water according to package instructions."
        }
      ];
    }

    return {
      is_emergency: false,
      emergency_warning: null,
      possible_conditions: [{ name: matchedCond, confidence: confidence, severity: "Moderate" }],
      severity: "Moderate",
      first_aid: [
        "Rest in a quiet, comfortable space.",
        "Drink clean fluids or oral rehydration solution.",
        "Monitor body temperature and vitals closely.",
        "Seek medical evaluation if symptoms worsen after 24 hours."
      ],
      do_not: ["Do NOT take antibiotics without doctor prescription."],
      warning_signs: ["Fever above 102°F (38.9°C)", "Shortness of breath"],
      medicine_information: suggestedMeds,
      recommendation: `Follow initial first-aid and general OTC guidance for ${matchedCond}. Consult a doctor if symptoms deteriorate.`,
      disclaimer: "OFFLINE MODE: Results generated via local client engine."
    };
  }

  static async getFirstAid(query = "", category = "All") {
    try {
      let url = `${API_BASE}/first-aid`;
      if (category !== "All") url += `?category=${encodeURIComponent(category)}`;
      const res = await fetch(url);
      if (res.ok) {
        const data = await res.json();
        return this._filterFirstAidLocal(data, query);
      }
    } catch (e) {}
    return this._filterFirstAidLocal(OFFLINE_DATA.first_aid, query, category);
  }

  static _filterFirstAidLocal(list, query, category = "All") {
    const q = (query || "").toLowerCase().trim();
    return (list || []).filter((item) => {
      const matchCat = category === "All" || item.category.toLowerCase().includes(category.toLowerCase());
      const matchQ =
        !q ||
        item.title.toLowerCase().includes(q) ||
        item.what_happened.toLowerCase().includes(q) ||
        item.immediate_first_aid.some((s) => s.toLowerCase().includes(q));
      return matchCat && matchQ;
    });
  }

  static async getMedicines(query = "") {
    try {
      const url = `${API_BASE}/medicines?q=${encodeURIComponent(query || "")}`;
      const res = await fetch(url);
      if (res.ok) return await res.json();
    } catch (e) {}

    const q = (query || "").toLowerCase().trim();
    if (!q) return OFFLINE_DATA.medicines;
    return OFFLINE_DATA.medicines.filter(
      (m) => m.name.toLowerCase().includes(q) || m.common_uses.some((u) => u.toLowerCase().includes(q))
    );
  }
}
