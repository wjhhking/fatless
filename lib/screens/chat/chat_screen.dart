import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  String _selectedMood = 'motivate';

  @override
  void initState() {
    super.initState();
    _addWelcomeMessages();
  }

  void _addWelcomeMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
          text: "Hi there! I thought we've met before. Maybe at a restaurant?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          text: "So what do you usually have for dinner?",
          isUser: false,
          timestamp: DateTime.now().add(const Duration(seconds: 1)),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Daniel'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (mood) {
              setState(() {
                _selectedMood = mood;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'motivate', child: Text('Motivate me')),
              const PopupMenuItem(value: 'distract', child: Text('Distract me')),
              const PopupMenuItem(value: 'remind', child: Text('Remind me')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getMoodIcon(_selectedMood)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMoodIndicator(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMoodIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blue[50],
      child: Row(
        children: [
          Icon(_getMoodIcon(_selectedMood), color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            'Daniel is ready to ${_selectedMood} you',
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'motivate':
        return Icons.fitness_center;
      case 'distract':
        return Icons.games;
      case 'remind':
        return Icons.alarm;
      default:
        return Icons.chat;
    }
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text('D', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: Colors.blue,
            mini: true,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    final userMessage = _messageController.text;
    _messageController.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _generateResponse(userMessage),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  String _generateResponse(String userMessage) {
    final responses = {
      'motivate': [
        "You're doing great! Every step counts towards your goal!",
        "Remember why you started - you've got this!",
        "Your future self will thank you for the effort you're putting in today!",
      ],
      'distract': [
        "Did you know that laughing burns calories? Here's a fun fact: A good laugh can burn as many calories as a few minutes of exercise!",
        "Let's talk about something fun! What's your favorite movie genre?",
        "Here's a riddle: What gets wetter the more it dries? (Answer: A towel!)",
      ],
      'remind': [
        "Don't forget to drink water! Staying hydrated is key to your success.",
        "Have you taken your vitamins today? Small habits make big differences!",
        "Remember to get enough sleep - your body recovers and burns calories while you rest!",
      ],
    };

    final moodResponses = responses[_selectedMood] ?? responses['motivate']!;
    return moodResponses[(DateTime.now().millisecond) % moodResponses.length];
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
