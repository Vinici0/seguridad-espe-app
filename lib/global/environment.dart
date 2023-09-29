import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.188.58.82:3000/api/v2'
      : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.188.58.82:3000'
      : 'http://localhost:3000';
}
