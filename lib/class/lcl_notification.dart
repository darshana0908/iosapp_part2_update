import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static final onNotifications = BehaviorSubject<String?>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void main() {
    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;
    print(locations.length); // => 429
    print(locations.keys.first); // => "Africa/Abidjan"
    print(locations.keys.last); // => "US/Pacific"
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channelDescription',
        importance: Importance.max,
        playSound: true,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('ic_launcher');

    const ios = IOSInitializationSettings();
    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload.toString());
    });
  }
// cancel the notification with id value of zero

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static void showScheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required var scheduledDate,
    shed,
    required pin,
    required foldername,
    required textname,
  }) async {
    // List<Map> response = await sqlDb.readData("SELECT dtime FROM  'notes' ");
    // String gg = response.toString();
    // print(gg);

    _notifications.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime.from(scheduledDate, tz.local),
      // tz.TZDateTime.now(tz.local)
      //    .add(Duration(days: scheduledDate, seconds: 20)),
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('tz.local');
    print(tz.local);
  }
}

// class Noti {
//   static Future initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize =
//         const AndroidInitializationSettings('launch_background');
//     // cancel the notification with id value of zero
//     await flutterLocalNotificationsPlugin.cancel(0);

//     var initializetionSetting = InitializationSettings(
//       android: androidInitialize,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializetionSetting);
//   }

//   static Future showBigTextNotification(
//       {var id = 0,
//       required String title,
//       required String body,
//       var payload,
//       required FlutterLocalNotificationsPlugin fln}) async {
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         const AndroidNotificationDetails(
//       'my_channel',
//       'channel_name',
//       playSound: true,
//       // sound: RawResourceAndroidNotificationSound('notification'),
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     var not = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, not);
//   }
// }
