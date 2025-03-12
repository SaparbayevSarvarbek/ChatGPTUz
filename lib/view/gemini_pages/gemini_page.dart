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
  final GeminiService geminiService = GeminiService();
  final List<ChatMessage> messages = [];
  final ChatUser user = ChatUser(id: "1", firstName: "Siz");
  final ChatUser bot = ChatUser(id: "2", firstName: "Gemini");
  final TextEditingController _messageController = TextEditingController();

  void sendMessage(String text) async {
    final ChatMessage userMessage = ChatMessage(
      text: text,
      user: user,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.insert(0, userMessage);
    });

    String response = await geminiService.sendMessage(text);

    final ChatMessage botMessage = ChatMessage(
      text: response,
      user: bot,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.insert(0, botMessage);
    });
  }

  void sendImage(File image) async {
    final ChatMessage userMessage = ChatMessage(
      text: "Rasm yuborildi",
      user: user,
      createdAt: DateTime.now(),
      medias: [
        ChatMedia(
          url: image.path,
          fileName: "image.jpg",
          type: MediaType.image,
        ),
      ],
    );

    setState(() {
      messages.insert(0, userMessage);
    });

    String response = await geminiService.sendImage(image);

    final ChatMessage botMessage = ChatMessage(
      text: response,
      user: bot,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.insert(0, botMessage);
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      sendImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Chat")),
      body: DashChat(
        currentUser: user,
        messages: messages,
        onSend: (ChatMessage message) {
          sendMessage(message.text);
          _messageController.clear();
        },
        inputOptions: InputOptions(
          textController: _messageController, // Eski inputFieldController o‘rniga shu
          trailing: [
            IconButton(
              icon: Icon(Icons.image),
              onPressed: pickImage,
            ),
          ],
        ),
      ),
    );
  }
}