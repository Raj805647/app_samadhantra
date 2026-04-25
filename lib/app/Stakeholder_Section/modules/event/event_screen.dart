import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/event/event_controller.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class EventScreen extends StatelessWidget {
  EventScreen({super.key});
  final controller = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: 'Events',
        isBackButton: true,
      ),
      body: Obx(() {
        if (controller.isEventLoading.value &&
            controller.events.isEmpty &&
            controller.isCategoryLoading.value &&
            controller.categories.isEmpty) {
          return _buildShimmerEffect();
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.fetchEvents(loadMore: true);
            }
            return true;
          },
          child: CustomScrollView(
            slivers: [
              // Categories Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.category, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: ScrollController()
                          ..addListener(() {
                            if (controller.hasMoreCategories.value) {
                              controller.fetchCategories(loadMore: true);
                            }
                          }),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: controller.categories.length + 1, // +1 for "All" button
                        itemBuilder: (context, index) {
                          // "All" Categories Button
                          if (index == 0) {
                            return _buildCategoryChip(
                              title: "All Events",
                              icon: Icons.grid_view_rounded,
                              isSelected: controller.selectedCategoryId.value == null,
                              onTap: () {
                                controller.selectedCategoryId.value = null;
                                controller.fetchEvents(categoryId: '');
                              },
                            );
                          }

                          final cat = controller.categories[index - 1];
                          final isSelected = controller.selectedCategoryId.value == cat.id;

                          return _buildCategoryChip(
                            title: cat.title ?? "",
                            imageUrl: cat.image,
                            isSelected: isSelected,
                            onTap: () {
                              controller.selectedCategoryId.value = cat.id;
                              controller.fetchEvents(categoryId: cat.id);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Events Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Row(
                    children: [
                      Icon(Icons.event_available, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "Upcoming Events",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Events List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final event = controller.events[index];
                    return _buildEventCard(event, context);
                  },
                  childCount: controller.events.length,
                ),
              ),

              // Loading More Indicator
              if (controller.isEventLoading.value && controller.events.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

              // Empty State
              if (controller.events.isEmpty && !controller.isEventLoading.value)
                SliverFillRemaining(
                  child: _buildEmptyState(),
                ),
            ],
          ),
        );
      }),
    );
  }

  // Category Chip Widget
  Widget _buildCategoryChip({
    required String title,
    String? imageUrl,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6B4EFF), Color(0xFF3B82F6)],
          )
              : null,
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF6B4EFF).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        icon ?? Icons.category,
                        size: 30,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                )
              else
                Container(
                  color: Colors.grey.shade100,
                  child: Icon(
                    icon ?? Icons.category,
                    size: 30,
                    color: Colors.grey.shade400,
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Event Card Widget
  Widget _buildEventCard(dynamic event, BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.eventDetailsScreen,
        arguments: event,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with Date Badge
                Stack(
                  children: [
                    Image.network(
                      event.image ?? "",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        );
                      },
                    ),
                    // Date Badge
                    if (event.date != null)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Color(0xFF6B4EFF),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(event.date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B4EFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Color(0xFF6B4EFF),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Upcoming",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B4EFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey,
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
        ),
      ),
    );
  }

  // Shimmer Effect for Loading
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(16),
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          );
        },
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Events Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Check back later for upcoming events",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return "";
    try {
      final d = DateTime.parse(date);
      return "${d.day}/${d.month}/${d.year}";
    } catch (e) {
      return date;
    }
  }
}