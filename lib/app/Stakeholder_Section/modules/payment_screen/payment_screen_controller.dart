import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_payment_model.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  final RxList<Payment> payments = <Payment>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedTab = 'pending'.obs;
  final RxList<String> years = <String>['2024', '2023', '2022'].obs;
  final RxString selectedYear = '2024'.obs;

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

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
          transactionId: 'TXN123456789',
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
          transactionId: 'TXN789012345',
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
          transactionId: 'TXN345678901',
          paymentMethod: 'Credit Card',
          invoiceNumber: 'INV-2024-003',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ];

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

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  void initiatePayment(String paymentId) {
    final index = payments.indexWhere((p) => p.id == paymentId);
    if (index != -1) {
      // Show payment gateway
      Get.defaultDialog(
        title: 'Make Payment',
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Amount to Pay',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    payments[index].formattedAmount,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Due Date: ${payments[index].formattedDueDate}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: Get.back,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _processPayment(paymentId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pay Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void _processPayment(String paymentId) {
    final index = payments.indexWhere((p) => p.id == paymentId);
    if (index != -1) {
      payments[index] = Payment(
        id: paymentId,
        assignmentId: payments[index].assignmentId,
        assignmentTitle: payments[index].assignmentTitle,
        providerName: payments[index].providerName,
        amount: payments[index].amount,
        type: payments[index].type,
        status: 'processing',
        dueDate: payments[index].dueDate,
        paymentDate: DateTime.now(),
        transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        paymentMethod: 'Credit Card',
        invoiceUrl: '',
        invoiceNumber: payments[index].invoiceNumber,
        taxAmount: payments[index].taxAmount,
        totalAmount: payments[index].totalAmount,
        createdAt: payments[index].createdAt,
      );

      Get.snackbar(
        'Success',
        'Payment initiated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Simulate payment completion after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        payments[index] = Payment(
          id: paymentId,
          assignmentId: payments[index].assignmentId,
          assignmentTitle: payments[index].assignmentTitle,
          providerName: payments[index].providerName,
          amount: payments[index].amount,
          type: payments[index].type,
          status: 'completed',
          dueDate: payments[index].dueDate,
          paymentDate: payments[index].paymentDate,
          transactionId: payments[index].transactionId,
          paymentMethod: payments[index].paymentMethod,
          invoiceUrl: '',
          invoiceNumber: payments[index].invoiceNumber,
          taxAmount: payments[index].taxAmount,
          totalAmount: payments[index].totalAmount,
          createdAt: payments[index].createdAt,
        );
        update();
      });
    }
  }

  void viewPaymentDetails(String paymentId) {
    Get.toNamed('/paymentDetailsScreen', arguments: {'paymentId': paymentId});
  }

  void viewInvoice(String paymentId) {
    print("============================== View Invoice for: $paymentId");

    final payment = payments.firstWhereOrNull((p) => p.id == paymentId);

    if (payment != null) {
      // Create invoice from payment data
      final invoice = Invoice(
        id: 'inv_${payment.id}',
        paymentId: payment.id,
        invoiceNumber: payment.invoiceNumber ?? 'INV-${DateTime.now().millisecondsSinceEpoch}',
        invoiceDate: payment.paymentDate ?? DateTime.now(),
        subtotal: payment.amount,
        taxAmount: payment.taxAmount ?? (payment.amount * 0.18), // 18% GST
        totalAmount: payment.totalAmount ?? (payment.amount * 1.18),
        items: [
          InvoiceItem(
            description: payment.typeText,
            quantity: 1,
            unitPrice: payment.amount,
            total: payment.amount,
          ),
        ],
        notes: 'Thank you for your business!',
      );

      print("============================== Invoice created: ${invoice.invoiceNumber}");

      // Navigate with invoice data
      Get.toNamed('/invoiceScreen', arguments: {'invoice': invoice});
    } else {
      print("============================== Payment not found");
      Get.snackbar(
        'No Invoice',
        'Invoice not generated for this payment',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<Payment> get pendingPayments {
    return payments.where((p) => p.status == 'pending').toList();
  }

  List<Payment> get completedPayments {
    return payments.where((p) => p.status == 'completed').toList();
  }

  List<Payment> get filteredPayments {
    if (selectedTab.value == 'pending') {
      return pendingPayments;
    } else {
      return completedPayments;
    }
  }

  double get totalPaid {
    return payments
        .where((p) => p.status == 'completed')
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  double get totalPending {
    return payments
        .where((p) => p.status == 'pending')
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  void refreshPayments() {
    loadPayments();
  }
}