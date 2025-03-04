import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyCMO2dgyDp5f27DACvfK1Em43MvgwfX6dE";
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=";

  Future<String> getResponse(String prompt, String? imageBase64) async {
    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            if (imageBase64 != null)
              {"inlineData": {"mimeType": "image/png", "data": imageBase64}},
            {"text": prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse(apiUrl + apiKey),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception("API xatosi: ${response.body}");
    }
  }
}
