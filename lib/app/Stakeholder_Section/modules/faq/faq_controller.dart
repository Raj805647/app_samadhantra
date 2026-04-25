import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/data/model/faq_response.dart';
import 'package:flutter/material.dart';
import '../../../data/model/faq_chat_box_reponse.dart';
import '../../../utils/app_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FaqController extends GetxController {
  // =========================
  // KEEPING YOUR FAQ API DATA
  // =========================

  RxList<FAQData> faqListData = <FAQData>[].obs;
  var isHelpFull = <int, bool?>{}.obs;
  final RxInt expandedIndex = (-1).obs;
  RxString category = ''.obs;

  final int limit = 10;
  int currentPage = 0;
  bool isFirstLoad = true;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;

  // =========================
  // CHAT SECTION
  // =========================

  WebSocketChannel? channel;
  StreamSubscription? socketSubscription;

  RxBool isSocketConnected = false.obs;
  RxBool isSending = false.obs;
  RxBool isTyping = false.obs;

  final TextEditingController messageController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  RxList<ChatMessage> messages = <ChatMessage>[].obs;

  var faqList = <Map<String, String>>[].obs;

  // =========================
  // INIT
  // =========================

  @override
  void onInit() {
    super.onInit();

    getFAQListData();   // unchanged
    loadFAQs();         // unchanged
    connectWebSocket();
    addWelcomeMessage();
  }

  // =========================
  // SOCKET CONNECTION
  // =========================

  void connectWebSocket() {
    try {
      final uri = Uri.parse(
        'ws://api.samadhantra.com/api/ws/chat/session1',
      );

      print("SOCKET URL => $uri");

      channel = WebSocketChannel.connect(uri);

      isSocketConnected.value = true;

      socketSubscription = channel!.stream.listen(
        onMessageReceived,
        onDone: () {
          print("SOCKET CLOSED");
          reconnectSocket();
        },
        onError: (error) {
          print("SOCKET ERROR => $error");
          reconnectSocket();
        },
      );
    } catch (e) {
      print("SOCKET EXCEPTION => $e");
      reconnectSocket();
    }
  }

  void reconnectSocket() {
    isSocketConnected.value = false;

    Future.delayed(const Duration(seconds: 3), () {
      connectWebSocket();
    });
  }

  void onMessageReceived(dynamic data) {
    print("SOCKET MESSAGE => $data");

    messages.add(ChatMessage.fromSocket(data));

    scrollToBottom();
  }

  // =========================
  // SEND MESSAGE
  // =========================

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);

    scrollToBottom();

    try {
      isSending.value = true;

      final payload = jsonEncode({
        "message": text,
        "sessionId": "session1",
        "type": "chat",
      });

      channel?.sink.add(payload);

      messageController.clear();
    } catch (e) {
      print("SEND ERROR => $e");
    } finally {
      isSending.value = false;
    }
  }

  // =========================
  // SCROLL
  // =========================

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // =========================
  // CHAT HELPERS
  // =========================

  void addWelcomeMessage() {
    messages.add(
      ChatMessage(
        content:
        "👋 Hello! I'm your FAQ assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void clearChat() {
    messages.clear();
    addWelcomeMessage();
  }

  // =========================
  // KEEPING YOUR EXISTING FAQS
  // =========================

  void loadFAQs() {
    faqList.value = [
      {
        'question': 'How do I reset my password?',
        'answer': 'Go to Settings > Account > Reset Password...'
      },
      {
        'question': 'What payment methods are accepted?',
        'answer': 'We accept credit cards, PayPal, and Apple Pay...'
      },
      {
        'question': 'How long does shipping take?',
        'answer': 'Standard shipping takes 3-5 business days...'
      },
      {
        'question': 'Can I cancel my order?',
        'answer': 'Orders can be canceled within 1 hour of purchase...'
      },
    ];
  }

  // =========================
  // YOUR API PAGINATION (UNCHANGED)
  // =========================

  void getFAQListData({bool loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        currentPage = 0;
        hasMoreData.value = true;
        faqListData.clear();
      }

      final int skip = currentPage * limit;

      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}${AppConfig.actionFQAList}?skip=$skip&limit=$limit',
        ),
      );

      if (response.statusCode == 200) {
        final List<FAQData> newData =
        (jsonDecode(response.body)['data'] as List)
            .map((e) => FAQData.fromJson(e))
            .toList();

        if (loadMore) {
          faqListData.addAll(newData);
        } else {
          faqListData.value = newData;
        }

        if (newData.length < limit) {
          hasMoreData.value = false;
        } else {
          currentPage++;
        }
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      hasMoreData.value = false;
      debugPrint("Pagination Error: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isFirstLoad = false;
    }
  }

  void loadMoreData() {
    if (!isLoadingMore.value &&
        !isLoading.value &&
        hasMoreData.value) {
      getFAQListData(loadMore: true);
    }
  }

  // =========================
  // DISPOSE
  // =========================
  void toggleHelpful(String? id, bool isHelpful) {
    Get.snackbar(
      isHelpful ? 'Thank You!' : 'Got it!',
      isHelpful
          ? 'Thanks for your feedback! 👍'
          : 'We’ll work on improving this 👎',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isHelpful ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }

  void markHelpful(int id, bool isHelpful) {
    isHelpFull[id] = isHelpful;

    update(); // if using GetX controller

    Get.snackbar(
      'Thank You!',
      'Your feedback helps us improve',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isHelpful ? Colors.green : Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
  @override
  void onClose() {
    socketSubscription?.cancel();
    channel?.sink.close();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}