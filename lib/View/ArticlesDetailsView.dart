import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/ViewModel/ArticleDetailsViewModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';

class ArticlesDetailsView extends StatelessWidget {
  final String articleId;

  const ArticlesDetailsView({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArticleDetailsViewModel()..loadArticleDetails(articleId),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ArticleDetailsViewModel>(
          builder: (context, model, _) {
            if (model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Constants.PrimaryColor),
              );
            }

            if (model.errorMessage != null || model.article == null) {
              return Center(
                child: Text(
                  model.errorMessage ?? "Failed to load article.".tr,
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final article = model.article!;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildModernAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        // 1. Premium Category Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.PrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Text(
                            article.category.toUpperCase(),
                            style: GoogleFonts.lexend(
                              color: Constants.PrimaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 11.sp,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // 2. Editorial Title
                        Text(
                          article.name,
                          style: GoogleFonts.lexend(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w900,
                            color: Constants.MidnightNavy,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.blueGrey.shade50,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  color: Colors.blueGrey.shade300,
                                  size: 26.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.authorUsername,
                                      style: GoogleFonts.lexend(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Constants.MidnightNavy,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      _formatDate(article.createdAt),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.blueGrey[400],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showModernShareSheet(
                                  context,
                                  article,
                                ), // UPDATED
                                child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.ios_share_rounded,
                                    color: Constants.MidnightNavy,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 36.h),

                        SelectionArea(
                          child: HtmlWidget(
                            article.content,
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xFF334155),
                              height: 1.85,
                              fontWeight: FontWeight.w400,
                            ),
                            customStylesBuilder: (element) {
                              if (element.localName == 'h1') {
                                return {
                                  'font-family': 'Lexend',
                                  'font-weight': '900',
                                  'font-size': '26px',
                                  'color': '#0A1325',
                                  'margin-top': '36px',
                                  'margin-bottom': '16px',
                                  'line-height': '1.3',
                                  'letter-spacing': '-0.5px',
                                };
                              }
                              if (element.localName == 'h2') {
                                return {
                                  'font-family': 'Lexend',
                                  'font-weight': '800',
                                  'font-size': '22px',
                                  'color': '#0A1325',
                                  'margin-top': '32px',
                                  'margin-bottom': '12px',
                                  'letter-spacing': '-0.3px',
                                };
                              }
                              if (element.localName == 'h3') {
                                return {
                                  'font-family': 'Lexend',
                                  'font-weight': '700',
                                  'font-size': '18px',
                                  'color': '#0CACBB',
                                  'margin-top': '24px',
                                  'margin-bottom': '10px',
                                };
                              }
                              if (element.localName == 'p') {
                                return {'margin-bottom': '20px'};
                              }
                              if (element.localName == 'strong' ||
                                  element.localName == 'b') {
                                return {
                                  'font-weight': '700',
                                  'color': '#0A1325',
                                };
                              }
                              if (element.localName == 'blockquote') {
                                return {
                                  'border-left': '4px solid #0CACBB',
                                  'background-color': '#F0FDF4',
                                  'padding': '16px 20px',
                                  'margin': '28px 0',
                                  'border-radius': '0 12px 12px 0',
                                  'font-style': 'italic',
                                  'color': '#0A1325',
                                  'font-weight': '500',
                                  'font-size': '17px',
                                };
                              }
                              if (element.localName == 'a') {
                                return {
                                  'color': '#0CACBB',
                                  'text-decoration': 'none',
                                  'font-weight': '600',
                                  'border-bottom': '1px dotted #0CACBB',
                                };
                              }
                              if (element.localName == 'ul' ||
                                  element.localName == 'ol') {
                                return {
                                  'padding-left': '24px',
                                  'margin-bottom': '20px',
                                };
                              }
                              if (element.localName == 'li') {
                                return {
                                  'margin-bottom': '10px',
                                  'color': '#334155',
                                };
                              }
                              if (element.localName == 'img') {
                                return {
                                  'max-width': '100%',
                                  'height': 'auto',
                                  'border-radius': '16px',
                                  'margin-top': '16px',
                                  'margin-bottom': '8px',
                                  'display': 'block',
                                };
                              }
                              if (element.localName == 'figure') {
                                return {'margin': '32px 0'};
                              }
                              if (element.localName == 'figcaption') {
                                return {
                                  'text-align': 'center',
                                  'font-size': '13px',
                                  'color': '#94A3B8',
                                  'font-style': 'italic',
                                  'margin-top': '8px',
                                };
                              }
                              if (element.localName == 'hr') {
                                return {
                                  'border': 'none',
                                  'border-top': '1px solid #E2E8F0',
                                  'margin': '32px 0',
                                };
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80.h,
      pinned: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      stretch: true,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueGrey.shade50),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Constants.MidnightNavy,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      DateTime dt = DateTime.parse(isoDate);
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${months[dt.month - 1]} ${dt.day}, ${dt.year}";
    } catch (e) {
      return isoDate;
    }
  }

  void _showModernShareSheet(BuildContext context, dynamic article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              Text(
                "Share Article".tr,
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: Constants.MidnightNavy,
                ),
              ),
              SizedBox(height: 20.h),

              // Article Preview Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.blueGrey.shade50),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        color: Constants.PrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.article_rounded,
                        color: Constants.PrimaryColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.name,
                            style: GoogleFonts.lexend(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Constants.MidnightNavy,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "${"By".tr} ${article.authorUsername}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.blueGrey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.PrimaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Share Now".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet

                        final String shareText =
                            '''
🩺 *${article.name}*

💡 Category: ${article.category}
✍️ By: ${article.authorUsername}

Read this full medical article and discover more health insights on the Medical House App! 🚀
''';
                        Share.share(shareText, subject: article.name);
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // 2. Copy Link Button
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF8FAFC),
                        foregroundColor: Constants.MidnightNavy,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(color: Colors.blueGrey.shade100),
                        ),
                      ),
                      icon: const Icon(Icons.copy_rounded),
                      label: Text(
                        "Copy Title".tr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: article.name));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Article title copied to clipboard!".tr,
                            ),
                            backgroundColor: Constants.MidnightNavy,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h), // Bottom padding
            ],
          ),
        );
      },
    );
  }
}
