import 'package:firebase_messaging/firebase_messaging.dart';

void setupFireBase(fireBaseMessaging) async {
  fireBaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("NOTIFICATION onMessage: $message");
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("NOTIFICATION onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("NOTIFICATION onResume: $message");
    },
  );

  fireBaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));

  fireBaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });

  fireBaseMessaging.getToken().then((String token) {
    assert(token != null);
    // AQUÍ PUEDES GUARDAR EL TOKEN DE FB POR SI LO NECESITAS PARA ALGO EN LA APP
    print("FCM Token: $token");
  });
}
