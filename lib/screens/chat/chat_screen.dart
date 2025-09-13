import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../models/recipe.dart';
import '../../models/exercise.dart';
import '../../services/openai_service.dart';
import '../../utils/config.dart';
import '../../utils/chat_prompt.dart';
import '../../widgets/common/bottom_navigation_widget.dart';
import '../../widgets/common/exercise_card_widget.dart';
import '../../widgets/common/recipe_card_widget.dart';
import '../../widgets/chat/message_bubble_widget.dart';
import '../../widgets/chat/message_input_widget.dart';
import '../../widgets/chat/quick_action_buttons_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final String _selectedMood = 'neutral';

  @override
  void initState() {
    super.initState();
    _addWelcomeMessages();
  }

  void _addWelcomeMessages() async {
    // Get the Zumba exercise from ExerciseData
    final zumbaExercise = ExerciseData.getExerciseByTitle('15 Min Zumba Cardio Workout');
    final bellPepperRecipe = RecipeData.getRecipeByTitle('Bell Pepper Beef Burger');
    
    setState(() {
      _messages.addAll([
        // Zumba exercise card
        ChatMessage(
          text: "Check out this amazing workout!",
          isUser: false,
          timestamp: DateTime.now(),
          cardWidget: zumbaExercise != null 
            ? ExerciseCardWidget(exercise: zumbaExercise, isInChat: true)
            : null,
          messageType: 'exercise',
        ),
        // User craving message
        ChatMessage(
          text: "But now I am so craving to Shake Shack, I wanna eat fries, I want burgers and the milk shake too!!",
          isUser: true,
          timestamp: DateTime.now().add(const Duration(seconds: 2)),
        ),
        // Healthy suggestion
        ChatMessage(
          text: "What about some healthy version like this Bell Pepper Beef Burger?",
          isUser: false,
          timestamp: DateTime.now().add(const Duration(seconds: 3)),
        ),
        // Recipe card
        ChatMessage(
          text: "Here's a delicious and healthy alternative!",
          isUser: false,
          timestamp: DateTime.now().add(const Duration(seconds: 4)),
          cardWidget: bellPepperRecipe != null 
            ? RecipeCardWidget(recipe: bellPepperRecipe, isInChat: true)
            : null,
          messageType: 'recipe',
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
                return MessageBubbleWidget(message: _messages[index]);
              },
            ),
          ),
          QuickActionButtonsWidget(onQuickAction: _sendQuickMessage),
          MessageInputWidget(
            controller: _messageController,
            onSend: _sendMessage,
          ),
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



  void _sendQuickMessage(String mood) {
    final quickMessage = ChatPrompt.getQuickMessage(mood);
    _sendMessage(quickMessage);
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

  void _sendMessage([String? customMessage]) async {
    final messageText = customMessage ?? _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Clear input if not a custom message
    if (customMessage == null) {
      _messageController.clear();
    }

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    // Add loading message
    setState(() {
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: true,
      ));
    });

    try {
      // Check if API key is configured
      if (!Config.isApiKeyConfigured) {
        setState(() {
          _messages.removeLast(); // Remove loading message
          _messages.add(ChatMessage(
            text: "Please configure your OpenAI API key in the settings to enable AI responses.",
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          ));
        });
        return;
      }

      // Get AI response
      final response = await OpenAIService.generateChatResponse(
        messageText,
        _selectedMood,
      );

      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(ChatMessage(
          text: "Sorry, I'm having trouble connecting. Please check your internet connection and API key.",
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
      });
    }
  }
}
