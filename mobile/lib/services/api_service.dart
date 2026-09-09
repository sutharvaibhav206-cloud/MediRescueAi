import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/condition.dart';
import '../models/first_aid.dart';
import '../models/medicine.dart';
import '../models/symptom_check.dart';
import 'offline_storage_service.dart';

class ApiService {
  // Configurable base URL (10.0.2.2 for Android Emulator, 127.0.0.1 for local, or custom IP)
  static String baseUrl = "http://10.0.2.2:8000/api";
  static const Duration timeoutDuration = Duration(seconds: 4);

  // Check health status of backend server
  static Future<bool> isBackendAvailable() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/health")).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy';
      }
    } catch (e) {
      print("Backend not available: $e");
    }
    return false;
  }

  // Symptom Checker API Call
  static Future<SymptomCheckResponseModel> checkSymptoms({
    required String symptomsText,
    List<String>? selectedSymptoms,
    int? age,
    String? gender,
    String? duration,
  }) async {
    final body = {
      "symptoms_text": symptomsText,
      "selected_symptoms": selectedSymptoms ?? [],
      "age": age,
      "gender": gender,
      "duration": duration,
    };

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/symptom-check"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SymptomCheckResponseModel.fromJson(data);
      }
    } catch (e) {
      print("API symptom check failed, using local offline fallback logic: $e");
    }

    // Offline Fallback for Symptom Checking
    return _buildOfflineSymptomResponse(symptomsText, selectedSymptoms);
  }

  // Offline Symptom Checker Builder
  static Future<SymptomCheckResponseModel> _buildOfflineSymptomResponse(
      String text, List<String>? selected) async {
    final offlineConditions = await OfflineStorageService.loadOfflineConditions();
    final combinedText = (text + " " + (selected?.join(" ") ?? "")).toLowerCase();

    MedicalConditionModel? matchedCond;
    for (var cond in offlineConditions) {
      if (combinedText.contains(cond.name.toLowerCase()) ||
          cond.symptoms.any((s) => combinedText.contains(s.toLowerCase()))) {
        matchedCond = cond;
        break;
      }
    }

    if (matchedCond != null) {
      return SymptomCheckResponseModel(
        isEmergency: false,
        possibleConditions: [
          PossibleConditionModel(
            name: matchedCond.name,
            confidence: 0.75,
            severity: matchedCond.severity,
          )
        ],
        severity: matchedCond.severity,
        firstAid: matchedCond.firstAid,
        doNot: matchedCond.doNot,
        warningSigns: matchedCond.warningSigns,
        recommendation: "OFFLINE MODE: Follow initial guidance. Consult a doctor if symptoms persist.",
        disclaimer: "OFFLINE RESULTS: Information retrieved from local offline database. Not a diagnostic replacement.",
      );
    }

    return SymptomCheckResponseModel(
      isEmergency: false,
      possibleConditions: [
        PossibleConditionModel(
          name: "General Discomfort / Symptom Match",
          confidence: 0.50,
          severity: "Mild to Moderate",
        )
      ],
      severity: "Moderate",
      firstAid: [
        "Rest in a quiet, comfortable space.",
        "Drink clean fluids or oral rehydration salt solution.",
        "Monitor your symptoms closely.",
        "Seek medical evaluation if pain or discomfort worsens."
      ],
      doNot: [
        "Do not self-prescribe unapproved medications."
      ],
      warningSigns: [
        "High fever above 102°F",
        "Shortness of breath or chest pain"
      ],
      recommendation: "OFFLINE MODE ACTIVE: Connect to backend for full ML predictions.",
      disclaimer: "IMPORTANT: Informational tool only. Consult a doctor for diagnosis.",
    );
  }

  // Fetch First-Aid Guides
  static Future<List<FirstAidGuideModel>> getFirstAidGuides({String? category}) async {
    try {
      String url = "$baseUrl/first-aid";
      if (category != null && category.isNotEmpty) {
        url += "?category=${Uri.encodeComponent(category)}";
      }
      final response = await http.get(Uri.parse(url)).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        final List<dynamic> list = json.decode(response.body);
        return list.map((item) => FirstAidGuideModel.fromJson(item)).toList();
      }
    } catch (e) {
      print("API getFirstAidGuides failed, using local offline fallback: $e");
    }

    final offlineList = await OfflineStorageService.loadOfflineFirstAid();
    if (category != null && category.isNotEmpty && category != 'All') {
      return offlineList.where((item) => item.category.toLowerCase().contains(category.toLowerCase())).toList();
    }
    return offlineList;
  }

  // Search Medicines
  static Future<List<MedicineModel>> searchMedicines(String query) async {
    try {
      final String url = "$baseUrl/medicines?q=${Uri.encodeComponent(query)}";
      final response = await http.get(Uri.parse(url)).timeout(timeoutDuration);
      if (response.statusCode == 200) {
        final List<dynamic> list = json.decode(response.body);
        return list.map((item) => MedicineModel.fromJson(item)).toList();
      }
    } catch (e) {
      print("API searchMedicines failed, using local offline fallback: $e");
    }

    final offlineMeds = await OfflineStorageService.loadOfflineMedicines();
    if (query.isEmpty) return offlineMeds;
    final qLower = query.toLowerCase();
    return offlineMeds.where((m) => m.name.toLowerCase().contains(qLower) || m.commonUses.any((u) => u.toLowerCase().contains(qLower))).toList();
  }
}
