import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/faq_response.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'faq_controller.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  final controller = Get.find<FaqController>();
  final theme = Theme.of(Get.context!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'FAQ', isBackButton: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomProgressIndicator());
        }
        if (controller.faqListData.isEmpty) {
          return const Center(child: Text("No FAQs found"));
        }

        return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
                  !controller.isLoadingMore.value &&
                  controller.hasMoreData.value) {
                controller.loadMoreData();
              }
              return false;
            },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.faqListData.length +
                      (controller.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= controller.faqListData.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: controller.isLoadingMore.value
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                        ),
                      );
                    }
                    final item = controller.faqListData[index];
                    return _buildAnimatedFaqCard(item, index);
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onTap: ()=> Get.toNamed(AppRoutes.faqChatBoxScreen),
          decoration: InputDecoration(
            hintText: 'Search for answers...',
            prefixIcon: Icon(Icons.search, color: theme.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFaqCard(FAQData item, int index) {
    final theme = Theme.of(Get.context!);

    return Obx(() {
      final isExpanded = controller.expandedIndex.value == index;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isExpanded ? 8 : 4,
        ),
        child: Material(
          elevation: isExpanded ? 8 : 2,
          shadowColor: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.cardColor,
            ),
            child: Column(
              children: [
                // Question Header
                InkWell(
                  onTap: () {
                    controller.expandedIndex.value = isExpanded ? -1 : index;
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.primaryColor.withOpacity(0.2),
                                theme.primaryColor.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.help_outline,
                            color: theme.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Question Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.question ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.titleMedium?.color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  if (item.category != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.primaryColor.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item.category!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  if (item.keywords != null)
                                    ...item.keywords!
                                        .take(2)
                                        .map(
                                          (k) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              k,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                  if ((item.keywords?.length ?? 0) > 2)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '+${item.keywords!.length - 2}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Expand Icon
                        AnimatedRotation(
                          duration: const Duration(milliseconds: 300),
                          turns: isExpanded ? 0.5 : 0.0,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.primaryColor,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Answer Section
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 18,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Answer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.answer ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),

                        // Helpful Buttons
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Was this helpful?',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildHelpfulButton(
                              icon: Icons.thumb_up_outlined,
                              label: 'Yes',
                              isSelected: controller.isHelpFull[index] == true,
                              onTap: () => controller.markHelpful(index, true),
                            ),

                            const SizedBox(width: 8),

                            _buildHelpfulButton(
                              icon: Icons.thumb_down_outlined,
                              label: 'No',
                              isSelected: controller.isHelpFull[index] == false,
                              onTap: () => controller.markHelpful(index, false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHelpfulButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    final Color activeColor = label == 'Yes' ? Colors.green : Colors.red;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? activeColor : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? activeColor : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }}
