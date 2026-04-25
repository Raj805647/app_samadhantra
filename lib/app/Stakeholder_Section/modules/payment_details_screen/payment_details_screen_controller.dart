import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_payment_model.dart';
import 'package:samadhantra/app/constant/app_color.dart';

class PaymentDetailController extends GetxController {
  final Rx<Payment?> payment = Rx<Payment?>(null);
  final Rx<Invoice?> invoice = Rx<Invoice?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  String? paymentId;

  @override
  void onInit() {
    super.onInit();
    getPaymentIdFromRoute();
  }

  void getPaymentIdFromRoute() {
    final dynamic args = Get.arguments;

    if (args is Map<String, dynamic>) {
      paymentId = args['paymentId']?.toString();
    }

    if (paymentId != null && paymentId!.isNotEmpty) {
      loadPaymentDetails(paymentId!);
    } else {
      errorMessage.value = 'Payment ID not found';
    }
  }

  Future<void> loadPaymentDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - In real app, fetch from API
      final mockPayments = {
        '1': Payment(
          id: '1',
          assignmentId: '1',
          assignmentTitle: 'Mobile App Development',
          providerName: 'Tech Solutions Inc.',
          amount: 15000.00,
          type: 'deposit',
          status: 'completed',
          dueDate: DateTime.now().subtract(const Duration(days: 10)),
          paymentDate: DateTime.now().subtract(const Duration(days: 11, hours: 2)),
          transactionId: 'TXN1234567890',
          paymentMethod: 'Credit Card (**** 1234)',
          invoiceUrl: 'https://example.com/invoice1.pdf',
          invoiceNumber: 'INV-2024-001',
          taxAmount: 2700.00,
          totalAmount: 17700.00,
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
        ),
        '2': Payment(
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
        '3': Payment(
          id: '3',
          assignmentId: '2',
          assignmentTitle: 'UI/UX Design',
          providerName: 'Design Studio Pro',
          amount: 20000.00,
          type: 'final',
          status: 'completed',
          dueDate: DateTime.now().subtract(const Duration(days: 20)),
          paymentDate: DateTime.now().subtract(const Duration(days: 21)),
          transactionId: 'TXN7890123456',
          paymentMethod: 'Bank Transfer',
          invoiceUrl: 'https://example.com/invoice2.pdf',
          invoiceNumber: 'INV-2024-002',
          taxAmount: 3600.00,
          totalAmount: 23600.00,
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
        '4': Payment(
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
        '5': Payment(
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
        '6': Payment(
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
      };

      payment.value = mockPayments[id];

      if (payment.value != null) {
        // Generate invoice data
        if (payment.value!.status == 'completed' || payment.value!.status == 'refunded') {
          invoice.value = Invoice(
            id: 'inv_$id',
            paymentId: id,
            invoiceNumber: payment.value!.invoiceNumber ?? 'INV-${DateTime.now().millisecondsSinceEpoch}',
            invoiceDate: payment.value!.paymentDate ?? DateTime.now(),
            subtotal: payment.value!.amount,
            taxAmount: payment.value!.taxAmount ?? 0.0,
            totalAmount: payment.value!.totalAmount ?? payment.value!.amount,
            items: [
              InvoiceItem(
                description: payment.value!.typeText,
                quantity: 1,
                unitPrice: payment.value!.amount,
                total: payment.value!.amount,
              ),
            ],
            notes: 'Thank you for your business!',
          );
        }
      } else {
        errorMessage.value = 'Payment not found';
      }

    } catch (e) {
      errorMessage.value = 'Failed to load payment details: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void initiatePayment() {
    if (payment.value != null && payment.value!.status == 'pending') {
      Get.defaultDialog(
        title: 'Make Payment',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Amount: ${payment.value!.formattedAmount}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Due Date: ${payment.value!.formattedDueDate}',
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
                      processPayment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor,
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

  void processPayment() {
    if (payment.value != null) {
      final updatedPayment = Payment(
        id: payment.value!.id,
        assignmentId: payment.value!.assignmentId,
        assignmentTitle: payment.value!.assignmentTitle,
        providerName: payment.value!.providerName,
        amount: payment.value!.amount,
        type: payment.value!.type,
        status: 'processing',
        dueDate: payment.value!.dueDate,
        paymentDate: DateTime.now(),
        transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        paymentMethod: 'Credit Card',
        invoiceNumber: payment.value!.invoiceNumber,
        taxAmount: payment.value!.taxAmount,
        totalAmount: payment.value!.totalAmount,
        createdAt: payment.value!.createdAt,
      );

      payment.value = updatedPayment;

      Get.snackbar(
        'Payment Initiated',
        'Your payment is being processed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Simulate payment completion
      Future.delayed(const Duration(seconds: 2), () {
        final completedPayment = Payment(
          id: payment.value!.id,
          assignmentId: payment.value!.assignmentId,
          assignmentTitle: payment.value!.assignmentTitle,
          providerName: payment.value!.providerName,
          amount: payment.value!.amount,
          type: payment.value!.type,
          status: 'completed',
          dueDate: payment.value!.dueDate,
          paymentDate: payment.value!.paymentDate,
          transactionId: payment.value!.transactionId,
          paymentMethod: payment.value!.paymentMethod,
          invoiceNumber: payment.value!.invoiceNumber,
          taxAmount: payment.value!.taxAmount,
          totalAmount: payment.value!.totalAmount,
          createdAt: payment.value!.createdAt,
        );

        payment.value = completedPayment;
      });
    }
  }

  void viewInvoice() {
    if (invoice.value != null) {
      Get.toNamed(
        '/invoice',
        arguments: {'invoice': invoice.value},
      );
    }
  }

  void reload() {
    if (paymentId != null) {
      loadPaymentDetails(paymentId!);
    }
  }
}