// screens/provider_ratings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/provider_rating_screen/provider_rating_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/data/model/stake_review_model.dart';

class ProviderRatingsScreen extends StatelessWidget {
  ProviderRatingsScreen({super.key});

  final ProviderRatingsController controller = Get.put(ProviderRatingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Provider Ratings",
        isBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshProviders,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        return _buildContent();
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading provider ratings...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Search and Filters
        _buildFilterSection(),

        // Rating Filter
        _buildRatingFilter(),

        // Providers List
        Expanded(
          child: _buildProvidersList(),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search providers by name or category...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const SizedBox(height: 16),

          // Category Filter Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: controller.categories.map((category) {
                final isSelected = controller.selectedCategory.value == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category != 'all')
                          Icon(
                            controller.categoryIcons[category],
                            size: 16,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                        if (category != 'all') const SizedBox(width: 4),
                        Text(
                          controller.categoryLabels[category] ?? category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    backgroundColor: Colors.grey[100],
                    selectedColor: AppColors.appColor,
                    onSelected: (_) => controller.setCategory(category),
                    checkmarkColor: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minimum Rating: ${controller.minRating.value.toStringAsFixed(1)}+',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Slider(
            value: controller.minRating.value,
            min: 0.0,
            max: 5.0,
            divisions: 10,
            label: '${controller.minRating.value.toStringAsFixed(1)}+',
            activeColor: AppColors.appColor,
            inactiveColor: Colors.grey[200],
            onChanged: controller.setMinRating,
          )),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text('2.5', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text('5.0', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersList() {
    return Obx(() {
      if (controller.filteredProviders.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.refreshProviders();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredProviders.length,
          itemBuilder: (context, index) {
            final provider = controller.filteredProviders[index];
            return _buildProviderCard(provider);
          },
        ),
      );
    });
  }

  Widget _buildProviderCard(ProviderRating provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: InkWell(
        onTap: () => controller.viewProviderDetails(provider),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.appColor.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        provider.providerName.isNotEmpty ? provider.providerName[0] : '?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.providerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                provider.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: provider.isFavorite ? Colors.red : Colors.grey[400],
                                size: 20,
                              ),
                              onPressed: () => controller.toggleFavorite(provider.providerId),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              controller.categoryIcons[provider.providerCategory] ?? Icons.business,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.categoryLabels[provider.providerCategory] ?? provider.providerCategory,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              provider.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Rating and Stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Average Rating
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, size: 20, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              provider.formattedRating,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${provider.totalReviews} reviews',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Stats
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons.work,
                                  value: provider.completedProjects.toString(),
                                  label: 'Projects',
                                ),
                              ),
                              Expanded(
                                child: _buildStatItem(
                                  icon: Icons.schedule,
                                  value: provider.experience,
                                  label: 'Experience',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Rating Distribution
                          _buildRatingDistribution(provider),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // About
              Text(
                'About',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider.about,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Recent Reviews Preview
              if (provider.recentReviews.isNotEmpty) ...[
                Text(
                  'Recent Reviews',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                ...provider.recentReviews.take(2).map((review) => _buildReviewPreview(review)),
                if (provider.recentReviews.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton(
                      onPressed: () => controller.viewProviderDetails(provider),
                      child: Text('View all ${provider.recentReviews.length} reviews'),
                    ),
                  ),
              ],

              const SizedBox(height: 8),

              // View Details Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.viewProviderDetails(provider),
                  icon: const Icon(Icons.remove_red_eye, size: 16),
                  label: const Text('View Details & Reviews'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.appColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingDistribution(ProviderRating provider) {
    return Column(
      children: List.generate(5, (index) {
        final starCount = 5 - index;
        final count = provider.ratingDistribution[starCount] ?? 0;
        final percentage = provider.totalReviews > 0
            ? (count / provider.totalReviews) * 100
            : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            children: [
              Text(
                '$starCount',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.star, size: 10, color: Colors.amber),
              const SizedBox(width: 4),
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    starCount >= 4 ? Colors.green :
                    starCount >= 3 ? Colors.orange :
                    Colors.red,
                  ),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewPreview(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                review.timeAgo,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review.assignmentTitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No Providers Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              controller.selectedCategory.value != 'all' || controller.minRating.value > 0
                  ? 'No providers match your current filters'
                  : 'No provider ratings available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.setCategory('all');
              controller.setMinRating(0.0);
              controller.setSearchQuery('');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}