import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_opportunities_screen/service_provider_opportunities_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderOpportunitiesScreen extends StatelessWidget {

  final ServiceProviderOpportunitiesController controller =
  Get.put(ServiceProviderOpportunitiesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Browse Opportunities",isBackButton: false,),
      body: Column(
        children: [
          // Search Bar
          // Padding(
          //   padding: EdgeInsets.all(16),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Search opportunities...',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     onChanged: (value) => controller.searchQuery.value = value,
          //   ),
          // ),
SizedBox(height: 10,),
          // Categories Filter
          Obx(() {
            return SizedBox(
              height: 50,
              child: ListView.builder(
                key: ValueKey(controller.selectedCategory.value), // This forces rebuild
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: controller.selectedCategory.value == category,
                      onSelected: (selected) {
                        controller.selectedCategory.value = category;
                      },
                    ),
                  );
                },
              ),
            );
          }),

          // Requirements List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final filteredRequirements = controller.filteredRequirements;

              if (filteredRequirements.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No opportunities found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredRequirements.length,
                itemBuilder: (context, index) {
                  final requirement = filteredRequirements[index];
                  return _buildRequirementCard(requirement, index);
                },
              );
            }),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Get.toNamed('/service-provider/advanced-search'),
      //   icon: Icon(Icons.tune),
      //   label: Text('Advanced Search'),
      // ),
    );
  }

  Widget _buildRequirementCard(Map<String, dynamic> requirement, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE + BOOKMARK
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    requirement['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  splashRadius: 22,
                  icon: Icon(
                    requirement['isBookmarked'] == true
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: requirement['isBookmarked'] == true
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onPressed: () => controller.toggleBookmark(index),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 🔹 DESCRIPTION
            Text(
              requirement['description'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            /// 🔹 DETAILS
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  icon: Icons.currency_rupee,
                  text: requirement['budget'] ?? '',
                ),
                _buildInfoChip(
                  icon: Icons.calendar_today,
                  text: requirement['deadline'] ?? '',
                ),
                _buildInfoChip(
                  icon: Icons.category,
                  text: requirement['category'] ?? '',
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔹 POSTED BY + PROPOSALS
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Posted by ${requirement['postedBy'] ?? ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${requirement['proposalCount'] ?? 0} proposals',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 ACTION BUTTONS
            Row(
              children: [

                Expanded(child: AppButton(title: "View Details",onPressed: (){
                  Get.toNamed(AppRoutes.serviceProviderRequirementDetails,arguments: requirement['id']);
                },)),
                const SizedBox(width: 12),

                Expanded(child: AppButton(title: "Submit Proposal",onPressed: (){
                  Get.toNamed(AppRoutes.serviceProviderSubmitProposal);
                },)),

                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildDetailChip({required IconData icon, required String text}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      backgroundColor: Colors.grey[100],
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Filter Opportunities'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add filter options here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.loadRequirements();
            },
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}