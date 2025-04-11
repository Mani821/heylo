import 'dart:convert';
import 'package:heylo/data/ai_model.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String role; // 'user' or 'assistant' or 'system'
  final String content;

  ChatMessage({required this.role, required this.content});

  Map<String, String> toJson() => {'role': role, 'content': content};
}

class AIService {
  static String get _apiKey =>
      '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';
  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';
  static const String _referer = 'https://monesave.shop/';

  Future<String> generateServiceDescription(
    Map<String, String> serviceDetails, {
    required int maxLength,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://monesave.shop/',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-r1-distill-llama-70b:free',
          'messages': <Map<String, String>>[
            // {
            //   'role': 'system',
            //   'content':
            //       'IMPORTANT: You are a service description generator. Your ONLY task is to output a single, professional service description ENCLOSED IN DOUBLE QUOTES. DO NOT include ANY explanations or meta-text. ONLY output the final description inside double quotes like this: "your description here". Focus on value proposition, expertise, and what clients can expect. Keep it professional, engaging, and direct. REMEMBER: ALWAYS put the final description inside double quotes.',
            // },
            {
              'role': 'user',
              'content':
                  'Generate a service description (max $maxLength chars) based on these details: ${serviceDetails.entries.map((e) => "${e.key}: ${e.value}").join(", ")}. REMEMBER: Output ONLY the description text in quotes.',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        /// Extract Text Between Quotes If Present, Otherwise Return The Whole Content
        final match = RegExp('"(.*?)"').firstMatch(content);
        return match?.group(1) ?? content;
      } else {
        throw Exception('Failed To Generate Service Description');
      }
    } catch (e) {
      throw Exception('Error Generating Service Description: $e');
    }
  }

  Future<String> generateBio(
    Map<String, String> userResponses, {
    required int maxLength,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://monesave.shop/',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-r1-distill-llama-70b:free',
          'messages': <Map<String, String>>[
            {
              'role': 'system',
              'content':
                  'IMPORTANT: You are a bio generator. Your ONLY task is to output a single, concise bio paragraph ENCLOSED IN DOUBLE QUOTES. DO NOT include ANY explanations, thoughts, or meta-text. DO NOT say things like "Let me create" or "Here is". ONLY output the final bio text inside double quotes like this: "your bio here". For stylists: focus on expertise, experience, and services. For clients: focus on style preferences and service interests. Keep it professional and direct. REMEMBER: ALWAYS put the final bio inside double quotes.',
            },
            {
              'role': 'user',
              'content':
                  'Generate ONLY a ${userResponses["role"]} bio (max $maxLength chars). Details: ${userResponses.entries.where((e) => e.key != "role").map((e) => "${e.key}: ${e.value}").join(", ")}. REMEMBER: Output ONLY the bio text, no explanations.',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'].trim();

        /// Extract Text Between Quotes If Present
        final RegExp quoteRegex = RegExp(r'"([^"]+)"');
        final match = quoteRegex.firstMatch(content);

        if (match != null && match.group(1) != null) {
          /// Use The Content Inside Quotes
          content = match.group(1)!;
        } else {
          /// If No Quotes Found, Clean Up Any Quotes And Use The Whole Content
          content = content.replaceAll('"', '').trim();
        }

        /// Capitalize First Letter of Each Word
        content = content
            .split(' ')
            .map((word) {
              if (word.isEmpty) return word;
              return word[0].toUpperCase() + word.substring(1);
            })
            .join(' ');

        return content;
      } else {
        throw Exception('Failed To Generate Bio: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Generating Bio: $e');
    }
  }

  // For 1v1 chat
  Future<String> sendMessage({
    required List<ChatMessage> conversationHistory,
    required String userMessage,
    String model =
        'openai/gpt-3.5-turbo', // Default model for chat, can be changed
    String?
    systemPrompt, // Optional system prompt for the chat's persona/context
  }) async {
    // Create the list of messages to send
    final List<Map<String, String>> messages = [];

    // Add optional system prompt if provided and history is empty (or at the start)
    if (systemPrompt != null && messages.isEmpty) {
      messages.add(ChatMessage(role: 'system', content: systemPrompt).toJson());
    }

    // Add existing conversation history
    messages.addAll(conversationHistory.map((msg) => msg.toJson()).toList());

    // Add the new user message
    messages.add(ChatMessage(role: 'user', content: userMessage).toJson());

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': _referer, // Use your app identifier
        },
        body: jsonEncode({
          'model': model,
          'messages': messages,
          // You might want to add other parameters like 'max_tokens', 'temperature'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Directly return the assistant's message content
        return data['choices'][0]['message']['content'] as String;
      } else {
        // Provide more detailed error info
        print('API Error Response: ${response.body}');
        throw Exception(
          'Failed to get chat response (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      throw Exception('Error sending chat message: $e');
    }
  }

  // To get all the models list
  Future<List<Datum>> fetchAllModels() async {
    try {
      final baseUrl = "https://openrouter.ai/api/v1/models";
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = Models.fromJson(data);
        return models.data;
      } else {
        print("Error fetching models: ${response.statusCode}");
        throw Exception('Failed to fetch models');
      }
    } catch (e, s) {
      print("Error fetching models: $e -- $s");
      throw Exception('Error fetching models');
    }
  }
}
