import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_notifications_screen/service_provider_notifications_screen_controller.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/service_notification_model.dart' hide NotificationFilter;

class ServiceProviderNotificationsScreen extends StatelessWidget {
  final ServiceProviderNotificationsController controller =
  Get.find<ServiceProviderNotificationsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Notifications",actions: [
      PopupMenuButton(
      icon: Icon(Icons.more_vert,color: AppColors.white,),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.mark_email_read, color: Colors.blue),
            title: Text('Mark All as Read'),
          ),
          value: 'mark_all_read',
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete_sweep, color: Colors.red),
            title: Text('Clear All'),
          ),
          value: 'clear_all',
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.settings, color: Colors.grey),
            title: Text('Notification Settings'),
          ),
          value: 'settings',
        ),
      ],
    ),
      ]),
      // _buildAppBar(),
      body: _buildBody(),
      // floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() => Row(
        children: [
          Text('Notifications'),
          if (controller.unreadCount.value > 0) ...[
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.unreadCount.value.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      )),
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.mark_email_read, color: Colors.blue),
                title: Text('Mark All as Read'),
              ),
              value: 'mark_all_read',
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.delete_sweep, color: Colors.red),
                title: Text('Clear All'),
              ),
              value: 'clear_all',
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.settings, color: Colors.grey),
                title: Text('Notification Settings'),
              ),
              value: 'settings',
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'mark_all_read':
                controller.markAllAsRead();
                break;
              case 'clear_all':
                controller.clearAllNotifications();
                break;
              case 'settings':
                Get.toNamed('/service-provider/notification-settings');
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Filter Chips
        // _buildFilterChips(),
        SizedBox(height: 8),

        // Notifications List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            }

            final filteredNotifications = controller.filteredNotifications;

            if (filteredNotifications.isEmpty) {
              return _buildEmptyState();
            }

            return _buildNotificationsList(filteredNotifications);
          }),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_getFilterLabel(filter)),
              selected: controller.selectedFilter.value == filter,
              selectedColor: Colors.blue.withOpacity(0.2),
              onSelected: (selected) {
                if (selected) {
                  controller.filterNotifications(filter);
                }
              },
            ),
          );
        },
      )),
    );
  }

  String _getFilterLabel(NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.all:
        return 'All';
      case NotificationFilter.unread:
        return 'Unread';
      case NotificationFilter.proposal:
        return 'Proposals';
      case NotificationFilter.assignment:
        return 'Assignments';
      case NotificationFilter.payment:
        return 'Payments';
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading notifications...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () async {
        // await controller.refreshNotifications();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: Get.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.selectedFilter.value == NotificationFilter.all
                      ? 'You\'re all caught up!'
                      : 'No ${_getFilterLabel(controller.selectedFilter.value).toLowerCase()} notifications',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.refreshNotifications,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<ServiceNotificationModel> notifications) {
    return RefreshIndicator(
      onRefresh: () async {
        // await controller.refreshNotifications();
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(ServiceNotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          Get.defaultDialog(
            title: 'Delete Notification',
            middleText: 'Are you sure you want to delete this notification?',
            textConfirm: 'Delete',
            textCancel: 'Cancel',
            onConfirm: () {
              controller.deleteNotification(notification.id);
              Get.back();
            },
          );
          return false; // We handle deletion in the dialog
        }
        return false;
      },
      child: Material(
        color: notification.isRead ? Colors.white : Colors.blue[50],
        child: InkWell(
          onTap: () => controller.handleNotificationTap(notification),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: notification.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.iconColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),

                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    color: notification.isRead
                                        ? Colors.grey[800]
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  notification.message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            notification.formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: notification.iconColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getTypeLabel(notification.type),
                              style: TextStyle(
                                fontSize: 10,
                                color: notification.iconColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            onPressed: () => _showNotificationOptions(notification),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.proposal:
        return 'PROPOSAL';
      case NotificationType.assignment:
        return 'ASSIGNMENT';
      case NotificationType.payment:
        return 'PAYMENT';
      case NotificationType.system:
        return 'SYSTEM';
      case NotificationType.message:
        return 'MESSAGE';
      case NotificationType.review:
        return 'REVIEW';
    }
  }

  Widget _buildFloatingActionButton() {
    return Obx(() {
      if (controller.isRefreshing.value) {
        return FloatingActionButton(
          onPressed: null,
          child: CircularProgressIndicator(color: Colors.white),
          backgroundColor: Colors.blue,
        );
      }

      return FloatingActionButton(
        onPressed: controller.refreshNotifications,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      );
    });
  }

  void _showNotificationOptions(ServiceNotificationModel notification) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Notification Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 0),

            if (!notification.isRead)
              ListTile(
                leading: Icon(Icons.mark_email_read, color: Colors.blue),
                title: Text('Mark as Read'),
                onTap: () {
                  Get.back();
                  controller.markAsRead(notification.id);
                },
              ),

            if (notification.isRead)
              ListTile(
                leading: Icon(Icons.mark_email_unread, color: Colors.blue),
                title: Text('Mark as Unread'),
                onTap: () {
                  Get.back();
                  // Mark as unread logic would go here
                  Get.snackbar(
                    'Info',
                    'Mark as unread coming soon',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
              ),

            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                controller.deleteNotification(notification.id);
              },
            ),

            ListTile(
              leading: Icon(Icons.copy, color: Colors.grey),
              title: Text('Copy Message'),
              onTap: () {
                Get.back();
                // Copy to clipboard
                Get.snackbar(
                  'Copied',
                  'Notification message copied',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.share, color: Colors.grey),
              title: Text('Share'),
              onTap: () {
                Get.back();
                // Share functionality
                Get.snackbar(
                  'Info',
                  'Share functionality coming soon',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
            ),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}