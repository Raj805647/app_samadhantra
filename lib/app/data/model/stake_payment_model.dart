import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Payment {
  final String id;
  final String assignmentId;
  final String assignmentTitle;
  final String? providerName;
  final double amount;
  final String type;
  final String status;
  final DateTime dueDate;
  final DateTime? paymentDate;
  final String? transactionId;
  final String? paymentMethod;
  final String? invoiceUrl;
  final String? invoiceNumber;
  final double? taxAmount;
  final double? totalAmount;
  final DateTime? createdAt;

  Payment({
    required this.id,
    required this.assignmentId,
    required this.assignmentTitle,
    this.providerName,
    required this.amount,
    required this.type,
    required this.status,
    required this.dueDate,
    this.paymentDate,
    this.transactionId,
    this.paymentMethod,
    this.invoiceUrl,
    this.invoiceNumber,
    this.taxAmount,
    this.totalAmount,
    this.createdAt,
  });

  // Add these getters to your existing Payment model
  String get formattedAmount {
    return '₹${NumberFormat('#,##0.00').format(amount)}';
  }

  String get formattedDueDate {
    return DateFormat('dd MMM yyyy').format(dueDate);
  }

  String get formattedPaymentDate {
    if (paymentDate == null) return 'Not Paid';
    return DateFormat('dd MMM yyyy').format(paymentDate!);
  }

  bool get isOverdue {
    return status == 'pending' && DateTime.now().isAfter(dueDate);
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return isOverdue ? Colors.red : Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return isOverdue ? 'OVERDUE' : 'PENDING';
      case 'processing':
        return 'PROCESSING';
      case 'completed':
        return 'PAID';
      case 'failed':
        return 'FAILED';
      case 'refunded':
        return 'REFUNDED';
      default:
        return status.toUpperCase();
    }
  }

  String get typeText {
    switch (type.toLowerCase()) {
      case 'deposit':
        return 'Deposit';
      case 'milestone':
        return 'Milestone';
      case 'final':
        return 'Final Payment';
      case 'refund':
        return 'Refund';
      default:
        return type;
    }
  }
}

class Invoice {
  final String id;
  final String paymentId;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final double subtotal;
  final double taxAmount;
  final double totalAmount;
  final String taxPercentage;
  final String gstNumber;
  final String panNumber;
  final String billingAddress;
  final String shippingAddress;
  final List<InvoiceItem> items;
  final String paymentTerms;
  final String notes;
  final String status;

  Invoice({
    required this.id,
    required this.paymentId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    this.taxPercentage = '18%',
    this.gstNumber = '27AABCU9603R1ZX',
    this.panNumber = 'AABCU9603R',
    this.billingAddress = '123 Business Street, Mumbai, Maharashtra 400001',
    this.shippingAddress = '123 Business Street, Mumbai, Maharashtra 400001',
    required this.items,
    this.paymentTerms = 'Net 30 days',
    this.notes = '',
    this.status = 'paid',
  });

  String get formattedInvoiceDate {
    return DateFormat('dd MMMM yyyy').format(invoiceDate);
  }

  String get formattedSubtotal {
    return '₹${NumberFormat('#,##0.00').format(subtotal)}';
  }

  String get formattedTaxAmount {
    return '₹${NumberFormat('#,##0.00').format(taxAmount)}';
  }

  String get formattedTotalAmount {
    return '₹${NumberFormat('#,##0.00').format(totalAmount)}';
  }
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  String get formattedUnitPrice {
    return '₹${NumberFormat('#,##0.00').format(unitPrice)}';
  }

  String get formattedTotal {
    return '₹${NumberFormat('#,##0.00').format(total)}';
  }
}