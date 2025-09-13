import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? senderName;
  final String? senderAvatar;
  final bool isLoading;
  final bool isError;
  final Widget? cardWidget;
  final String messageType; // 'text', 'exercise', 'recipe'

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.senderName,
    this.senderAvatar,
    this.isLoading = false,
    this.isError = false,
    this.cardWidget,
    this.messageType = 'text',
  });
}

class GroupChatMessage {
  final String text;
  final String senderName;
  final bool isCurrentUser;
  final DateTime timestamp;
  final String? senderAvatar;
  final Color? senderColor;

  GroupChatMessage({
    required this.text,
    required this.senderName,
    required this.isCurrentUser,
    required this.timestamp,
    this.senderAvatar,
    this.senderColor,
  });
}

// Predefined chat data
class ChatData {
  static final List<GroupChatMessage> weightLossWarriorsMessages = [
    GroupChatMessage(
      text: "OMG guys! I just hit 120lbs! 🎉",
      senderName: "You",
      isCurrentUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      senderColor: const Color(0xFF4A90E2),
    ),
    GroupChatMessage(
      text: "YESSS! Congratulations! 🎊 That's amazing progress!",
      senderName: "Sarah",
      isCurrentUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      senderColor: const Color(0xFFE91E63),
    ),
    GroupChatMessage(
      text: "Way to go! 🔥 You've been working so hard for this!",
      senderName: "Mike",
      isCurrentUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      senderColor: const Color(0xFF4CAF50),
    ),
    GroupChatMessage(
      text: "So proud of you! Let's celebrate! 🥳",
      senderName: "Sarah",
      isCurrentUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      senderColor: const Color(0xFFE91E63),
    ),
    GroupChatMessage(
      text: "Thanks everyone! Couldn't have done it without this amazing support group! ❤️",
      senderName: "You",
      isCurrentUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      senderColor: const Color(0xFF4A90E2),
    ),
  ];

  static final List<GroupChatMessage> fitnessMotivationMessages = [
    GroupChatMessage(
      text: "Just finished my morning workout! 💪 Who's joining me tomorrow?",
      senderName: "Alex",
      isCurrentUser: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      senderColor: const Color(0xFFFF9800),
    ),
    GroupChatMessage(
      text: "Count me in! What time are we meeting?",
      senderName: "You",
      isCurrentUser: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      senderColor: const Color(0xFF4A90E2),
    ),
    GroupChatMessage(
      text: "6 AM at the park! Let's crush those goals! 🏃‍♀️",
      senderName: "Alex",
      isCurrentUser: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      senderColor: const Color(0xFFFF9800),
    ),
    GroupChatMessage(
      text: "I'm in too! Need that motivation boost 🔥",
      senderName: "Emma",
      isCurrentUser: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      senderColor: const Color(0xFF9C27B0),
    ),
    GroupChatMessage(
      text: "Perfect! See you all bright and early! ☀️",
      senderName: "You",
      isCurrentUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      senderColor: const Color(0xFF4A90E2),
    ),
  ];
}