import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_payment_model.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen({super.key});

  final Invoice? invoice = Get.arguments?['invoice'];

  @override
  Widget build(BuildContext context) {
    if (invoice == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Invoice",
          isBackButton: true,
        ),
        body: Center(
          child: Text('Invoice not found'),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Invoice",
        isBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _downloadInvoice,
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareInvoice,
            tooltip: 'Share',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Header
            _buildInvoiceHeader(invoice!),

            const SizedBox(height: 24),

            // Invoice Details
            _buildInvoiceDetails(invoice!),

            const SizedBox(height: 24),

            // Payment Status
            _buildPaymentStatus(invoice!),

            const SizedBox(height: 32),

            // Tax Details
            _buildTaxDetails(invoice!),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildInvoiceHeader(Invoice invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INVOICE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appColor,
                  ),
                ),
                Text(
                  invoice.invoiceNumber,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Samadhantra',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Business Solutions Platform',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ${invoice.formattedInvoiceDate}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Status: ${invoice.status.toUpperCase()}',
              style: TextStyle(
                color: invoice.status == 'paid' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvoiceDetails(Invoice invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                invoice.formattedSubtotal,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST ${invoice.taxPercentage}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                invoice.formattedTaxAmount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                invoice.formattedTotalAmount,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus(Invoice invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: invoice.status == 'paid' ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: invoice.status == 'paid' ? Colors.green[100]! : Colors.orange[100]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            invoice.status == 'paid' ? Icons.check_circle : Icons.pending,
            color: invoice.status == 'paid' ? Colors.green : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.status == 'paid' ? 'Payment Successful' : 'Payment Pending',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: invoice.status == 'paid' ? Colors.green[800] : Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  invoice.status == 'paid'
                      ? 'Thank you for your payment. Invoice marked as paid.'
                      : 'Payment is pending. Please complete the payment to mark this invoice as paid.',
                  style: TextStyle(
                    fontSize: 13,
                    color: invoice.status == 'paid' ? Colors.green[600] : Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxDetails(Invoice invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TAX DETAILS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GSTIN',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    invoice.gstNumber,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PAN',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    invoice.panNumber,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax Rate',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    invoice.taxPercentage,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _shareInvoice,
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppColors.appColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _downloadInvoice,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadInvoice() {
    Get.snackbar(
      'Download Started',
      'Downloading invoice PDF...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _shareInvoice() {
    Get.snackbar(
      'Share Invoice',
      'Sharing invoice...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}