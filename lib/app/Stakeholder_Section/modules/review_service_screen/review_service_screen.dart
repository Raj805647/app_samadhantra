// screens/review_service_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/review_service_screen/review_service_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';

class ReviewServiceScreen extends StatelessWidget {
  ReviewServiceScreen({super.key});

  final ReviewServiceController controller = Get.put(ReviewServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Review Service",
        isBackButton: true,
      ),
      body: Obx(() {
        if (controller.isSubmitting.value) {
          return _buildSubmittingState();
        }

        return _buildForm();
      }),
    );
  }

  Widget _buildSubmittingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Submitting Review...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we save your feedback',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Assignment Info
            _buildAssignmentInfo(),

            const SizedBox(height: 24),

            // Rating Section
            _buildRatingSection(),

            const SizedBox(height: 24),

            // Review Comment
            _buildCommentSection(),

            const SizedBox(height: 24),

            // Tags Selection
            _buildTagsSection(),

            const SizedBox(height: 24),

            // Recommendation
            _buildRecommendationSection(),

            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.appColor.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.assignment_turned_in,
              color: AppColors.appColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.assignmentTitle.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      controller.providerName.value,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Service Completed',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you rate this service? *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),

        // Star Rating
        Center(
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: () => controller.setRating(starIndex.toDouble()),
                child: Icon(
                  starIndex <= controller.selectedRating.value
                      ? Icons.star
                      : Icons.star_border,
                  size: 48,
                  color: starIndex <= controller.selectedRating.value
                      ? Colors.amber
                      : Colors.grey[300],
                ),
              );
            }),
          )),
        ),

        const SizedBox(height: 12),

        // Rating Description
        Obx(() {
          if (controller.selectedRating.value > 0) {
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.ratingDescriptionColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: controller.ratingDescriptionColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  controller.ratingDescription.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: controller.ratingDescriptionColor,
                  ),
                ),
              ),
            );
          }
          return Center(
            child: Text(
              'Tap stars to rate',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Write your review *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share details of your experience with this service',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller.commentController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'What did you like or dislike? What could be improved?\n\nBe specific and helpful to other users...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${controller.commentController.text.length} characters',
              style: TextStyle(
                fontSize: 12,
                color: controller.commentController.text.length < 10
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select tags (optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose up to 3 tags that describe your experience',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.availableTags.map((tag) {
            final isSelected = controller.selectedTags.contains(tag);
            return _buildTagChip(tag, isSelected);
          }).toList(),
        ),

        const SizedBox(height: 8),

        Obx(() => Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              '${controller.selectedTags.length}/3 tags selected',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildTagChip(String tag, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.toggleTag(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.appColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Would you recommend this provider?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRecommendationOption(
                icon: Icons.thumb_up,
                label: 'Yes',
                isSelected: controller.wouldRecommend.value,
                onTap: () => controller.wouldRecommend.value = true,
                color: Colors.green,
              ),
              _buildRecommendationOption(
                icon: Icons.thumb_down,
                label: 'No',
                isSelected: !controller.wouldRecommend.value,
                onTap: () => controller.wouldRecommend.value = false,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? color : Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.selectedRating.value > 0 ||
            controller.commentController.text.length >= 10
            ? controller.submitReview
            : null,
        icon: const Icon(Icons.send, size: 20),
        label: const Text(
          'Submit Review',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.selectedRating.value > 0 &&
              controller.commentController.text.length >= 10
              ? AppColors.appColor
              : Colors.grey[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    ));
  }

  void _showClearConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Discard Review?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard your review?',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}