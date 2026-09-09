class MedicineModel {
  final String name;
  final String purpose;
  final List<String> commonUses;
  final List<String> importantWarnings;
  final List<String> contraindications;
  final String disclaimer;

  MedicineModel({
    required this.name,
    required this.purpose,
    required this.commonUses,
    required this.importantWarnings,
    required this.contraindications,
    required this.disclaimer,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      name: json['name'] ?? '',
      purpose: json['purpose'] ?? '',
      commonUses: List<String>.from(json['common_uses'] ?? []),
      importantWarnings: List<String>.from(json['important_warnings'] ?? []),
      contraindications: List<String>.from(json['contraindications'] ?? []),
      disclaimer: json['disclaimer'] ?? 'Consult a qualified doctor or pharmacist before taking any medication.',
    );
  }
}
