import 'dart:convert';

import 'package:chatgptuz/models/message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatgptPage extends StatefulWidget {
  const ChatgptPage({super.key});

  @override
  State<ChatgptPage> createState() => _ChatgptPageState();
}

class _ChatgptPageState extends State<ChatgptPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _msgs = [];
  bool _isTyping = false;

  final String _apiKey =
      "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";

  void _sendMsg() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _msgs.insert(0, Message(true, text));
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": text}
          ]
        }),
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        String botResponse =
            json["choices"][0]["message"]["content"]?.toString()?.trim() ??
                "Javob yo‘q!";

        setState(() {
          _isTyping = false;
          _msgs.insert(0, Message(false, botResponse));
        });

        _scrollToBottom();
      } else {
        print("API xatolik: ${response.statusCode}, Javob: ${response.body}");
        _showError(
            "Xatolik: ${response.statusCode} - API bilan muammo yuz berdi.");
      }
    } catch (e) {
      print("Xatolik: $e");
      _showError("Internet yoki API ulanishida muammo bor!");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ChatGPT Bot")), body: Container());
  }

  Widget _inputField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (value) => _sendMsg(),
                  textInputAction: TextInputAction.send,
                  showCursor: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Xabar yozing...",
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: _sendMsg,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class Message {
  final bool isSender;
  final String msg;

  Message(this.isSender, this.msg);
}
