import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import '../../../data/model/chat_session_response.dart';
import 'message_details_screen_controller.dart';

class MessageDetailsScreen extends StatelessWidget {
  MessageDetailsScreen({super.key});

  final controller = Get.put(MessageDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppbar(),
      body: _buildChattingList(),
      bottomSheet: _buildChattingField(),
    );
  }

  Widget _buildChattingList() {
    return Obx(() {
      if (controller.isLoading.value && controller.historyChatList.isEmpty) {
        return const Center(child: CustomProgressIndicator());
      }

      if (controller.historyChatList.isEmpty) {
        return _buildEmptyChatState();
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 60),
        itemCount: controller.historyChatList.length,
        itemBuilder: (context, index) {
          final msg = controller.historyChatList[index];

          final currentDate = DateTime.parse(msg.createdAt!);

          /// 🔥 Check previous message date
          DateTime? previousDate;
          if (index > 0) {
            previousDate = DateTime.parse(
                controller.historyChatList[index - 1].createdAt!);
          }

          /// 🔥 Show header only if date changes
          bool showHeader = index == 0 ||
              previousDate == null ||
              currentDate.day != previousDate.day ||
              currentDate.month != previousDate.month ||
              currentDate.year != previousDate.year;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHeader)
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getFormattedDateLabel(currentDate),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),

              buildChatCard(message: msg),
            ],
          );
        },
      );
    });
  }
  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AppColors.appColor,
      elevation: 1,
      titleSpacing: 0,
      title: Obx(
        () => Row(
          children: [
            /// PROFILE IMAGE
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                controller.chattingLists.value.userName!.isEmpty
                    ? 'U'
                    : controller.chattingLists.value.userName![0].toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appColor,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// NAME + STATUS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// USER NAME
                  Text(
                    controller.chattingLists.value.userName ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 2),

                  /// STATUS
                  Text(
                    controller.chattingLists.value.requirementCategory ?? 'Not Available',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(
            AppRoutes.myAgreementScreen,
            arguments: {
              'reqBidId': controller.chattingLists.value.requirementBidId,
              'reqId': controller.chattingLists.value.requirementId,
              'providerUserID': controller.chattingLists.value.userId ?? '',
            },
          ),
          icon: Icon(Icons.file_copy_outlined),
        ),
      ],
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColors.appColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 70,
                color: AppColors.appColor,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "No messages yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Start the conversation by sending your first message.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                controller.messageController.text = "Hi 👋";
                controller.sendMessage();
                },
              icon: const Icon(
                Icons.waving_hand_rounded,
                size: 20,
                color: AppColors.yellow,
              ),
              label: const Text(
                "Start chatting",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatCard({required Messages message}) {
    final isSender = message.user_id == controller.userId.value;
    final isImage = controller.chattingLists.value.userProfileUrl;
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isSender ? 60 : 16,
          right: isSender ? 16 : 60,
          top: 8,
          bottom: 8,
        ),
        child: Row(
          mainAxisAlignment: isSender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Avatar only for receiver
            if (!isSender) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child:
                    controller.chattingLists.value.userProfileUrl != null &&
                        controller
                            .chattingLists
                            .value
                            .userProfileUrl!
                            .isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          "${AppConfig.imageBaseUrl}${controller.chattingLists.value.userProfileUrl}",
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _defaultAvatar();
                          },
                        ),
                      )
                    : _defaultAvatar(),
              ),
              const SizedBox(width: 8),
            ],

            /// Message Bubble
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: isSender
                      ? const LinearGradient(
                          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                        )
                      : null,
                  color: isSender ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSender ? 20 : 4),
                    topRight: Radius.circular(isSender ? 4 : 20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    /// Receiver name
                    if (!isSender)
                      Text(
                        controller.chattingLists.value.userName ?? '',
                        style: const TextStyle(
                          color: Color(0xFF1E3C72),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),

                    if (!isSender) const SizedBox(height: 4),

                    /// Message
                    Text(
                      message.message ?? '',
                      style: TextStyle(
                        color: isSender
                            ? Colors.white
                            : const Color(0xFF2D3748),
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Time
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatChatTime(message.createdAt ?? ''),
                          style: TextStyle(
                            color: isSender
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),

                        if (isSender) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChattingField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// MESSAGE FIELD
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller.messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value.isEmpty)
                    controller.isSend.value = false;
                  else
                    controller.isSend.value = true;
                },
                // onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),

          const SizedBox(width: 6),

          /// SEND BUTTON
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: controller.isSend.value
                    ? AppColors.appColor
                    : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: controller.isSend.value
                    ? () {
                        controller.sendMessage();
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Center(
      child: Text(
        controller.chattingLists.value.userName![0],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  String getFormattedDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(messageDate).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    if (difference == 2) return "Day before yesterday";

    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  String formatChatTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(dateTime).toLocal();
      return DateFormat('h:mm a').format(parsedDate);
    } catch (e) {
      return '';
    }
  }
}
