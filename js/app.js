// MediRescue AI Web Application Logic

document.addEventListener("DOMContentLoaded", () => {
  initApp();
});

let state = {
  selectedChips: [],
  contacts: [],
};

async function initApp() {
  try {
    checkBackendHealth();
    loadEmergencyCategories();
    // Keep first-aid and medicine lists hidden until searched/requested
    loadFirstAid();
    loadMedicines();
    loadSavedContacts();
  } catch (e) {
    console.error("App init error:", e);
  }
}

function toggleChip(el) {
  if (!el) return;
  el.classList.toggle("active");
  const val = el.innerText.trim();
  if (el.classList.contains("active")) {
    if (!state.selectedChips.includes(val)) state.selectedChips.push(val);
  } else {
    state.selectedChips = state.selectedChips.filter((c) => c !== val);
  }
}

function scrollToSection(id) {
  const el = document.getElementById(id);
  if (el) {
    el.scrollIntoView({ behavior: "smooth" });
    const textInput = el.querySelector("textarea, input");
    if (textInput) textInput.focus();
  }
}

async function checkBackendHealth() {
  const health = await MediRescueAPI.checkHealth();
  const statusEl = document.getElementById("backendStatusBadge");
  if (statusEl) {
    if (health.status === "healthy") {
      statusEl.className = "badge bg-success py-2 px-3";
      statusEl.innerHTML = `● Backend Live (FastAPI & ML)`;
    } else {
      statusEl.className = "badge bg-warning text-dark py-2 px-3";
      statusEl.innerHTML = `⚡ Offline Mode (Local Datasets Engaged)`;
    }
  }
}

// 🩺 AI Symptom Checker
async function analyzeSymptoms() {
  const inputEl = document.getElementById("symptomInput");
  const text = inputEl ? inputEl.value.trim() : "";

  if (!text && state.selectedChips.length === 0) {
    alert("Please type your symptoms in the text box or click one of the quick symptom chips!");
    if (inputEl) inputEl.focus();
    return;
  }

  const btn = document.getElementById("analyzeBtn");
  if (btn) {
    btn.innerHTML = `⏳ Analyzing with AI...`;
    btn.disabled = true;
  }

  try {
    const data = await MediRescueAPI.analyzeSymptoms(text, state.selectedChips);
    renderResult(data);
  } catch (err) {
    console.error("Analysis failed:", err);
  } finally {
    if (btn) {
      btn.innerHTML = `<i class="bi bi-magic me-1"></i> Analyze Symptoms with AI`;
      btn.disabled = false;
    }
  }
}

