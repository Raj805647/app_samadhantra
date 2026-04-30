import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

import '../../../data/model/my_agreement_response.dart';
import 'assignment_screen_controller.dart';

class AssignmentsScreen extends StatelessWidget {
  final controller = Get.put(AssignmentController());

  AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'My Assignments',
        isBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.white),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () => _showSearchBar(),
          ),
        ],
      ),
      body: _buildAssignmentsList(),
    );
  }

  Widget _buildAssignmentsList() {
    if (controller.isAssignmentLoading.value) {
      return CustomProgressIndicator();
    }
    if (controller.agreements.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.agreements.length,
      itemBuilder: (context, index) {
        final assignment = controller.agreements[index];
        return _buildAssignmentCard(assignment);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No assignments yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your assigned service providers will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(AgreementData a) {
    DateTime? start = _parseDate(a.deliveryStartDate);
    DateTime? end = _parseDate(a.expectedCompletionDate);
    DateTime? created = _parseDate(a.createdAt);

    double progress = _calculateProgress(start, end);
    String reviewStage = _getReviewStage(progress);

    print('dsknfkdSBDaszcxzcsfb');
    print(a.createdAt);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          print('akdjfbhsf=> $progress');
          Get.toNamed(
            AppRoutes.assignmentDetailsScreen,
            arguments: {
              'agreement_id': a.id,
              'progress': (progress * 100).toInt(),
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          a.agreementNumber ??
                              "AG-${a.id?.toString().substring(0, 4) ?? '000'}",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDate(created) ?? 'Created recently',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(a.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      a.status ?? "Unknown",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(a.status),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Provider & Requirement (Single Row)
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getDisplayName(a.providerUserId),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getRequirementTitle(a.requirementId),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Timeline (Compact)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCompactDate("Start", _formatDate(start) ?? 'TBD'),
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: Colors.grey.shade400,
                  ),
                  _buildCompactDate("End", _formatDate(end) ?? 'TBD'),
                ],
              ),

              const SizedBox(height: 8),

              /// Progress Bar
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progress",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "${(progress * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 0.8
                                  ? Colors.green
                                  : progress >= 0.4
                                  ? Colors.orange
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Review Stage Chip
                  _buildReviewStageChip(reviewStage, progress),
                ],
              ),

              const SizedBox(height: 6),

              /// Amount Row
              Container(
                padding: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contract Amount",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "₹${_formatCurrency(a.contractAmount ?? 0)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _parseDate(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  double _calculateProgress(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 0;

    final now = DateTime.now();

    if (now.isBefore(start)) return 0;
    if (now.isAfter(end)) return 1;

    final total = end.difference(start).inSeconds;
    final done = now.difference(start).inSeconds;

    return done / total;
  }

  /// Compact date widget
  Widget _buildCompactDate(String label, String date) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Compact review stage chip
  Widget _buildReviewStageChip(String reviewStage, double progress) {
    Color chipColor;

    if (progress >= 0.8) {
      chipColor = Colors.green;
    } else if (progress >= 0.4) {
      chipColor = Colors.orange;
    } else {
      chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        reviewStage,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  /// Helper: Get review stage based on progress
  String _getReviewStage(double progress) {
    if (progress >= 0.8) {
      return "Final";
    } else if (progress >= 0.4) {
      return "Review";
    } else {
      return "Initial";
    }
  }

  /// Helper: Format currency (Compact)
  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  /// Helper: Get display name
  String _getDisplayName(String? userId) {
    if (userId == null || userId == '-') return 'N/A';
    if (userId.length > 15) return '${userId.substring(0, 12)}...';
    return userId;
  }

  /// Helper: Get requirement title
  String _getRequirementTitle(String? reqId) {
    if (reqId == null || reqId == '-') return 'N/A';
    if (reqId.length > 15) return '${reqId.substring(0, 12)}...';
    return reqId;
  }

  /// Helper: Handle card tap
  void _onCardTap(AgreementData a) {
    // Navigate to details
  }

  /// Helper: Status color mapping
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
      case 'in progress':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Helper: Format date
  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'assigned':
        color = Colors.blue;
        icon = Icons.assignment;
        break;
      case 'in-progress':
        color = AppColors.appColor;
        icon = Icons.play_circle;
        break;
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewBadge(String reviewType, int progressPercentage) {
    Color color;
    String title;
    IconData icon;

    switch (reviewType) {
      case '40_percent':
        color = Colors.blue;
        title = 'Mid-Project Review Available';
        icon = Icons.timeline;
        break;
      case '80_percent':
        color = Colors.orange;
        title = 'Pre-Completion Review Available';
        icon = Icons.star_half;
        break;
      case 'final':
        color = Colors.green;
        title = 'Final Review Available';
        icon = Icons.star_rate;
        break;
      default:
        color = Colors.grey;
        title = 'Review Available';
        icon = Icons.reviews;
    }

    return GestureDetector(
      onTap: () {
        Get.snackbar(
          'Review',
          'Please go to assignment details to submit review',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.appColor,
          colorText: Colors.white,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    'Share your feedback at $progressPercentage% completion',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Review Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Assignments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('All', Icons.list),
              _buildFilterOption('This Month', Icons.calendar_today),
              _buildFilterOption('This Year', Icons.calendar_month),
              _buildFilterOption('Custom Range', Icons.date_range),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Apply Filter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.appColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Get.back();
        Get.snackbar(
          'Filter Applied',
          'Showing $title assignments',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.appColor,
          colorText: Colors.white,
        );
      },
    );
  }

  void _showSearchBar() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search assignments...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onChanged: (value) {
                  // Implement search logic if needed
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
