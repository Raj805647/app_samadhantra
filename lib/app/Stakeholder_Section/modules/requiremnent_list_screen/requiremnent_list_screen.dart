import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requiremnent_list_screen/requiremnent_list_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/my_requirements_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class RequirementsListScreen extends StatelessWidget {
  RequirementsListScreen({super.key});

  final RequirementsController controller = Get.put(RequirementsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// 📢 Announcement Button
            FloatingActionButton(
              heroTag: "announcement",
              mini: true,
              backgroundColor: Colors.orange,
              onPressed: () {
                Get.toNamed(AppRoutes.activeTargetListScreen);
              },
              child: const Icon(Icons.campaign, color: Colors.white),
            ),

            const SizedBox(height: 10),

            /// ➕ Post Requirement Button (Main)
            FloatingActionButton(
              heroTag: "post",
              backgroundColor: AppColors.appColor,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.postRequirementScreen);
              },
              child: const Icon(
                Iconsax.add,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
        ),
      appBar: CustomAppBar(title: "Requirements", isBackButton: false),
      body: Obx(() {
        if (controller.isLoading.value && controller.requirements.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const SizedBox(height: 10),
            // Filter Chips (optional - uncomment if needed)
            // _buildFilterChips(),

            // Requirements List
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Load more when scrolled to bottom
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      !controller.isLoadingMore.value &&
                      controller.hasMoreData.value) {
                    controller.loadMoreRequirements();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () => controller.fetchRequirements(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: controller.requirements.length +
                        (controller.hasMoreData.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the bottom
                      if (index >= controller.requirements.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: controller.isLoadingMore.value
                                ? const CircularProgressIndicator()
                                : const Text(
                              'load more requirements',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      final requirement = controller.requirements[index];
                      return _buildRequirementItem(requirement);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRequirementItem(MyRequirementData requirement) {
    return GestureDetector(
      onTap: () {
        controller.viewRequirementDetail(requirement.id??"");
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getCategoryColor(requirement.requirementCategory??"")
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getCategoryIcon(requirement.requirementCategory??""),
                  color: _getCategoryColor(requirement.requirementCategory??""),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Main Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Requirement Category
                    Text(
                      requirement.requirementCategory??"",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Problem Description (Truncated)
                    Text(
                      requirement.problemDescription?.isNotEmpty == true
                          ? requirement.problemDescription!
                          : 'No description',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Timeline and Budget
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        // Timeline
                        if (requirement.timeline?.isNotEmpty == true)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.access_time, size: 10, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  requirement.timeline ?? "",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Budget
                        if (requirement.budgetRange?.isNotEmpty == true)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.currency_rupee, size: 10, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  requirement.budgetRange??"",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Status and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(requirement.status??"").withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: _getStatusColor(requirement.status??"").withOpacity(0.3)),
                          ),
                          child: Text(
                            requirement.status?.toUpperCase()??"",
                            style: TextStyle(
                              fontSize: 10,
                              color: _getStatusColor(requirement.status??""),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Created Date
                        Text(
                          _formatDate(requirement.createdAt ?? ""),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onPressed: () => controller.viewRequirementDetail(requirement.id??""),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  Color _getCategoryColor(String category) {
    switch (category) {
      case "Talent, Internship & Hiring":
        return Colors.blue;
      case "Technology & Digital Solutions":
        return Colors.purple;
      case "Investment & Funding":
        return Colors.green;
      case "Education & Skill Development":
        return Colors.orange;
      case "Business & Startup Services":
        return Colors.red;
      case "Government, CSR & Public Programs":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Talent, Internship & Hiring":
        return Icons.group;
      case "Technology & Digital Solutions":
        return Icons.computer;
      case "Investment & Funding":
        return Icons.attach_money;
      case "Education & Skill Development":
        return Icons.school;
      case "Business & Startup Services":
        return Icons.business;
      case "Government, CSR & Public Programs":
        return Icons.account_balance;
      default:
        return Icons.assignment;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "created":
        return Colors.blue;
      case "open":
        return Colors.green;
      case "closed":
        return Colors.grey;
      case "in_progress":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "Today";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays}d ago";
      } else if (difference.inDays < 30) {
        return "${(difference.inDays / 7).floor()}w ago";
      } else {
        return "${(difference.inDays / 30).floor()}mo ago";
      }
    } catch (e) {
      return dateString;
    }
  }
}