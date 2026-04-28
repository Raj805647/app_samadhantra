import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_circularprogress_indicator.dart';
import '../../../constant/app_color.dart';
import '../../../constant/custom_appbar.dart';
import '../../../constant/custom_textformfield.dart';
import '../../../data/model/provider_requester_chatting_response.dart';
import '../../../global_routes/app_routes.dart';
import 'message_screen_controller.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: ()=> controller.fetchCurrentTabData(),
        child: SingleChildScrollView(
          child: Obx((){
            if(controller.isLoading.value && controller.chattingLists.isEmpty){
              return Center(child: CustomProgressIndicator());
            }
            else if(controller.chattingLists.isEmpty){
              Center(child: Text('No Any Chatting Contact'));
            }
            return Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.chattingLists.length,
                  itemBuilder: (context, index) {
                    final data = controller.chattingLists[index];
                    return _buildChatCard(data);
                  },
                ),
              ],
            );
          },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: "Admin Messages",
      isBackButton: true,
      actions: [
        IconButton(
          onPressed: controller.toggleSearch,
          icon: const Icon(Icons.search, color: AppColors.white),
        ),
        IconButton(
          onPressed: ()=> controller.fetchCurrentTabData,
          icon: const Icon(Icons.more_vert, color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Obx(
      () => controller.isSearchVisible.value
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextFormField(
                controller: controller.searchController,
                hintText: 'Search...',
                suffixIcon: Icons.search,
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildChatCard(ChattingListData chattingListData) {
    final hasImage = chattingListData.userProfileUrl != null && chattingListData.userProfileUrl!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Get.toNamed(
                AppRoutes.messageDetailScreen,
                arguments: chattingListData,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar with Badge
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey.shade100,
                        backgroundImage: hasImage
                            ? NetworkImage(
                          'https://api.samadhantra.com${chattingListData.userProfileUrl}',
                        )
                            : null,
                        child: !hasImage
                            ? Text(
                          chattingListData.userName?[0].toUpperCase() ?? '?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appColor,
                          ),
                        )
                            : null,
                      ),
                      // Role Badge
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: chattingListData.myRole == 'provider'
                                  ? [Colors.green.shade400, Colors.green.shade700]
                                  : [Colors.blue.shade400, Colors.blue.shade700],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            chattingListData.myRole == 'provider' ? 'Provider' : 'Requester',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // User Info
                  Expanded(
                    child: Text(
                      chattingListData.userName ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Action Indicator
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.appColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.appColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
