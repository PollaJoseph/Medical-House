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

class HospitalService {
  final String title;
  final String imageUrl;

  HospitalService({required this.title, required this.imageUrl});
}

class HospitalSection {
  final String mainTitle;
  final String imageUrl;
  final List<HospitalService> subSections;

  HospitalSection({
    required this.mainTitle,
    required this.imageUrl,
    required this.subSections,
  });
}
