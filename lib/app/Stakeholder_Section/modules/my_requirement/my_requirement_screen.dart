import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/my_requirement/my_requirement_controller.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';

import '../../../constant/app_color.dart';
import '../../../constant/custom_appbar.dart';
import '../../../data/model/stake_holder_model/my_requirements_model.dart';
import '../../../global_routes/app_routes.dart';

class MyRequirementScreen extends StatelessWidget {
  MyRequirementScreen({super.key});

  final controller = Get.put(MyRequirementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Requirements", isBackButton: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.requirements.isEmpty) {
          return const Center(child: CustomProgressIndicator());
        }

        if (controller.requirements.isEmpty) {
          return const Center(child: Text("Not Post Available"));
        }


        return RefreshIndicator(
          onRefresh: () => controller.fetchRequirements(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.requirements.length,
            itemBuilder: (context, index) {
              final requirement = controller.requirements[index];
              return _buildRequirementItem(requirement);
            },
          ),
        );
      }),
    );
  }

  Widget _buildRequirementItem(MyRequirementData requirement) {
    final categoryColor =
    _getCategoryColor(requirement.requirementCategory ?? "");
    final statusColor = _getStatusColor(requirement.status ?? "");

    return InkWell(
      onTap: ()=> Get.toNamed(AppRoutes.myRequirementsDetails, arguments: requirement),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            /// Header
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(requirement.requirementCategory ?? ""),
                    color: categoryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
      
                /// Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requirement.requirementCategory ?? "Uncategorized",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(requirement.createdAt ?? ""),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
      
                /// Status
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    requirement.status?.toUpperCase() ?? "",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                )
              ],
            ),
      
            const SizedBox(height: 8),
      
            /// Problem Description
            if (requirement.problemDescription?.isNotEmpty == true)
              Text(
                requirement.problemDescription!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
      
            const SizedBox(height: 10),
      
            /// Info Row
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                if (requirement.preferredLocation != null)
                  _miniInfo(Icons.location_on,
                      requirement.preferredLocation!, Colors.blue),
      
                if (requirement.timeline?.isNotEmpty == true)
                  _miniInfo(
                      Icons.calendar_today, requirement.timeline!, Colors.orange),
      
                if (requirement.budgetRange?.isNotEmpty == true)
                  _miniInfo(Icons.currency_rupee,
                      requirement.budgetRange!, Colors.green),
              ],
            ),
      
            const SizedBox(height: 12),
      
            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
      
                /// Update
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.postRequirementScreen,
                      arguments: requirement,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16, color: AppColors.appColor),
                      const SizedBox(width: 4),
                      Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.appColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
      
                const SizedBox(width: 18),
      
                /// Delete
                InkWell(
                  onTap: () =>
                      _showDeleteConfirmation(Get.context!, requirement),
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 16, color: Colors.red[700]),
                      const SizedBox(width: 4),
                      Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

// Helper method for info chips
  Widget _miniInfo(
     IconData icon,
     String label,
     Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  void _showDeleteConfirmation(BuildContext context, MyRequirementData requirement) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red[700],
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Delete Requirement",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to delete this requirement? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Call delete method from controller
                        controller.deleteRequirement(requirement.id ?? '');
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods remain the same
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
