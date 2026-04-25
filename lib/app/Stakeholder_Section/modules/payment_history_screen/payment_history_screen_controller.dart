import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_payment_model.dart';

class PaymentHistoryController extends GetxController {
  final RxList<Payment> payments = <Payment>[].obs;
  final RxList<Payment> filteredPayments = <Payment>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;
  final RxString selectedYear = DateTime.now().year.toString().obs;

  final List<String> filters = ['all', 'pending', 'completed', 'failed', 'refunded'];
  final Map<String, String> filterLabels = {
    'all': 'All Payments',
    'pending': 'Pending',
    'completed': 'Completed',
    'failed': 'Failed',
    'refunded': 'Refunded',
  };

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      payments.value = [
        Payment(
          id: '1',
          assignmentId: '1',
          assignmentTitle: 'Mobile App Development',
          providerName: 'Tech Solutions Inc.',
          amount: 15000.00,
          type: 'deposit',
          status: 'completed',
          dueDate: DateTime.now().subtract(const Duration(days: 10)),
          paymentDate: DateTime.now().subtract(const Duration(days: 11)),
          transactionId: 'TXN123456',
          paymentMethod: 'Credit Card',
          invoiceUrl: '',
          invoiceNumber: 'INV-2024-001',
          taxAmount: 2700.00,
          totalAmount: 17700.00,
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
        ),
        Payment(
          id: '2',
          assignmentId: '1',
          assignmentTitle: 'Mobile App Development',
          providerName: 'Tech Solutions Inc.',
          amount: 15000.00,
          type: 'milestone',
          status: 'pending',
          dueDate: DateTime.now().add(const Duration(days: 5)),
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Payment(
          id: '3',
          assignmentId: '2',
          assignmentTitle: 'UI/UX Design',
          providerName: 'Design Studio Pro',
          amount: 20000.00,
          type: 'final',
          status: 'completed',
          dueDate: DateTime.now().subtract(const Duration(days: 20)),
          paymentDate: DateTime.now().subtract(const Duration(days: 21)),
          transactionId: 'TXN789012',
          paymentMethod: 'Bank Transfer',
          invoiceUrl: '',
          invoiceNumber: 'INV-2024-002',
          taxAmount: 3600.00,
          totalAmount: 23600.00,
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Payment(
          id: '4',
          assignmentId: '1',
          assignmentTitle: 'Mobile App Development',
          providerName: 'Tech Solutions Inc.',
          amount: 20000.00,
          type: 'final',
          status: 'pending',
          dueDate: DateTime.now().add(const Duration(days: 30)),
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Payment(
          id: '5',
          assignmentId: '3',
          assignmentTitle: 'Website Redesign',
          providerName: 'Web Masters',
          amount: 25000.00,
          type: 'milestone',
          status: 'failed',
          dueDate: DateTime.now().subtract(const Duration(days: 2)),
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Payment(
          id: '6',
          assignmentId: '4',
          assignmentTitle: 'ERP System Integration',
          providerName: 'ERP Solutions Ltd.',
          amount: 50000.00,
          type: 'deposit',
          status: 'refunded',
          dueDate: DateTime.now().subtract(const Duration(days: 15)),
          paymentDate: DateTime.now().subtract(const Duration(days: 20)),
          transactionId: 'TXN345678',
          paymentMethod: 'Credit Card',
          invoiceNumber: 'INV-2024-003',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ];

      applyFilters();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load payments: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Payment> result = payments;

    // Apply status filter
    if (selectedFilter.value != 'all') {
      result = result.where((payment) => payment.status == selectedFilter.value).toList();
    }

    // Apply year filter
    result = result.where((payment) {
      return payment.createdAt?.year.toString() == selectedYear.value;
    }).toList();

    // Sort by date (newest first)
    result.sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);

    filteredPayments.value = result;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    applyFilters();
  }

  void setYear(String year) {
    selectedYear.value = year;
    applyFilters();
  }

  List<String> get availableYears {
    final years = <String>{'2024', '2023', '2022'};
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  double get totalPaid {
    return payments
        .where((p) => p.status == 'completed')
        .fold(0.0, (sum, payment) => sum + (payment.totalAmount ?? payment.amount));
  }

  double get totalPending {
    return payments
        .where((p) => p.status == 'pending')
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  double get totalRefunded {
    return payments
        .where((p) => p.status == 'refunded')
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  void refreshPayments() {
    loadPayments();
  }
}