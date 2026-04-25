import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/razorpay_screen/razorpay_controller.dart';

class PaymentService extends GetxService {
  static PaymentService get to => Get.find();

  final RazorpayController _razorpayController = Get.put(RazorpayController());

  Future<void> processPayment({
    required double amount,
    required String currency,
    String? orderId,
    Map<String, dynamic>? userDetails,
  }) async {
    // You can add business logic here
    // Like creating order on your backend first

    _razorpayController.openCheckout(
      amount: amount,
      currency: currency,
      orderId: orderId,
      name: userDetails?['name'],
      email: userDetails?['email'],
      contact: userDetails?['phone'],
      description: 'Order Payment',
    );
  }

  // Call this from your backend to verify payment
  Future<bool> verifyPayment(String paymentId, String signature) async {
    // Implement verification logic with your backend
    // This should call your backend API to verify the signature
    return true;
  }
}