import 'dart:convert';
import 'dart:io';

import 'package:chatgptuz/view/gemini_pages/gemini_service.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final GeminiService _geminiService = GeminiService();
  final ChatUser _user = ChatUser(
      id: '1', firstName: 'User', profileImage: 'assets/images/profile.jpg');
  final ChatUser _gemini = ChatUser(
      id: '2',
      firstName: 'Gemini',
      profileImage: 'assets/images/gemini_logo.png');
  List<ChatMessage> _messages = [];

  Future<void> _sendMessage(ChatMessage message) async {
    setState(() => _messages.insert(0, message));

    String? imageBase64;
    if (message.medias!.isNotEmpty) {
      final File imageFile = File(message.medias!.first.url);
      List<int> imageBytes = await imageFile.readAsBytes();
      imageBase64 = base64Encode(imageBytes);
    }

    String response =
        await _geminiService.getResponse(message.text ?? "", imageBase64);

    setState(() {
      _messages.insert(
        0,
        ChatMessage(text: response, user: _gemini, createdAt: DateTime.now()),
      );
    });
  }

  Future<void> _pickImage(Function(ChatMessage) onSend) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      onSend(
        ChatMessage(
          user: _user,
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(type: MediaType.image, url: imageFile.path, fileName: '')
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Gemini Chat"), backgroundColor: Colors.blueAccent),
      body: DashChat(
        currentUser: _user,
        onSend: _sendMessage,
        messages: _messages,
        messageOptions: MessageOptions(
          containerColor: Colors.grey,
          currentUserContainerColor: Colors.blueAccent,
          textColor: Colors.black,
          currentUserTextColor: Colors.white,
        ),
        inputOptions: InputOptions(
          sendButtonBuilder: (onSend) => IconButton(
            icon: Icon(Icons.send, color: Colors.blueAccent),
            onPressed: onSend,
          ),
          inputToolbarPadding: EdgeInsets.all(8),
          inputDecoration: InputDecoration(
            hintText: "Xabar yozing...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
          trailing: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.image, color: Colors.blueAccent),
                  onPressed: () {
                    final dashChatState =
                        context.findAncestorWidgetOfExactType<DashChat>();
                    if (dashChatState != null) {
                      _pickImage(_sendMessage);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
