import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../models/recipe.dart';
import '../../models/exercise.dart';
import '../../services/openai_service.dart';
import '../../utils/config.dart';
import '../../utils/chat_prompt.dart';
import '../../widgets/common/bottom_navigation_widget.dart';

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

  void _addWelcomeMessages() async {
    if (Config.isApiKeyConfigured) {
      try {
        final welcomeMessage = await OpenAIService.generateWelcomeMessage();
        setState(() {
          _messages.add(ChatMessage(
            text: welcomeMessage,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      } catch (e) {
        _addLocalWelcomeMessages();
      }
    } else {
      _addLocalWelcomeMessages();
    }
  }
  
  void _addLocalWelcomeMessages() {
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4DB6AC), // Teal
                Color(0xFF26A69A), // Darker teal
                Color(0xFF00897B), // Even darker teal
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF66BB6A),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Daniel 🏃',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00695C),
            ),
            child: IconButton(
              icon: const Icon(Icons.star, color: Colors.white),
              onPressed: () {},
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
          _buildQuickActionButtons(),
          _buildMessageInput(),
        ],
      ),
      bottomNavigationBar: const BottomNavigationWidget(currentRoute: '/chat')
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
            'Daniel is ready to $_selectedMood you',
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            'Distract me',
            Icons.games,
            Colors.purple,
            () => _sendQuickMessage('distract'),
          ),
          _buildQuickActionButton(
            'Motivate me',
            Icons.fitness_center,
            Colors.orange,
            () => _sendQuickMessage('motivate'),
          ),
          _buildQuickActionButton(
            'Remind me',
            Icons.alarm,
            Colors.green,
            () => _sendQuickMessage('remind'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 3,
            shadowColor: color.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  void _sendQuickMessage(String mood) {
    final quickMessage = ChatPrompt.getQuickMessage(mood);
    setState(() {
      _selectedMood = mood;
    });
    _messageController.text = quickMessage;
    _sendMessage();
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: message.isLoading 
                  ? null 
                  : (message.isError 
                    ? null 
                    : const LinearGradient(
                        colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )),
                color: message.isLoading 
                  ? Colors.grey[400] 
                  : (message.isError ? Colors.red[400] : null),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.isLoading 
                ? const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Center(
                    child: Text(
                      'D',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: message.isUser 
                  ? const LinearGradient(
                      colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
                color: message.isUser 
                  ? null
                  : (message.isError ? Colors.red[50] : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: message.isUser 
                      ? const Color(0xFF4DB6AC).withOpacity(0.3)
                      : Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isLoading && !message.isUser) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (message.isError && !message.isUser) ...[
                    const Icon(Icons.error_outline, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser 
                          ? Colors.white 
                          : (message.isError ? Colors.red[700] : const Color(0xFF37474F)),
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: message.isUser ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4DB6AC).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              ),
              style: const TextStyle(
                color: Color(0xFF37474F),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4DB6AC), Color(0xFF26A69A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4DB6AC).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      // Add loading message
      _messages.add(ChatMessage(
        text: "Thinking...",
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: true,
      ));
    });

    _messageController.clear();

    try {
      String response;
      if (Config.isApiKeyConfigured) {
        response = await OpenAIService.generateChatResponse(userMessage, _selectedMood);
      } else {
        response = _generateLocalResponse(userMessage);
      }
      
      setState(() {
        // Remove loading message
        _messages.removeLast();
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        // Remove loading message
        _messages.removeLast();
        _messages.add(ChatMessage(
          text: "Sorry, I'm having trouble responding right now. ${_generateLocalResponse(userMessage)}",
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
      });
    }
  }

  String _generateLocalResponse(String userMessage) {
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
  final bool isLoading;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
    this.isError = false,
  });
}
