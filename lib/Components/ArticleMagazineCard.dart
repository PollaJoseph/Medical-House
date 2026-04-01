import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/Model/ArticleModel.dart';

class ArticleMagazineCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const ArticleMagazineCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              child: article.articleImage != null
                  ? Image.network(
                      article.articleImage!,
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180.h,
                      width: double.infinity,
                      color: Colors.blueGrey.shade50,
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.blueGrey.shade200,
                        size: 40.sp,
                      ),
                    ),
            ),

            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.category.toUpperCase(),
                    style: TextStyle(
                      color: Constants.PrimaryColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    article.name,
                    style: GoogleFonts.lexend(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Constants.MidnightNavy,
                    ),
                  ),

                  if (article.shortDescription != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      article.shortDescription!,
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontSize: 13.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundImage: NetworkImage(article.authorImage),
                        backgroundColor: Colors.blueGrey.shade50,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        article.authorUsername,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Constants.MidnightNavy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        article.createdAt.split('T')[0],
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.blueGrey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
