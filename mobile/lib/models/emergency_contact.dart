import 'dart:convert';

class EmergencyContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;

  EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      relationship: json['relationship'] ?? 'Family',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'relationship': relationship,
      };

  static String encode(List<EmergencyContactModel> contacts) => json.encode(
        contacts.map<Map<String, dynamic>>((c) => c.toJson()).toList(),
      );

  static List<EmergencyContactModel> decode(String contactsStr) =>
      (json.decode(contactsStr) as List<dynamic>)
          .map<EmergencyContactModel>((item) => EmergencyContactModel.fromJson(item))
          .toList();
}
