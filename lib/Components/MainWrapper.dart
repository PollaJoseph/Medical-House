import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Components/CustomNavigationBar.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/View/ArticleView.dart';
import 'package:medical_house/View/HomeView.dart';
import 'package:medical_house/View/OffersView.dart';
import 'package:medical_house/View/SettingsView.dart';

class MainWrapper extends StatefulWidget {
  final String? Username;
  final String? UserImage;
  final int? Points;
  const MainWrapper({super.key, this.Username, this.UserImage, this.Points});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  var _selectedTab = _SelectedTab.home;

  List<Widget> _getPages() {
    return [
      HomeView(
        Username: widget.Username,
        UserImage: widget.UserImage,
        Points: widget.Points,
      ),
      const OffersView(),
      const ArticleView(),
      const SettingsView(),
    ];
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Generate the pages list during build to ensure data is current
    final pages = _getPages();

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Use the dynamic pages list
          pages[_SelectedTab.values.indexOf(_selectedTab)],

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h, left: 26.w, right: 26.w),
              child: CustomNavigationBar(
                currentIndex: _SelectedTab.values.indexOf(_selectedTab),
                onTap: _handleIndexChanged,
                items: [
                  CustomNavItem(
                    selectedImage: Constants.HomeIconPath,
                    unselectedImage: Constants.HomeIconPath,
                  ),
                  CustomNavItem(
                    selectedImage: Constants.OfferIconPath,
                    unselectedImage: Constants.OfferIconPath,
                  ),
                  CustomNavItem(
                    selectedImage: Constants.ArticleIconPath,
                    unselectedImage: Constants.ArticleIconPath,
                  ),
                  CustomNavItem(
                    selectedImage: Constants.ProfileIconPath,
                    unselectedImage: Constants.ProfileIconPath,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab { home, chat, search, profile }