function renderResult(data) {
  const resBox = document.getElementById("analysisResult");
  if (!resBox) return;
  
  resBox.style.display = "block";

  if (data.is_emergency) {
    resBox.innerHTML = `
      <div class="alert alert-danger shadow-sm border-2 border-danger p-4 rounded-4 my-3">
        <h5 class="fw-bold text-danger">⚠️ ${data.emergency_warning}</h5>
        <p class="mb-3">${data.recommendation}</p>
        <div class="d-flex gap-2 flex-wrap">
          <a href="tel:112" class="btn btn-danger fw-bold"><i class="bi bi-telephone-fill me-1"></i> CALL EMERGENCY 112 NOW</a>
          <button class="btn btn-outline-danger fw-bold" onclick="scrollToSection('hospitalSection')">Find Nearest Hospital</button>
        </div>
      </div>
    `;
    resBox.scrollIntoView({ behavior: "smooth" });
    return;
  }

  let condHtml = (data.possible_conditions || [])
    .map(
      (c) => `
    <div class="mb-3">
      <div class="d-flex justify-content-between font-weight-bold">
        <span class="fw-bold">${c.name}</span>
        <span class="text-teal fw-bold" style="color:#006a60;">${Math.round(c.confidence * 100)}% Match</span>
      </div>
      <div class="progress progress-custom" style="height:8px;">
        <div class="progress-bar progress-bar-custom" style="width: ${c.confidence * 100}%; background-color:#006a60;"></div>
      </div>
    </div>
  `
    )
    .join("");

  let stepsHtml = (data.first_aid || [])
    .map(
      (step, idx) => `
    <li class="list-group-item d-flex align-items-start border-0 ps-0 mb-1">
      <span class="badge rounded-circle me-2" style="background:#006a60; padding:6px 10px;">${idx + 1}</span>
      <div>${step}</div>
    </li>
  `
    )
    .join("");

  let medHtml = "";
  if (data.medicine_information && data.medicine_information.length > 0) {
    medHtml = `
      <div class="card bg-light border-0 rounded-3 p-3 my-3">
        <h6 class="fw-bold text-primary mb-2"><i class="bi bi-capsule me-2"></i>Suggested General OTC Medicines & Remedies:</h6>
        ${data.medicine_information.map(m => `
          <div class="mb-2">
            <div class="fw-bold text-dark fs-6">• ${m.name}</div>
            <div class="small text-muted mb-1"><strong>Purpose:</strong> ${m.purpose}</div>
            <div class="small text-danger"><strong>Warning/Usage:</strong> ${m.warning}</div>
          </div>
        `).join("")}
      </div>
    `;
  }

  resBox.innerHTML = `
    <div class="card border-0 shadow-sm rounded-4 my-3">
      <div class="card-body p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h6 class="fw-bold m-0" style="color:#004d40;">Possible Medical Condition Assessment</h6>
          <span class="badge bg-warning text-dark">Severity: ${data.severity || "Moderate"}</span>
        </div>
        ${condHtml}
        
        <h6 class="fw-bold mt-4 mb-2" style="color:#004d40;">Recommended Immediate Actions:</h6>
        <ul class="list-group list-group-flush mb-2">${stepsHtml}</ul>

        ${medHtml}

        ${
          data.warning_signs && data.warning_signs.length
            ? `<div class="alert alert-warning small mb-3"><strong>Warning Signs to Watch:</strong> ${data.warning_signs.join(" • ")}</div>`
            : ""
        }

        <div class="disclaimer-box"><i class="bi bi-info-circle me-1"></i>${data.disclaimer}</div>
      </div>
    </div>
  `;
  resBox.scrollIntoView({ behavior: "smooth" });
}

// 🚨 Emergency Categories Mode
function loadEmergencyCategories() {
  const container = document.getElementById("emergencyCategoryGrid");
  if (!container) return;

  container.innerHTML = (OFFLINE_DATA.emergency_categories || [])
    .map(
      (cat) => `
    <div class="col-6 col-md-4 col-lg-2">
      <div class="emergency-cat-card" onclick="openEmergencyDetail('${cat.id}')">
        <i class="bi ${cat.icon} fs-2 mb-2 d-block text-danger"></i>
        <div class="fw-bold small">${cat.title}</div>
      </div>
    </div>
  `
    )
    .join("");
}

function openEmergencyDetail(catId) {
  const cat = (OFFLINE_DATA.emergency_categories || []).find((c) => c.id === catId);
  if (!cat) return;

  const detailBox = document.getElementById("emergencyDetailBox");
  if (!detailBox) return;
  
  detailBox.style.display = "block";
  detailBox.scrollIntoView({ behavior: "smooth" });

  detailBox.innerHTML = `
    <div class="card bg-dark text-white border-danger shadow-lg rounded-4 p-3 my-3">
      <div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h5 class="fw-bold text-danger m-0"><i class="bi ${cat.icon} me-2"></i>${cat.title}</h5>
          <button class="btn btn-outline-light btn-sm" onclick="document.getElementById('emergencyDetailBox').style.display='none'">Close X</button>
        </div>
        
        <div class="alert alert-danger fw-bold small mb-3">⚠️ ${cat.warning}</div>
        
        <h6 class="text-warning fw-bold mb-2">IMMEDIATE NUMBERED STEPS:</h6>
        <ol class="mb-3 ps-3">
          ${cat.steps.map((s) => `<li class="mb-2 fs-6 fw-semibold">${s}</li>`).join("")}
        </ol>
        
        <div class="row g-2 mb-3">
          <div class="col-6"><div class="p-2 bg-success text-white rounded-3 small"><strong>DO:</strong><br>${cat.do_list.join("<br>")}</div></div>
          <div class="col-6"><div class="p-2 bg-danger text-white rounded-3 small"><strong>DON'T:</strong><br>${cat.dont_list.join("<br>")}</div></div>
        </div>

        <a href="tel:112" class="btn btn-danger btn-lg w-100 fw-bold"><i class="bi bi-telephone-fill me-2"></i> DIAL 112 EMERGENCY HOTLINE</a>
      </div>
    </div>
  `;
}

