import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../utils/chat_prompt.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-4o';
  
  static String get _apiKey => Config.apiKey;
  
  static Future<String> generateChatResponse(String userMessage, String mood) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(mood),
            },
            {
              'role': 'user',
              'content': userMessage,
            },
          ],
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error communicating with OpenAI: $e');
    }
  }

  static String _getSystemPrompt(String mood) {
    return ChatPrompt.getPromptForMood(mood);
  }

  static Future<String> generateWelcomeMessage() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a friendly health and fitness assistant. Generate a warm, welcoming message for a user starting their wellness journey. Keep it brief and encouraging.',
            },
            {
              'role': 'user',
              'content': 'Generate a welcome message for someone using a health and fitness app.',
            },
          ],
          'max_tokens': 100,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return 'Welcome to your health journey! I\'m here to support you every step of the way. 💪';
      }
    } catch (e) {
      return 'Hi there! Ready to crush your health goals together? Let\'s make today amazing! 🌟';
    }
  }
}