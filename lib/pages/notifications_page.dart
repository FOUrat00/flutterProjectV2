import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/notification_item.dart';
import '../services/notification_manager.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationManager _notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    _notificationManager.addListener(_updateState);
  }

  @override
  void dispose() {
    _notificationManager.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _notificationManager.notifications;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notifications',
          style: UrbinoTextStyles.heading2(context),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all, color: UrbinoColors.gold),
              tooltip: 'Mark all as read',
              onPressed: () {
                _notificationManager.markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All marked as read'),
                    backgroundColor: UrbinoColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: UrbinoColors.lightBeige.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: UrbinoColors.gold.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: UrbinoTextStyles.heading2(context).copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You are all caught up!',
            style: UrbinoTextStyles.bodyText(context).copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: UrbinoColors.error,
          borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        _notificationManager.deleteNotification(item.id);
      },
      child: GestureDetector(
        onTap: () {
          _notificationManager.markAsRead(item.id);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead
                ? Theme.of(context).cardColor.withOpacity(0.6)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
            boxShadow: [
              if (!item.isRead)
                BoxShadow(
                  color: UrbinoColors.gold.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
            border: !item.isRead
                ? Border.all(color: UrbinoColors.gold.withOpacity(0.3))
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeIcon(item.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: item.isRead
                                ? UrbinoTextStyles.bodyTextBold(context)
                                    .copyWith(
                                        color: Theme.of(context).disabledColor)
                                : UrbinoTextStyles.bodyTextBold(context),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: UrbinoColors.brickOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.body,
                      style: UrbinoTextStyles.bodyText(context).copyWith(
                        fontSize: 13,
                        color: item.isRead
                            ? Theme.of(context).disabledColor
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(item.timestamp),
                      style: UrbinoTextStyles.smallText(context).copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.payment:
        icon = Icons.payment;
        color = UrbinoColors.success;
        break;
      case NotificationType.warning:
        icon = Icons.warning_amber_rounded;
        color = UrbinoColors.warning;
        break;
      case NotificationType.error:
        icon = Icons.error_outline;
        color = UrbinoColors.error;
        break;
      case NotificationType.message:
        icon = Icons.mail_outline;
        color = UrbinoColors.darkBlue;
        break;
      case NotificationType.success:
        icon = Icons.check_circle_outline;
        color = UrbinoColors.success;
        break;
      case NotificationType.info:
      default:
        icon = Icons.info_outline;
        color = UrbinoColors.gold;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
