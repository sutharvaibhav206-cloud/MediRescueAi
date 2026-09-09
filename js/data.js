// Embedded Offline Medical Master Datasets
const OFFLINE_DATA = {
  first_aid: [
    {
      category: "Injuries",
      title: "Fracture & Bone Injury",
      what_happened: "A bone is cracked or broken due to trauma, fall, or high impact.",
      immediate_first_aid: [
        "Keep the injured area completely still and immobilized.",
        "Do NOT attempt to push back a protruding bone or realign the limb.",
        "Apply an ice pack wrapped in a cloth to reduce swelling without pressing hard.",
        "If trained, apply a temporary splint above and below the fracture site."
      ],
      do_list: [
        "Keep the victim calm and warm.",
        "Support the injured limb in the position found.",
        "Call emergency medical services immediately."
      ],
      dont_list: [
        "Do NOT move the person if spinal or neck injury is suspected.",
        "Do NOT test the limb by trying to walk or bend it.",
        "Do NOT give food or drink in case emergency surgery is needed."
      ],
      when_to_seek_help: [
        "Bone is visible through torn skin (open fracture)",
        "Limb is numb, pale, or blue at extremities",
        "Severe unbearable pain or inability to move"
      ],
      icon: "bi-bandaid"
    },
    {
      category: "Burns",
      title: "Thermal & Chemical Burns",
      what_happened: "Skin damage caused by heat, fire, hot liquid, steam, or corrosive chemical contact.",
      immediate_first_aid: [
        "Cool burn under cool running tap water for 10-20 minutes.",
        "For chemical burns, flush continuously with water for at least 20 minutes.",
        "Remove jewelry or constricting items before swelling occurs.",
        "Cover loosely with a clean, sterile non-stick bandage."
      ],
      do_list: [
        "FLUSH continuously with water.",
        "Protect burned area from dirt and contamination.",
        "Seek urgent medical advice for major burns."
      ],
      dont_list: [
        "Do NOT apply ice, butter, grease, toothpaste, or oil.",
        "Do NOT pop blisters.",
        "Do NOT peel off clothing stuck to burned skin."
      ],
      when_to_seek_help: [
        "Burn is larger than 3 inches in diameter",
        "Burn is on face, hands, feet, groin, or major joint",
        "Burn is caused by chemicals or electrical source"
      ],
      icon: "bi-fire"
    },
    {
      category: "Bleeding",
      title: "Severe External Bleeding",
      what_happened: "Deep cut or vascular laceration resulting in rapid blood loss.",
      immediate_first_aid: [
        "Apply direct, firm pressure on wound with a sterile gauze or clean cloth.",
        "Maintain pressure continuously without lifting the cloth to check.",
        "If blood soaks through, add another cloth on top.",
        "Elevate wound above heart level if safe.",
        "Call emergency services immediately."
      ],
      do_list: [
        "Use sterile gloves or clean barrier if available.",
        "Keep victim lying down and quiet.",
        "Monitor breathing and consciousness."
      ],
      dont_list: [
        "Do NOT remove original soaked cloth bandage.",
        "Do NOT apply tourniquet unless trained and direct pressure fails."
      ],
      when_to_seek_help: [
        "Blood is spurting from wound",
        "Bleeding does not stop after 10 minutes of direct pressure",
        "Victim feels faint, dizzy, or shows signs of shock"
      ],
      icon: "bi-droplet-fill"
    },
    {
      category: "Breathing emergencies",
      title: "Choking & Airway Obstruction",
      what_happened: "Food or foreign object blocks the trachea, preventing airflow.",
      immediate_first_aid: [
        "If person CANNOT cough, speak, or breathe:",
        "Give 5 sharp back blows between shoulder blades with heel of hand.",
        "Give 5 abdominal thrusts (Heimlich maneuver): Stand behind, wrap arms around waist, place fist above navel, thrust upward and inward.",
        "Repeat cycle until object is dislodged or person becomes unconscious.",
        "Call emergency services immediately."
      ],
      do_list: [
        "Act immediately; choking can cause brain damage within minutes.",
        "Begin CPR compressions if person collapses."
      ],
      dont_list: [
        "Do NOT perform abdominal thrusts on infants under 1 year (use chest thrusts).",
        "Do NOT slap back while person is standing upright without leaning forward."
      ],
      when_to_seek_help: [
        "Choking obstruction is not dislodged immediately",
        "Person becomes unresponsive or turns blue"
      ],
      icon: "bi-wind"
    },
    {
      category: "Heat-related problems",
      title: "Heat Stroke & Exhaustion",
      what_happened: "Overheating of the body due to high ambient temperatures and dehydration.",
      immediate_first_aid: [
        "Move person to a cool, shaded or air-conditioned room.",
        "Remove excess or tight clothing.",
        "Cool person rapidly: apply ice packs to armpits, groin, and neck, or spray with cool water.",
        "Give small sips of cool water or electrolyte drink if conscious."
      ],
      do_list: [
        "Fan the person while dampening skin.",
        "Monitor body temperature.",
        "Call emergency services if confusion or high fever is present."
      ],
      dont_list: [
        "Do NOT give fluids if person is confused or vomiting.",
        "Do NOT give aspirin or paracetamol for heat stroke."
      ],
      when_to_seek_help: [
        "Body temperature reaches 104°F (40°C) or higher",
        "Confusion, agitation, slurred speech, or seizures occur"
      ],
      icon: "bi-thermometer-sun"
    },
    {
      category: "Allergic reactions",
      title: "Anaphylactic Shock",
      what_happened: "Severe life-threatening allergic reaction to food, venom, or medicine.",
      immediate_first_aid: [
        "Call emergency services immediately.",
        "If person has a prescribed epinephrine auto-injector (EpiPen), assist them in using it on outer mid-thigh.",
        "Have person lie flat on back with feet elevated.",
        "If breathing is difficult, allow them to sit up."
      ],
      do_list: [
        "Stay with person continuously.",
        "Be prepared to give second dose of epinephrine after 5-15 minutes if symptoms persist."
      ],
      dont_list: [
        "Do NOT place pillow under head if breathing is difficult.",
        "Do NOT delay calling emergency services even if EpiPen was given."
      ],
      when_to_seek_help: [
        "Swelling of lips/throat, wheezing, or loss of consciousness"
      ],
      icon: "bi-exclamation-triangle"
    },
    {
      category: "Bites and stings",
      title: "Snake Bite & Animal Bite",
      what_happened: "Puncture wound or envenomation from snake, dog, or wild animal.",
      immediate_first_aid: [
        "Keep victim calm and still to slow venom spread.",
        "Remove tight clothing, rings, or watch near the bite area.",
        "Clean wound gently with soap and water.",
        "Immobilize the bitten limb at or slightly below heart level.",
        "Transport victim to nearest hospital emergency room immediately."
      ],
      do_list: [
        "Note the snake's appearance (color, pattern) from a safe distance.",
        "Seek anti-venom medical treatment urgently."
      ],
      dont_list: [
        "Do NOT cut into the bite wound or suck out venom.",
        "Do NOT apply tourniquet or ice packs to snake bite."
      ],
      when_to_seek_help: [
        "All snake bites require immediate hospital emergency evaluation!"
      ],
      icon: "bi-bug"
    },
    {
      category: "Common illnesses",
      title: "High Fever & Convulsions",
      what_happened: "Spike in body temperature causing febrile seizure or distress.",
      immediate_first_aid: [
        "Place person on their side in a recovery position.",
        "Clear area around them to prevent injury.",
        "Apply cool sponge bath on forehead and neck.",
        "Administer oral rehydration fluids when fully conscious."
      ],
      do_list: [
        "Keep track of time seizure lasts.",
        "Consult a pediatrician/doctor for fever evaluation."
      ],
      dont_list: [
        "Do NOT restrain person during seizure.",
        "Do NOT put anything into their mouth."
      ],
      when_to_seek_help: [
        "Seizure lasts longer than 5 minutes",
        "Fever exceeds 103°F or is accompanied by stiff neck"
      ],
      icon: "bi-heart-pulse"
    }
  ],
  medicines: [
    {
      name: "Paracetamol (Crocin / Dolo 650 / Calpol)",
      purpose: "Analgesic and Antipyretic (Fever & Pain Relief)",
      common_uses: [
        "Temporary relief of mild to moderate fever",
        "Headache, toothache, and body pain relief",
        "Minor muscular aches and flu discomfort"
      ],
      important_warnings: [
        "Do not exceed 4000 mg (4 grams) total daily dose for adults.",
        "Overdose can cause severe liver damage.",
        "Avoid alcohol consumption while taking paracetamol."
      ],
      contraindications: [
        "Severe liver impairment or acute hepatitis",
        "Known hypersensitivity to paracetamol"
      ],
      disclaimer: "Consult a qualified doctor or pharmacist before taking any medication."
    },
    {
      name: "Ibuprofen (Advil / Combiflam)",
      purpose: "Non-Steroidal Anti-Inflammatory Drug (NSAID)",
      common_uses: [
        "Reduction of swelling and localized inflammation",
        "Joint pain, ligament sprains, and backache",
        "Toothache and menstrual cramps"
      ],
      important_warnings: [
        "Take with food or milk to minimize stomach irritation.",
        "Long-term use increases risk of stomach ulcers and GI bleeding."
      ],
      contraindications: [
        "Active stomach ulcers or history of GI bleeding",
        "Severe kidney disease or severe heart failure",
        "Third trimester of pregnancy"
      ],
      disclaimer: "Consult a qualified doctor or pharmacist before taking any medication."
    },
    {
      name: "Oral Rehydration Salts (ORS / Electral)",
      purpose: "Electrolyte and Fluid Replacement Solution",
      common_uses: [
        "Dehydration caused by diarrhea, vomiting, or stomach flu",
        "Heat exhaustion, intense sun exposure, and excessive sweating",
        "Strenuous physical effort or sports recovery"
      ],
      important_warnings: [
        "Dissolve packet contents strictly in the exact volume of clean drinking water specified on label.",
        "Do not boil the solution after mixing."
      ],
      contraindications: [
        "Intestinal obstruction or severe kidney dysfunction (requires medical monitoring)"
      ],
      disclaimer: "Consult a doctor if dehydration symptoms worsen or persistent vomiting prevents fluid retention."
    },
    {
      name: "Cetirizine (Cetzine / Okacet)",
      purpose: "Antihistamine for Allergy & Itch Relief",
      common_uses: [
        "Relief of allergic rhinitis (sneezing, runny nose, watery eyes)",
        "Hives (urticaria) and skin itching",
        "Insect sting and mosquito bite skin reactions"
      ],
      important_warnings: [
        "May cause mild drowsiness in some individuals.",
        "Avoid operating heavy machinery or driving if affected."
      ],
      contraindications: [
        "End-stage renal failure",
        "Hypersensitivity to cetirizine or hydroxyzine"
      ],
      disclaimer: "Consult a doctor or pharmacist for proper dosage guidance."
    },
    {
      name: "Antacid Gel / Tablets (Gelusil / Digene / Eno)",
      purpose: "Gastric Acid Neutralizer",
      common_uses: [
        "Quick relief of heartburn and acid indigestion",
        "Upset stomach due to hyperacidity or overeating",
        "Sour stomach and gas bloat discomfort"
      ],
      important_warnings: [
        "May alter absorption of other medications; take 2 hours apart from other drugs.",
        "Excessive use may cause bowel changes (diarrhea or constipation)."
      ],
      contraindications: [
        "Severe renal failure",
        "Severe hypophosphatemia"
      ],
      disclaimer: "Do not use continuously for more than 14 days without consulting a medical practitioner."
    },
    {
      name: "Povidone-Iodine (Betadine Ointment / Liquid)",
      purpose: "Topical Antiseptic Disinfectant",
      common_uses: [
        "Disinfecting minor cuts, scrapes, and superficial wounds",
        "Preventing bacterial infection in skin lacerations and minor burns",
        "Pre-dressing wound cleaning"
      ],
      important_warnings: [
        "For external skin application only.",
        "Avoid contact with eyes. Discontinue if skin irritation or rash occurs."
      ],
      contraindications: [
        "Thyroid disorders (for extensive chronic application)",
        "Known iodine hypersensitivity"
      ],
      disclaimer: "External application only. Seek medical attention for deep or heavily bleeding wounds."
    },
    {
      name: "Neosporin / Triple Antibiotic Ointment",
      purpose: "Topical Antibacterial First-Aid Ointment",
      common_uses: [
        "First-aid protection against infection in minor cuts, scrapes, and burns",
        "Keeping minor wound beds clean and moist under dressing"
      ],
      important_warnings: [
        "For external topical skin use only.",
        "Do not apply over large body areas or deep puncture wounds."
      ],
      contraindications: [
        "Known hypersensitivity to neomycin, polymyxin, or bacitracin"
      ],
      disclaimer: "Consult a doctor if skin condition persists or worsens after 7 days."
    },
    {
      name: "Diclofenac Gel (Volini / Omnigel / Moov)",
      purpose: "Topical Analgesic Pain Relief Gel",
      common_uses: [
        "Relief of muscle strain, joint pain, and ankle sprains",
        "Localized backache, neck pain, and muscular stiffness",
        "Sports injury recovery"
      ],
      important_warnings: [
        "Apply topically on intact, unbroken skin only.",
        "Wash hands thoroughly after applying. Do not apply near eyes or open wounds."
      ],
      contraindications: [
        "Open wounds, infected skin, or severe eczema",
        "Known NSAID hypersensitivity"
      ],
      disclaimer: "Topical pain relief gel for temporary muscular discomfort."
    },
    {
      name: "Calamine Lotion",
      purpose: "Topical Antipruritic Soothing Lotion",
      common_uses: [
        "Relief of itching from insect bites and bee stings",
        "Soothes sunburn, mild rash, and chickenpox itching",
        "Drying weeping skin irritations"
      ],
      important_warnings: [
        "For external skin application only. Shake well before use.",
        "Avoid contact with eyes, mouth, and mucous membranes."
      ],
      contraindications: [
        "Open deep wounds or severe third-degree burns"
      ],
      disclaimer: "Consult a healthcare provider if rash worsens or persists beyond 7 days."
    },
    {
      name: "Silver Sulfadiazine Cream (Burnol)",
      purpose: "Topical Burn Antiseptic Cream",
      common_uses: [
        "Soothing minor 1st and 2nd degree thermal burns",
        "Preventing infection in minor skin scalds and heat burns"
      ],
      important_warnings: [
        "For topical burn application only.",
        "Clean burn area under cool water before applying a thin layer."
      ],
      contraindications: [
        "Sulfa drug allergy",
        "Pregnant women near term or infants under 2 months"
      ],
      disclaimer: "Seek urgent hospital emergency care for major or deep burns."
    },
    {
      name: "Aloe Vera Gel",
      purpose: "Natural Skin Soothing & Hydrating Agent",
      common_uses: [
        "Cooling minor sun burns and thermal skin heat",
        "Soothing dry, irritated, or itchy skin",
        "Post-insect sting skin hydration"
      ],
      important_warnings: [
        "For external topical use.",
        "Perform a patch test if sensitive skin."
      ],
      contraindications: [
        "Deep open surgical wounds"
      ],
      disclaimer: "Natural soothing agent for minor skin discomfort."
    },
    {
      name: "Dextromethorphan Cough Syrup (Benadryl DR / Ascoril D)",
      purpose: "Cough Suppressant (Dry Cough)",
      common_uses: [
        "Relief of dry, tickly, non-productive cough",
        "Throat irritation causing coughing fits"
      ],
      important_warnings: [
        "Do not exceed recommended dose.",
        "May cause mild drowsiness. Avoid alcohol while taking."
      ],
      contraindications: [
        "Patients taking MAO inhibitors within 14 days",
        "Chronic bronchitis or asthma with heavy mucus production"
      ],
      disclaimer: "Consult a doctor if cough lasts more than 7 days or is accompanied by high fever."
    },
    {
      name: "Omeprazole / Pantoprazole (Pan 40 / Omez)",
      purpose: "Proton Pump Inhibitor (Gastric Acid Reducer)",
      common_uses: [
        "Relief of frequent heartburn, acid reflux (GERD), and stomach gastritis",
        "Prevention of stomach acid erosion"
      ],
      important_warnings: [
        "Take 30 minutes before breakfast with a glass of water.",
        "Not intended for immediate relief of acute heartburn."
      ],
      contraindications: [
        "Known hypersensitivity to substituted benzimidazoles"
      ],
      disclaimer: "Consult a physician for persistent acid reflux or stomach pain."
    },
    {
      name: "Saline Nasal Drops / Spray (Otrivin S / Nasivion Saline)",
      purpose: "Nasal Moisturizer & Mild Decongestant",
      common_uses: [
        "Clearing dry, crusty, or congested nasal passages",
        "Moisturizing nasal membranes to prevent dry nosebleeds",
        "Relief of cold and allergy nasal stuffiness"
      ],
      important_warnings: [
        "Safe for daily nasal hygiene when plain saline solution.",
        "Do not share nasal spray bottles to prevent cross-infection."
      ],
      contraindications: [
        "Hypersensitivity to saline ingredients"
      ],
      disclaimer: "Gentle nasal hydration spray."
    },
    {
      name: "Loperamide (Imodium)",
      purpose: "Anti-Diarrheal Medication",
      common_uses: [
        "Symptomatic control of sudden acute non-infectious watery diarrhea",
        "Traveler's diarrhea management"
      ],
      important_warnings: [
        "Drink plenty of fluids/ORS alongside loperamide.",
        "Do NOT use if high fever or bloody stool is present."
      ],
      contraindications: [
        "Dysentery (bloody stool + high fever)",
        "Acute ulcerative colitis or bacterial enterocolitis"
      ],
      disclaimer: "Consult a doctor immediately if diarrhea persists longer than 48 hours."
    }
  ],
  emergency_categories: [
    {
      id: "bleeding",
      title: "Severe Bleeding",
      icon: "bi-droplet-fill",
      steps: [
        "Apply firm, direct pressure on the wound using a clean cloth or sterile bandage.",
        "Maintain continuous pressure without lifting the cloth to inspect.",
        "If blood soaks through, add another cloth layer directly on top.",
        "Elevate the injured limb above heart level if safe to do so."
      ],
      do_list: ["Keep victim lying down and quiet.", "Call emergency services immediately."],
      dont_list: ["Do NOT remove the original soaked cloth.", "Do NOT apply a tourniquet unless trained."],
      warning: "Call emergency services IMMEDIATELY if blood is spurting or does not slow after 10 minutes of pressure."
    },
    {
      id: "burns",
      title: "Thermal & Chemical Burns",
      icon: "bi-fire",
      steps: [
        "Immediately hold burn under cool, running tap water for 10 to 15 minutes.",
        "Remove rings or constricting clothing near burn before swelling begins.",
        "Cover loosely with a clean, sterile non-stick bandage or plastic wrap."
      ],
      do_list: ["FLUSH continuously with cool water.", "Seek urgent hospital treatment for major burns."],
      dont_list: ["Do NOT apply ice, ice water, butter, oil, or toothpaste.", "Do NOT pop blisters."],
      warning: "Seek emergency hospital care immediately if burn covers face, hands, groin, or appears charred/white."
    },
    {
      id: "choking",
      title: "Choking Emergency",
      icon: "bi-wind",
      steps: [
        "If victim CANNOT cough, speak, or breathe, act immediately!",
        "Give 5 sharp back blows between shoulder blades using heel of hand.",
        "Give 5 abdominal thrusts (Heimlich maneuver): fist above navel, thrust inward and upward.",
        "Repeat 5 back blows and 5 thrusts until object is dislodged."
      ],
      do_list: ["Begin CPR compressions immediately if victim loses consciousness."],
      dont_list: ["Do NOT perform abdominal thrusts on infants under 1 year.", "Do NOT slap back while standing upright."],
      warning: "Call emergency services IMMEDIATELY if obstruction is not cleared within seconds."
    },
    {
      id: "chest_pain",
      title: "Chest Pain / Heart Distress",
      icon: "bi-heart-pulse-fill",
      steps: [
        "Call emergency services IMMEDIATELY.",
        "Have victim sit in a comfortable position (half-sitting, back supported).",
        "Loosen tight clothing around neck and chest.",
        "Help victim take prescribed nitroglycerin if prescribed for known condition."
      ],
      do_list: ["Keep victim calm and still.", "Be ready to perform CPR if victim collapses."],
      dont_list: ["Do NOT leave victim alone.", "Do NOT allow victim to walk or exert energy."],
      warning: "CRITICAL EMERGENCY: Severe chest pain radiating to arm or jaw requires immediate emergency medical transport!"
    },
    {
      id: "breathing",
      title: "Breathing Difficulty",
      icon: "bi-lungs-fill",
      steps: [
        "Sit person upright in a comfortable position to open lungs.",
        "Help person use their prescribed rescue asthma inhaler if available.",
        "Loosen tight collars, ties, and chest clothing.",
        "Encourage slow, deep breaths through mouth."
      ],
      do_list: ["Maintain calm atmosphere; anxiety worsens breathing."],
      dont_list: ["Do NOT lay victim flat on back.", "Do NOT crowd around the victim."],
      warning: "Call emergency services IMMEDIATELY if lips/nails turn blue or person cannot speak words."
    },
    {
      id: "unconscious",
      title: "Fainting / Unconsciousness",
      icon: "bi-person-x-fill",
      steps: [
        "Check for breathing and pulse immediately.",
        "If breathing normally, lay person flat on back and elevate legs 12 inches.",
        "Place in recovery position (side-lying) if left unattended or vomiting.",
        "Loosen collar, belts, and tight clothing."
      ],
      do_list: ["Ensure good air ventilation around victim.", "Time how long victim remains unconscious."],
      dont_list: ["Do NOT give food, water, or medicine by mouth.", "Do NOT splash water on person's face."],
      warning: "Call emergency services IMMEDIATELY if person does not regain consciousness within 1 minute."
    }
  ]
};
