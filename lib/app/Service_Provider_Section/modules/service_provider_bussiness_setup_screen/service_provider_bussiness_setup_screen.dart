// lib/app/modules/service_provider/views/service_provider_business_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_bussiness_setup_screen/service_provider_bussiness_setup_screen_controller.dart';


class ServiceProviderBusinessSetupScreen extends StatelessWidget {
  final ServiceProviderBusinessSetupController controller = Get.put(ServiceProviderBusinessSetupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
      ),
      body: Obx(() => Stepper(
        currentStep: controller.currentSetupStep.value,
        onStepContinue: controller.nextStep,
        onStepCancel: controller.previousStep,
        controlsBuilder: (context, details) {
          return Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                if (controller.currentSetupStep.value > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: Text('Back'),
                    ),
                  ),
                if (controller.currentSetupStep.value > 0) SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(
                      controller.currentSetupStep.value == 3 ? 'Finish Setup' : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: Text('Portfolio'),
            content: _buildPortfolioStep(),
            isActive: controller.currentSetupStep.value >= 0,
          ),
          Step(
            title: Text('Certifications'),
            content: _buildCertificationsStep(),
            isActive: controller.currentSetupStep.value >= 1,
          ),
          Step(
            title: Text('Payment Methods'),
            content: _buildPaymentMethodsStep(),
            isActive: controller.currentSetupStep.value >= 2,
          ),
          Step(
            title: Text('Bank Details'),
            content: _buildBankDetailsStep(),
            isActive: controller.currentSetupStep.value >= 3,
          ),
        ],
      )),
    );
  }

  Widget _buildPortfolioStep() {
    return Column(
      children: [
        Text(
          'Add your portfolio items to showcase your work',
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 20),
        Obx(() => Column(
          children: controller.portfolioItems.map((item) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.work),
                title: Text(item['title'] ?? ''),
                subtitle: Text(item['description'] ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.portfolioItems.remove(item),
                ),
              ),
            );
          }).toList(),
        )),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => _addPortfolioItem(),
          icon: Icon(Icons.add),
          label: Text('Add Portfolio Item'),
        ),
      ],
    );
  }

  Widget _buildCertificationsStep() {
    return Column(
      children: [
        Text(
          'Add your certifications and qualifications',
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 20),
        Obx(() => Column(
          children: controller.certifications.map((cert) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.verified),
                title: Text(cert['name'] ?? ''),
                subtitle: Text('Issued by: ${cert['issuer']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.certifications.remove(cert),
                ),
              ),
            );
          }).toList(),
        )),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => _addCertification(),
          icon: Icon(Icons.add),
          label: Text('Add Certification'),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsStep() {
    return Column(
      children: [
        Text(
          'Add your preferred payment methods',
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 20),
        Obx(() => Column(
          children: controller.paymentMethods.map((method) {
            return Card(
              child: ListTile(
                leading: Icon(_getPaymentMethodIcon(method['type'])),
                title: Text(method['name'] ?? ''),
                subtitle: Text(method['details'] ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.paymentMethods.remove(method),
                ),
              ),
            );
          }).toList(),
        )),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () => _addBankAccount(),
              icon: Icon(Icons.account_balance),
              label: Text('Bank Account'),
            ),
            ElevatedButton.icon(
              onPressed: () => _addUPI(),
              icon: Icon(Icons.payment),
              label: Text('UPI'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBankDetailsStep() {
    return Column(
      children: [
        Text(
          'Add your bank account for payments',
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Account Holder Name *',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => controller.accountName.value = value,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Account Number *',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => controller.accountNumber.value = value,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'IFSC Code *',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => controller.ifscCode.value = value,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Bank Name *',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => controller.bankName.value = value,
        ),
      ],
    );
  }

  IconData _getPaymentMethodIcon(String type) {
    switch (type) {
      case 'bank':
        return Icons.account_balance;
      case 'upi':
        return Icons.payment;
      default:
        return Icons.credit_card;
    }
  }

  void _addPortfolioItem() {
    Get.dialog(
      AlertDialog(
        title: Text('Add Portfolio Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Project Title'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add portfolio item
              Get.back();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addCertification() {
    Get.dialog(
      AlertDialog(
        title: Text('Add Certification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Certification Name'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Issuing Organization'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add certification
              Get.back();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addBankAccount() {
    // Implement bank account addition
  }

  void _addUPI() {
    // Implement UPI addition
  }
}