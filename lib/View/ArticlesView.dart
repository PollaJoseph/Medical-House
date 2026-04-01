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
                _buildSliverAppBar(),
                _buildCategoryList(model),
                _buildArticleList(model),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 100.h,
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC),
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
    final categories = [
      "All",
      "Dental",
      "Dermatology &\n Cosmetology",
      "General",
    ];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          itemCount: categories.length,
          itemBuilder: (context, index) => CategoryChip(
            label: categories[index],
            isSelected: model.selectedCategory == categories[index],
            onTap: () => model.setCategory(categories[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleList(ArticlesViewModel model) {
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
