class PatientProfile {
  final String name;
  final String imageUrl;
  final int points;

  PatientProfile({
    required this.name,
    required this.imageUrl,
    required this.points,
  });
}

class HospitalSection {
  final String mainTitle;
  final String imageUrl;
  final List<String> subSections;

  HospitalSection({
    required this.mainTitle,
    required this.imageUrl,
    required this.subSections,
  });
}
