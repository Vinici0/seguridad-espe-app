import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://10.3.0.251:3005/api'
      : 'http://localhost:3000/api';
  static String socketUrl =
      Platform.isAndroid ? 'http://10.3.0.251:3005' : 'http://localhost:3000';
}
//para probar directo en la emulacion de android
  // static String apiUrl = Platform.isAndroid
  //     ? 'http://192.168.3.15:3000/api'
  //     : 'http://localhost:3000/api';
