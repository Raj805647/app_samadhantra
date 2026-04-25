import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/assignment_details/assignment_details_controller.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import '../../../constant/app_circularprogress_indicator.dart';
import '../../../data/model/assignment_details_response.dart';
import '../assignment_screen/assignment_screen_controller.dart';
import 'package:get/get.dart';

class AssignmentDetailScreen extends StatelessWidget {
  AssignmentDetailScreen({super.key});

  final controller = Get.find<AssignmentDetailsController>();

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomProgressIndicator());
        }else if (controller.assignmentDetails.isNull) {
          return const Center(child: Text('No Data'));
        }

        final data = controller.assignmentDetails.value;
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            _buildAppBar(data),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildHeaderCard(data),
                    const SizedBox(height: 16),
                    _buildProgressAndReviewCard(data),
                    const SizedBox(height: 16),
                    _buildStatsSection(data),
                    const SizedBox(height: 16),
                    _buildMilestonesCard(data),
                    const SizedBox(height: 16),
                    _buildDocumentsCard(data),
                    const SizedBox(height: 24),
                    _buildActionButtons(data),
                    const SizedBox(height:50),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(AssignmentDetailsData data) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        data.requirementTitle ?? 'Assignment Details',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade700,
                Colors.purple.shade600,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.status?.toUpperCase() ?? 'ACTIVE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Budget Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.currency_rupee,
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatCurrency(data.budget ?? 0),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(AssignmentDetailsData data) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Provider Info Section with Gradient Border
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.blue.shade50.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    /// Animated Avatar
                    Hero(
                      tag: 'provider_avatar_${data.providerName}',
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade500,
                              Colors.purple.shade500,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade200,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: data.providerImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.network(
                            data.providerImage.toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.business_center,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        )
                            : const Icon(
                          Icons.business_center,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.providerName ?? 'Provider Name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '128 reviews',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getStatusColor(data.status).withOpacity(0.1),
                                  _getStatusColor(data.status).withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getStatusColor(data.status).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(data.status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  data.status ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(data.status),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                /// Stats Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.calendar_today_rounded,
                        label: 'Assigned',
                        value: _formatDate(data.assignedDate),
                        iconColor: Colors.blue,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.play_circle_filled_rounded,
                        label: 'Start Date',
                        value: _formatDate(data.startDate),
                        iconColor: Colors.green,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: _buildInfoTile(
                        icon: Icons.currency_rupee,
                        label: 'Budget',
                        value: _formatCurrency(data.budget ?? 0),
                        iconColor: Colors.orange,
                        highlight: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced Progress and Review Card
  Widget _buildProgressAndReviewCard(AssignmentDetailsData data) {
    final  progress = controller.progress.value;
    Color reviewColor = _getReviewColor(controller.progress.value);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child:           Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        reviewColor.withOpacity(0.15),
                        reviewColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.trending_up_rounded,
                    color: reviewColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Project Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: reviewColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$progress%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: reviewColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            /// Animated Progress Bar
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: progress/100),
              duration: const Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(reviewColor),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            /// Milestone Stats
            Row(
              children: [
                _buildMilestoneStat(
                  'Completed',
                  _getCompletedMilestonesCount(data.milestones ?? []),
                  data.milestones?.length ?? 0,
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildMilestoneStat(
                  'In Progress',
                  _getInProgressMilestonesCount(data.milestones ?? []),
                  data.milestones?.length ?? 0,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildMilestoneStat(
                  'Pending',
                  _getPendingMilestonesCount(data.milestones ?? []),
                  data.milestones?.length ?? 0,
                  Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// New Stats Section
  Widget _buildStatsSection(AssignmentDetailsData data) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Tasks',
            '${data.milestones?.length ?? 0}',
            Icons.task_alt_rounded,
            Colors.blue,
                () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Documents',
            '${data.documents?.length ?? 0}',
            Icons.folder_rounded,
            Colors.purple,
                () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Reviews',
            '3',
            Icons.star_rate_rounded,
            Colors.orange,
                () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Enhanced Milestones Section
  Widget _buildMilestonesCard(AssignmentDetailsData data) {
    final milestones = data.milestones ?? [];

    if (milestones.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.timeline_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No milestones added yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Milestones will appear here once added',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.purple.shade400],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.flag_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Milestones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_getCompletedMilestonesCount(milestones)}/${milestones.length} Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: milestones.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              return _buildMilestoneItem(milestones[index], index);
            },
          ),
        ],
      ),
    );
  }

  /// Enhanced Milestone Item with Animation
  Widget _buildMilestoneItem(Milestones milestone, int index) {
    bool isCompleted = milestone.status?.toLowerCase() == 'completed';
    bool isOverdue = _isOverdue(milestone.dueDate) && !isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.shade50
                : isOverdue
                ? Colors.red.shade50
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Animated Status Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isCompleted
                      ? LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  )
                      : isOverdue
                      ? LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade600],
                  )
                      : LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isCompleted
                          ? Colors.green
                          : isOverdue
                          ? Colors.red
                          : Colors.blue)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 20, color: Colors.white)
                      : Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.title ?? 'Milestone ${index + 1}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.grey.shade600 : Colors.black87,
                      ),
                    ),
                    if (milestone.description != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        milestone.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 14,
                          color: isOverdue ? Colors.red : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(milestone.dueDate) ?? 'No date',
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : Colors.grey.shade600,
                            fontWeight: isOverdue ? FontWeight.w600 : null,
                          ),
                        ),
                        if (milestone.completedDate != null) ...[
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Completed: ${_formatDate(milestone.completedDate.toString())}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (!isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        milestone.status?.toLowerCase() == 'in_progress'
                            ? Colors.orange.shade100
                            : Colors.grey.shade200,
                        milestone.status?.toLowerCase() == 'in_progress'
                            ? Colors.orange.shade50
                            : Colors.grey.shade100,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: milestone.status?.toLowerCase() == 'in_progress'
                          ? Colors.orange.shade300
                          : Colors.grey.shade300,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: milestone.status?.toLowerCase() == 'in_progress'
                              ? Colors.orange
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        milestone.status ?? 'Pending',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: milestone.status?.toLowerCase() == 'in_progress'
                              ? Colors.orange.shade800
                              : Colors.grey.shade700,
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

  /// Enhanced Documents Section
  Widget _buildDocumentsCard(AssignmentDetailsData data) {
    final documents = data.documents ?? [];

    if (documents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.red.shade400],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.folder_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Documents & Files',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${documents.length} files',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: documents.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              return _buildDocumentItem(documents[index]);
            },
          ),
        ],
      ),
    );
  }

  /// Enhanced Document Item
  Widget _buildDocumentItem(Documents doc) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDocument(doc.url),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getDocumentColor(doc.type).withOpacity(0.15),
                      _getDocumentColor(doc.type).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getDocumentIcon(doc.type),
                  color: _getDocumentColor(doc.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.name ?? 'Document ${doc.type}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Uploaded by ${doc.uploader ?? 'Unknown'} • ${_formatDate(doc.uploadDate)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.download_rounded,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Action Buttons Section
  Widget _buildActionButtons(AssignmentDetailsData data) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.messageScreen),
            icon: const Icon(Icons.message_rounded, size: 20),
            label: const Text('Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              side: BorderSide(color: Colors.blue.shade200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showMilestoneDetails(),
            icon: const Icon(Icons.star_rate_rounded, size: 20),
            label: const Text('Feedback'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Enhanced Info Tile
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String? value,
    Color iconColor = Colors.grey,
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value ?? 'N/A',
          style: TextStyle(
            fontSize: 14,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            color: highlight ? Colors.green.shade700 : Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Milestone Stat Widget
  Widget _buildMilestoneStat(String label, int count, int total, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$count/$total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }


  int _getCompletedMilestonesCount(List<Milestones> milestones) {
    return milestones.where((m) => m.status?.toLowerCase() == 'completed').length;
  }

  int _getInProgressMilestonesCount(List<Milestones> milestones) {
    return milestones.where((m) => m.status?.toLowerCase() == 'in_progress').length;
  }

  int _getPendingMilestonesCount(List<Milestones> milestones) {
    return milestones.where((m) => m.status?.toLowerCase() == 'pending').length;
  }

  String _getReviewDescription(int progress) {
    if (progress >= 80) {
      return "Project is in final review. Quality check and final approval pending.";
    } else if (progress >= 40) {
      return "First review completed. Project is on track for final delivery.";
    } else {
      return "Project initialization phase. Initial review will begin at 40% completion.";
    }
  }

  Color _getReviewColor(int progress) {
    if (progress >= 80) return Colors.green.shade600;
    if (progress >= 40) return Colors.orange.shade600;
    return Colors.blue.shade600;
  }

  bool _isOverdue(String? dueDate) {
    if (dueDate == null) return false;
    try {
      DateTime due = DateTime.parse(dueDate);
      return due.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  IconData _getDocumentIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getDocumentColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'pdf':
        return Colors.red.shade600;
      case 'image':
        return Colors.purple.shade600;
      case 'doc':
      case 'docx':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) return null;
    try {
      DateTime date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return 'Today';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} days ago';
      } else if (diff.inDays < 30) {
        return '${(diff.inDays / 7).floor()} weeks ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (_) {
      return dateString;
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} K';
    }
    return '${amount.toStringAsFixed(0)}';
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
      case 'in_progress':
        return Colors.green.shade600;
      case 'pending':
        return Colors.orange.shade600;
      case 'completed':
        return Colors.blue.shade600;
      case 'cancelled':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }



  void _openDocument(String? url) {
    if (url != null) {
      Get.snackbar(
        'Opening Document',
        'Opening document...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showMilestoneDetails() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Title
                    const Text(
                      "Submit Review",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Info Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.assignmentDetails.value.providerName ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.assignmentDetails.value.requirementTitle ?? "",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 6),
                          Obx(() {
                            return Text(
                              "Completion: ${controller.progress.value}%",
                              style: const TextStyle(fontSize: 12),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Rating Title
                    const Text(
                      "Your Rating",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 10),

                    /// ⭐ Stars
                    Center(
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 34,
                        unratedColor: Colors.grey.shade300,
                        itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          controller.rating.value = rating;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Comment Box
                    TextField(
                      controller: controller.commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Write a comment (optional)",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 80), // space for bottom bar
                  ],
                ),
              ),

              /// 🔻 Sticky Bottom Button (Bottom AppBar style)
              Obx(() => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () {
                      if (controller.rating.value == 0) {
                        Get.snackbar("Error", "Please select rating");
                        return;
                      }
                      if(controller.progress.value <= 40 && controller.progress.value >= 80) {
                        controller.submitInitialReview();
                      }else if(controller.progress.value == 100){
                        controller.submitFinalRequesterReview();
                      }else if(controller.assignmentDetails.value.providerName == ''){
                        controller.submitFinalProviderReview();
                      }
                    },                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                        : const Text("Submit Review"),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }}