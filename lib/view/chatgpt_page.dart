import 'dart:convert';
import 'package:chatgptuz/consts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatgptPage extends StatefulWidget {
  const ChatgptPage({super.key});

  @override
  State<ChatgptPage> createState() => _ChatgptPageState();
}

class _ChatgptPageState extends State<ChatgptPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  bool isLoading = false;

  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<void> sendMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      messages.add("Siz: $message");
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $CHATGPT_API_KEY',
        },
        body: json.encode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'user',
              'content': message,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        String aiMessage = responseData['choices'][0]['message']['content'];

        setState(() {
          messages.add("Gemini AI: $aiMessage");
          isLoading = false;
        });
      } else {
        setState(() {
          print(response.body);
          messages.add("Xatolik yuz berdi: ${response.statusCode} \n ${response.body}");
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        messages.add("Xatolik: $e");
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT Ilovasi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Savol kiriting...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
