// lib/app/modules/service_provider/controllers/service_provider_earnings_controller.dart
import 'package:get/get.dart';

class ServiceProviderEarningsController extends GetxController {
  var isLoading = false.obs;
  var selectedPeriod = 'Monthly'.obs;
  var earningsData = {}.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  var paymentMethods = <Map<String, dynamic>>[].obs;

  final List<String> periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  void onInit() {
    super.onInit();
    loadEarningsData();
    loadTransactions();
    loadPaymentMethods();
  }

  void loadEarningsData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    earningsData.value = {
      'totalEarnings': 1250000,
      'pendingPayments': 150000,
      'thisMonth': 85000,
      'lastMonth': 72000,
      'avgPerProject': 45000,
      'growthRate': 15.5,
      'chartData': [
        {'month': 'Jan', 'earnings': 75000},
        {'month': 'Feb', 'earnings': 82000},
        {'month': 'Mar', 'earnings': 78000},
        {'month': 'Apr', 'earnings': 85000},
        {'month': 'May', 'earnings': 92000},
        {'month': 'Jun', 'earnings': 88000},
      ],
    };

    isLoading.value = false;
  }

  void loadTransactions() {
    transactions.value = [
      {
        'id': '1',
        'date': '2024-01-15',
        'description': 'Payment for Mobile App Development',
        'amount': 50000,
        'type': 'credit',
        'status': 'Completed',
        'assignmentId': 'ASG001',
        'client': 'ABC Enterprises',
      },
      {
        'id': '2',
        'date': '2024-01-10',
        'description': 'Payment for Logo Design',
        'amount': 10000,
        'type': 'credit',
        'status': 'Completed',
        'assignmentId': 'ASG002',
        'client': 'XYZ Corp',
      },
      {
        'id': '3',
        'date': '2024-01-05',
        'description': 'Payment for Website Redesign',
        'amount': 35000,
        'type': 'credit',
        'status': 'Pending',
        'assignmentId': 'ASG003',
        'client': 'Startup Co.',
      },
    ];
  }

  void loadPaymentMethods() {
    paymentMethods.value = [
      {
        'id': '1',
        'type': 'bank',
        'name': 'HDFC Bank',
        'accountNumber': 'XXXXXX1234',
        'isDefault': true,
      },
      {
        'id': '2',
        'type': 'upi',
        'name': 'Google Pay',
        'upiId': 'user@okhdfcbank',
        'isDefault': false,
      },
    ];
  }

  void addPaymentMethod(Map<String, dynamic> method) {
    paymentMethods.add(method);
    Get.snackbar('Success', 'Payment method added');
  }

  void setDefaultPaymentMethod(String id) {
    for (var method in paymentMethods) {
      method['isDefault'] = method['id'] == id;
    }
    paymentMethods.refresh();
    Get.snackbar('Success', 'Default payment method updated');
  }

  void requestPayout(double amount) {
    if (amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    Get.defaultDialog(
      title: 'Request Payout',
      middleText: 'Request payout of ₹${amount.toStringAsFixed(2)}?',
      textConfirm: 'Request',
      textCancel: 'Cancel',
      onConfirm: () {
        // Process payout request
        Get.back();
        Get.snackbar('Success', 'Payout request submitted');
      },
    );
  }

  void viewTransactionDetails(String transactionId) {
    final transaction = transactions.firstWhere((t) => t['id'] == transactionId);
    Get.toNamed('/service-provider/transaction-details', arguments: transaction);
  }
}