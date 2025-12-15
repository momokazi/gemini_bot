// lib/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/message.dart';

// NOTE: Replace this with your actual API key, ideally from a secure location
// like environment variables, not hardcoded.
const String _apiKey = 'AIzaSyAEmwwmAj-jmsVOCfyhktdZ3klWDo4QUNg';

class GeminiService {
  final GenerativeModel _model;

  // Use a chat session to maintain conversation context (memory)
  late final ChatSession _chat;

  GeminiService()
    : _model = GenerativeModel(
        model: 'gemini-2.5-flash', // Fast and cost-effective model
        apiKey: _apiKey,
      ) {
    _chat = _model.startChat();
  }

  Future<Message> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) {
      return Message(
        text: "Please enter a message.",
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
    }

    try {
      // Send the message to the chat session
      final response = await _chat.sendMessage(Content.text(userMessage));

      // Convert the API response text into our clean Message model
      return Message(
        text: response.text ?? 'Error: No response text received.',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return Message(
        text: "An error occurred: $e",
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
    }
  }
}
