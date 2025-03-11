import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ImageAi extends StatefulWidget {
  const ImageAi({super.key});

  @override
  State<ImageAi> createState() => _ImageAiState();
}

class _ImageAiState extends State<ImageAi> {
  final TextEditingController _textController = TextEditingController();
  String? generatedImageUrl;
  bool isLoading = false;

  Future<void> generateImage(String prompt) async {
    setState(() {
      isLoading = true;
    });

    final apiKey = "vk-XaofUl7PaPiD7DE3NaT1YLXnqot4E8GfVEjom2fF6MbCMT"; // Image.Art API kalitingizni shu joyga qo'ying
    final url = "https://api.vyro.ai/v2/image/generations"; // API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "prompt": prompt,
          "size": "1024x1024",
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          generatedImageUrl = jsonResponse["image_url"]; // API dan olingan rasm URL
          isLoading = false;
        });
      } else {
        print("Error: ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Exception: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Generator")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "Rasm uchun matn kiriting",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  generateImage(_textController.text);
                }
              },
              child: Text("Rasm yaratish"),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (generatedImageUrl != null)
              Expanded(
                child: Image.network(generatedImageUrl!),
              ),
          ],
        ),
      ),
    );
  }
}