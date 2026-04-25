// // screens/subscription_payment_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/payment_controller.dart';
//
// class SubscriptionPaymentScreen extends StatelessWidget {
//   final PaymentController _controller = Get.find();
//   final String userId;
//   final String userType;
//   final double amount;
//   final String planName;
//
//   SubscriptionPaymentScreen({
//     Key? key,
//     required this.userId,
//     required this.userType,
//     required this.amount,
//     required this.planName,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Subscribe to $planName'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Obx(() {
//         if (_controller.isLoading) {
//           return _buildLoadingView();
//         }
//
//         if (_controller.paymentStatus == PaymentStatus.success) {
//           return _buildSuccessView();
//         }
//
//         if (_controller.paymentStatus == PaymentStatus.failed) {
//           return _buildFailedView();
//         }
//
//         return _buildPaymentView();
//       }),
//     );
//   }
//
//   Widget _buildLoadingView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 20),
//           Text('Processing your payment...'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentView() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Plan Details
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     planName,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Monthly Subscription',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Amount',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         '₹$amount',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           SizedBox(height: 30),
//
//           // Features
//           Text(
//             'Features included:',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           _buildFeature('✓ Unlimited course access'),
//           _buildFeature('✓ Download study materials'),
//           _buildFeature('✓ Live doubt sessions'),
//           _buildFeature('✓ Certificate of completion'),
//
//           Spacer(),
//
//           // Payment Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 _controller.initiatePayment(
//                   userId: userId,
//                   userType: userType,
//                   paymentType: 'subscription',
//                   amountInr: amount,
//                   prefillData: {
//                     'name': 'Student Name', // Get from user profile
//                     'email': 'student@example.com',
//                     'phone': '+919876543210',
//                   },
//                   notes: {
//                     'plan_name': planName,
//                     'plan_duration': 'monthly',
//                   },
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Subscribe Now',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 10),
//
//           Text(
//             'By subscribing, you agree to our Terms of Service and Privacy Policy',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeature(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(Icons.check_circle, color: Colors.green, size: 20),
//           SizedBox(width: 10),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSuccessView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.check_circle, color: Colors.green, size: 80),
//             SizedBox(height: 20),
//             Text(
//               'Subscription Activated!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Your subscription has been successfully activated.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Order ID: ${_controller.currentOrderId}',
//               style: TextStyle(fontFamily: 'monospace', fontSize: 12),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 Get.offAllNamed('/dashboard');
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 child: Text('Go to Dashboard'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFailedView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, color: Colors.red, size: 80),
//             SizedBox(height: 20),
//             Text(
//               'Payment Failed',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Obx(() => Text(
//               _controller.errorMessage,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             )),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 OutlinedButton(
//                   onPressed: () => _controller.retryPayment(),
//                   child: Text('Try Again'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () => Get.back(),
//                   child: Text('Choose Another Plan'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }