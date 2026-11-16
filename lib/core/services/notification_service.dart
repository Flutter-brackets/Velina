import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// OneSignal v5 Push Notification service for Velina.
class NotificationService {
  const NotificationService._();

  static const String appId = '2a0f6f0e-ec21-4739-b861-095f4f8a6e68';
  static final ValueNotifier<String?> pendingUrl = ValueNotifier<String?>(null);

  static void initClickListener() {
    OneSignal.Notifications.addClickListener((event) {
      final notif = event.notification;
      final target = notif.launchUrl ?? notif.additionalData?['url']?.toString();
      if (target != null && target.contains('velinaboutiquesa.com')) {
        pendingUrl.value = target;
      }
    });
  }

  static void clearPendingUrl() {
    pendingUrl.value = null;
  }
}
