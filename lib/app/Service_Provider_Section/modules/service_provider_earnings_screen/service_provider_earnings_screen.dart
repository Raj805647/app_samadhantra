// lib/app/modules/service_provider/views/service_provider_earnings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_earnings_screen/service_provider_earnings_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderEarningsScreen extends StatelessWidget {
  final ServiceProviderEarningsController controller = Get.put(
    ServiceProviderEarningsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Earnings & Payments"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Selector
              _buildPeriodSelector(),
              SizedBox(height: 24),

              // Summary Cards
              _buildSummaryCards(),
              SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(),
              SizedBox(height: 24),

              // Recent Transactions
              _buildRecentTransactions(),
              SizedBox(height: 24),

              // Payment Methods
              _buildPaymentMethods(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Earnings Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Obx(
          () => DropdownButton<String>(
            value: controller.selectedPeriod.value,
            items: controller.periods.map((period) {
              return DropdownMenuItem(value: period, child: Text(period));
            }).toList(),
            onChanged: (value) => controller.selectedPeriod.value = value!,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          title: 'Total Earnings',
          value:
              '₹ ${controller.earningsData['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
          icon: Icons.currency_rupee,
          color: Colors.green,
          subtitle: 'Lifetime',
        ),
        _buildStatCard(
          title: 'Pending Payments',
          value:
              '₹ ${controller.earningsData['pendingPayments']?.toStringAsFixed(0) ?? '0'}',
          icon: Icons.pending_actions,
          color: Colors.orange,
          subtitle: 'Awaiting clearance',
        ),
        _buildStatCard(
          title: 'This Month',
          value:
              '₹ ${controller.earningsData['thisMonth']?.toStringAsFixed(0) ?? '0'}',
          icon: Icons.calendar_today,
          color: Colors.blue,
          subtitle: 'Current month earnings',
        ),
        _buildStatCard(
          title: 'Growth Rate',
          value:
              '${controller.earningsData['growthRate']?.toStringAsFixed(1) ?? '0'}%',
          icon: Icons.trending_up,
          color:
              controller.earningsData['growthRate'] != null &&
                  controller.earningsData['growthRate']! >= 0
              ? Colors.green
              : Colors.red,
          subtitle: 'Compared to last month',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- Top Row ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const Icon(Icons.more_vert, size: 18, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 12),

            /// ---------- Title ----------
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            /// ---------- Value ----------
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const Spacer(),

            /// ---------- Subtitle ----------
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.request_quote,
                label: 'Request Payout',
                onTap: () => _requestPayout(),
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.add_card,
                label: 'Add Payment Method',
                onTap: () => _addPaymentMethod(),
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _viewAllTransactions(),
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...controller.transactions.take(5).map((transaction) {
          return _buildTransactionItem(transaction);
        }).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isCredit = transaction['type'] == 'credit';
    final color = isCredit ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () {
        controller.viewTransactionDetails(transaction['id']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------- Icon --------
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: color,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            /// -------- Details --------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['description'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Client: ${transaction['client']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction['date'] ?? '',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// -------- Amount & Status --------
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${transaction['amount']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    transaction['status'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addPaymentMethod(),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...controller.paymentMethods.map((method) {
          return _buildPaymentMethodItem(method);
        }).toList(),
      ],
    );
  }

  Widget _buildPaymentMethodItem(Map<String, dynamic> method) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            method['type'] == 'bank' ? Icons.account_balance : Icons.payment,
            color: Colors.blue,
          ),
        ),
        title: Text(method['name']),
        subtitle: Text(
          method['type'] == 'bank'
              ? 'Account: ${method['accountNumber']}'
              : 'UPI ID: ${method['upiId']}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (method['isDefault'] == true)
              Chip(
                label: Text('Default'),
                backgroundColor: Colors.green[100],
                labelStyle: TextStyle(color: Colors.green),
              ),
            SizedBox(width: 8),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(child: Text('Set as Default'), value: 'default'),
                PopupMenuItem(child: Text('Edit'), value: 'edit'),
                PopupMenuItem(
                  child: Text('Remove', style: TextStyle(color: Colors.red)),
                  value: 'remove',
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'default':
                    controller.setDefaultPaymentMethod(method['id']);
                    break;
                  case 'edit':
                    _editPaymentMethod(method);
                    break;
                  case 'remove':
                    _removePaymentMethod(method);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _requestPayout() {
    double amount = 0.0;

    Get.dialog(
      AlertDialog(
        title: Text('Request Payout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Available Balance: ₹${controller.earningsData['pendingPayments'] ?? '0'}',
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0.0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (amount > 0) {
                controller.requestPayout(amount);
                Get.back();
              }
            },
            child: Text('Request Payout'),
          ),
        ],
      ),
    );
  }

  void _addPaymentMethod() {
    String selectedType = 'bank';
    String name = '';
    String account = '';
    String upiId = '';

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Payment Method',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: 'Payment Method Type',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'bank', child: Text('Bank Account')),
                  DropdownMenuItem(value: 'upi', child: Text('UPI')),
                ],
                onChanged: (value) => selectedType = value!,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: selectedType == 'bank'
                      ? 'Bank Name'
                      : 'Payment App Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => name = value,
              ),
              SizedBox(height: 16),
              if (selectedType == 'bank')
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Account Number',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => account = value,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'IFSC Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                )
              else
                TextField(
                  decoration: InputDecoration(
                    labelText: 'UPI ID',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => upiId = value,
                ),
              SizedBox(height: 20),
              AppButton(
                title: "Add Payment Method",
                onPressed: () {
                  final method = {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'type': selectedType,
                    'name': name,
                    if (selectedType == 'bank') 'accountNumber': account,
                    if (selectedType == 'upi') 'upiId': upiId,
                    'isDefault': controller.paymentMethods.isEmpty,
                  };
                  controller.addPaymentMethod(method);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editPaymentMethod(Map<String, dynamic> method) {
    // Implement edit functionality
    Get.snackbar('Info', 'Edit functionality coming soon');
  }

  void _removePaymentMethod(Map<String, dynamic> method) {
    Get.defaultDialog(
      title: 'Remove Payment Method',
      middleText: 'Are you sure you want to remove this payment method?',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.paymentMethods.remove(method);
        Get.back();
        Get.snackbar('Success', 'Payment method removed');
      },
    );
  }

  void _viewAllTransactions() {
    Get.toNamed('/service-provider/transactions');
  }
}
