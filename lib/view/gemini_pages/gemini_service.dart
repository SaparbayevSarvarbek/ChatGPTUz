import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GeminiService {
  final String apiKey = "AIzaSyCMO2dgyDp5f27DACvfK1Em43MvgwfX6dE"; // API kalitingizni shu yerga qo'ying

  Future<String> sendMessage(String message) async {
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateText?key=$apiKey");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "prompt": {"text": message},
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "No response";
    } else {
      return "Error: ${response.body}";
    }
  }

  Future<String> sendImage(File imageFile) async {
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateText?key=$apiKey");

    final base64Image = base64Encode(await imageFile.readAsBytes());

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "prompt": {
          "text": "Describe this image",
          "image": {"content": base64Image}
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "No response";
    } else {
      return "Error: ${response.body}";
    }
  }
}
