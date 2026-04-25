import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/payment_history_screen/payment_history_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_payment_model.dart';

class PaymentHistoryScreen extends StatelessWidget {
  PaymentHistoryScreen({super.key});

  final PaymentHistoryController controller = Get.put(PaymentHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Payment History",
        isBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshPayments,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        return _buildContent();
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading payments...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Stats Summary
        _buildStatsSummary(),

        // Filters
        _buildFilterSection(),

        // Payments List
        Expanded(
          child: _buildPaymentsList(),
        ),
      ],
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Paid',
                  amount: controller.totalPaid,
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Pending',
                  amount: controller.totalPending,
                  color: Colors.orange,
                  icon: Icons.pending,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year Filter
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                'Year:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Obx(() => DropdownButton<String>(
                value: controller.selectedYear.value,
                underline: const SizedBox(),
                items: controller.availableYears.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.setYear(value);
                },
              )),
            ],
          ),

          const SizedBox(height: 16),

          // Status Filter Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: controller.filters.map((filter) {
                final isSelected = controller.selectedFilter.value == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      controller.filterLabels[filter] ?? filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    selected: isSelected,
                    backgroundColor: Colors.grey[100],
                    selectedColor: AppColors.appColor,
                    onSelected: (_) => controller.setFilter(filter),
                    checkmarkColor: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsList() {
    return Obx(() {
      if (controller.filteredPayments.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.refreshPayments();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredPayments.length,
          itemBuilder: (context, index) {
            final payment = controller.filteredPayments[index];
            return _buildPaymentCard(payment);
          },
        ),
      );
    });
  }

  Widget _buildPaymentCard(Payment payment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            '/payment-details',
            arguments: {'paymentId': payment.id},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      payment.assignmentTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: payment.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: payment.statusColor),
                    ),
                    child: Text(
                      payment.statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: payment.statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Provider
              if (payment.providerName!.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      payment.providerName ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Details Row
              Row(
                children: [
                  // Amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          payment.formattedAmount,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.status == 'completed' ? 'Paid Date' : 'Due Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          payment.status == 'completed'
                              ? payment.formattedPaymentDate.split(',')[0]
                              : payment.formattedDueDate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: payment.isOverdue ? Colors.red : Colors.grey[800],
                          ),
                        ),
                        if (payment.isOverdue)
                          Text(
                            'OVERDUE',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      payment.typeText.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // View Details Button
                  TextButton(
                    onPressed: () {
                      Get.toNamed(
                        '/payment-details',
                        arguments: {'paymentId': payment.id},
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'View Details',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No Payments Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.selectedFilter.value == 'all'
                ? 'You don\'t have any payments yet'
                : 'No ${controller.selectedFilter.value} payments found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (controller.selectedFilter.value != 'all')
            ElevatedButton(
              onPressed: () => controller.setFilter('all'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('View All Payments'),
            ),
        ],
      ),
    );
  }
}