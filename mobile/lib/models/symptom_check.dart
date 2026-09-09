class PossibleConditionModel {
  final String name;
  final double confidence;
  final String severity;

  PossibleConditionModel({
    required this.name,
    required this.confidence,
    required this.severity,
  });

  factory PossibleConditionModel.fromJson(Map<String, dynamic> json) {
    return PossibleConditionModel(
      name: json['name'] ?? 'Unknown Condition',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      severity: json['severity'] ?? 'Moderate',
    );
  }
}

class SymptomCheckResponseModel {
  final bool isEmergency;
  final String? emergencyWarning;
  final List<PossibleConditionModel> possibleConditions;
  final String severity;
  final List<String> firstAid;
  final List<String> doNot;
  final List<String> warningSigns;
  final String recommendation;
  final String disclaimer;

  SymptomCheckResponseModel({
    required this.isEmergency,
    this.emergencyWarning,
    required this.possibleConditions,
    required this.severity,
    required this.firstAid,
    required this.doNot,
    required this.warningSigns,
    required this.recommendation,
    required this.disclaimer,
  });

  factory SymptomCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return SymptomCheckResponseModel(
      isEmergency: json['is_emergency'] ?? false,
      emergencyWarning: json['emergency_warning'],
      possibleConditions: (json['possible_conditions'] as List? ?? [])
          .map((c) => PossibleConditionModel.fromJson(c))
          .toList(),
      severity: json['severity'] ?? 'Moderate',
      firstAid: List<String>.from(json['first_aid'] ?? []),
      doNot: List<String>.from(json['do_not'] ?? []),
      warningSigns: List<String>.from(json['warning_signs'] ?? []),
      recommendation: json['recommendation'] ?? '',
      disclaimer: json['disclaimer'] ?? 'Informational tool only. Not a medical diagnosis.',
    );
  }
}
