import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Model/HomeModel.dart';

class SectionDetailView extends StatelessWidget {
  final HospitalSection section;

  const SectionDetailView({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color midnightNavy = Color(0xFF0D1B34);
    const Color surgicalTeal = Color(0xFF0CACBB);
    const Color backgroundGrey = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundGrey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. The Expanding Image Header
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: midnightNavy,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                section.mainTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18.sp,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(section.imageUrl, fit: BoxFit.cover),
                  Container(
                    color: midnightNavy.withOpacity(0.4),
                  ), // Darken for text
                ],
              ),
            ),
          ),

          // 2. The List of Subsections
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final subName = section.subSections[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    title: Text(
                      subName,
                      style: TextStyle(
                        color: midnightNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: surgicalTeal,
                      size: 16.sp,
                    ),
                    onTap: () {
                      debugPrint("Tapped on $subName");
                    },
                  ),
                );
              }, childCount: section.subSections.length),
            ),
          ),
        ],
      ),
    );
  }
}
