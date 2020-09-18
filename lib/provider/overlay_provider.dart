import 'dart:collection';

import 'package:flutter/material.dart';

/// using single-tone here to ease one-time accessing this provider
/// without the need to provide [BuildContext] or listen for changes
class NotificationsProvider extends ChangeNotifier {
  static final NotificationsProvider _instance = NotificationsProvider._();
  factory NotificationsProvider() => _instance;
  NotificationsProvider._();

  Queue<NotificationElement> _notificationsQueue = Queue();

  NotificationElement get activeOverlay =>
      _notificationsQueue.isNotEmpty ? _notificationsQueue.first : null;

  void showNotification(NotificationElement entry) {
    var duplicate = _notificationsQueue.firstWhere(
      (element) => element.text == entry.text,
      orElse: () => null,
    );
    if (duplicate == null) {
      _notificationsQueue.add(entry);
      notifyListeners();
    }
  }

  void dismissNotification() {
    _notificationsQueue.removeFirst();
    notifyListeners();
  }
}

class NotificationElement {
  final String text;
  final Duration duration;
  final Function onTap;
  final NotificationType type;

  NotificationElement({
    @required this.type,
    @required this.text,
    this.duration,
    this.onTap,
  }) : assert(type != null && text != null);
}

enum NotificationType {
  error,
  message,
}
