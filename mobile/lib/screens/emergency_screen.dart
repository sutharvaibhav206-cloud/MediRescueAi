import 'package:flutter/material.dart';
import '../services/location_service.dart';

class EmergencyCategory {
  final String id;
  final String title;
  final IconData icon;
  final List<String> immediateSteps;
  final List<String> doList;
  final List<String> dontList;
  final String emergencyWarning;

  EmergencyCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.immediateSteps,
    required this.doList,
    required this.dontList,
    required this.emergencyWarning,
  });
}

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  EmergencyCategory? _selectedCategory;

  final List<EmergencyCategory> _categories = [
    EmergencyCategory(
      id: 'bleeding',
      title: 'Severe Bleeding',
      icon: Icons.water_drop,
      immediateSteps: [
        'Apply firm, direct pressure on the wound using a clean cloth or sterile bandage.',
        'Maintain continuous pressure without lifting the cloth to inspect.',
        'If blood soaks through, add another cloth layer directly on top.',
        'Elevate the injured limb above heart level if safe to do so.'
      ],
      doList: [
        'Keep victim lying down and quiet to slow heart rate.',
        'Call emergency services immediately if bleeding persists.'
      ],
      dontList: [
        'Do NOT remove the original soaked cloth.',
        'Do NOT apply a tourniquet unless trained and direct pressure fails.'
      ],
      emergencyWarning: 'Call emergency services IMMEDIATELY if blood is spurting or does not slow after 10 minutes of direct pressure.',
    ),
    EmergencyCategory(
      id: 'burns',
      title: 'Burns',
      icon: Icons.local_fire_department,
      immediateSteps: [
        'Immediately hold burn under cool, running tap water for 10 to 15 minutes.',
        'Remove rings or constricting clothing near burn before swelling begins.',
        'Cover loosely with a clean, sterile non-stick bandage or clean plastic wrap.'
      ],
      doList: [
        'FLUSH continuously with cool water.',
        'Seek urgent hospital treatment for major burns.'
      ],
      dontList: [
        'Do NOT apply ice, ice water, butter, oil, or toothpaste to burns.',
        'Do NOT pop or break blisters.'
      ],
      emergencyWarning: 'Seek emergency hospital care immediately if burn covers face, hands, groin, or appears charred/white.',
    ),
    EmergencyCategory(
      id: 'fracture',
      title: 'Fracture / Injury',
      icon: Icons.bone,
      immediateSteps: [
        'Immobilize the injured area completely in the position found.',
        'Apply an ice pack wrapped in a cloth to reduce swelling.',
        'If trained, apply a temporary splint supporting above and below the joint.'
      ],
      doList: [
        'Keep the victim calm and warm.',
        'Call for emergency transport if severe.'
      ],
      dontList: [
        'Do NOT attempt to push back protruding bone or realign limb.',
        'Do NOT allow victim to walk on an injured leg.'
      ],
      emergencyWarning: 'Seek immediate emergency care if bone penetrates skin or limb is numb, pale, or cold.',
    ),
    EmergencyCategory(
      id: 'choking',
      title: 'Choking',
      icon: Icons.air,
      immediateSteps: [
        'If victim CANNOT cough, speak, or breathe, act immediately!',
        'Give 5 sharp back blows between shoulder blades using heel of hand.',
        'Give 5 abdominal thrusts (Heimlich maneuver): fist above navel, thrust inward and upward.',
        'Repeat 5 back blows and 5 thrusts until object is dislodged.'
      ],
      doList: [
        'Begin CPR compressions immediately if victim loses consciousness.'
      ],
      dontList: [
        'Do NOT perform abdominal thrusts on infants under 1 year (use chest thrusts).',
        'Do NOT slap back while victim is standing upright.'
      ],
      emergencyWarning: 'Call emergency services IMMEDIATELY if obstruction is not cleared within seconds.',
    ),
    EmergencyCategory(
      id: 'fainting',
      title: 'Fainting / Unconsciousness',
      icon: Icons.airline_seat_flat,
      immediateSteps: [
        'Check for breathing and pulse immediately.',
        'If breathing normally, lay person flat on back and elevate legs 12 inches.',
        'Place in recovery position (side-lying) if left unattended or vomiting.',
        'Loosen collar, belts, and tight clothing.'
      ],
      doList: [
        'Ensure good air ventilation around victim.',
        'Time how long victim remains unconscious.'
      ],
      dontList: [
        'Do NOT give food, water, or medicine by mouth.',
        'Do NOT splash water on person\'s face.'
      ],
      emergencyWarning: 'Call emergency services IMMEDIATELY if person does not regain consciousness within 1 minute or stops breathing.',
    ),
    EmergencyCategory(
      id: 'seizure',
      title: 'Seizure',
      icon: Icons.flash_on,
      immediateSteps: [
        'Clear immediate space of sharp or hard objects.',
        'Cushion the person\'s head with something soft.',
        'Turn person gently onto one side to keep airway clear.',
        'Time the duration of the seizure.'
      ],
      doList: [
        'Stay calm and remain with person until seizure ends naturally.'
      ],
      dontList: [
        'Do NOT put anything into the person\'s mouth.',
        'Do NOT attempt to hold down or restrain movement.'
      ],
      emergencyWarning: 'Call emergency services IMMEDIATELY if seizure lasts longer than 5 minutes or recurs without recovery.',
    ),
    EmergencyCategory(
      id: 'chest_pain',
      title: 'Chest Pain',
      icon: Icons.favorite,
      immediateSteps: [
        'Call emergency services IMMEDIATELY.',
        'Have victim sit in a comfortable position (half-sitting, back supported).',
        'Loosen tight clothing around neck and chest.',
        'Help victim take prescribed nitroglycerin if prescribed for known condition.'
      ],
      doList: [
        'Keep victim calm and still.',
        'Be ready to perform CPR if victim collapses.'
      ],
      dontList: [
        'Do NOT leave victim alone.',
        'Do NOT allow victim to walk or exert energy.'
      ],
      emergencyWarning: 'CRITICAL EMERGENCY: Severe chest pain radiating to arm or jaw requires immediate hospital emergency services!',
    ),
    EmergencyCategory(
      id: 'breathing',
      title: 'Breathing Difficulty',
      icon: Icons.lungs,
      immediateSteps: [
        'Sit person upright in a comfortable position to open lungs.',
        'Help person use their prescribed rescue asthma inhaler if available.',
        'Loosen tight collars, ties, and chest clothing.',
        'Encourage slow, deep breaths through mouth.'
      ],
      doList: [
        'Maintain calm atmosphere; anxiety worsens breathing.'
      ],
      dontList: [
        'Do NOT lay victim flat on back.',
        'Do NOT crowd around the victim.'
      ],
      emergencyWarning: 'Call emergency services IMMEDIATELY if lips/nails turn blue or person cannot speak words.',
    ),
    EmergencyCategory(
      id: 'poisoning',
      title: 'Poisoning',
      icon: Icons.warning_amber,
      immediateSteps: [
        'Call Poison Control / Emergency Services immediately.',
        'Identify what was ingested, inhaled, or touched, and keep container.',
        'If skin contact: flush with water for 15-20 minutes.',
        'If inhaled: move person to fresh air immediately.'
      ],
      doList: [
        'Keep victim calm and save poison container for medical teams.'
      ],
      dontList: [
        'Do NOT induce vomiting unless explicitly instructed by Poison Control.',
        'Do NOT give ipecac syrup or activated charcoal without medical order.'
      ],
      emergencyWarning: 'Poisoning is a critical emergency! Contact emergency services or poison control immediately.',
    ),
    EmergencyCategory(
      id: 'bites',
      title: 'Animal / Insect Bite',
      icon: Icons.bug_report,
      immediateSteps: [
        'For Snake Bite: Keep victim still; immobilize bitten limb at or below heart level.',
        'For Insect Sting: Remove sting sac by scraping gently with a card edge.',
        'Wash wound thoroughly with soap and clean water.',
        'Apply ice pack wrapped in cloth to reduce swelling.'
      ],
      doList: [
        'Note snake/insect appearance from a safe distance.',
        'Seek urgent hospital anti-venom treatment for snake bites.'
      ],
      dontList: [
        'Do NOT cut snake bite wound or attempt to suck out venom.',
        'Do NOT apply tourniquet or ice to snake bites.'
      ],
      emergencyWarning: 'All venomous snake bites and animal bites require immediate hospital emergency evaluation.',
    ),
    EmergencyCategory(
      id: 'allergy',
      title: 'Allergic Reaction',
      icon: Icons.notifications_active,
      immediateSteps: [
        'Remove known allergen immediately.',
        'If Anaphylaxis: Administer EpiPen auto-injector into outer mid-thigh.',
        'Have person lie flat with legs elevated (sit up if breathing is hard).',
        'Call emergency services immediately.'
      ],
      doList: [
        'Be prepared to administer second EpiPen dose after 5-15 mins if help hasn\'t arrived.'
      ],
      dontList: [
        'Do NOT delay calling emergency services even if EpiPen was used.'
      ],
      emergencyWarning: 'Swelling of throat, lips, or wheezing is a life-threatening anaphylactic emergency!',
    ),
    EmergencyCategory(
      id: 'fever',
      title: 'High Fever',
      icon: Icons.thermostat,
      immediateSteps: [
        'Apply cool damp sponge or washcloth on forehead and neck.',
        'Give small sips of clean water or oral rehydration solution.',
        'Keep room well-ventilated and dress person in lightweight clothing.'
      ],
      doList: [
        'Monitor body temperature with thermometer.'
      ],
      dontList: [
        'Do NOT bundle in thick blankets if shivering with high fever.',
        'Do NOT give aspirin to children or teenagers.'
      ],
      emergencyWarning: 'Seek emergency care if fever exceeds 103°F (39.4°C), lasts over 3 days, or causes stiff neck.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        title: const Text(
          "🚨 Emergency Assistance Mode",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_selectedCategory != null) {
              setState(() {
                _selectedCategory = null;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Emergency Call Header Bar
          Container(
            color: const Color(0xFFB71C1C),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.phone_in_talk, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Call Emergency Hotline (112)",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFB71C1C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  ),
                  onPressed: () => LocationService.makePhoneCall("112"),
                  child: const Text("DIAL 112", style: TextStyle(fontWeight: FontWeight.black)),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _selectedCategory == null
                ? _buildCategoryGrid()
                : _buildCategoryDetail(_selectedCategory!),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Text(
            "SELECT EMERGENCY TYPE",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.4), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon, color: Colors.redAccent, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        cat.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDetail(EmergencyCategory cat) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          // Selected Category Header
          Row(
            children: [
              Icon(cat.icon, color: Colors.redAccent, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cat.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Emergency Warning Callout
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF7F1D1D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.amber, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    cat.emergencyWarning,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Immediate Numbered Steps
          const Text(
            "IMMEDIATE FIRST-AID STEPS",
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.black,
              fontSize: 15,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          ...cat.immediateSteps.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      "${entry.key + 1}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // DO List
          const Text(
            "DO (SAFE ACTIONS)",
            style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...cat.doList.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),

          // DON'T List
          const Text(
            "DON'T (ACTIONS TO AVOID)",
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...cat.dontList.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),

          // Call Hotline Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => LocationService.makePhoneCall("112"),
              icon: const Icon(Icons.phone_in_talk, size: 24),
              label: const Text(
                "CALL EMERGENCY SERVICES (112)",
                style: TextStyle(fontWeight: FontWeight.black, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
