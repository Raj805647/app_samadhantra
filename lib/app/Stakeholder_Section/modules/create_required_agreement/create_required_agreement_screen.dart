import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/create_required_agreement/create_required_agreement_controller.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../constant/app_color.dart';

class CreateRequiredAgreementScreen extends StatelessWidget {
  CreateRequiredAgreementScreen({super.key});
  final controller = Get.find<CreateRequiredAgreementController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create Require Agreement',
        isBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),
            const SizedBox(height: 24),

            // Agreement Details Section
            _buildSectionTitle(
              title: "Agreement Details",
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),
            _buildAgreementDetailsSection(),
            const SizedBox(height: 24),

            // Financial Section
            _buildSectionTitle(
              title: "Financial Details",
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 16),
            _buildFinancialSection(),
            const SizedBox(height: 24),

            // Milestone Section
            _buildSectionTitle(
              title: "Payment Milestones",
              icon: Icons.timeline,
            ),
            const SizedBox(height: 16),
            _buildMilestoneSection(),
            const SizedBox(height: 24),

            // Timeline Section
            _buildSectionTitle(
              title: "Project Timeline",
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildTimelineSection(),
            const SizedBox(height: 24),

            // Legal Section
            _buildSectionTitle(title: "Legal Information", icon: Icons.gavel),
            const SizedBox(height: 16),
            _buildLegalSection(),
            const SizedBox(height: 24),

            // Signature Section
            _buildSectionTitle(title: "Signatures", icon: Icons.edit_note),
            const SizedBox(height: 16),
            _buildSignatureSection(),
            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.appColor, AppColors.appColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.appColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment_turned_in,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "New Agreement",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Fill in the details below to create a new requirement agreement",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.appColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.appColor),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAgreementDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          CustomTextFormField(
            hintText: "Scope Description",
            controller: controller.scopeDescriptionController,
            prefixIcon: Icons.description,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hintText: "Specifications & Deliverables",
            controller: controller.specificationsDeliverablesController,
            prefixIcon: Icons.checklist,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hintText: "Delivery Location",
            controller: controller.deliveryLocationController,
            prefixIcon: Icons.location_on_outlined,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          CustomTextFormField(
            hintText: "Contract Amount",
            controller: controller.contractAmountController,
            prefixIcon: Icons.currency_rupee,
            keyboardType: TextInputType.number,
            // formatter: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => controller.calculateTotalPayable(),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hintText: "Applicable Taxes",
            controller: controller.applicableTaxesController,
            prefixIcon: Icons.receipt,
            keyboardType: TextInputType.number,
            // formatter: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => controller.calculateTotalPayable(),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.green.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Payable Amount:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "₹${NumberFormat('#,##,###').format(controller.totalPayableAmount.value)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildMilestoneCard(
            title: "Milestone 1",
            amountController: controller.milestone1AmountController,
            timelineValue: controller.milestone1Timeline,
            timelineHint: "On signing",
          ),
          const SizedBox(height: 16),
          _buildMilestoneCard(
            title: "Milestone 2",
            amountController: controller.milestone2AmountController,
            timelineValue: controller.milestone2Timeline,
            timelineHint: "As per progress",
          ),
          const SizedBox(height: 16),
          _buildMilestoneCard(
            title: "Milestone 3",
            amountController: controller.milestone3AmountController,
            timelineValue: controller.milestone3Timeline,
            timelineHint: "On completion",
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard({
    required String title,
    required TextEditingController amountController,
    required RxString timelineValue,
    required String timelineHint,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.appColor,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextFormField(
            hintText: "Amount (₹)",
            controller: amountController,
            prefixIcon: Icons.currency_rupee,
            keyboardType: TextInputType.number,
            // formatter: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),
          Obx(
            () => CustomTextFormField(
              hintText: timelineHint,
              controller: TextEditingController(text: timelineValue.value),
              prefixIcon: Icons.timeline,
              readOnly: true,
              onTap: () => _showTimelinePicker(timelineValue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          CustomTextFormField(
            hintText: "Delivery Start Date",
            controller: controller.deliveryStartDateController,
            prefixIcon: Icons.play_circle_outline,
            readOnly: true,
            onTap: () => _selectDate(controller.deliveryStartDateController),
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hintText: "Expected Completion Date",
            controller: controller.expectedCompletionDateController,
            prefixIcon: Icons.check_circle_outline,
            readOnly: true,
            onTap: () =>
                _selectDate(controller.expectedCompletionDateController),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          CustomTextFormField(
            hintText: "Jurisdiction Court",
            controller: controller.jurisdictionCourtController,
            prefixIcon: Icons.account_balance,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildDigitalSignature(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: AppColors.appColor, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Facilitator Signatory: Samadhantra Authorized Signatory",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalSignature() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Digital Signature',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Signature(
                controller: controller.signatureController,
                backgroundColor: Colors.white,
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => controller.signatureController.clear(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.submitAgreement(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: AppColors.appColor,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  "Create Agreement",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _showTimelinePicker(RxString timelineValue) {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Timeline",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit_note),
                title: const Text("On signing"),
                onTap: () {
                  timelineValue.value = "On signing";
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.engineering),
                title: const Text("As per progress"),
                onTap: () {
                  timelineValue.value = "As per progress";
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.celebration),
                title: const Text("On completion"),
                onTap: () {
                  timelineValue.value = "On completion";
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
