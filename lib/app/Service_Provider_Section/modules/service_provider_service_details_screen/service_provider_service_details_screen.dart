import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_service_details_screen/service_provider_service_details_screen_controller.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderServiceDetailsScreen extends StatelessWidget {
  final ServiceProviderServiceDetailsController controller =
  Get.put(ServiceProviderServiceDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Service Details",actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.white),
            onPressed: controller.editService,
            tooltip: 'Edit Service',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'duplicate',
                child: ListTile(
                  leading: Icon(Icons.content_copy, color: Colors.green),
                  title: Text('Duplicate Service'),
                ),
              ),
              PopupMenuItem(
                value: 'status',
                child: ListTile(
                  leading: Icon(
                    controller.service.isActive
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: controller.service.isActive ? Colors.orange : Colors.green,
                  ),
                  title: Text(controller.service.isActive
                      ? 'Deactivate Service'
                      : 'Activate Service'),
                ),
              ),
              PopupMenuItem(
                value: 'featured',
                child: ListTile(
                  leading: Icon(
                    controller.service.isFeatured
                        ? Icons.star_border
                        : Icons.star,
                    color: Colors.amber,
                  ),
                  title: Text(
                    controller.service.isFeatured
                        ? 'Remove from Featured'
                        : 'Mark as Featured',
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share, color: Colors.blue),
                  title: Text('Share Service'),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete Service'),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'duplicate':
                  controller.duplicateService();
                  break;
                case 'status':
                  controller.toggleServiceStatus();
                  break;
                case 'featured':
                  controller.toggleFeaturedStatus();
                  break;
                case 'share':
                  controller.shareService();
                  break;
                case 'delete':
                  controller.deleteService();
                  break;
              }
            },
          ),

      ],),
      // _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Header Card
            _buildServiceHeader(),
            SizedBox(height: 20),

            // Tabs Navigation
            _buildTabNavigation(),
            SizedBox(height: 20),

            // Tab Content
            _buildTabContent(),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading service details...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Icon
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(controller.service.category)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(controller.service.category),
                    color: _getCategoryColor(controller.service.category),
                    size: 32,
                  ),
                ),
                SizedBox(width: 16),

                // Service Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.service.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (controller.service.isFeatured)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.amber),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 14, color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text(
                                    'Featured',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.service.category,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'Delivery: ${controller.service.deliveryDays} days',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.work, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            controller.service.experienceLevel,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Divider(),

            // Status and Pricing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.service.isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.service.isActive
                            ? Icons.check_circle
                            : Icons.pause_circle,
                        size: 16,
                        color: controller.service.isActive
                            ? Colors.green
                            : Colors.red,
                      ),
                      SizedBox(width: 6),
                      Text(
                        controller.service.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: controller.service.isActive
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),

                // Pricing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Starting from',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '₹${controller.service.hourlyRate.toInt()}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    Text(
                      'Hourly Rate',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabButton('overview', Icons.dashboard, 'Overview'),
          _buildTabButton('details', Icons.info, 'Details'),
          _buildTabButton('pricing', Icons.currency_rupee, 'Pricing'),
          _buildTabButton('orders', Icons.receipt, 'Orders'),
          _buildTabButton('analytics', Icons.analytics, 'Analytics'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab, IconData icon, String label) {
    return Expanded(
      child: Obx(() {
        final isActive = controller.activeTab.value == tab;
        return TextButton(
          onPressed: () => controller.changeTab(tab),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: isActive ? AppColors.appColor : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.white : Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabContent() {
    return Obx(() {
      switch (controller.activeTab.value) {
        case 'overview':
          return _buildOverviewTab();
        case 'details':
          return _buildDetailsTab();
        case 'pricing':
          return _buildPricingTab();
        case 'orders':
          return _buildOrdersTab();
        case 'analytics':
          return _buildAnalyticsTab();
        default:
          return _buildOverviewTab();
      }
    });
  }

  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Grid
        Text(
          'Performance Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: controller.stats.length,
          itemBuilder: (context, index) {
            final stat = controller.stats[index];
            return _buildStatCard(stat);
          },
        ),

        SizedBox(height: 24),

        // Recent Reviews
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Reviews List
        Column(
          children: controller.reviews.take(2).map((review) {
            return _buildReviewCard(review);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          controller.service.description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),

        SizedBox(height: 24),

        // Skills
        Text(
          'Skills & Expertise',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.service.skills.map((skill) {
            return Chip(
              label: Text(skill),
              backgroundColor: Colors.blue[50],
              labelStyle: TextStyle(color: Colors.blue[700]),
            );
          }).toList(),
        ),

        SizedBox(height: 24),

        // Tags
        Text(
          'Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.service.tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: Colors.grey[100],
            );
          }).toList(),
        ),

        SizedBox(height: 24),

        // Service Details
        Text(
          'Service Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        _buildDetailItem('Created', _formatDate(controller.service.createdAt)),
        _buildDetailItem('Category', controller.service.category),
        _buildDetailItem('Experience Level', controller.service.experienceLevel),
        _buildDetailItem('Delivery Time', '${controller.service.deliveryDays} days'),
      ],
    );
  }

  Widget _buildPricingTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing Models',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),

        // Hourly Rate
        _buildPricingCard(
          icon: Icons.schedule,
          title: 'Hourly Rate',
          amount: '₹${controller.service.hourlyRate.toInt()}',
          description: 'Perfect for ongoing work or consultations',
          color: Colors.blue,
        ),

        SizedBox(height: 12),

        // Daily Rate
        _buildPricingCard(
          icon: Icons.calendar_today,
          title: 'Daily Rate',
          amount: '₹${controller.service.dailyRate.toInt()}',
          description: 'Full day of dedicated work',
          color: Colors.green,
        ),

        SizedBox(height: 12),

        // Project Rate
        _buildPricingCard(
          icon: Icons.assignment_turned_in,
          title: 'Project Rate',
          amount: '₹${controller.service.projectRate.toInt()}',
          description: 'Fixed price for complete projects',
          color: Colors.purple,
        ),

        SizedBox(height: 24),

        // Edit Pricing Button
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              _showEditPricingDialog();
            },
            icon: Icon(Icons.edit),
            label: Text('Edit Pricing'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Chip(
              label: Text('${controller.orders.length} orders'),
              backgroundColor: Colors.blue[50],
              labelStyle: TextStyle(color: Colors.blue[700]),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Orders Summary
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOrderStat(
                  'Total Revenue',
                  '₹${controller.totalRevenue.toDouble().toStringAsFixed(0)}',
                ),
                _buildOrderStat('Completed', controller.orders.where((o) => o['status'] == 'completed').length.toString()),
                _buildOrderStat('In Progress', controller.orders.where((o) => o['status'] == 'in_progress').length.toString()),
              ],
            ),
          ),
        ),

        SizedBox(height: 16),

        // Orders List
        Column(
          children: controller.orders.map((order) {
            return _buildOrderCard(order);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Analytics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),

        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Total Orders',
                controller.orders.length.toString(),
                Icons.receipt,
                Colors.blue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildAnalyticsCard(
                'Avg. Rating',
                controller.averageRating.toStringAsFixed(1),
                Icons.star,
                Colors.amber,
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Revenue Chart
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Trends',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.analytics.length,
                    itemBuilder: (context, index) {
                      final data = controller.analytics[index];
                      return _buildBarChartItem(data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16),

        // Performance Metrics
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Metrics',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildMetricItem('Client Satisfaction', '95%', Colors.green),
                _buildMetricItem('On-Time Delivery', '92%', Colors.blue),
                _buildMetricItem('Repeat Clients', '45%', Colors.purple),
                _buildMetricItem('Response Rate', '98%', Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconForStat(stat['icon']),
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: stat['isPositive']
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    stat['change'],
                    style: TextStyle(
                      fontSize: 12,
                      color: stat['isPositive'] ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              stat['value'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              stat['title'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, color: Colors.blue),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['userName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review['rating']
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  review['date'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              review['comment'],
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Chip(
              label: Text(review['project']),
              backgroundColor: Colors.grey[100],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required IconData icon,
    required String title,
    required String amount,
    required String description,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(controller.getStatusColor(order['status']))
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            order['status'] == 'completed'
                ? Icons.check_circle
                : order['status'] == 'in_progress'
                ? Icons.autorenew
                : Icons.pending,
            color: Color(controller.getStatusColor(order['status'])),
          ),
        ),
        title: Text(
          order['id'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order['clientName']),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12),
                SizedBox(width: 4),
                Text(order['date']),
                SizedBox(width: 12),
                Icon(Icons.schedule, size: 12),
                SizedBox(width: 4),
                Text('${order['deliveryDays']} days'),
              ],
            ),
          ],
        ),
        trailing: SizedBox(
          width: 90, // constrain width
          child: Column(
            mainAxisSize: MainAxisSize.min, // ⭐ VERY IMPORTANT
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${order['amount']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                label: Text(
                  controller.getStatusText(order['status']),
                  style: TextStyle(
                    color: Color(controller.getStatusColor(order['status'])),
                    fontSize: 10,
                  ),
                ),
                backgroundColor:
                Color(controller.getStatusColor(order['status']))
                    .withOpacity(0.1),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),

        onTap: () => controller.viewOrderDetails(order['id']),
      ),
    );
  }

  Widget _buildOrderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartItem(Map<String, dynamic> data) {
    final maxRevenue = controller.analytics
        .map((a) => a['revenue'] as int)
        .reduce((a, b) => a > b ? a : b);
    // final height = (data['revenue'] as int / maxRevenue) * 100;

    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 40,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
          SizedBox(height: 8),
          Text(
            data['month'],
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(
            '₹${((data['revenue'] as num) / 1000).toStringAsFixed(0)}k',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),

        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey[700])),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
              label: Text('Back to Services'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                controller.shareService();
              },
              icon: Icon(Icons.share,color: AppColors.white,),
              label: Text('Share Service',style: TextStyle(color: AppColors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPricingDialog() {
    final hourlyController =
    TextEditingController(text: controller.service.hourlyRate.toString());
    final dailyController =
    TextEditingController(text: controller.service.dailyRate.toString());
    final projectController =
    TextEditingController(text: controller.service.projectRate.toString());

    Get.dialog(
      AlertDialog(
        title: Text('Edit Pricing'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: hourlyController,
                decoration: InputDecoration(
                  labelText: 'Hourly Rate (₹)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: dailyController,
                decoration: InputDecoration(
                  labelText: 'Daily Rate (₹)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: projectController,
                decoration: InputDecoration(
                  labelText: 'Project Rate (₹)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final hourly = double.tryParse(hourlyController.text) ?? 0;
              final daily = double.tryParse(dailyController.text) ?? 0;
              final project = double.tryParse(projectController.text) ?? 0;
              controller.updatePricing(hourly, daily, project);
            },
            child: Text('Update Pricing'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStat(String icon) {
    switch (icon) {
      case 'receipt':
        return Icons.receipt;
      case 'star':
        return Icons.star;
      case 'check_circle':
        return Icons.check_circle;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.bar_chart;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'web development':
        return Icons.web;
      case 'mobile app development':
        return Icons.mobile_friendly;
      case 'ui/ux design':
        return Icons.design_services;
      case 'graphic design':
        return Icons.graphic_eq;
      case 'digital marketing':
        return Icons.trending_up;
      case 'seo':
        return Icons.search;
      case 'content writing':
        return Icons.article;
      case 'video editing':
        return Icons.video_library;
      case 'consulting':
        return Icons.business;
      case 'e-commerce':
        return Icons.shopping_cart;
      case 'cloud services':
        return Icons.cloud;
      default:
        return Icons.business_center;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'web development':
        return Colors.blue;
      case 'mobile app development':
        return Colors.green;
      case 'ui/ux design':
        return Colors.purple;
      case 'graphic design':
        return Colors.orange;
      case 'digital marketing':
        return Colors.teal;
      case 'seo':
        return Colors.indigo;
      case 'content writing':
        return Colors.brown;
      case 'video editing':
        return Colors.red;
      case 'consulting':
        return Colors.cyan;
      case 'e-commerce':
        return Colors.amber;
      case 'cloud services':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final day = date.day.toString();
    final month = months[date.month - 1];
    final year = date.year;

    var hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return '$day $month $year, ${hour.toString()}:$minute $amPm';
  }
}