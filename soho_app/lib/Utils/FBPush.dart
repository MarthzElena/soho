import 'package:firebase_messaging/firebase_messaging.dart';

void setupFireBase(fireBaseMessaging) async {
  fireBaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
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
  });
}
