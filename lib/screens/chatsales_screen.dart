import 'package:flutter/material.dart';

class ChatSalesScreen extends StatefulWidget {
  static const String chatsalesroute = 'chatsales';
  const ChatSalesScreen({Key? key}) : super(key: key);

  @override
  State<ChatSalesScreen> createState() => _ChatSalesScreenState();
}

class _ChatSalesScreenState extends State<ChatSalesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ChatSalesScreen'),
      ),
    );
  }
}
