import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/my_agreement_response.dart';
import 'package:signature/signature.dart';

import '../../../utils/app_config.dart';
import 'my_agreement_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'dart:convert';

class MyAgreementDetailsScreen extends StatelessWidget {
  MyAgreementDetailsScreen({super.key});

  final controller = Get.find<MyAgreementController>();
  AgreementData agreement = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: 'Agreement Details', isBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Header Card
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, double value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade700,
                      Colors.blue.shade900,
                      Colors.purple.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            agreement.agreementNumber ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            controller
                                .getStatusText(agreement.status ?? '')
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Created: ${agreement.createdAt?.split('T')[0] ?? ''}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '₹${agreement.totalPayableAmount?.toStringAsFixed(2) ?? '0'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Info Row
            Row(
              children: [
                Expanded(
                  child: _buildQuickInfoCard(
                    icon: Icons.location_on,
                    label: 'Location',
                    value: agreement.deliveryLocation ?? 'N/A',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickInfoCard(
                    icon: Icons.calendar_today,
                    label: 'Start Date',
                    value: agreement.deliveryStartDate ?? 'N/A',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickInfoCard(
                    icon: Icons.event,
                    label: 'Completion',
                    value: agreement.expectedCompletionDate ?? 'N/A',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Financial Details
            _buildAnimatedSectionCard(
              title: 'Financial Details',
              icon: Icons.attach_money,
              color: Colors.blue,
              delay: 0,
              children: [
                _buildModernDetailRow(
                  'Contract Amount',
                  '₹${agreement.contractAmount?.toStringAsFixed(2) ?? '0'}',
                  icon: Icons.currency_rupee,
                ),
                _buildModernDetailRow(
                  'Applicable Taxes',
                  '₹${agreement.applicableTaxes?.toStringAsFixed(2) ?? '0'}',
                  icon: Icons.receipt,
                ),
                const Divider(height: 24),
                _buildModernDetailRow(
                  'Total Payable',
                  '₹${agreement.totalPayableAmount?.toStringAsFixed(2) ?? '0'}',
                  isBold: true,
                  valueColor: Colors.green,
                  icon: Icons.account_balance_wallet,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Scope & Deliverables
            _buildAnimatedSectionCard(
              title: 'Scope & Deliverables',
              icon: Icons.description,
              color: Colors.teal,
              delay: 1,
              children: [
                _buildExpandableText(
                  'Scope Description',
                  agreement.scopeDescription ?? 'Not specified',
                  icon: Icons.preview,
                ),
                const SizedBox(height: 16),
                _buildExpandableText(
                  'Specifications',
                  agreement.specificationsDeliverables ?? 'Not specified',
                  icon: Icons.settings,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Milestones with Progress
            _buildAnimatedSectionCard(
              title: 'Milestones',
              icon: Icons.flag,
              color: Colors.amber,
              delay: 2,
              children: [
                _buildMilestoneProgress(
                  'Milestone 1',
                  agreement.milestone1Amount ?? 0,
                  agreement.milestone1Timeline ?? '',
                  progress: 0.33,
                ),
                const SizedBox(height: 12),
                _buildMilestoneProgress(
                  'Milestone 2',
                  agreement.milestone2Amount ?? 0,
                  agreement.milestone2Timeline ?? '',
                  progress: 0.66,
                ),
                const SizedBox(height: 12),
                _buildMilestoneProgress(
                  'Milestone 3',
                  agreement.milestone3Amount ?? 0,
                  agreement.milestone3Timeline ?? '',
                  progress: 1.0,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Legal Information
            _buildAnimatedSectionCard(
              title: 'Legal Information',
              icon: Icons.gavel,
              color: Colors.red,
              delay: 3,
              children: [
                _buildModernDetailRow(
                  'Jurisdiction Court',
                  agreement.jurisdictionCourt ?? 'Not specified',
                  icon: Icons.account_balance,
                ),
                _buildModernDetailRow(
                  'Facilitator Signatory',
                  agreement.facilitatorSignatory ?? 'Not specified',
                  icon: Icons.person,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Signatures with Modern Design
            _buildAnimatedSectionCard(
              title: 'Signatures',
              icon: Icons.edit,
              color: Colors.purple,
              delay: 4,
              children: [
                _buildSignatureStatus(
                  'Requester Signature',
                  agreement.requesterSignature,
                  'Signed by requester',
                  'Pending signature',
                ),
                const SizedBox(height: 12),
                _buildSignatureStatus(
                  'Provider Signature',
                  agreement.providerSignature,
                  'Signed by provider',
                  'Awaiting your signature',
                ),
                if (agreement.signedAt != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _buildModernDetailRow(
                      'Signed At',
                      agreement.createdAt!,
                      icon: Icons.access_time,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Center(
              child: SizedBox(
                width: 250,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      controller.downloadAgreementPdf(agreement.id ?? ''),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Download PDF'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Colors.blue.shade700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required int delay,
    required List<Widget> children,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (delay * 100)),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableText(
    String label,
    String text, {
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: const TextStyle(height: 1.5)),
        ),
      ],
    );
  }

  Widget _buildMilestoneProgress(
    String title,
    double amount,
    String timeline, {
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            timeline,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : Colors.amber,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureStatus(
    String title,
    String? signaturePath,
    String signedText,
    String pendingText,
  ) {
    final bool isSigned = signaturePath?.isNotEmpty ?? false;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSigned ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSigned ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Column(
        children: [
          /// 🔹 Top Row (Status)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSigned ? Colors.green : Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSigned ? Icons.check : Icons.pending,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      isSigned ? signedText : pendingText,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSigned
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// 🔹 Signature Image
          if (isSigned) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "${AppConfig.imageBaseUrl}$signaturePath",
                height: 80,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("Failed to load signature");
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
