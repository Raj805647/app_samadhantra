import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/provider_requester_chatting_response.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import '../../../constant/token_storage_service.dart';
import '../../../data/model/chat_session_response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'dart:async';

import '../../../data/model/stake_holder_model/my_requirements_model.dart';

class MessageDetailsController extends GetxController {
  final apiService = ApiService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  RxList<Messages> historyChatList = <Messages>[].obs;
  Rx<ChattingListData> chattingLists = ChattingListData().obs;
  RxString userId = ''.obs;
  RxString requirementName = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isSocketConnected = false.obs;
  RxBool isSend = false.obs;

  WebSocketChannel? channel;
  StreamSubscription? socketSubscription;

  @override
  void onInit() async {
    super.onInit();
    chattingLists.value = Get.arguments ?? chattingLists();
    userId.value = await TokenService.getUserId() ?? '';
    await loadChatHistory();
     fetchRequirement();
    connectWebSocket();
  }

  void connectWebSocket() {
    try {
      final uri = Uri(
        scheme: 'ws',
        host: 'api.samadhantra.com',
        path: '/api/ws/requirement-chat/${chattingLists.value.sessionId}',
        queryParameters: {
          'user_id': userId.value.trim(),
          'token': chattingLists.value.accessToken,
        },
      );

      print("SOCKET URL => $uri");

      channel = WebSocketChannel.connect(uri);

      isSocketConnected.value = true;

      channel!.stream.listen(
        (message) {
          print("MESSAGE => $message");
          _handleIncomingMessage(message);
        },
        onDone: () {
          print("SOCKET CLOSED");
        },
        onError: (error) {
          print("SOCKET ERROR => $error");
        },
      );
    } catch (e) {
      print("SOCKET EXCEPTION => $e");
    }
  }

  void reconnectSocket() {
    isSocketConnected.value = false;

    Future.delayed(const Duration(seconds: 2), () {
      connectWebSocket();
    });
  }

  void _handleIncomingMessage(dynamic data) async {
    try {
      print("SOCKET MESSAGE => $data");

      /// Reload full chat history whenever message received
       refreshHistoryWithDelay();

      scrollToBottom();
    } catch (e) {
      print("Socket parse error: $e");
    }
  }

  void sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty || channel == null) return;

    channel!.sink.add(text);

    messageController.clear();
    isSend.value = false;

    refreshHistoryWithDelay();
    scrollToBottom();
  }

  Timer? _historyRefreshTimer;

  void refreshHistoryWithDelay() {
    _historyRefreshTimer?.cancel();

    _historyRefreshTimer = Timer(
      const Duration(milliseconds: 500),
          () async {
        await loadChatHistory();
        scrollToBottom();
      },
    );
  }

  Future<void> loadChatHistory() async {
    try {
      final url = Uri.parse(
        "https://api.samadhantra.com/api/chat/history/${chattingLists.value.sessionId}"
        "?token=${chattingLists.value.accessToken}",
      );
      print(url);

      final response = await http.get(url);

      final data = jsonDecode(response.body);
      print('akjdbfkjbsadbf=>$data');

      final messages = data["data"]["messages"] ?? [];

      historyChatList.value = messages
          .map<Messages>((e) => Messages.fromJson(e))
          .toList();

      Future.delayed(const Duration(milliseconds: 300), scrollToBottom);
    } catch (e) {
      print("History error: $e");
    }
  }

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

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    socketSubscription?.cancel();
    channel?.sink.close();
    super.onClose();
  }

  void fetchRequirement() async {
    try {
      final response = await apiService.get(
        AppConfig.getrequirementDetailByIdUrl(
          chattingLists.value.requirementId,
        ),
      );
      print('akjdfbhsabhfbsda=> ${response.data}');
      requirementName.value = MyRequirementData.fromJson(response.data['data']).requirementCategory ?? '';

    } catch (error) {
      print('akdjbfkbsdhbfds=> $error');
    }
  }
}
