import 'package:medical_house/Model/ServiceModel.dart'; // MUST IMPORT THIS

class PatientProfile {
  final String name;
  final String imageUrl;
  final String points;

  PatientProfile({
    required this.name,
    required this.imageUrl,
    required this.points,
  });
}

// ⚠️ DELETE THE ENTIRE HospitalService CLASS ⚠️

class HospitalSection {
  final String mainTitle;
  final String imageUrl;
  final List<ServiceModel> subSections;

  HospitalSection({
    required this.mainTitle,
    required this.imageUrl,
    required this.subSections,
  });
}

class HealthArticle {
  final String title;
  final String author;
  final String imageUrl;
  final String readTime;
  final String category;

  HealthArticle({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.readTime,
    required this.category,
  });
}
