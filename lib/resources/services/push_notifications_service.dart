import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  //La instancia de firebase messaging para conocer el token y el estado de la app
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('onBackground Handler ${message.messageId}');
    // print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessage Handler ${message.messageId}');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print( 'onMessageOpenApp Handler ${ message.messageId }');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    // await requestPermission();

    // Token: Token de la app en el dispositivo
    token = await FirebaseMessaging.instance.getToken(); //
    print('Token1: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(
        _backgroundHandler); //Cuando la app está en segundo plano
    FirebaseMessaging.onMessage
        .listen(_onMessageHandler); //Cuando la app está en primer plano
    FirebaseMessaging.onMessageOpenedApp
        .listen(_onMessageOpenApp); // Cuando la app está cerrada

    // Local Notifications
  }

  // Apple / Web
  /*
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    print('User push notification status ${ settings.authorizationStatus }');

  }
  */

  static closeStreams() {
    _messageStream.close();
  }
}
