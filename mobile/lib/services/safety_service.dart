class ClientSafetyService {
  static const Map<String, List<String>> _criticalKeywords = {
    'Chest Pain': ['chest pain', 'heart attack', 'pain in chest', 'cardiac', 'arm pain'],
    'Breathing Difficulty': ['difficulty breathing', 'shortness of breath', 'gasping', 'cannot breathe', 'suffocating'],
    'Unconsciousness': ['unconscious', 'fainted', 'passed out', 'collapsed', 'unresponsive'],
    'Severe Bleeding': ['severe bleeding', 'blood spurting', 'heavy blood loss', 'gushing blood'],
    'Choking': ['choking', 'food stuck in throat', 'blocked airway', 'cannot swallow'],
    'Stroke': ['stroke', 'face drooping', 'arm weakness', 'slurred speech'],
    'Anaphylaxis': ['severe allergy', 'swollen throat', 'epipen', 'anaphylaxis'],
  };

  static bool checkEmergency(String text, List<String> selectedChips) {
    final combined = (text + " " + selectedChips.join(" ")).toLowerCase();
    for (var category in _criticalKeywords.values) {
      for (var kw in category) {
        if (combined.contains(kw)) {
          return true;
        }
      }
    }
    return false;
  }
}
