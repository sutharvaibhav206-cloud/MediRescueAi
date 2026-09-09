import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/first_aid.dart';
import '../models/medicine.dart';
import '../models/condition.dart';
import '../models/emergency_contact.dart';

class OfflineStorageService {
  static const String _contactsKey = 'emergency_contacts';
  static const String _nationalNumKey = 'national_emergency_number';

  // Load offline First-Aid guides bundled in assets
  static Future<List<FirstAidGuideModel>> loadOfflineFirstAid() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/json/first_aid_offline.json');
      final List<dynamic> list = json.decode(jsonStr);
      return list.map((item) => FirstAidGuideModel.fromJson(item)).toList();
    } catch (e) {
      print("Error loading offline first aid JSON: $e");
      return [];
    }
  }

  // Load offline Medicines bundled in assets
  static Future<List<MedicineModel>> loadOfflineMedicines() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/json/medicines_offline.json');
      final List<dynamic> list = json.decode(jsonStr);
      return list.map((item) => MedicineModel.fromJson(item)).toList();
    } catch (e) {
      print("Error loading offline medicines JSON: $e");
      return [];
    }
  }

  // Load offline Conditions bundled in assets
  static Future<List<MedicalConditionModel>> loadOfflineConditions() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/json/conditions_offline.json');
      final List<dynamic> list = json.decode(jsonStr);
      return list.map((item) => MedicalConditionModel.fromJson(item)).toList();
    } catch (e) {
      print("Error loading offline conditions JSON: $e");
      return [];
    }
  }

  // Emergency Contacts Storage
  static Future<List<EmergencyContactModel>> getSavedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsStr = prefs.getString(_contactsKey);
    if (contactsStr != null && contactsStr.isNotEmpty) {
      return EmergencyContactModel.decode(contactsStr);
    }
    return [
      EmergencyContactModel(
        id: '1',
        name: 'National Emergency Services',
        phoneNumber: await getNationalEmergencyNumber(),
        relationship: 'Official Emergency Hotline',
      ),
      EmergencyContactModel(
        id: '2',
        name: 'Ambulance Hotline',
        phoneNumber: '108',
        relationship: 'Medical Emergency',
      ),
    ];
  }

  static Future<void> saveContact(EmergencyContactModel contact) async {
    final contacts = await getSavedContacts();
    contacts.add(contact);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contactsKey, EmergencyContactModel.encode(contacts));
  }

  static Future<void> deleteContact(String id) async {
    final contacts = await getSavedContacts();
    contacts.removeWhere((c) => c.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contactsKey, EmergencyContactModel.encode(contacts));
  }

  // National Emergency Number Configuration (Default: 112 for India/Global)
  static Future<String> getNationalEmergencyNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nationalNumKey) ?? '112';
  }

  static Future<void> setNationalEmergencyNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nationalNumKey, number);
  }
}
