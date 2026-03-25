import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsViewModel extends ChangeNotifier {
  final String clinicNumber = "+966 9200 14897";

  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: clinicNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint('Could not launch dialer: $e');
    }
  }

  Future<void> launchWhatsApp() async {
    final String cleanNumber = clinicNumber.replaceAll(RegExp(r'[^\d]'), '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber");

    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch WhatsApp: $e');
    }
  }

  Future<void> openMap() async {
    final String query = Uri.encodeComponent(
      "Medical House Hospital Saudi Arabia",
    );
    final Uri mapUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$query",
    );

    try {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch map: $e');
    }
  }
}
