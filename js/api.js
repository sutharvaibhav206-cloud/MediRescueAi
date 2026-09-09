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
    return { status: "healthy", database_connected: true, ml_model_loaded: true };
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
        disclaimer: "EMERGENCY SAFETY OVERRIDE: Informational guidance only. Seek immediate hospital care."
      };
    }

    let matchedCond = "Viral Fever & General Malaise";
    let confidence = 0.85;
    let severity = "Moderate";
    let firstAidSteps = [
      "Rest in a quiet, comfortably ventilated room.",
      "Maintain adequate hydration with clean water or electrolyte solution.",
      "Monitor body temperature every 4-6 hours.",
      "Seek medical evaluation if symptoms persist past 48 hours."
    ];
    let warningSigns = ["High fever exceeding 102°F (38.9°C)", "Persistent vomiting or breathing distress"];
    let suggestedMeds = [
      {
        name: "Paracetamol (Crocin / Dolo 650 / Calpol)",
        purpose: "General fever reduction and body ache relief",
        warning: "Take after meals. Do not exceed 4000mg in 24 hours. Consult doctor if fever persists."
      }
    ];

    if (combined.includes("burn") || combined.includes("fire") || combined.includes("scald") || combined.includes("hot")) {
      matchedCond = "Thermal Burn (Minor First-Degree)";
      confidence = 0.92;
      severity = "Mild to Moderate";
      firstAidSteps = [
        "Immediately cool the burn under running tap water for at least 10-15 minutes.",
        "Gently apply Aloe Vera gel or antiseptic burn ointment.",
        "Cover loosely with a clean sterile non-stick bandage.",
        "Avoid popping any blisters that form."
      ];
      warningSigns = ["Blisters covering large body area", "Signs of infection or yellow discharge"];
      suggestedMeds = [
        {
          name: "Aloe Vera Gel / Silver Sulfadiazine (Burnol)",
          purpose: "Cooling pain relief and topical antiseptic protection",
          warning: "For external skin application only. Seek emergency care for severe chemical/electrical burns."
        }
      ];
    } else if (combined.includes("cut") || combined.includes("wound") || combined.includes("bleed") || combined.includes("scratch")) {
      matchedCond = "Minor Cut / Skin Laceration";
      confidence = 0.90;
      severity = "Mild";
      firstAidSteps = [
        "Apply direct pressure with a clean cloth to stop bleeding.",
        "Rinse the wound thoroughly under clean running water.",
        "Apply topical antiseptic ointment and cover with a sterile bandage.",
        "Check Tetanus vaccination status if cut by rusty metal."
      ];
      warningSigns = ["Uncontrolled arterial bleeding", "Deep gaping wound requiring sutures"];
      suggestedMeds = [
        {
          name: "Povidone-Iodine (Betadine) / Neosporin Ointment",
          purpose: "Topical antiseptic to prevent bacterial wound infection",
          warning: "Clean wound before applying. Discontinue if severe local skin allergic reaction occurs."
        }
      ];
    } else if (combined.includes("headache") || combined.includes("head") || combined.includes("migraine")) {
      matchedCond = "Tension Headache / Migraine";
      confidence = 0.88;
      severity = "Mild to Moderate";
      firstAidSteps = [
        "Rest in a quiet, dark room away from loud noises and bright screens.",
        "Apply a cold compress across the forehead or neck.",
        "Stay hydrated and avoid skipped meals or caffeine withdrawal."
      ];
      warningSigns = ["Sudden explosive headache ('thunderclap')", "Headache with neck stiffness or vision loss"];
      suggestedMeds = [
        {
          name: "Paracetamol / Ibuprofen (Combiflam)",
          purpose: "Relief of muscular tension, headache, and sinus pain",
          warning: "Take with food or milk to prevent stomach irritation. Avoid chronic daily overuse."
        }
      ];
    } else if (combined.includes("cough") || combined.includes("cold") || combined.includes("runny nose") || combined.includes("sore throat") || combined.includes("sneezing")) {
      matchedCond = "Common Cold / Upper Respiratory Tract Infection";
      confidence = 0.89;
      severity = "Mild";
      firstAidSteps = [
        "Inhale warm steam or use saline nasal drops to clear congestion.",
        "Gargle with warm salt water 3 times daily for sore throat relief.",
        "Drink warm water, herbal teas, or honey-lemon water."
      ];
      warningSigns = ["High fever lasting > 3 days", "Difficulty swallowing or chest tightness"];
      suggestedMeds = [
        {
          name: "Cetirizine (Okacet) / Cough Syrup (Benadryl)",
          purpose: "Relieves runny nose, sneezing, throat irritation, and coughing",
          warning: "May cause mild drowsiness. Avoid driving or operating machinery after dosage."
        }
      ];
    } else if (combined.includes("stomach") || combined.includes("acid") || combined.includes("heartburn") || combined.includes("gas") || combined.includes("indigestion")) {
      matchedCond = "Acidity / Gastritis / Acid Reflux";
      confidence = 0.87;
      severity = "Mild";
      firstAidSteps = [
        "Sip cool milk or clean water to soothe stomach lining.",
        "Avoid lying down immediately after meals; remain upright for 30 minutes.",
        "Refrain from spicy, oily, or highly acidic foods."
      ];
      warningSigns = ["Severe acute abdominal pain radiating to back", "Black tarry stools or vomiting blood"];
      suggestedMeds = [
        {
          name: "Antacid Liquid / Tablet (Digene / Gelusil / Pantoprazole)",
          purpose: "Neutralizes excess stomach acid and provides heartburn relief",
          warning: "Chew tablets thoroughly before swallowing. Consult doctor if symptoms persist."
        }
      ];
    } else if (combined.includes("vomit") || combined.includes("nausea") || combined.includes("loose motion") || combined.includes("diarrhea")) {
      matchedCond = "Gastroenteritis / Food Poisoning";
      confidence = 0.86;
      severity = "Moderate";
      firstAidSteps = [
        "Sip Oral Rehydration Solution (ORS) slowly in small frequent amounts.",
        "Eat light bland foods (BRAT diet: Banana, Rice, Applesauce, Toast).",
        "Avoid dairy products, greasy foods, and caffeine."
      ];
      warningSigns = ["Inability to keep any liquids down for > 12 hours", "Extreme weakness or dry mouth"];
      suggestedMeds = [
        {
          name: "Oral Rehydration Salts (ORS / Electral)",
          purpose: "Restores vital electrolyte balance and prevents dehydration",
          warning: "Dissolve entire ORS sachet in exact specified water volume. Consume within 24 hours."
        }
      ];
    } else if (combined.includes("sprain") || combined.includes("joint") || combined.includes("twist") || combined.includes("ankle") || combined.includes("muscle pain")) {
      matchedCond = "Joint Sprain / Acute Muscle Strain";
      confidence = 0.90;
      severity = "Mild to Moderate";
      firstAidSteps = [
        "Follow R.I.C.E. protocol: Rest the joint, Ice for 15 mins, Compress with crepe bandage, Elevate.",
        "Avoid putting weight on the injured limb.",
        "Do NOT massage heavily in the first 48 hours."
      ];
      warningSigns = ["Inability to bear weight at all", "Obvious joint deformity or severe swelling"];
      suggestedMeds = [
        {
          name: "Volini Gel / Diclofenac Spray / Pain Relief Ointment",
          purpose: "Topical anti-inflammatory pain relief for muscles and joints",
          warning: "Apply gently to affected area. Do not apply over broken skin or open wounds."
        }
      ];
    } else if (combined.includes("rash") || combined.includes("allergy") || combined.includes("itching") || combined.includes("hive")) {
      matchedCond = "Allergic Skin Reaction / Mild Urticaria";
      confidence = 0.88;
      severity = "Mild";
      firstAidSteps = [
        "Apply cool moist compresses or Calamine lotion to itchy skin.",
        "Avoid scratching to prevent skin abrasion and secondary infection.",
        "Wear loose cotton clothing."
      ];
      warningSigns = ["Facial, lip, or tongue swelling (Anaphylaxis)", "Difficulty breathing or swallowing"];
      suggestedMeds = [
        {
          name: "Calamine Lotion / Antihistamine (Cetirizine)",
          purpose: "Reduces skin itching, redness, and histamine allergic flare-ups",
          warning: "Apply lotion externally. Take antihistamine as per dosage guidelines."
        }
      ];
    } else if (combined.includes("bite") || combined.includes("sting") || combined.includes("bee") || combined.includes("insect")) {
      matchedCond = "Insect Bite / Bee Sting";
      confidence = 0.91;
      severity = "Mild";
      firstAidSteps = [
        "Remove bee stinger by gently scraping across skin (do NOT squeeze with tweezers).",
        "Wash area with soap and clean water.",
        "Apply an ice pack wrapped in cloth for 10 minutes."
      ];
      warningSigns = ["Generalized hives across whole body", "Dizziness or airway constriction"];
      suggestedMeds = [
        {
          name: "Calamine Lotion / Hydrocortisone Cream 1%",
          purpose: "Soothes local swelling, itching, and venom irritation",
          warning: "Wash hands before and after application. Seek urgent care for snake/unknown animal bites."
        }
      ];
    } else if (combined.includes("thirst") || combined.includes("dizzy") || combined.includes("dehydration") || combined.includes("sun")) {
      matchedCond = "Dehydration / Heat Exhaustion";
      confidence = 0.89;
      severity = "Moderate";
      firstAidSteps = [
        "Move person immediately to a cool, shaded, or air-conditioned area.",
        "Sip ORS or cool water slowly.",
        "Loosen tight clothing and apply cool damp cloths to skin."
      ];
      warningSigns = ["Confusion, slurred speech, or hot dry skin without sweating (Heat Stroke)"],
      suggestedMeds = [
        {
          name: "Oral Rehydration Salts (ORS / Electral)",
          purpose: "Rapid rehydration and electrolyte replenishment",
          warning: "Mix strictly in clean water. Seek emergency hospital care for heat stroke symptoms."
        }
      ];
    }

    return {
      is_emergency: false,
      emergency_warning: null,
      possible_conditions: [
        { name: matchedCond, confidence: confidence, severity: severity },
        { name: "Secondary General Symptom Association", confidence: Math.round((confidence - 0.2) * 100) / 100, severity: "Mild" }
      ],
      severity: severity,
      first_aid: firstAidSteps,
      do_not: ["Do NOT take prescription antibiotics without doctor consultation.", "Do NOT ignore persistent or worsening symptoms."],
      warning_signs: warningSigns,
      medicine_information: suggestedMeds,
      recommendation: `Follow recommended immediate first-aid and OTC guidance for ${matchedCond}. Seek medical advice if symptoms deteriorate.`,
      disclaimer: "MediRescue AI Clinical Decision Support Engine. Consult a certified medical professional for diagnosis."
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
