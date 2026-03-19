import 'package:flutter/material.dart';
import 'package:medical_house/Model/HomeModel.dart';
import 'package:medical_house/View/SectionDetailView.dart';

class HomeViewModel extends ChangeNotifier {
  // User Data with Points
  final PatientProfile currentUser = PatientProfile(
    name: "Ahmed Hassan",
    imageUrl:
        "https://ui-avatars.com/api/?name=Ahmed+Hassan&background=0D1B34&color=fff",
    points: 1250,
  );

  final List<HospitalSection> hospitalSections = [
    HospitalSection(
      mainTitle: "Dermatology & Cosmetology",
      imageUrl:
          "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=800&auto=format&fit=crop",
      subSections: [
        "Laser Hair Removal",
        "Botox & Fillers",
        "Skin Rejuvenation",
        "Acne Treatment",
        "Chemical Peels",
      ],
    ),
    HospitalSection(
      mainTitle: "Dental Department",
      imageUrl:
          "https://images.unsplash.com/photo-1606811841689-23dfddce3e95?q=80&w=800&auto=format&fit=crop",
      subSections: [
        "Hollywood Smile",
        "Teeth Whitening",
        "Orthodontics",
        "Dental Implants",
        "Veneers",
      ],
    ),
  ];

  void openSection(BuildContext context, HospitalSection section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionDetailView(section: section),
      ),
    );
  }
}
