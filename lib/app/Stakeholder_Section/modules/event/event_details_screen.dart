import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/data/model/events_response.dart';
import '../../../constant/app_color.dart';
import '../../../constant/custom_appbar.dart';
import '../../../constant/helper_widget.dart';
import 'event_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatelessWidget {
  EventDetailsScreen({super.key});

  EventsData event = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name ?? ''),
        flexibleSpace: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.appColor, AppColors.appColor2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.appColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        leading: Container(
          width: 42,
          height: 42,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
              color: AppColors.white,
            ),
            splashRadius: 24,
            padding: EdgeInsets.zero, // IMPORTANT
            constraints: const BoxConstraints(), // IMPORTANT
          ),
        ),
      ),
      body: ListView(
        children: [
          // Hero Image with gradient overlay
          Stack(
            children: [
              Image.network(
                event.image ?? event.ogImage ?? "",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.date != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              _formatDate(event.date!),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      event.name ?? "",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description Section
                if (event.description != null && event.description!.isNotEmpty)
                  _buildSection(
                    title: "About This Event",
                    icon: Icons.description,
                    content: Text(
                      event.description!,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Event Details Card
                if (_hasEventDetails())
                  _buildSection(
                    title: "Event Details",
                    icon: Icons.info_outline,
                    content: Column(
                      children: [
                        if (event.categoryId != null)
                          _buildInfoRow(
                            Icons.category,
                            "Category",
                            event.categoryId!,
                          ),
                        if (event.slug != null)
                          _buildInfoRow(Icons.link, "Slug", event.slug!),
                        if (event.date != null)
                          _buildInfoRow(
                            Icons.calendar_today,
                            "Date",
                            _formatDateTime(event.date!),
                          ),
                        if (event.createdAt != null)
                          _buildInfoRow(
                            Icons.create,
                            "Created",
                            _formatDateTime(event.createdAt!),
                          ),
                        if (event.updatedAt != null)
                          _buildInfoRow(
                            Icons.update,
                            "Last Updated",
                            _formatDateTime(event.updatedAt!),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Media Section
                if (_hasMedia())
                  _buildSection(
                    title: "Media",
                    icon: Icons.perm_media,
                    content: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (event.video != null && event.video!.isNotEmpty)
                          _buildMediaButton(
                            icon: Icons.video_library,
                            label: "Video",
                            onTap: () => _launchURL(event.video!),
                          ),
                        if (event.youtubeVideo != null &&
                            event.youtubeVideo!.isNotEmpty)
                          _buildMediaButton(
                            icon: Icons.play_circle_filled,
                            label: "YouTube",
                            onTap: () => _launchURL(event.youtubeVideo!),
                          ),
                        if (event.instagramPost != null &&
                            event.instagramPost!.isNotEmpty)
                          _buildMediaButton(
                            icon: Iconsax.instagram,
                            label: "Instagram",
                            onTap: () => _launchURL(event.instagramPost!),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // SEO Information
                if (_hasSEOInfo())
                  _buildSection(
                    title: "Additional Information",
                    icon: Icons.search,
                    content: Column(
                      children: [
                        if (event.metaDescription != null &&
                            event.metaDescription!.isNotEmpty)
                          _buildInfoRow(
                            Icons.description,
                            "Meta Description",
                            event.metaDescription!,
                          ),
                        if (event.metaKeywords != null &&
                            event.metaKeywords!.isNotEmpty)
                          _buildInfoRow(
                            Icons.tag,
                            "Keywords",
                            event.metaKeywords!,
                          ),
                        if (event.metaAuthor != null &&
                            event.metaAuthor!.isNotEmpty)
                          _buildInfoRow(
                            Icons.person,
                            "Author",
                            event.metaAuthor!,
                          ),
                        if (event.robots != null && event.robots!.isNotEmpty)
                          _buildInfoRow(
                            Iconsax.rotate_left,
                            "Robots",
                            event.robots!,
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    // Add your registration logic here
                    _showRegistrationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "Register Now",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for sections
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: content,
        ),
      ],
    );
  }

  // Helper widget for info rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for media buttons
  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateTime(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  bool _hasEventDetails() {
    return event.categoryId != null ||
        event.slug != null ||
        event.date != null ||
        event.createdAt != null ||
        event.updatedAt != null;
  }

  bool _hasMedia() {
    return (event.video != null && event.video!.isNotEmpty) ||
        (event.youtubeVideo != null && event.youtubeVideo!.isNotEmpty) ||
        (event.instagramPost != null && event.instagramPost!.isNotEmpty);
  }

  bool _hasSEOInfo() {
    return (event.metaDescription != null &&
            event.metaDescription!.isNotEmpty) ||
        (event.metaKeywords != null && event.metaKeywords!.isNotEmpty) ||
        (event.metaAuthor != null && event.metaAuthor!.isNotEmpty) ||
        (event.robots != null && event.robots!.isNotEmpty);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Error', 'Could not launch URL');
    }
  }

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register for Event'),
        content: const Text('Do you want to register for this event?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Successfully registered for ${event.name}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
