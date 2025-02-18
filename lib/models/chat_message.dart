import 'package:dash_chat_2/dash_chat_2.dart';

class ChatMessage {
  final String text;
  final ChatUser user;
  final DateTime createdAt;
  final String? image; // Rasmni qo'shish

  ChatMessage({
    required this.text,
    required this.user,
    required this.createdAt,
    this.image,
  });
}