import 'dart:collection';

import 'package:flutter/material.dart';

/// using single-tone here to ease one-time accessing this provider
/// without the need to provide [BuildContext] or listen for changes
class NotificationsLayerProvider extends ChangeNotifier {
  static final NotificationsLayerProvider _instance =
      NotificationsLayerProvider._();
  factory NotificationsLayerProvider() => _instance;
  NotificationsLayerProvider._();

  Queue<NotificationElement> _notificationsQueue = Queue();

  NotificationElement get activeOverlay =>
      _notificationsQueue.isNotEmpty ? _notificationsQueue.first : null;

  void showNotification(NotificationElement entry) {
    var duplicate = _notificationsQueue.firstWhere(
      (element) => element == entry,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationElement &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          type == other.type;

  @override
  int get hashCode => text.hashCode ^ type.hashCode;
}

enum NotificationType {
  error,
  message,
}