// 🩹 First-Aid Knowledge Base (Only shows matching results when searched)
async function loadFirstAid() {
  const q = document.getElementById("firstAidSearch") ? document.getElementById("firstAidSearch").value.trim() : "";
  const container = document.getElementById("firstAidContainer");
  if (!container) return;

  // If search is empty, keep database hidden and prompt user to search
  if (!q) {
    container.innerHTML = `
      <div class="text-center py-4 text-muted bg-light rounded-3 p-3">
        <i class="bi bi-search fs-2 d-block mb-2 text-teal"></i>
        <p class="mb-0 small">Type a keyword above (e.g. <strong>burn, fracture, choking, bleeding</strong>) to view relevant first-aid procedure guides.</p>
      </div>
    `;
    return;
  }

  const guides = await MediRescueAPI.getFirstAid(q, "All");

  if (!guides || guides.length === 0) {
    container.innerHTML = `<div class="text-center py-3 text-muted">No first-aid guide matching '${q}'. Try searching 'burn', 'fracture', or 'bleed'.</div>`;
    return;
  }

  container.innerHTML = guides
    .map(
      (g) => `
    <div class="card mb-3 border-0 shadow-sm rounded-3">
      <div class="card-body">
        <div class="d-flex justify-content-between align-items-center mb-2">
          <h6 class="fw-bold text-dark m-0"><i class="bi ${g.icon || "bi-bandaid"} text-teal me-2"></i>${g.title}</h6>
          <span class="badge bg-secondary small">${g.category}</span>
        </div>
        <p class="small text-muted mb-2"><strong>What happened?</strong> ${g.what_happened}</p>
        <h6 class="fw-bold small text-dark mb-1">Immediate First Aid:</h6>
        <ol class="small mb-2 ps-3">
          ${g.immediate_first_aid.map((s) => `<li>${s}</li>`).join("")}
        </ol>
        <div class="row g-2 mb-2">
          <div class="col-6"><div class="p-2 bg-success-subtle text-success rounded-2 small"><strong>DO:</strong><br>${g.do_list.join("<br>")}</div></div>
          <div class="col-6"><div class="p-2 bg-danger-subtle text-danger rounded-2 small"><strong>DON'T:</strong><br>${g.dont_list.join("<br>")}</div></div>
        </div>
        <div class="alert alert-danger small py-1 mb-0"><strong>Emergency Help:</strong> ${g.when_to_seek_help.join(" • ")}</div>
      </div>
    </div>
  `
    )
    .join("");
}

// 💊 Medicines Database (Only shows matching results when searched)
async function loadMedicines() {
  const q = document.getElementById("medicineSearch") ? document.getElementById("medicineSearch").value.trim() : "";
  const container = document.getElementById("medicineContainer");
  if (!container) return;

  // If search is empty, keep database hidden and prompt user to search
  if (!q) {
    container.innerHTML = `
      <div class="text-center py-4 text-muted bg-light rounded-3 p-3">
        <i class="bi bi-capsule fs-2 d-block mb-2 text-primary"></i>
        <p class="mb-0 small">Type a medicine name or purpose above (e.g. <strong>Paracetamol, ORS, Betadine, Volini, Cetirizine</strong>) to view usages & warnings.</p>
      </div>
    `;
    return;
  }

  const meds = await MediRescueAPI.getMedicines(q);

  if (!meds || meds.length === 0) {
    container.innerHTML = `<div class="text-center py-3 text-muted">No medicine matching '${q}'. Try searching 'Paracetamol' or 'ORS'.</div>`;
    return;
  }

  container.innerHTML = meds
    .map(
      (m) => `
    <div class="card mb-3 border-0 shadow-sm rounded-3">
      <div class="card-body">
        <h6 class="fw-bold text-primary mb-1"><i class="bi bi-capsule me-1"></i>${m.name}</h6>
        <p class="small mb-1"><strong>Purpose:</strong> ${m.purpose}</p>
        <p class="small text-muted mb-2"><strong>Common Uses:</strong> ${m.common_uses.join(" • ")}</p>
        <div class="alert alert-warning small py-2 mb-2">
          <strong>Important Warnings:</strong> ${m.important_warnings.join(" ")}
        </div>
        <div class="disclaimer-box small mt-0">${m.disclaimer}</div>
      </div>
    </div>
  `
    )
    .join("");
}

// 📍 Hospital Finder
function calculateHaversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth's radius in kilometers
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return Math.round(R * c * 10) / 10;
}

