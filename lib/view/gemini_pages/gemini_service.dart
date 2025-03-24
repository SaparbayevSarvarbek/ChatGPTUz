import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GeminiService {
  final String apiKey = "AIzaSyCMO2dgyDp5f27DACvfK1Em43MvgwfX6dE"; // API kalitingizni shu yerga qo'ying

  // Matnli so'rov uchun: endpoint v1beta va "contents" maydoni ishlatiladi.
  Future<String> sendMessage(String message) async {
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "No response";
    } else {
      print('Error text: ${response.body} (Status: ${response.statusCode})');
      return "Error: ${response.body}";
    }
  }

  // Rasmli so'rov uchun: endpoint va JSON format to'g'rilandi.
  Future<String> sendImage(File imageFile) async {
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateContent?key=$apiKey");

    final base64Image = base64Encode(await imageFile.readAsBytes());

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "inlineData": {
                  "mimeType": "image/jpeg", // Agar PNG bo'lsa, "image/png" deb yozing.
                  "data": base64Image,
                }
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "No response";
    } else {
      print('Error image: ${response.body} (Status: ${response.statusCode})');
      return "Error: ${response.body}";
    }
  }
}
