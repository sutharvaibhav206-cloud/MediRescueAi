import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/safety_service.dart';
import '../models/symptom_check.dart';
import '../widgets/disclaimer_card.dart';
import 'emergency_screen.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final TextEditingController _symptomsController = TextEditingController();
  final List<String> _selectedChips = [];
  int? _age;
  String? _gender = 'Unspecified';
  String? _duration = '1-2 days';

  bool _isLoading = false;
  SymptomCheckResponseModel? _result;

  final List<String> _symptomChipOptions = [
    'Fever',
    'Headache',
    'Chest Pain',
    'Breathing Issue',
    'Cough',
    'Skin Rash',
    'Dizziness',
    'Vomiting',
    'Stomach Pain',
    'Minor Cut',
    'Burn',
    'Sprain',
    'Insect Bite',
  ];

  void _analyzeSymptoms() async {
    final text = _symptomsController.text.trim();
    if (text.isEmpty && _selectedChips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please describe your symptoms or select at least one symptom chip."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
    });

    // Client-side Safety Pre-check
    final isClientEmergency = ClientSafetyService.checkEmergency(text, _selectedChips);
    if (isClientEmergency) {
      print("Client safety interceptor triggered emergency warning.");
    }

    final response = await ApiService.checkSymptoms(
      symptomsText: text,
      selectedSymptoms: _selectedChips,
      age: _age,
      gender: _gender,
      duration: _duration,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _result = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006A60),
        title: const Text(
          "🩺 AI Symptom Checker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Card Container for Input
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    const Text(
                      "Describe your symptoms",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _symptomsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "e.g., 'I have fever, headache and body pain for 2 days...'",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Quick Symptom Selection:",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _symptomChipOptions.map((chip) {
                        final isSelected = _selectedChips.contains(chip);
                        return FilterChip(
                          label: Text(chip),
                          selected: isSelected,
                          selectedColor: const Color(0xFF006A60).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF006A60),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF006A60) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedChips.add(chip);
                              } else {
                                _selectedChips.remove(chip);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Optional Meta Details (Age, Gender, Duration)
                    ExpansionTile(
                      title: const Text(
                        "Optional Patient Details (Age, Gender, Duration)",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.teal),
                      ),
                      tilePadding: EdgeInsets.zero,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Age",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onChanged: (val) => _age = int.tryParse(val),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _gender,
                                decoration: const InputDecoration(
                                  labelText: "Gender",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                items: ['Unspecified', 'Male', 'Female', 'Other']
                                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                    .toList(),
                                onChanged: (val) => setState(() => _gender = val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _duration,
                          decoration: const InputDecoration(
                            labelText: "Symptom Duration",
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: ['< 24 hours', '1-2 days', '3-5 days', '> 1 week']
                              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                              .toList(),
                          onChanged: (val) => setState(() => _duration = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Analyze Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006A60),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : _analyzeSymptoms,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.analytics_outlined),
                        label: Text(
                          _isLoading ? "Analyzing with AI..." : "Analyze Symptoms with AI",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Results Section
            if (_result != null) _buildResultView(_result!),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(SymptomCheckResponseModel result) {
    return Column(
      crossAxisAlignment: CrossAlignment.start,
      children: [
        // If Emergency Detected
        if (result.isEmergency) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.warning, color: Colors.white, size: 40),
                const SizedBox(height: 8),
                Text(
                  result.emergencyWarning ?? "POSSIBLE MEDICAL EMERGENCY",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red[900]),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen()));
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text("GO TO EMERGENCY ASSISTANCE", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Possible Conditions Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Possible Medical Conditions",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: result.isEmergency ? Colors.red[100] : Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Severity: ${result.severity}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: result.isEmergency ? Colors.red[900] : Colors.deepOrange[900],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...result.possibleConditions.map((cond) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Possible: ${cond.name}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              "${(cond.confidence * 100).toInt()}% Match",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.teal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: cond.confidence,
                          backgroundColor: Colors.teal[50],
                          color: const Color(0xFF006A60),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // First Aid Guidance Steps
                const Text(
                  "Recommended Immediate Actions:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF006A60)),
                ),
                const SizedBox(height: 8),
                ...result.firstAid.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: const Color(0xFF006A60),
                            child: Text("${e.key + 1}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, height: 1.3))),
                        ],
                      ),
                    )),

                if (result.warningSigns.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    "Warning Signs (Seek Medical Care if present):",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 4),
                  ...result.warningSigns.map((ws) => Text("• $ws", style: const TextStyle(fontSize: 12, color: Colors.black87))),
                ],

                const SizedBox(height: 12),
                DisclaimerCard(text: result.disclaimer),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
