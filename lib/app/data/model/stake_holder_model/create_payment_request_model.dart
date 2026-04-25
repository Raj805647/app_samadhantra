// models/payment_models.dart
class CreatePaymentRequest {
  final String userId;
  final String userType;
  final String paymentType;
  final double amountInr;
  final String currency;
  final String receipt;

  CreatePaymentRequest({
    required this.userId,
    required this.userType,
    required this.paymentType,
    required this.amountInr,
    required this.currency,
    required this.receipt,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_type': userType,
    'payment_type': paymentType,
    'amount_inr': amountInr,
    'currency': currency,
    'receipt': receipt,
  };
}

class CreatePaymentResponse {
  final String orderId;
  final String razorpayKey;
  final double amount;
  final String currency;
  final String receipt;
  final String status;

  CreatePaymentResponse({
    required this.orderId,
    required this.razorpayKey,
    required this.amount,
    required this.currency,
    required this.receipt,
    required this.status,
  });

  factory CreatePaymentResponse.fromJson(Map<String, dynamic> json) {
    return CreatePaymentResponse(
      orderId: json['order_id'] ?? json['id'] ?? '',
      razorpayKey: json['razorpay_key'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'INR',
      receipt: json['receipt'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class VerifyPaymentRequest {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  VerifyPaymentRequest({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() => {
    'razorpay_order_id': razorpayOrderId,
    'razorpay_payment_id': razorpayPaymentId,
    'razorpay_signature': razorpaySignature,
  };
}

class VerifyPaymentResponse {
  final bool success;
  final String message;
  final String paymentId;
  final String orderId;
  final double amount;

  VerifyPaymentResponse({
    required this.success,
    required this.message,
    required this.paymentId,
    required this.orderId,
    required this.amount,
  });

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      paymentId: json['payment_id'] ?? '',
      orderId: json['order_id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}