import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/blog/blog_controller.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/blog/blog_details_screen.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

import '../../../constant/helper_widget.dart';
import '../../../data/model/blog_response.dart';

class BlogScreen extends StatelessWidget {
  BlogScreen({super.key});
  final controller = Get.find<BlogController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      appBar: CustomAppBar(title: 'Discover', isBackButton: true),
      body: Obx(() {
        if(controller.isLoading.value && controller.blogListData.isEmpty){
          return Center(child: CustomProgressIndicator(),);
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isLoadingMore.value &&
                controller.hasMoreData.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              controller.loadMoreData();
            }
            return false;
          },
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10),
            itemCount:
            controller.blogListData.length +
                (controller.hasMoreData.value
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index == controller.blogListData.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CustomProgressIndicator()),
                );
              }
              final blog = controller.blogListData[index];
              return _buildBlogCard(context, blog: blog);
            },
          ),
        );
      }),
    );
  }

  Widget _buildBlogCard(BuildContext context, {required BlogListData blog}) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.blogDetailsScreen,arguments: blog),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: blog.image != null
                    ? Image.network(
                        blog.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.article,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            // Right side - Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      blog.title ?? "Untitled",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Subtitle/Description
                    Text(
                      blog.subTitle ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Meta information row
                    Row(
                      children: [
                        // Author
                        if (blog.metaAuthor != null) ...[
                          const Icon(
                            Icons.person_outline,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              blog.metaAuthor!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Date
                        if (blog.createdAt != null) ...[
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatDate(blog.createdAt!),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],

                        const Spacer(),

                        // Read more indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Read",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 8,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
