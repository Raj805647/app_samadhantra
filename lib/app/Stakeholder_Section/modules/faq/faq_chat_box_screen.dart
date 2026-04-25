import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../../data/model/faq_chat_box_reponse.dart';
import 'faq_controller.dart';

  class FaqChatBoxScreen extends StatelessWidget {
    FaqChatBoxScreen({super.key});
    final controller = Get.find<FaqController>();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessageBubble(message);
                },
              )),
            ),
            _buildQuickSuggestions(),
            _buildMessageInput(),
          ],
        ),
      );
    }

    PreferredSizeWidget _buildAppBar() {
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade800,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.support_agent, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FAQ Assistant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(fontSize: 10, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildQuickSuggestions() {
      return Container(
        height: 50,
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        child: Row(
          children: [
            // Static menu button at start
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: GestureDetector(
                onTap: _showFAQSheet,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade600,
                        Colors.purple.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),

            // Scrollable suggestions
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 16),
                itemCount: controller.faqListData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => controller.sendMessage(
                      controller.faqListData[index].category ?? '',
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            size: 14,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            controller.faqListData[index].category ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildMessageBubble(ChatMessage message) {
      final isUser = message.isUser;
      final content = message.content;
      final timestamp = message.timestamp;

      return Align(
        alignment:
        isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          constraints: BoxConstraints(
            maxWidth:
            MediaQuery.of(Get.context!).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? LinearGradient(
                    colors: [
                      Colors.blue.shade600,
                      Colors.purple.shade600,
                    ],
                  )
                      : LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft:
                    Radius.circular(isUser ? 20 : 4),
                    bottomRight:
                    Radius.circular(isUser ? 4 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    color: isUser
                        ? Colors.white
                        : Colors.grey.shade800,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  _formatTime(timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildMessageInput() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your question...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              ),
            ),
          ],
        ),
      );
    }

    void _sendMessage() {
      if (controller.messageController.text.trim().isNotEmpty) {
        controller.sendMessage(controller.messageController.text.trim());
        controller.messageController.clear();
        _scrollToBottom();
      }
    }

    void _scrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.scrollController.hasClients) {
          controller.scrollController.animateTo(
            controller.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    void _showFAQSheet() {
      Get.bottomSheet(
        Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  children: controller.faqList.map((faq) {
                    return ListTile(
                      leading: Icon(Icons.question_answer, color: Colors.blue.shade600),
                      title: Text(faq['question'] ?? ''),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.back();
                        controller.sendMessage(faq['question'] ?? '');
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    }

    String _formatTime(DateTime time) {
      final now = DateTime.now();
      if (now.day == time.day) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      } else if (now.subtract(const Duration(days: 1)).day == time.day) {
        return 'Yesterday';
      }
      return '${time.day}/${time.month}';
    }
  }