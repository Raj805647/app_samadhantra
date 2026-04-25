import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/blog/blog_controller.dart';

import '../../../constant/custom_appbar.dart';
import '../../../data/model/blog_comment_response.dart';
import '../../../data/model/blog_response.dart';

class BlogDetailsScreen extends StatelessWidget {
  BlogDetailsScreen({super.key});

  final controller = Get.find<BlogController>();
  BlogListData blog = Get.arguments;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Hero Image with Gradient Overlay
          _buildHeroImage(),

          // Draggable Content Sheet
          _buildDraggableContent(context),

          // Back Button
          _buildBackButton(),
        ],
      ),
      bottomSheet:           _buildBottomActionBar(context, blog.id!),
    );
  }

  Widget _buildHeroImage() {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image
          Image.network(
            blog.image ?? "",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 350,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 350,
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 350,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
          // Gradient Overlay
          Container(
            height: 350,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.6, 0.8, 1.0],
              ),
            ),
          ),
          // Blog Category/Tag (if available)
          if (blog.metaAuthor != null)
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  blog.metaAuthor!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDraggableContent(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // Drag Handle
              SliverToBoxAdapter(
                child: _buildDragHandle(),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Title
                    _buildTitle(),
                    const SizedBox(height: 12),

                    // Meta Info Row
                    _buildMetaInfo(),
                    const SizedBox(height: 20),

                    // Subtitle
                    _buildSubtitle(),
                    const SizedBox(height: 24),

                    // Divider
                    const Divider(height: 1),
                    const SizedBox(height: 24),

                    // Main Content
                    _buildContent(),
                    const SizedBox(height: 32),

                    // Comments Section Header
                    _buildCommentsHeader(),

                    // Comments List
                    _buildCommentsList(),
                    const SizedBox(height: 80), // Extra space for bottom bar
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 50,
        height: 4,
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      blog.title ?? "",
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.black,
          child: Icon(Icons.person, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Text(
          blog.metaAuthor ?? "Admin",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.circle, size: 4, color: Colors.grey),
        const SizedBox(width: 12),
        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          _formatDate(blog.createdAt),
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        if (blog.updatedAt != null && blog.updatedAt != blog.createdAt)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Icon(Icons.edit, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Updated",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubtitle() {
    if (blog.subTitle == null || blog.subTitle!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        blog.subTitle!,
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: Colors.grey.shade700,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          blog.details ?? "",
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),

        // YouTube Video if available
        if (blog.youtubeVideo != null && blog.youtubeVideo!.isNotEmpty)
          _buildYouTubeVideo(blog.youtubeVideo!),

        // Instagram Post if available
        if (blog.instagramPost != null && blog.instagramPost!.isNotEmpty)
          _buildInstagramPost(blog.instagramPost!),

        // Meta Info Section
        if (_hasMetaInfo())
          _buildMetaInfoSection(),
      ],
    );
  }

  Widget _buildYouTubeVideo(String videoUrl) {
    // Extract video ID from YouTube URL
    String videoId = videoUrl;
    if (videoUrl.contains('youtube.com/watch?v=')) {
      videoId = videoUrl.split('v=')[1].split('&')[0];
    } else if (videoUrl.contains('youtu.be/')) {
      videoId = videoUrl.split('youtu.be/')[1].split('?')[0];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📺 Watch Video",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.play_circle_filled, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstagramPost(String instagramUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade400,
              Colors.pink.shade400,
              Colors.orange.shade400,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Iconsax.instagram, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Instagram Post",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Check out this post on Instagram",
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                // Open Instagram URL
                Get.toNamed('/webview', arguments: instagramUrl);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.open_in_new, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfoSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📝 Article Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (blog.metaDescription != null && blog.metaDescription!.isNotEmpty)
              _buildMetaItem("Description", blog.metaDescription!),
            if (blog.metaKeywords != null && blog.metaKeywords!.isNotEmpty)
              _buildMetaItem("Keywords", blog.metaKeywords!),
            if (blog.robots != null && blog.robots!.isNotEmpty)
              _buildMetaItem("Robots", blog.robots!),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "💬 Comments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "${controller.comments.length}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildCommentsList() {
    return Obx(() {
      if (controller.comments.isEmpty) {
        return Column(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              "No comments yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Be the first to comment!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.comments.length,
        itemBuilder: (context, index) {
          final c = controller.comments[index];
          return _buildCommentTile(c);
        },
      );
    });
  }

  Widget _buildCommentTile(BlogCommentListData commentData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated Avatar
          Hero(
            tag: commentData.id ?? '',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  _getInitials(commentData.authorName),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author & time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        commentData.authorName ?? "Anonymous",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatTimeAgo(commentData.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Comment text
                Text(
                  commentData.content ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, String blogId) {
    final url = controller.profileController.profileData.value.profilePhotoUrl ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: url.isEmpty ? Colors.black: Colors.transparent,
              backgroundImage: NetworkImage('https://api.samadhantra.com/$url',),
              child: url.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _openCommentSheet(context, blogId),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    "Write a comment...",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCommentSheet(BuildContext context, String id) {
    final focusNode = FocusNode();

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => Text(
                    "${controller.comments.length} comments",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  )),
                ],
              ),
            ),

            const Divider(height: 1),

            // Comments List
            Expanded(
              child: Obx(() {
                if (controller.comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No comments yet",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Start the conversation!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.comments.length,
                  itemBuilder: (context, index) {
                    final c = controller.comments[index];
                    return _buildCommentTile(c);
                  },
                );
              }),
            ),

            // Input Field
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.commentController,
                      focusNode: focusNode,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black, Colors.black87],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          if (controller.commentController.text.trim().isNotEmpty) {
                            controller.postComment(blog.id!);
                            controller.commentController.clear();
                            focusNode.unfocus();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "Recent";
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day} ${_getMonthAbbreviation(date.month)} ${date.year}";
    } catch (e) {
      return "Recent";
    }
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  bool _hasMetaInfo() {
    return (blog.metaDescription != null && blog.metaDescription!.isNotEmpty) ||
        (blog.metaKeywords != null && blog.metaKeywords!.isNotEmpty) ||
        (blog.robots != null && blog.robots!.isNotEmpty);
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "?";
    final names = name.trim().split(' ');
    if (names.length == 1) return names[0][0].toUpperCase();
    return "${names[0][0]}${names[1][0]}".toUpperCase();
  }

  String _formatTimeAgo(String? dateString) {
    if (dateString == null) return "Just now";
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return "${date.day}/${date.month}/${date.year}";
      } else if (difference.inDays > 0) {
        return "${difference.inDays}d ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes}m ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "Recently";
    }
  }
}