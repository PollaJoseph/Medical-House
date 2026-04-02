import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_house/Components/ArticleMagazineCard.dart';
import 'package:medical_house/Components/CategoryChip.dart';
import 'package:medical_house/Constants.dart';
import 'package:medical_house/ViewModel/ArticlesViewModel.dart';
import 'package:provider/provider.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArticlesViewModel()..loadArticles(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Consumer<ArticlesViewModel>(
          builder: (context, model, _) {
            if (model.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Constants.PrimaryColor),
              );
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context),
                _buildCategoryList(model),
                _buildArticleList(model),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100.h,
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC),
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Constants.MidnightNavy,
              size: 18,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Medical Articles",
          style: TextStyle(
            color: Constants.MidnightNavy,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(ArticlesViewModel model) {
    final categories = model.availableCategories;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final categoryName = categories[index];
            return CategoryChip(
              label: categoryName,
              isSelected: model.selectedCategory == categoryName,
              onTap: () => model.setCategory(
                categoryName,
              ), // Passes the exact API string
            );
          },
        ),
      ),
    );
  }

  Widget _buildArticleList(ArticlesViewModel model) {
    if (model.filteredArticles.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 100.h),
          child: Center(
            child: Text(
              "No articles found for this category.",
              style: TextStyle(color: Colors.blueGrey[300], fontSize: 16.sp),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(24.w),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ArticleMagazineCard(
            article: model.filteredArticles[index],
            onTap: () {
              // Navigate to full article content here
            },
          ),
          childCount: model.filteredArticles.length,
        ),
      ),
    );
  }
}
