class MedicineInfoModel {
  final String name;
  final String purpose;
  final String warning;

  MedicineInfoModel({
    required this.name,
    required this.purpose,
    required this.warning,
  });

  factory MedicineInfoModel.fromJson(Map<String, dynamic> json) {
    return MedicineInfoModel(
      name: json['name'] ?? '',
      purpose: json['purpose'] ?? '',
      warning: json['warning'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'purpose': purpose,
        'warning': warning,
      };
}

class MedicalConditionModel {
  final String name;
  final List<String> symptoms;
  final String severity;
  final List<String> firstAid;
  final List<String> doNot;
  final List<String> warningSigns;
  final List<MedicineInfoModel> medicineInformation;

  MedicalConditionModel({
    required this.name,
    required this.symptoms,
    required this.severity,
    required this.firstAid,
    required this.doNot,
    required this.warningSigns,
    required this.medicineInformation,
  });

  factory MedicalConditionModel.fromJson(Map<String, dynamic> json) {
    return MedicalConditionModel(
      name: json['name'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      severity: json['severity'] ?? 'Moderate',
      firstAid: List<String>.from(json['first_aid'] ?? []),
      doNot: List<String>.from(json['do_not'] ?? []),
      warningSigns: List<String>.from(json['warning_signs'] ?? []),
      medicineInformation: (json['medicine_information'] as List? ?? [])
          .map((m) => MedicineInfoModel.fromJson(m))
          .toList(),
    );
  }
}
