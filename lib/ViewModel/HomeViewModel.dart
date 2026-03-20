import 'package:flutter/material.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/HomeModel.dart';
import 'package:medical_house/View/SectionDetailView.dart';

class HomeViewModel extends ChangeNotifier {
  // User Data with Points
  final PatientProfile currentUser = PatientProfile(
    name: "Ahmed Hassan",
    imageUrl: Constants.MaleAvatarImagePath,
    points: 1250,
  );

  final List<HospitalSection> hospitalSections = [
    HospitalSection(
      mainTitle: "Dermatology & Cosmetology",
      imageUrl: Constants.DermatologySectionImagePath,
      subSections: [
        HospitalService(
          title: "Laser Hair Removal",
          imageUrl: Constants.DermatologyDepartment1ImagePath,
        ),
        HospitalService(
          title: "Bleaching Fine Hair",
          imageUrl: Constants.DermatologyDepartment2ImagePath,
        ),
        HospitalService(
          title: "Deep Cleansing of The Skin",
          imageUrl: Constants.DermatologyDepartment3ImagePath,
        ),
        HospitalService(
          title: "Filler for Lips and Cheeks",
          imageUrl: Constants.DermatologyDepartment4ImagePath,
        ),
        HospitalService(
          title: "Botox for Wrinkle Removal",
          imageUrl: Constants.DermatologyDepartment5ImagePath,
        ),
        HospitalService(
          title: "Face Lift Threads",
          imageUrl: Constants.DermatologyDepartment6ImagePath,
        ),
        HospitalService(
          title: "Skin Rejuvenation Injections",
          imageUrl: Constants.DermatologyDepartment7ImagePath,
        ),
      ],
    ),

    HospitalSection(
      mainTitle: "Dental Department",
      imageUrl: Constants.DentalSectionImagePath,
      subSections: [
        HospitalService(
          title: "Dental Fillings",
          imageUrl: Constants.DentalDepartment8ImagePath,
        ),
        HospitalService(
          title: "Teeth Whitening",
          imageUrl: Constants.DentalDepartment2ImagePath,
        ),
        HospitalService(
          title: "Teeth Cleaning",
          imageUrl: Constants.DentalDepartment1ImagePath,
        ),
        HospitalService(
          title: "Nerve Treatment",
          imageUrl: Constants.DentalDepartment4ImagePath,
        ),
        HospitalService(
          title: "Dental Implants",
          imageUrl: Constants.DentalDepartment6ImagePath,
        ),
        HospitalService(
          title: "Dental Crowns",
          imageUrl: Constants.DentalDepartment9ImagePath,
        ),
        HospitalService(
          title: "Maxillofacial Surgery",
          imageUrl: Constants.DentalDepartment5ImagePath,
        ),
        HospitalService(
          title: "Orthodontics",
          imageUrl: Constants.DentalDepartment3ImagePath,
        ),
        HospitalService(
          title: "Cosmetic Lenses and Crowns",
          imageUrl: Constants.DentalDepartment7ImagePath,
        ),
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
