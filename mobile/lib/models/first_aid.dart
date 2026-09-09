class FirstAidGuideModel {
  final String category;
  final String title;
  final String whatHappened;
  final List<String> immediateFirstAid;
  final List<String> doList;
  final List<String> dontList;
  final List<String> whenToSeekHelp;
  final String icon;

  FirstAidGuideModel({
    required this.category,
    required this.title,
    required this.whatHappened,
    required this.immediateFirstAid,
    required this.doList,
    required this.dontList,
    required this.whenToSeekHelp,
    required this.icon,
  });

  factory FirstAidGuideModel.fromJson(Map<String, dynamic> json) {
    return FirstAidGuideModel(
      category: json['category'] ?? 'General',
      title: json['title'] ?? '',
      whatHappened: json['what_happened'] ?? '',
      immediateFirstAid: List<String>.from(json['immediate_first_aid'] ?? []),
      doList: List<String>.from(json['do_list'] ?? []),
      dontList: List<String>.from(json['dont_list'] ?? []),
      whenToSeekHelp: List<String>.from(json['when_to_seek_help'] ?? []),
      icon: json['icon'] ?? 'medical_services',
    );
  }
}
