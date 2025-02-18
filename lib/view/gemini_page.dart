import 'package:chatgptuz/consts.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final List<ChatMessage> messages = [];
  bool isLoading = false;

  final ChatUser user = ChatUser(id: "1", firstName: "Sarvarbek");
  final ChatUser gemini = ChatUser(
    id: "2",
    firstName: "Gemini AI",
    profileImage: 'assets/images/gemini_logo.png',
  );

  Future<void> sendMessage(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
      isLoading = true;
    });

    final model = GenerativeModel(model: 'gemini-pro', apiKey: GEMINI_API_KEY);

    try {
      final response =
          await model.generateContent([Content.text(message.text)]);
      String aiResponse = response.text ?? "Javob kelmadi.";

      setState(() {
        messages.insert(
            0,
            ChatMessage(
                text: aiResponse, user: gemini, createdAt: DateTime.now()));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        messages.insert(
            0,
            ChatMessage(
                text: "Xatolik: $e", user: gemini, createdAt: DateTime.now()));
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/gemini_logo.png"),
            ),
            SizedBox(width: 10),
            Text("Gemini AI"),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (isLoading)
            Lottie.asset("assets/images/loading.json", width: 80, height: 80),
          Expanded(
            child: DashChat(
              currentUser: user,
              messages: messages,
              onSend: sendMessage,
              messageOptions: MessageOptions(
                  currentUserContainerColor: Colors.blueAccent,
                  containerColor: Colors.grey.shade200,
                  textColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
