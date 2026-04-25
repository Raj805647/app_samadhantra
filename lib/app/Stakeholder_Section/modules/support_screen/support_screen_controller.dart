import 'package:flutter/material.dart' show Colors;
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_support_ticket_model.dart';

class SupportController extends GetxController {
  static SupportController get instance => Get.find();

  final RxList<SupportTicket> tickets = <SupportTicket>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedTicketId = ''.obs;
  final Rx<SupportTicket?> selectedTicket = null.obs;

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  void loadTickets() {
    isLoading.value = true;

    tickets.value = [
      SupportTicket(
        id: '1',
        title: 'Payment not reflecting in account',
        description: 'I made a payment 2 days ago but it\'s not showing in my account.',
        category: 'billing',
        priority: 'high',
        status: 'in-progress',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now().subtract(Duration(hours: 3)),
        assignedTo: 'Support Agent #123',
        messages: [
          TicketMessage(
            id: '1',
            senderType: 'user',
            senderName: 'You',
            message: 'I made a payment 2 days ago but it\'s not reflecting.',
            timestamp: DateTime.now().subtract(Duration(days: 2)),
          ),
          TicketMessage(
            id: '2',
            senderType: 'support',
            senderName: 'Support Agent',
            message: 'We\'re looking into this issue. Please share your transaction ID.',
            timestamp: DateTime.now().subtract(Duration(days: 1)),
          ),
        ],
      ),
      SupportTicket(
        id: '2',
        title: 'Unable to upload documents',
        description: 'Getting error while trying to upload project documents.',
        category: 'technical',
        priority: 'medium',
        status: 'open',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        assignedTo: null,
        messages: [],
      ),
      SupportTicket(
        id: '3',
        title: 'Provider assignment delay',
        description: 'It\'s been 3 days but no provider assigned yet.',
        category: 'general',
        priority: 'medium',
        status: 'resolved',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        assignedTo: 'Support Agent #456',
        messages: [],
      ),
    ];

    isLoading.value = false;
  }

  void createTicket({
    required String title,
    required String description,
    required String category,
    required String priority,
  }) {
    final newTicket = SupportTicket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      priority: priority,
      status: 'open',
      createdAt: DateTime.now(),
      messages: [],
    );

    tickets.insert(0, newTicket);

    Get.back();
    Get.snackbar(
      'Ticket Created',
      'Your support ticket has been created successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void sendMessage(String ticketId, String message) {
    final ticket = tickets.firstWhere((t) => t.id == ticketId);
    final newMessage = TicketMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderType: 'user',
      senderName: 'You',
      message: message,
      timestamp: DateTime.now(),
    );

    // Update ticket
    final index = tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final updatedTicket = SupportTicket(
        id: ticket.id,
        title: ticket.title,
        description: ticket.description,
        category: ticket.category,
        priority: ticket.priority,
        status: ticket.status,
        createdAt: ticket.createdAt,
        updatedAt: DateTime.now(),
        assignedTo: ticket.assignedTo,
        messages: [...ticket.messages, newMessage],
      );

      tickets[index] = updatedTicket;
      selectedTicket.value = updatedTicket;
    }
  }

  List<SupportTicket> get openTickets {
    return tickets.where((t) => t.status != 'resolved' && t.status != 'closed').toList();
  }

  List<SupportTicket> get resolvedTickets {
    return tickets.where((t) => t.status == 'resolved' || t.status == 'closed').toList();
  }
}