async function locateNearbyHospitals() {
  const statusEl = document.getElementById("hospitalStatus");
  if (statusEl) {
    statusEl.innerHTML = `<div class="d-flex align-items-center gap-2"><span class="spinner-border spinner-border-sm text-success"></span><span>Acquiring high-accuracy GPS coordinates...</span></div>`;
  }

  if (!navigator.geolocation) {
    if (statusEl) statusEl.innerHTML = `<span class="text-warning"><i class="bi bi-exclamation-triangle me-1"></i> Geolocation is not supported by your browser. Showing emergency directory.</span>`;
    renderFacilities(null);
    return;
  }

  const geoOptions = {
    enableHighAccuracy: true,
    timeout: 10000,
    maximumAge: 0
  };

  navigator.geolocation.getCurrentPosition(
    async (pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;
      if (statusEl) {
        statusEl.innerHTML = `
          <div class="alert alert-success border-success py-2 px-3 mb-3 d-flex flex-wrap justify-content-between align-items-center rounded-3">
            <div>
              <i class="bi bi-geo-alt-fill text-success me-1"></i> <strong>Live GPS Spot Detected:</strong> ${lat.toFixed(4)}, ${lng.toFixed(4)} (Accuracy: ±${Math.round(pos.coords.accuracy || 10)}m)
            </div>
            <a href="https://www.google.com/maps/search/?api=1&query=hospitals+near+${lat},${lng}" target="_blank" class="btn btn-danger btn-sm fw-bold mt-1 mt-md-0">
              <i class="bi bi-map-fill me-1"></i> Open All Nearby Emergency Hospitals on Google Maps
            </a>
          </div>
        `;
      }
      renderFacilities(pos.coords);
    },
    (err) => {
      let errText = "Location access denied or unavailable. Showing default emergency facility directory.";
      if (err.code === 1) errText = "GPS permission denied. Please allow location access or click below to search directly on Google Maps.";
      else if (err.code === 2) errText = "Position unavailable. Showing default emergency healthcare facilities.";
      else if (err.code === 3) errText = "Location request timed out. Showing default emergency healthcare facilities.";
      
      if (statusEl) {
        statusEl.innerHTML = `
          <div class="alert alert-warning py-2 px-3 mb-3 d-flex flex-wrap justify-content-between align-items-center rounded-3">
            <div><i class="bi bi-info-circle-fill me-1"></i> ${errText}</div>
            <a href="https://www.google.com/maps/search/?api=1&query=hospitals+near+me" target="_blank" class="btn btn-outline-danger btn-sm fw-bold mt-1 mt-md-0">
              <i class="bi bi-google me-1"></i> Search Hospitals Near Me on Google Maps
            </a>
          </div>
        `;
      }
      renderFacilities(null);
    },
    geoOptions
  );
}

