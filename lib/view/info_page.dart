import 'dart:convert';
import 'dart:io';

import 'package:chatgptuz/consts.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    setState(() {
      messages.insert(0, {"text": text, "isUser": true});
      isLoading = true;
    });

    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateText?key=$GEMINI_API_KEY");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "prompt": {"text": text},
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        messages.insert(
            0, {"text": data["candidates"][0]["output"], "isUser": false});
      });
    } else {
      setState(() {
        messages.insert(
            0, {"text": "Xatolik: ${response.statusCode}", "isUser": false});
      });
    }
    setState(() => isLoading = false);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        messages.insert(0, {"image": imageFile.path, "isUser": true});
        isLoading = true;
      });

      analyzeImage(imageFile);
    }
  }

  Future<void> analyzeImage(File imageFile) async {
    final url = Uri.parse(
        "https://vision.googleapis.com/v1/images:annotate?key=$GEMINI_API_KEY");

    final bytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(bytes);

    final requestPayload = {
      "requests": [
        {
          "image": {"content": base64Image},
          "features": [
            {"type": "LABEL_DETECTION"}
          ]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List labels = data["responses"][0]["labelAnnotations"];
      String aiResponse =
          labels.map((label) => label["description"]).join(", ");

      setState(() {
        messages.insert(0, {"text": "AI javobi: $aiResponse", "isUser": false});
      });
    } else {
      setState(() {
        messages.insert(
            0, {"text": "Xatolik: ${response.statusCode}", "isUser": false});
      });
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini AI Chat"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          msg["isUser"] ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: msg.containsKey("image")
                        ? Image.file(File(msg["image"]),
                            width: 150, height: 150, fit: BoxFit.cover)
                        : Text(msg["text"],
                            style: TextStyle(
                                fontSize: 16,
                                color: msg["isUser"]
                                    ? Colors.white
                                    : Colors.black)),
                  ),
                );
              },
            ),
          ),
          if (isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.photo, color: Colors.deepPurple),
                  onPressed: pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Xabar yozing...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
