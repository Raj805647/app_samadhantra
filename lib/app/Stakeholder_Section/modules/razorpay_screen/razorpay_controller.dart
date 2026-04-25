import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayController extends GetxController {
  late Razorpay _razorpay;
  final _paymentStatus = Rx<PaymentStatus?>(null);
  final _errorMessage = RxString('');
  final _isLoading = false.obs;

  /// Optional callbacks set by caller (e.g. complete_profile) for payment result
  void Function(PaymentSuccessResponse)? _onPaymentSuccess;
  void Function(PaymentFailureResponse)? _onPaymentError;

  PaymentStatus? get paymentStatus => _paymentStatus.value;
  String get errorMessage => _errorMessage.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required double amount,
    required String currency,
    String? orderId,
    String? description,
    String? name,
    String? email,
    String? contact,
    Map<String, dynamic>? prefill,
    Map<String, dynamic>? notes,
    void Function(PaymentSuccessResponse)? onPaymentSuccess,
    void Function(PaymentFailureResponse)? onPaymentError,
  }) {
    _isLoading.value = true;
    _paymentStatus.value = null;
    _errorMessage.value = '';
    _onPaymentSuccess = onPaymentSuccess;
    _onPaymentError = onPaymentError;

    try {
      var options = <String, dynamic>{
        'key': 'rzp_live_S8OBY1RvrbL0v4', // Replace with your key
        'amount': (amount * 100).toInt(), // Convert to paise
        'currency': currency,
        'name': name ?? 'Samadhantra',
        'description': description ?? 'Payment',
        'prefill': {
          'contact': contact ?? '',
          'email': email ?? '',
          if (prefill != null) ...prefill,
        },
        'notes': notes ?? {},
        'theme': {
          'color': '#007AFF',
          'hide_topbar': false,
        },
      };
      if (orderId != null && orderId.isNotEmpty) {
        options['order_id'] = orderId;
      }

      // Remove null/empty values from options
      options.removeWhere((key, value) => value == null);

      _razorpay.open(options);
    } catch (e) {
      _errorMessage.value = 'Error: ${e.toString()}';
      _isLoading.value = false;
      _onPaymentSuccess = null;
      _onPaymentError = null;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _isLoading.value = false;
    _paymentStatus.value = PaymentStatus.success;

    final callback = _onPaymentSuccess;
    _onPaymentSuccess = null;
    _onPaymentError = null;
    callback?.call(response);

    Get.snackbar(
      'Success',
      'Payment successful: ${response.paymentId}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _isLoading.value = false;
    _paymentStatus.value = PaymentStatus.failed;
    _errorMessage.value = 'Error: ${response.code} - ${response.message}';

    final callback = _onPaymentError;
    _onPaymentSuccess = null;
    _onPaymentError = null;
    callback?.call(response);

    Get.snackbar(
      'Payment Failed',
      'Error: ${response.message}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _isLoading.value = false;
    Get.snackbar(
      'External Wallet',
      'Selected wallet: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearPaymentStatus() {
    _paymentStatus.value = null;
    _errorMessage.value = '';
  }
}

enum PaymentStatus {
  success,
  failed,
  processing,
}