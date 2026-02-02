import 'package:flutter/material.dart';
import '../models/notification_item.dart';

class NotificationManager extends ChangeNotifier {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal() {
    // Add some initial mock notifications
    _addMockNotifications();
  }

  final List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void _addMockNotifications() {
    _notifications.addAll([
      NotificationItem(
        id: '1',
        title: 'Welcome to Urbino!',
        body: 'Complete your profile to get the best roommate matches.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.info,
      ),
      NotificationItem(
        id: '2',
        title: 'Payment Reminder',
        body: 'Your rent installment for February is due in 3 days.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.payment,
      ),
      NotificationItem(
        id: '3',
        title: 'New Event Nearby',
        body: 'Erasmus party at Piazza della Repubblica tonight at 22:00!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.success,
      ),
    ]);
  }

  void addNotification(NotificationItem item) {
    _notifications.insert(0, item);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