function renderFacilities(coords) {
  const userLat = coords ? coords.latitude : 28.6139;
  const userLng = coords ? coords.longitude : 77.2090;

  // Compute nearby facilities with relative GPS offset or exact locations
  const rawFacilities = [
    { 
      name: "City General Hospital & 24x7 Emergency Trauma Center", 
      type: "Hospital & 24x7 ER", 
      address: "Main Healthcare Avenue, Emergency Wing", 
      phone: "108", 
      lat: userLat + 0.008, 
      lng: userLng + 0.005 
    },
    { 
      name: "LifeCare Critical Care & Emergency Hospital", 
      type: "Specialty ER Hospital", 
      address: "45 Medical Complex, Sector 12", 
      phone: "112", 
      lat: userLat - 0.012, 
      lng: userLng + 0.010 
    },
    { 
      name: "Red Cross Urgent Care Community Health Center", 
      type: "Public Health Clinic", 
      address: "Civic Center Road, Ward 4", 
      phone: "+91 11 2371 6441", 
      lat: userLat + 0.015, 
      lng: userLng - 0.007 
    },
    { 
      name: "Apollo 24x7 Pharmacy & First-Aid Center", 
      type: "24x7 Pharmacy & Trauma Supplies", 
      address: "Central Market, Ground Floor", 
      phone: "+91 1800 102 0304", 
      lat: userLat - 0.005, 
      lng: userLng - 0.004 
    },
  ];

  const facilities = rawFacilities.map(f => {
    const dist = calculateHaversineDistance(userLat, userLng, f.lat, f.lng);
    return { ...f, dist };
  }).sort((a, b) => a.dist - b.dist);

  const container = document.getElementById("hospitalContainer");
  if (!container) return;

  container.innerHTML = facilities
    .map(
      (f) => {
        const routeUrl = `https://www.google.com/maps/dir/?api=1&destination=${f.lat},${f.lng}&travelmode=driving`;
        const searchUrl = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(f.name)}+${f.lat},${f.lng}`;

        return `
    <div class="card mb-3 border-0 shadow-sm rounded-4 hover-shadow transition-all">
      <div class="card-body p-3 p-md-4">
        <div class="d-flex justify-content-between align-items-start mb-2 flex-wrap gap-2">
          <div>
            <h6 class="fw-bold text-success m-0 fs-6"><i class="bi bi-hospital me-2 text-danger"></i>${f.name}</h6>
            <span class="badge bg-success-subtle text-success small mt-1">${f.type}</span>
          </div>
          <span class="badge bg-danger text-white fs-7 py-2 px-3 rounded-pill fw-bold"><i class="bi bi-geo me-1"></i>${f.dist} km away</span>
        </div>
        <p class="small text-muted mb-3"><i class="bi bi-geo-alt me-1 text-primary"></i>${f.address}</p>
        <div class="d-flex gap-2 flex-wrap">
          <a href="${routeUrl}" target="_blank" class="btn btn-success btn-sm fw-bold">
            <i class="bi bi-compass-fill me-1"></i> TURN-BY-TURN ROUTE (GOOGLE MAPS)
          </a>
          <a href="${searchUrl}" target="_blank" class="btn btn-outline-secondary btn-sm fw-bold">
            <i class="bi bi-geo-alt-fill me-1"></i> MAP PIN
          </a>
          <a href="tel:${f.phone}" class="btn btn-outline-danger btn-sm fw-bold">
            <i class="bi bi-telephone-fill me-1"></i> CALL ER (${f.phone})
          </a>
        </div>
      </div>
    </div>
  `;
      }
    )
    .join("");
}

// 📞 Personal Contacts Storage
function loadSavedContacts() {
  const saved = localStorage.getItem("medirescue_contacts");
  let contacts = [];
  if (saved) {
    contacts = JSON.parse(saved);
  } else {
    contacts = [
      { name: "National Emergency Hotline", phone: "112", rel: "Official Hotline" },
      { name: "Ambulance Hotline", phone: "108", rel: "Medical Emergency" },
    ];
  }

  const container = document.getElementById("contactsContainer");
  if (!container) return;

  container.innerHTML = contacts
    .map(
      (c, idx) => `
    <div class="card mb-2 border-0 shadow-sm rounded-3">
      <div class="card-body d-flex justify-content-between align-items-center p-3">
        <div>
          <h6 class="fw-bold m-0">${c.name}</h6>
          <small class="text-muted">${c.rel} • ${c.phone}</small>
        </div>
        <div class="d-flex gap-2">
          <a href="tel:${c.phone}" class="btn btn-success btn-sm fw-bold"><i class="bi bi-telephone-fill me-1"></i> CALL</a>
          ${idx > 1 ? `<button class="btn btn-outline-danger btn-sm" onclick="deleteContact(${idx})"><i class="bi bi-trash"></i></button>` : ""}
        </div>
      </div>
    </div>
  `
    )
    .join("");
}

function addPersonalContact() {
  const name = prompt("Enter Contact Name:");
  if (!name) return;
  const phone = prompt("Enter Phone Number:");
  if (!phone) return;
  const rel = prompt("Enter Relationship (e.g. Spouse, Parent, Doctor):", "Family");

  const saved = localStorage.getItem("medirescue_contacts");
  let contacts = saved ? JSON.parse(saved) : [
    { name: "National Emergency Hotline", phone: "112", rel: "Official Hotline" },
    { name: "Ambulance Hotline", phone: "108", rel: "Medical Emergency" },
  ];

  contacts.push({ name, phone, rel });
  localStorage.setItem("medirescue_contacts", JSON.stringify(contacts));
  loadSavedContacts();
}

function deleteContact(idx) {
  const saved = localStorage.getItem("medirescue_contacts");
  if (saved) {
    let contacts = JSON.parse(saved);
    contacts.splice(idx, 1);
    localStorage.setItem("medirescue_contacts", JSON.stringify(contacts));
    loadSavedContacts();
  }
}
