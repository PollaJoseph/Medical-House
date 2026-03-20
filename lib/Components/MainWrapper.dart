import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Components/CustomNavigationBar.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/View/ArticleView.dart';
import 'package:medical_house/View/HomeView.dart';
import 'package:medical_house/View/OffersView.dart';
import 'package:medical_house/View/SettingsView.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  var _selectedTab = _SelectedTab.home;

  final List<Widget> _pages = [
    const HomeView(),
    const OffersView(),
    const ArticleView(),
    const SettingsView(),
  ];

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _pages[_SelectedTab.values.indexOf(_selectedTab)],

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
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
