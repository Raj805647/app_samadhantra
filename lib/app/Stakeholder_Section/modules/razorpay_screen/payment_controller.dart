// // controllers/payment_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../services/api_service.dart';
// import '../models/payment_models.dart';
//
// class PaymentController extends GetxController {
//   final ApiService _apiService = Get.find();
//   late Razorpay _razorpay;
//
//   final _isLoading = false.obs;
//   final _paymentStatus = Rx<PaymentStatus?>(null);
//   final _errorMessage = RxString('');
//   final _currentOrderId = RxString('');
//   final _currentPaymentType = RxString('');
//
//   bool get isLoading => _isLoading.value;
//   PaymentStatus? get paymentStatus => _paymentStatus.value;
//   String get errorMessage => _errorMessage.value;
//   String get currentOrderId => _currentOrderId.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeRazorpay();
//   }
//
//   @override
//   void onClose() {
//     _razorpay.clear();
//     super.onClose();
//   }
//
//   void _initializeRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   // Main payment initiation method
//   Future<void> initiatePayment({
//     required String userId,
//     required String userType,
//     required String paymentType,
//     required double amountInr,
//     String currency = 'INR',
//     Map<String, dynamic>? prefillData,
//     Map<String, dynamic>? notes,
//   }) async {
//     _isLoading.value = true;
//     _paymentStatus.value = null;
//     _errorMessage.value = '';
//     _currentPaymentType.value = paymentType;
//
//     try {
//       // 1. Create order on backend
//       final orderResponse = await _apiService.createPaymentOrder(
//         userId: userId,
//         userType: userType,
//         paymentType: paymentType,
//         amountInr: amountInr,
//         currency: currency,
//       );
//
//       _currentOrderId.value = orderResponse.orderId;
//
//       // 2. Open Razorpay checkout
//       final options = {
//         'key': orderResponse.razorpayKey,
//         'amount': (amountInr * 100).toInt(), // Convert to paise
//         'currency': orderResponse.currency,
//         'name': 'Your App Name',
//         'description': '${paymentType.replaceAll('_', ' ').toTitleCase()} Payment',
//         'order_id': orderResponse.orderId,
//         'prefill': {
//           'contact': prefillData?['phone'] ?? '',
//           'email': prefillData?['email'] ?? '',
//           'name': prefillData?['name'] ?? '',
//         },
//         'notes': {
//           'user_id': userId,
//           'user_type': userType,
//           'payment_type': paymentType,
//           'receipt': orderResponse.receipt,
//           ...?notes,
//         },
//         'theme': {
//           'color': '#007AFF',
//         },
//       };
//
//       _razorpay.open(options);
//     } catch (e) {
//       _isLoading.value = false;
//       _errorMessage.value = 'Failed to initiate payment: $e';
//
//       Get.snackbar(
//         'Error',
//         _errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     try {
//       _paymentStatus.value = PaymentStatus.processing;
//
//       // 1. Verify payment with backend
//       final verification = await _apiService.verifyPayment(
//         orderId: response.orderId!,
//         paymentId: response.paymentId!,
//         signature: response.signature!,
//       );
//
//       if (verification.success) {
//         // 2. Save payment details to database
//         await _apiService.savePaymentDetails(
//           userId: response.notes?['user_id'] ?? '',
//           orderId: response.orderId!,
//           paymentId: response.paymentId!,
//           paymentType: _currentPaymentType.value,
//           amount: (response.amount! / 100), // Convert back from paise
//           status: 'success',
//         );
//
//         _paymentStatus.value = PaymentStatus.success;
//
//         Get.snackbar(
//           'Payment Successful',
//           'Your payment was processed successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//
//         // Navigate to success screen or refresh user subscription
//         _handlePaymentSuccessNavigation();
//       } else {
//         _handleVerificationFailed(response, verification.message);
//       }
//     } catch (e) {
//       _handlePaymentError(PaymentFailureResponse(
//         code: 500,
//         message: 'Verification failed: $e',
//       ));
//     } finally {
//       _isLoading.value = false;
//     }
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     _isLoading.value = false;
//     _paymentStatus.value = PaymentStatus.failed;
//     _errorMessage.value = 'Error ${response.code}: ${response.message}';
//
//     Get.snackbar(
//       'Payment Failed',
//       _errorMessage.value,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Get.snackbar(
//       'Redirecting',
//       'Opening ${response.walletName}',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   void _handleVerificationFailed(
//       PaymentSuccessResponse response,
//       String message,
//       ) {
//     _paymentStatus.value = PaymentStatus.failed;
//     _errorMessage.value = 'Payment verification failed: $message';
//
//     // Save as failed payment in database
//     _apiService.savePaymentDetails(
//       userId: response.notes?['user_id'] ?? '',
//       orderId: response.orderId!,
//       paymentId: response.paymentId!,
//       paymentType: _currentPaymentType.value,
//       amount: (response.amount! / 100),
//       status: 'verification_failed',
//     );
//
//     Get.snackbar(
//       'Verification Failed',
//       _errorMessage.value,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
//   }
//
//   void _handlePaymentSuccessNavigation() {
//     // Handle navigation based on payment type
//     switch (_currentPaymentType.value) {
//       case 'subscription':
//         Get.offAllNamed('/subscription-success');
//         break;
//       case 'course_purchase':
//         Get.offAllNamed('/course-access');
//         break;
//       default:
//         Get.offAllNamed('/payment-success');
//     }
//   }
//
//   void retryPayment() {
//     _paymentStatus.value = null;
//     _errorMessage.value = '';
//   }
// }
//
// enum PaymentStatus {
//   processing,
//   success,
//   failed,
// }
//
// // Extension for string formatting
// extension StringExtension on String {
//   String toTitleCase() {
//     return split(' ').map((word) {
//       if (word.isEmpty) return word;
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).join(' ');
//   }
// }