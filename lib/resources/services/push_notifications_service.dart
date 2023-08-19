import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<Map<String, dynamic>> _messageStream =
      StreamController.broadcast();

  static Stream<Map<String, dynamic>> get messagesStream =>
      _messageStream.stream;

  //_backgroundHandler - Cuando la app está en segundo plano
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    final Map<String, dynamic> messageData = message.data;
    _messageStream.add(messageData);
    // final Map<String, dynamic> messageData = message.data;
    // final String dataString = messageData['usuario'] ?? 'No data';
    // final Map<String, dynamic> userData = jsonDecode(dataString);
    // _messageStream.add(userData);
  }

  //_onMessageHandler - Cuando la app está en primer plano
  static Future<void> _onMessageHandler(RemoteMessage message) async {
    final Map<String, dynamic> messageData = message.data;
    final dataNotification = jsonDecode(messageData['data']);
    print(dataNotification);

    if (dataNotification['type'] == 'sos') {
      _messageStream.add(messageData);
    }

    if (dataNotification['type'] == 'sala') {
      _messageStream.add(messageData);
    }

    if (dataNotification['type'] == 'publication') {
      dataNotification['primerPlano'] = true;
      print(dataNotification);

      // Update the messageData with the modified dataNotification map
      messageData['data'] = jsonEncode(dataNotification);

      // Now _messageStream will contain the modified messageData
      _messageStream.add(messageData);
    }
  }

  //_onMessageOpenApp - Cuando la app está cerrada
  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    final Map<String, dynamic> messageData = message.data;
    _messageStream.add(messageData);
  }

  static Future initializeApp() async {
    try {
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
    } catch (e) {
      // Manejo de la excepción aquí
      print('Error en la inicialización de FCM: $e');
      // Puedes mostrar un mensaje al usuario o realizar otras acciones aquí
    }
  }

  static closeStreams() {
    _messageStream.close();
  }
}
