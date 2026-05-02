import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_circularprogress_indicator.dart';
import '../../../constant/custom_appbar.dart';
import '../../../data/model/announcements_acitve_list_response.dart';
import 'active_target_list_controller.dart';

class ActiveTargetListScreen extends StatelessWidget {
  ActiveTargetListScreen({super.key});

  final controller = Get.put(ActiveTargetListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Target List',
        isBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CustomProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getActiveTargetList();
          },

          child: controller.recentRequirements.isEmpty
              ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: _emptyState()),
              ),
            ],
          )
              : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount:
            controller.recentRequirements.length,
            itemBuilder: (context, index) {
              final requirement =
              controller.recentRequirements[index];

              return _buildTargetCard(requirement);
            },
          ),
        );
      }),
    );
  }  Widget _buildTargetCard(AnnouncementData requirement) {
    print('asdkjbfkjbsdajhbfhvsdhb');
    print(controller.recentRequirements.value);
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/requirementDetails',
        arguments: requirement.requirementId,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              /// Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                ),
              ),

              /// Main content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 TITLE + STATUS + ICON
                    Row(
                      children: [
                        /// Category icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: statusColor(
                              requirement.isActive ?? false,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getCategoryIcon(requirement.requirementCategory  ?? ''),
                            size: 18,
                            color: statusColor(requirement.isActive ?? false),
                          ),
                        ),

                        /// Title
                        Expanded(
                          child: Text(
                            requirement.requirementCategory ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        /// Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor(
                              requirement.isActive ?? false,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusColor(
                                requirement.isActive ?? false,
                              ).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: statusColor(requirement.isActive ?? false),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                requirement.isActive! ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor(requirement.isActive ?? false),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    /// 🔹 DESCRIPTION with icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            requirement.problemDescription ??
                                "No description provided",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    /// 🔹 FOOTER INFO with better visual hierarchy
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          /// Location
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              (requirement.preferredLocation != null && requirement.preferredLocation!.isEmpty)
                                  ? 'Bhopal'
                                  : requirement.preferredLocation ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Optional: Decorative corner accent
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        statusColor(requirement.isActive ?? false).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No targets available',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'painting':
        return Icons.format_paint;
      case 'carpentry':
        return Icons.handyman;
      case 'moving':
        return Icons.local_shipping;
      default:
        return Icons.category_outlined;
    }
  }

  Color statusColor(bool isActive) {
    return isActive ? Colors.green : Colors.grey;
  }
}
