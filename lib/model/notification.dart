import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Channel Id',
        'Channel Name',
        icon: "@mipmap/ic_launcher",
        priority: Priority.max,
        importance: Importance.max,
        enableVibration: true,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    id = 0,
    title,
    body,
    payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );
}
