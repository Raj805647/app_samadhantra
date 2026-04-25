import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/bottom_nav_screen/bottom_nav_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/home_screen/home_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/razorpay_screen/razorpay_controller.dart';

class PaymentScreen extends StatelessWidget {
  final RazorpayController _controller = Get.put(RazorpayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              if (_controller.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (_controller.paymentStatus == PaymentStatus.success) {
                return PaymentSuccessWidget();
              }

              if (_controller.paymentStatus == PaymentStatus.failed) {
                return PaymentFailedWidget(
                  error: _controller.errorMessage,
                  onRetry: () => _controller.clearPaymentStatus(),
                );
              }

              return PaymentForm();
            }),
          ],
        ),
      ),
    );
  }
}

class PaymentForm extends StatelessWidget {
  final RazorpayController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Total Amount: ₹500',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'Order #ORD123456',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            _controller.openCheckout(
              amount: 500.0,
              currency: 'INR',
              name: 'John Doe',
              email: 'john@example.com',
              contact: '+919876543210',
              description: 'Purchase of Product XYZ',
              notes: {
                'order_id': 'ORD123456',
                'product_id': 'PROD123',
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Pay Now',
              style: TextStyle(fontSize: 18),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Secure payment powered by Razorpay',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class PaymentSuccessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 80),
        SizedBox(height: 20),
        Text(
          'Payment Successful!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Your payment has been processed successfully.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Get.offAll(() => BottomNavScreen()); // Navigate to home
          },
          child: Text('Continue Shopping'),
        ),
      ],
    );
  }
}

class PaymentFailedWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  PaymentFailedWidget({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Colors.red, size: 80),
        SizedBox(height: 20),
        Text(
          'Payment Failed',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: onRetry,
              child: Text('Try Again'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ],
    );
  }
}