import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/my_agreement/my_agreement_controller.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/my_agreement_response.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:signature/signature.dart';

class MyAgreementScreen extends StatelessWidget {
  MyAgreementScreen({super.key});
  final controller = Get.find<MyAgreementController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: 'My Agreements', isBackButton: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.agreements.isEmpty) {
          return const Center(child: CustomProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCreateAgreementCard(),
            ...controller.agreements.map(
              (agreement) => _buildAgreementCard(agreement),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCreateAgreementCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.appColor, AppColors.appColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add, color: Colors.blue),
        ),
        title: const Text(
          "Create New Agreement",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          "Quickly create and manage agreements",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Get.toNamed(
            AppRoutes.createRequiredAgreementScreen,
            arguments: {
              'reqBidId': controller.bidId.value,
              'reqId': controller.reqId.value,
              'providerUserID': controller.providerUserID.value,
            },
          );
        },
      ),
    );
  }

  Widget _buildAgreementCard(AgreementData agreement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agreement.agreementNumber ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${agreement.createdAt?.split('T')[0] ?? ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(
                            controller
                                .getStatusColor(agreement.status ?? '')
                                .substring(1, 7),
                            radix: 16,
                          ) +
                          0xFF000000,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.getStatusText(agreement.status ?? ''),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(
                        int.parse(
                              controller
                                  .getStatusColor(agreement.status ?? '')
                                  .substring(1, 7),
                              radix: 16,
                            ) +
                            0xFF000000,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content - Limited info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '₹${agreement.totalPayableAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Location
                _buildInfoRow(
                  Icons.location_on_outlined,
                  'Delivery Location',
                  agreement.deliveryLocation ?? '',
                ),
                const SizedBox(height: 12),

                // Delivery Start Date
                _buildInfoRow(
                  Icons.calendar_today,
                  'Delivery Start',
                  agreement.deliveryStartDate ?? '',
                ),
              ],
            ),
          ),

          // Single Action Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                (agreement.providerSignature == null)
                    ? showSignatureDialog(agreement.id ?? '', () {
                        Get.toNamed(
                          AppRoutes.myAgreementDetailsScreen,
                          arguments: agreement,
                        );
                      })
                    : Get.toNamed(
                        AppRoutes.myAgreementDetailsScreen,
                        arguments: agreement,
                      );
              },
              icon: const Icon(Icons.visibility),
              label: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void showSignatureDialog(String agreementId, VoidCallback onSignedSuccess) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.draw_rounded, size: 40, color: Colors.blue),

            const SizedBox(height: 12),

            const Text(
              'Signature Required',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'To view details and download the agreement PDF, please sign below. This is required.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Signature(
                controller: controller.signatureController,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.signatureController.clear();
                    },
                    child: const Text("Clear"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.signatureController.isNotEmpty) {
                        await controller.signAgreement(agreementId);

                        controller.signatureController.clear();
                        onSignedSuccess();
                        Get.back();
                      } else {
                        Get.snackbar(
                          "Required",
                          "Please sign first to continue",
                        );
                      }
                    },
                    child: const Text("Sign & Continue"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
